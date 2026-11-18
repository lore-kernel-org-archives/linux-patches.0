Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032836;
	b=MF3xym6W4uCRS42aE91vOMy6Q6F6vrExU1C9+wL5bBEvnKHO2hp+hst+ay59JCkNl1/W
	 ZoTBN5wVcIpDtQ2fyhf+gvEaCF34KhnKJDGdhUPOqQggtNJvW3wLJQmOfz+lBJgk6K4Ug
	 0M7kph4xtqpTfQLj2ZVA4eYGk6fto+BsvZ1+YUYD7cISfpsoK81vcjUp+/mGptI3cmvo3
	 5ZO/Ebg0YncrJz0AhP5byWRaju617GQe1XKuYvg6/WBJVDCfy+Ad2mgpdLY9SBcSv271l
	 HGRx7x2pFt140Bob21/ssCer4XsCsNa7sM3G7KVEjRn8JirNfjYO1M5MHe6N8BPBy2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=481OigVuC9jHq3dNLFzfbL51TUrgFBjnWSIoa/W5W0k=;
	b=P0YZOkMA1IvdNNsRS/4JCzcMLr2eSXyR4VvH5Z7esD6M0dBZ+zOYheCjyLHpwT1qXFaR
	 fza8eWD9yjMGlCykfWtMQsVOQIOctmwHPQF2ChGvh1CtvcdiphfCsHNVcGuD4BSobdr2k
	 PANY54ojkgyNQ6/reDtmTt2tg2CqyHHgf2YJwWtff1Jc+mdnnVZayEYXyZkZyT2VFZW1N
	 tBr+Qqu9SUkk63UKl9nB5mhR6E/hAS6UaC8pmPS/CHO3EjGf9nLngQ8cX0057ykdm7fe5
	 p6RahJLRXxnOpli0PHvAWZOlKMEuSIdmpfshtH84X3DznC/uz9Hpzg0kebPP3+PcH8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4lC1iJA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65FB60A262D;
	Wed, 18 Nov 2026 20:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q4lC1iJA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086C51F000C4;
	Wed, 18 Nov 2026 20:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032836;
	bh=481OigVuC9jHq3dNLFzfbL51TUrgFBjnWSIoa/W5W0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4lC1iJADmvASCvVqAYjzVufT3a60SoHO7Dj2kex/jeawfMGgpQE4TSugxSH9kWmy
	 uKcvSunFIwHa27fof4C2wYaKYeKzut2lnnDB78j1H4aRAmuo0z4znAG3bjf12M2QyK
	 HGGJf9dN9uhc4zIODTQFJQzgFxm2e4Oqvn0Pztxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1551/1756] scripts/gdb: fix radix tree lookup pointer handling
Date: Wed, 18 Nov 2026 16:01:18 +0100
Message-ID: <20261118150110.801047422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ting-Han Hou <ue081723@gmail.com>

[ Upstream commit 66d190b072b4e261aff35debb53872ace9b80628 ]

Patch series "scripts/gdb: fix radix tree lookup and stack depot
diagnostic", v2.

Two scripts/gdb fixes.

Patch 1 fixes $lx_radix_tree_lookup(), which dereferenced slot contents
as if they were node pointers. v2 also handles the XArray sibling,
retry and zero entries that Sashiko pointed out: they carry the
internal tag but are not node pointers, and the v1 patch raised a GDB
MemoryError on them. Large folios in the page cache make sibling
entries common, so this was worth fixing rather than documenting.

Patch 2 is unchanged from v1 apart from being resent with git
send-email, since the earlier copy was word-wrapped by the mail
client. Sorry about that.

Both patches are tested against standalone GCC-built fixtures that use
the kernel struct layouts (details below the --- line of each patch),
not against a running kernel.

This patch (of 2):

lookup() casts each slot to a pointer to a node pointer and then
dereferences it. Since the slot already contains an entry pointer,
this reads the entry's contents as another pointer instead of
returning the entry itself. Internal entries also keep their tag
bits when descending, so multi-level trees are read from the wrong
address and $lx_radix_tree_lookup() fails with a memory error.

