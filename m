Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059905;
	b=je3jTYFoCNRW8ajDVwMTnDnonDZwe13hz95DWCgQiSKB4agb2zTm2kDgcQSf57iK31Bq
	 A1iNLis6PcsfN4YXYErVLZzoO6mAWh8pbXsNyLpoYjb3GgHAVI5+vGQIm6+Z3LJ54bLua
	 Qx4ptOU3vmNN6gQMwwyFfTKCdxi3Km5vssG4VN+PZwiabqxfQZC8S36euFH0nISpPPtao
	 ADWKZ0t1FbL+Bd1JYeb0SHt3Wa3NHx6Q60A43cNeNocb9Glck76XRwphVcUpKk6I6PPqv
	 S9pzuMa7BOmEM0OnGXX/tBaritWdxreaiNHPYqxENf5BMuOV76ZgF047pe07yTh7AlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NYpCazdqMX7tfAYyVI+YmEDytjwGNDAUbKjHTK+EIeI=;
	b=EDVPvWTxNKBj5/6QWPtvdhNyUJOWLrz8osW7LVM/hBlbW2LVNr5UbkRylbS2WuhAVeHf
	 VMG5dXSt1FoGtlOMEyxu7MaIgEEVTuObcCuLBx90bsEKmgMGtfq3BVRm9Wx4f/IJcoXD1
	 y9RIXtA4JosvWmarZgzfcgziQUoMoOlXxeoyYwfvUw1z1XXxwJpOqEamdMP8sNi01absq
	 SCnjhvQMGjd5s5POnUcDZ0bsz28PJd1k1SW3boqznryNAvj9okABlgps8vpilwYZLbZm/
	 dF6z0yiPlvA6AYwSfY1Hmc7C9ClQF0W3hrx+a7Zjm9wTlUitJoHs8kyw2wqMmgYKCug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tsNHS2Ag;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2432E606A320;
	Thu, 19 Nov 2026 03:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tsNHS2Ag
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B5F1F000C4;
	Thu, 19 Nov 2026 03:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059905;
	bh=NYpCazdqMX7tfAYyVI+YmEDytjwGNDAUbKjHTK+EIeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tsNHS2AgrFTQnN2XgnPtC2FixucvJDY+Kky/ZX0D4O8Iu9WCov4nHHjWh1by/M8+0
	 9S5Ot90aoj6JE4L0hFKoleSfKJHQJ+J+FyX0Esc4VnTUIlHLE4u2NkB+jy47byCyE2
	 11p8VJpphsxoIgc35FNzLsALYCo/2jHfsS4/PDF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Baker <len.baker@gmx.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1007/1848] assoc_array: Avoid open coded arithmetic in allocator arguments
Date: Wed, 18 Nov 2026 15:50:45 +0100
Message-ID: <20261118145958.923571807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f700986830190..dcf60528313ab 100644
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



