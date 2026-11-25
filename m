Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620286;
	b=KmoMVcchGmzgfsqMWShDiBcSmrYtEsvqyzE8qd2AcuaabiKPmzSolvqGC7Ld9KDlSCXf
	 HAe9ff0dr+cfCeSQ6f6+2K0A8sKbtqwv7vU/kSmQsuuMB1llJgPwPlQC3gH1DF0bqlv2R
	 N4qUlLoKhBOM/KG8tYEK5pUgFbr0bTWeLUhUJBN+8/M/SzqIYFfdWo9ge/PBN6nT4ZC7G
	 8TkXREr/7Tlq+PWkVbW+Zqbh9j0J4sBtQZ+3xW5jkZXliA1hjkTXmdkcq6oPOc0y+WBlH
	 rH95p0WDqiNzPDdPWmi3Tr4nE3Lkpfx/O569f512NW1HwQxOcNGDQU3IloGwwnmK1Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vTbsZw1snu/oizvj1Fv4fe5OsTE38tXS1/HNmzOR2kM=;
	b=H5A1KdPyFomQ9MtFU4JwP1MzNCXnxMr1nz5aCA8gK8Dw5T1NJpEtM57I1+Z6wjx2wrKC
	 Q8NJS0h1qXa+bFOPRd6PP5OFgtNZBwip5dVxwLzHKzw8pgm1/2fD4SwFLVFZpXEZV1PWl
	 U2tuZ5s2mYTR1N027PS8jlwkuIesGgvsvB/vXmgNfMDeKlWKStrCcSg4CLSZBYLi6tr1j
	 2Q2lvQ6SjNwtNI0s5MLL/iuPeow6Nu/9h4597S7aGxGCrGlSupiyrrJkN6lwdtY2u0HjL
	 QOqs26RHIyXsurFSKUg50nDgXt9/jjZ5iqpw2Cm2KHSRChsHgyHV6LFg7CsyX88LY0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Da6BqC3C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E133606A33E;
	Wed, 25 Nov 2026 15:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Da6BqC3C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A587B1F000D4;
	Wed, 25 Nov 2026 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620286;
	bh=vTbsZw1snu/oizvj1Fv4fe5OsTE38tXS1/HNmzOR2kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Da6BqC3CpQPZij6FZHxYNA+Z/s+PiAn0pjjcOlJQJVfVxXd1+OZ/ATTD1s965spq+
	 RP35zAbDRfoaUmf7QVRgVXI4wPZpbbIpS2+DDrKX6wDcgpo07zTud9HGi0nAxETQ7N
	 gY/zP3gh8Hwxo/veO//l7dbY7OSz0ohin1f4Rqn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0867/1005] dm persistent data: test return value of node_copy
Date: Wed, 25 Nov 2026 15:36:45 +0100
Message-ID: <20261125143842.018241532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 624d146d97c5fbe7200ef4b2dd5350ecf57d6b79 upstream.

There were 3 places where the return value of node_copy was not tested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: c671ffa55d8b ("dm btree remove: change a bunch of BUG_ON() calls to proper errors")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-btree-remove.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -253,7 +253,9 @@ static int __rebalance2(struct dm_btree_
 		/*
 		 * Merge
 		 */
-		node_copy(left, right, -nr_right);
+		ret = node_copy(left, right, -nr_right);
+		if (unlikely(ret))
+			return ret;
 		left->header.nr_entries = cpu_to_le32(nr_left + nr_right);
 		delete_at(parent, r->index);
 
@@ -315,13 +317,16 @@ static int delete_center_node(struct dm_
 {
 	uint32_t max_entries = le32_to_cpu(left->header.max_entries);
 	unsigned int shift = min(max_entries - nr_left, nr_center);
+	int ret;
 
 	if (nr_left + shift > max_entries) {
 		DMERR("node shift out of bounds");
 		return -EINVAL;
 	}
 
-	node_copy(left, center, -shift);
+	ret = node_copy(left, center, -shift);
+	if (unlikely(ret))
+		return ret;
 	left->header.nr_entries = cpu_to_le32(nr_left + shift);
 
 	if (shift != nr_center) {
@@ -333,7 +338,9 @@ static int delete_center_node(struct dm_
 		}
 
 		node_shift(right, shift);
-		node_copy(center, right, shift);
+		ret = node_copy(center, right, shift);
+		if (unlikely(ret))
+			return ret;
 		right->header.nr_entries = cpu_to_le32(nr_right + shift);
 	}
 	*key_ptr(parent, r->index) = right->keys[0];