Sibling, retry and zero entries carry the same internal tag but are
small integers rather than node pointers, so the tag alone must not
decide whether to descend. A page cache populated with large folios
has a sibling entry in every slot but the first of each folio.

Walk the tree the way xas_load() does: descend only through entries
that xa_is_node() would accept, follow sibling entries to the
canonical slot of a multi-index entry, and treat retry and zero
entries like empty slots since they hold no data. Remove the explicit
shift counter, as traversal now follows the entry type.

Link: https://lore.kernel.org/20261011023044.1722-1-ue081723@gmail.com
Link: https://lore.kernel.org/20261011023044.1722-2-ue081723@gmail.com
Fixes: b7235d6bb516 ("scripts/gdb: add a Radix Tree Parser")
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/radixtree.py | 66 ++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 26 deletions(-)

diff --git a/scripts/gdb/linux/radixtree.py b/scripts/gdb/linux/radixtree.py
index bc2954e45c327..8ce9936dfa50f 100644
--- a/scripts/gdb/linux/radixtree.py
+++ b/scripts/gdb/linux/radixtree.py
@@ -27,6 +27,24 @@ def entry_to_node(node):
     indirect_ptr = node.cast(long_type) & ~constants.LX_RADIX_TREE_INTERNAL_NODE
     return indirect_ptr.cast(radix_tree_node_type.get_type().pointer())
 
+def is_node(entry):
+    # Like xa_is_node(): internal entries below 4096 are sibling, retry
+    # or zero entries rather than pointers to a struct xa_node.
+    ulong_type = utils.get_ulong_type()
+    return is_internal_node(entry) and entry.cast(ulong_type) > 4096
+
+def is_sibling(entry):
+    # Like xa_is_sibling(): a multi-index entry occupies several slots,
+    # and all but the first hold a sibling entry that encodes the offset
+    # of the first one.
+    ulong_type = utils.get_ulong_type()
+    return is_internal_node(entry) and entry.cast(ulong_type) < \
+        xa_mk_internal(constants.LX_RADIX_TREE_MAP_SIZE - 1)
+
+def sibling_offset(entry):
+    ulong_type = utils.get_ulong_type()
+    return int(entry.cast(ulong_type)) >> 2
+
 def node_maxindex(node):
     return (constants.LX_RADIX_TREE_MAP_SIZE << node['shift']) - 1
 
@@ -40,39 +58,35 @@ def resolve_root(root):
 
 def lookup(root, index):
     root = resolve_root(root)
-    node = root['xa_head']
-    if node == 0:
-        return None
+    entry = root['xa_head']
 
-    if not (is_internal_node(node)):
-        if (index > 0):
+    if is_node(entry):
+        node = entry_to_node(entry)
+        if index > node_maxindex(node):
             return None
-        return node
 
-    node = entry_to_node(node)
-    maxindex = node_maxindex(node)
-
-    if (index > maxindex):
-        return None
-
-    shift = node['shift'] + constants.LX_RADIX_TREE_MAP_SHIFT
-
-    while True:
-        offset = (index >> node['shift']) & constants.LX_RADIX_TREE_MAP_MASK
-        slot = node['slots'][offset]
+        # Walk down the tree like xas_load() does.
+        while True:
+            offset = (index >> node['shift']) & constants.LX_RADIX_TREE_MAP_MASK
+            entry = node['slots'][offset]
 
-        if slot == 0:
-            return None
+            while is_sibling(entry):
+                entry = node['slots'][sibling_offset(entry)]
+                if node['shift'] and is_node(entry):
+                    # xas_descend() turns this into a retry entry.
+                    return None
 
-        node = slot.cast(node.type.pointer()).dereference()
-        if node == 0:
-            return None
+            if not is_node(entry) or node['shift'] == 0:
+                break
+            node = entry_to_node(entry)
+    elif index > 0:
+        return None
 
-        shift -= constants.LX_RADIX_TREE_MAP_SHIFT
-        if (shift <= 0):
-            break
+    # Empty slots and retry or zero entries hold no data.
+    if entry == 0 or is_internal_node(entry):
+        return None
 
-    return node
+    return entry
 
 def descend(parent, index):
     offset = (index >> int(parent["shift"])) & constants.LX_RADIX_TREE_MAP_MASK
-- 
2.53.0



