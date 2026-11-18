Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042479;
	b=wulfhip0EC10S6HOw+NCmDCCU3w7wS9dl+OI999B++nbt7bu3g6eLH4DiUYJb13tpYKb
	 RLdcGVmI0+4FU1cKBI2Lm7kNJQSNBxWerJTQ2Bk3onrR2yN01fksZuHNnqKChnUkVASaG
	 9noyb3PE3tgxexkdRZ0KXrFQ+aSkaPbMj6HzRFxzrVG3/IatRU7CPQ5LcjCDZ38xxqE2P
	 FqOF/XgYWjcWNOIwll2/04x9IroXCeX0kTfSPRLQ6/xTvGumZXpIdD75Sq8q74nlSSMow
	 +zA0KNTzt/vaEHn4OwrhSDArsbIOCACfUS7YMRiKMYXNG8mNlBzo9mIrYc8/0fmDf6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lMVtKF7fznbmm1eq4/4iuNKnq3dehAV9EZw5Cn6oK+E=;
	b=ldAMBxT4YvoPvCXo2zzzL2OnZKJV0YS2gW0yzOgWuM69RhZiCwHicfppQHFub5X/5CTV
	 H6fPZu6NxoLsWTwA8qAgayS8l8Ukii39zJdnlKDqqDzwowRtMBKg/+I2gyUWDk2XPGOG4
	 LGQUW6Y95EzUAl+sOZYCj1kgthqcVR9znl0A/zDvXciiZrczXeBVf7fdCgJObQC58avzj
	 pACafQWk6iKGxpk+8FUYdYwFVVtWuPehTknq2wERV2fCsoj1hbyB8KJeXRtuVv6n3bPXW
	 1DnDMLMT+yNwvfQY1hDcuMm7+QeG7evNWGBrUIucf0py7HgUS9jBptkpQmg7/0ArhOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UfIe79n7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641DE606A32F;
	Wed, 18 Nov 2026 22:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UfIe79n7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0571F000C6;
	Wed, 18 Nov 2026 22:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042479;
	bh=lMVtKF7fznbmm1eq4/4iuNKnq3dehAV9EZw5Cn6oK+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UfIe79n7whcq0JFuN0G8sa+kZH1Z2KdDLAkGBEWDnyOCagweOaYJerOYG9rNgoLrv
	 w/jU3RSOjZskQJMz8oNoexCAtR6JP5bgy1Kn3xmUPXinu8j2v/Sf7yRDj7cDTMdPFP
	 kFBjCoOoqMNj7bR3e/Q2eSSlFisNzah49i2VG/Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkman <daniel@iogearbox.net>,
	Heiko Carstens <hca@linux.ibm.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3158/3318] scripts/gdb/radix-tree: add lx-radix-tree-command
Date: Wed, 18 Nov 2026 16:03:00 +0100
Message-ID: <20261118150454.599807105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit caa71919a622e3f7d290d4f17ae538b15f5cb6d3 ]

Patch series "scripts/gdb/symbols: make BPF debug info available to GDB",
v2.

This series greatly simplifies debugging BPF progs when using QEMU gdbstub
by providing symbol names, sizes, and line numbers to GDB.

Patch 1 adds radix tree iteration, which is necessary for parsing
prog_idr.  Patch 2 is the actual implementation; its description contains
some details on how to use this.

This patch (of 2):

Add a function and a command to iterate over radix tree contents.
Duplicate the C implementation in Python, but drop support for tagging.

Link: https://lkml.kernel.org/r/20251106124600.86736-1-iii@linux.ibm.com
Link: https://lkml.kernel.org/r/20251106124600.86736-2-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 66d190b072b4 ("scripts/gdb: fix radix tree lookup pointer handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/radixtree.py | 139 +++++++++++++++++++++++++++++++--
 1 file changed, 132 insertions(+), 7 deletions(-)

diff --git a/scripts/gdb/linux/radixtree.py b/scripts/gdb/linux/radixtree.py
index 074543ac763d2..bc2954e45c327 100644
--- a/scripts/gdb/linux/radixtree.py
+++ b/scripts/gdb/linux/radixtree.py
@@ -30,13 +30,16 @@ def entry_to_node(node):
 def node_maxindex(node):
     return (constants.LX_RADIX_TREE_MAP_SIZE << node['shift']) - 1
 
-def lookup(root, index):
+def resolve_root(root):
+    if root.type == radix_tree_root_type.get_type():
+        return root
     if root.type == radix_tree_root_type.get_type().pointer():
-        node = root.dereference()
-    elif root.type != radix_tree_root_type.get_type():
-        raise gdb.GdbError("must be {} not {}"
-                           .format(radix_tree_root_type.get_type(), root.type))
+        return root.dereference()
+    raise gdb.GdbError("must be {} not {}"
+                       .format(radix_tree_root_type.get_type(), root.type))
 
