Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054250;
	b=PyfEKaNmaUSKYGTd0rn84MKMwMJneZeKUV5RKlAhOH1NMnUhwjheoAKDBtPYGWA2Dev6
	 epA04bngAZ8owNsUfAnBFAO//hcAy0l4d4KdHs4Zz28fViSGYdTNirQ9RxZTc1y90ngXd
	 0TULFmt3reXKS7nrPNU4TMMF+c/MHCAsHgghkJL2/jJuRbJrHUCxQ9JDKJqMmeCKF87ve
	 I55xXDUXDueUxqWVmvoZD0vRBm1Ci9fLCQPIOsaUp9kmpoBidyE61UmLSlUt0CHdZ/6Gv
	 QmMNBdVdLNNgRQFWBllacI2mYbevRUCLvynZljIutyhNbjPP7qJj7MRKsr1CgCsViYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5C5EjjkJZO305YI7Sj0B9T77d78lNlY7zA+Lj9YNSEk=;
	b=TPwLt9AMSAyhoqMowVyvs/I+cleybPIXM3+n0+yaBWWatUPwe9/RP2ZVugQCLJ3RsoSa
	 5dGHEA4gw7yVc/s7ilhymPfZW2e1c9o2F7mPmEHgUXndJ/ZyzJvmmb+quHWzCqR5HgMtO
	 /ti3dcYtapUYjNhgfqS4R3hN/WpYXE76/MfeWgOL/zktAZ0RoE8Sf1NXI1ic72HzPasz/
	 eFltTMqCf9gLpNC5B/XOwWicxhbtgmu5/X3u23lu16pj+4REoiW5GbKQYJlD0dfHetYFu
	 H3Jir/p9y/jBUAMY3/QmDPyZNFhkyI5Pw8ErdYHz9VZpHHIYFBPexRPiX3Gr4yYPliQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1nC20Bx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD60606A32C;
	Thu, 19 Nov 2026 02:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x1nC20Bx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2A51F000C4;
	Thu, 19 Nov 2026 02:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054249;
	bh=5C5EjjkJZO305YI7Sj0B9T77d78lNlY7zA+Lj9YNSEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1nC20Bxm53yO3FDTibYFrl3+S953jiFkKZ7T1Ud56v1ErhC1Jawf0afE34jQ7Wfm
	 1petUXkfOn7L18cldhbVz64hD5GLgACL9seiPRckhTiBd72Rln4iib6v6DKwoDrdzc
	 h02SygEAGQ70BoBSSk0TovYuy5Eyutdy1yBPtslQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Baker <len.baker@gmx.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1201/2214] assoc_array: Avoid open coded arithmetic in allocator arguments
Date: Wed, 18 Nov 2026 15:47:57 +0100
Message-ID: <20261118150059.906084192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Baker <len.baker@gmx.com>

[ Upstream commit 2a12e0003580505b8e7d82f9a8fef95f4a1031a8 ]

As noted in the "Deprecated Interfaces, Language Features, Attributes,
and Conventions" documentation [1], size calculations (especially
multiplication) should not be performed in memory allocator (or similar)
function arguments due to the risk of them overflowing. This could lead
to values wrapping around and a smaller allocation being made than the
caller was expecting. Using those allocations could lead to linear
overflows of heap memory and other misbehaviors.

So, use the struct_size() helper to do the arithmetic instead of the
argument "size + count * size" in the kmalloc() and kzalloc() functions.

Also, take the opportunity to refactor the memcpy() calls to use the
struct_size() and flex_array_size() helpers.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

