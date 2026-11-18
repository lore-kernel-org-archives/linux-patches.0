Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027867;
	b=0/zJbBwypNLtJHMUMCtqspXCBe7YCjBvx+gvoo+H5kOSwIxzkWORFGpOyWcD8zdBq9DB
	 91w/P9tov0sagXiaqUGhKzuBusHLCI/76z6TvIicEKJPzuaQEH3LSje3pTW9Wp8rdlSPZ
	 xSej1iaRzTFBO6nAOe5sGLVorAXA68hO+j5uwRjHk6i0miJqA3iY7Tqw1oQ5JA9Gs6KD2
	 sa+b3tMVccLqztxdSYG13f2d+EucF8fg/8YW18nmWa3NVeUM/Y10b4hKp0tv03OY4LyHQ
	 z4Sasc5PQQTwCsYxAbvMUO+ZCBM4kRz5FHzzZGW8A1juaal0vIW50O8q5jRGuTokPVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=38KVbyNuQG9/ZPEP4z+ismEKUOn+N70oVmKejIcd3bc=;
	b=aQj8PmSuQl8N6YoS4n2Uat/YIntscuyb5bMdOlAYW4037QNq1+uAVWrH8C0Ld/fZGLti
	 UooQIw9qkzGKlFz0rweutX9PZ3F9cGbmH9sZ3comlVARUez1q+D6fDQHLaRup0F3e8lwE
	 YU1qSq2zPjz2ipr6uiruch26q+SFBwrfov14H1RquWTIMlL9AGH9ZzM6NiTerp30jT1Kg
	 7NS9p7uyw9a6ydr+fkmxHiew0avq4ievc1/EQzKWU0SMETEA8rIccJwJ9mYodXw0V4Br3
	 nFk5bj49JrwrY4F0GIRxGoVwUlW8lpKSJJcWvK6S+Nehq58wdMksIUScBI5TWuJsMfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w06PHlvC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874A0606A320;
	Wed, 18 Nov 2026 18:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w06PHlvC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9051A1F000C4;
	Wed, 18 Nov 2026 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027867;
	bh=38KVbyNuQG9/ZPEP4z+ismEKUOn+N70oVmKejIcd3bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w06PHlvCYyBaNfKY6jGxP7sO68P18J7z+wsDhlyCg4n3LSWe7wXV2YIzupSIAENRH
	 hUPx4mF9hUYbKPbk7biWOcSuWKVdaWVfuFc2/e9k3CIX/zTQzjyT27ZYd+/OgWprTE
	 jmltFpXU9Q+kceBESQYYrEkie6eqgldDTHSDzuB0=
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
Subject: [PATCH 6.18 1940/2151] scripts/gdb: fix radix tree lookup pointer handling
Date: Wed, 18 Nov 2026 16:01:15 +0100
Message-ID: <20261118150232.440090037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