+def lookup(root, index):
+    root = resolve_root(root)
     node = root['xa_head']
     if node == 0:
         return None
@@ -71,14 +74,120 @@ def lookup(root, index):
 
     return node
 
-class LxRadixTree(gdb.Function):
+def descend(parent, index):
+    offset = (index >> int(parent["shift"])) & constants.LX_RADIX_TREE_MAP_MASK
+    return offset, parent["slots"][offset]
+
+def load_root(root):
+    node = root["xa_head"]
+    nodep = node
+
+    if is_internal_node(node):
+        node = entry_to_node(node)
+        maxindex = node_maxindex(node)
+        return int(node["shift"]) + constants.LX_RADIX_TREE_MAP_SHIFT, \
+               nodep, maxindex
+
+    return 0, nodep, 0
+
+class RadixTreeIter:
+    def __init__(self, start):
+        self.index = 0
+        self.next_index = start
+        self.node = None
+
+def xa_mk_internal(v):
+    return (v << 2) | 2
+
+LX_XA_RETRY_ENTRY = xa_mk_internal(256)
+LX_RADIX_TREE_RETRY = LX_XA_RETRY_ENTRY
+
+def next_chunk(root, iter):
+    mask = (1 << (utils.get_ulong_type().sizeof * 8)) - 1
+
+    index = iter.next_index
+    if index == 0 and iter.index != 0:
+        return None
+
+    restart = True
+    while restart:
+        restart = False
+
+        _, child, maxindex = load_root(root)
+        if index > maxindex:
+            return None
+        if not child:
+            return None
+
+        if not is_internal_node(child):
+            iter.index = index
+            iter.next_index = (maxindex + 1) & mask
+            iter.node = None
+            return root["xa_head"].address
+
+        while True:
+            node = entry_to_node(child)
+            offset, child = descend(node, index)
+
+            if not child:
+                while True:
+                    offset += 1
+                    if offset >= constants.LX_RADIX_TREE_MAP_SIZE:
+                        break
+                    slot = node["slots"][offset]
+                    if slot:
+                        break
+                index &= ~node_maxindex(node)
+                index = (index + (offset << int(node["shift"]))) & mask
+                if index == 0:
+                    return None
+                if offset == constants.LX_RADIX_TREE_MAP_SIZE:
+                    restart = True
+                    break
+                child = node["slots"][offset]
+
+            if not child:
+                restart = True
+                break
+            if child == LX_XA_RETRY_ENTRY:
+                break
+            if not node["shift"] or not is_internal_node(child):
+                break
+
+    iter.index = (index & ~node_maxindex(node)) | offset
+    iter.next_index = ((index | node_maxindex(node)) + 1) & mask
+    iter.node = node
+
+    return node["slots"][offset].address
+
+def next_slot(slot, iter):
+    mask = (1 << (utils.get_ulong_type().sizeof * 8)) - 1
+    for _ in range(iter.next_index - iter.index - 1):
+        slot += 1
+        iter.index = (iter.index + 1) & mask
+        if slot.dereference():
+            return slot
+    return None
+
+def for_each_slot(root, start=0):
+    iter = RadixTreeIter(start)
+    slot = None
+    while True:
+        if not slot:
+            slot = next_chunk(root, iter)
+            if not slot:
+                break
+        yield iter.index, slot
+        slot = next_slot(slot, iter)
+
+class LxRadixTreeLookup(gdb.Function):
     """ Lookup and return a node from a RadixTree.
 
 $lx_radix_tree_lookup(root_node [, index]): Return the node at the given index.
 If index is omitted, the root node is dereference and returned."""
 
     def __init__(self):
-        super(LxRadixTree, self).__init__("lx_radix_tree_lookup")
+        super(LxRadixTreeLookup, self).__init__("lx_radix_tree_lookup")
 
     def invoke(self, root, index=0):
         result = lookup(root, index)
@@ -87,4 +196,20 @@ If index is omitted, the root node is dereference and returned."""
 
         return result
 
+class LxRadixTree(gdb.Command):
+    """Show all values stored in a RadixTree."""
+
+    def __init__(self):
+        super(LxRadixTree, self).__init__("lx-radix-tree", gdb.COMMAND_DATA,
+                                          gdb.COMPLETE_NONE)
+
+    def invoke(self, argument, from_tty):
+        args = gdb.string_to_argv(argument)
+        if len(args) != 1:
+            raise gdb.GdbError("Usage: lx-radix-tree ROOT")
+        root = gdb.parse_and_eval(args[0])
+        for index, slot in for_each_slot(root):
+            gdb.write("[{}] = {}\n".format(index, slot.dereference()))
+
 LxRadixTree()
+LxRadixTreeLookup()
-- 
2.53.0