Signed-off-by: Len Baker <len.baker@gmx.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Stable-dep-of: 48691075b0ad ("assoc_array: don't chain a new shortcut onto an existing one")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 861965af48b9c..65409f0d2e0e5 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -742,8 +742,7 @@ static bool assoc_array_insert_into_terminal_node(struct assoc_array_edit *edit,
 	keylen = round_up(diff, ASSOC_ARRAY_KEY_CHUNK_SIZE);
 	keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
 
-	new_s0 = kzalloc(sizeof(struct assoc_array_shortcut) +
-			 keylen * sizeof(unsigned long), GFP_KERNEL);
+	new_s0 = kzalloc(struct_size(new_s0, index_key, keylen), GFP_KERNEL);
 	if (!new_s0)
 		return false;
 	edit->new_meta[2] = assoc_array_shortcut_to_ptr(new_s0);
@@ -850,8 +849,8 @@ static bool assoc_array_insert_mid_shortcut(struct assoc_array_edit *edit,
 		keylen = round_up(diff, ASSOC_ARRAY_KEY_CHUNK_SIZE);
 		keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
 
-		new_s0 = kzalloc(sizeof(struct assoc_array_shortcut) +
-				 keylen * sizeof(unsigned long), GFP_KERNEL);
+		new_s0 = kzalloc(struct_size(new_s0, index_key, keylen),
+				 GFP_KERNEL);
 		if (!new_s0)
 			return false;
 		edit->new_meta[1] = assoc_array_shortcut_to_ptr(new_s0);
@@ -865,7 +864,7 @@ static bool assoc_array_insert_mid_shortcut(struct assoc_array_edit *edit,
 		new_n0->parent_slot = 0;
 
 		memcpy(new_s0->index_key, shortcut->index_key,
-		       keylen * sizeof(unsigned long));
+		       flex_array_size(new_s0, index_key, keylen));
 
 		blank = ULONG_MAX << (diff & ASSOC_ARRAY_KEY_CHUNK_MASK);
 		pr_devel("blank off [%zu] %d: %lx\n", keylen - 1, diff, blank);
@@ -900,8 +899,8 @@ static bool assoc_array_insert_mid_shortcut(struct assoc_array_edit *edit,
 		keylen = round_up(shortcut->skip_to_level, ASSOC_ARRAY_KEY_CHUNK_SIZE);
 		keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
 
-		new_s1 = kzalloc(sizeof(struct assoc_array_shortcut) +
-				 keylen * sizeof(unsigned long), GFP_KERNEL);
+		new_s1 = kzalloc(struct_size(new_s1, index_key, keylen),
+				 GFP_KERNEL);
 		if (!new_s1)
 			return false;
 		edit->new_meta[2] = assoc_array_shortcut_to_ptr(new_s1);
@@ -914,7 +913,7 @@ static bool assoc_array_insert_mid_shortcut(struct assoc_array_edit *edit,
 		new_n0->slots[sc_slot] = assoc_array_shortcut_to_ptr(new_s1);
 
 		memcpy(new_s1->index_key, shortcut->index_key,
-		       keylen * sizeof(unsigned long));
+		       flex_array_size(new_s1, index_key, keylen));
 
 		edit->set[1].ptr = &side->back_pointer;
 		edit->set[1].to = assoc_array_shortcut_to_ptr(new_s1);
@@ -1492,13 +1491,12 @@ int assoc_array_gc(struct assoc_array *array,
 		shortcut = assoc_array_ptr_to_shortcut(cursor);
 		keylen = round_up(shortcut->skip_to_level, ASSOC_ARRAY_KEY_CHUNK_SIZE);
 		keylen >>= ASSOC_ARRAY_KEY_CHUNK_SHIFT;
-		new_s = kmalloc(sizeof(struct assoc_array_shortcut) +
-				keylen * sizeof(unsigned long), GFP_KERNEL);
+		new_s = kmalloc(struct_size(new_s, index_key, keylen),
+				GFP_KERNEL);
 		if (!new_s)
 			goto enomem;
 		pr_devel("dup shortcut %p -> %p\n", shortcut, new_s);
-		memcpy(new_s, shortcut, (sizeof(struct assoc_array_shortcut) +
-					 keylen * sizeof(unsigned long)));
+		memcpy(new_s, shortcut, struct_size(new_s, index_key, keylen));
 		new_s->back_pointer = new_parent;
 		new_s->parent_slot = shortcut->parent_slot;
 		*new_ptr_pp = new_parent = assoc_array_shortcut_to_ptr(new_s);
-- 
2.53.0



