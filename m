Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065413;
	b=qon/wwwQdNnOo7xi4u6cnNAEsa5BKAuE+fKqPCT25nLNvxgdSmMnLRULq36phAWVMlVh
	 lu1HCKgxqxSW/uyXAXGHMRERpIMJrzy79HGtZskSv6Otr94HWlb0aweSD828K5af23kPv
	 ySoRx1S3GMKwefy9lXs7DnYv/xxZr/ejxgFevzV1HMpsY/xbIZfiHQbciUHtynnJV+J93
	 RJE90siuiUrX41/Ya7hN04ZXMd3ajzXXYoVMzS/298Hvgz2Vdv6rAG6gU3QH2K3YPhy9C
	 4Rso0xk9Kz7yhXAU7i2cW/Mlj0WgnrRBUPCWOfWMdwzYe2Lcvab1qv18k1Go+72SXfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p0RLjJonUKh/C8d0M0jIu6I21pXHkhJy00AyIQ16DpY=;
	b=tB19BH0b6jt2dmPNNfiXchle+j2DiY3nsbTR4Ej1un+vNa7HSyyvtlrunxaoTZlTy89L
	 KYReDaET2T59X3p4U1fbyH4/MKc26nFUlrb4+IGaSRQ4x4de8vbmsBiQVXpoVMbABMSQN
	 kKHNDlk4zSRQig1rn9tq/76JU72vzPEtiUXcd91UyHS1dK2Vh7quyU6Szn5lTSQL7I6D/
	 Hx4c83Eb0xqpB2F8pGlKq7+7TqPoQ7qeZCLIz7FDAfZIVK8ey6qSLyrysmiA9jGHrOdMQ
	 DwtaYqrmNi6N+wyaMaMRkXgH6fVZb4anCQtabqEnMmpg2sfSzGau+m6+4Y3oMYgFAng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvPDdMB0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21D3606D811;
	Sat,  7 Nov 2026 15:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvPDdMB0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA521F008A2;
	Sat,  7 Nov 2026 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065412;
	bh=p0RLjJonUKh/C8d0M0jIu6I21pXHkhJy00AyIQ16DpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvPDdMB01ngvlzwOOr1bwF7WKZ1zTaHF9lakJcvFapqPDWl+SBH1KV5SE1+dl+FGI
	 PPL+8edgHNWYKeBFUDii8Z3RjSsO/TXiPyYdJ60DUK+lGUPYaBzcYjVgNbWBaPUmmb
	 UcPzYI003Q8Njxr2f4VZddyEydhisOnIYfE5RPho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Hoffmann <f3lix.dev@gmx.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1122/1257] libceph: reject mismatched CRUSH weight-set sizes
Date: Sat,  7 Nov 2026 08:56:58 -0500
Message-ID: <20261107135010.225735953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Felix Hoffmann <f3lix.dev@gmx.de>

[ Upstream commit d8fc89b5bfe4cb3aebe4c8a818247d11291b841c ]

A CEPH_MSG_OSD_MAP message can contain CRUSH choose args with replacement
weight vectors for straw2 buckets.  decode_choose_args() validates the
optional IDs vector against the referenced bucket, but does not validate
the size of any replacement-weight vector.

The CRUSH mapper assumes that each replacement vector has exactly as many
entries as the bucket.  A zero-length vector for a nonempty bucket makes
bucket_straw2_choose() dereference NULL, while a shorter nonzero vector
causes an out-of-bounds read.  An authenticated monitor or OSD can deliver
such a map and crash a kernel client when it performs placement for an
ordinary request.

Reject a nonempty collection of weight sets for an absent bucket and
require every replacement-weight vector to match its bucket size.

Cc: stable@vger.kernel.org
Fixes: 5cf9c4a9959b ("libceph, crush: per-pool crush_choose_arg_map for crush_do_rule()")
Assisted-by: Codex:gpt-5
Signed-off-by: Felix Hoffmann <f3lix.dev@gmx.de>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osdmap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index cf34b35c9a901..7bd27c2fc8726 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -376,7 +376,9 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 		ceph_decode_32_safe(p, end, num_buckets, e_inval);
 		while (num_buckets--) {
 			struct crush_choose_arg *arg;
+			struct crush_bucket *bucket;
 			u32 bucket_index;
+			u32 i;
 
 			ceph_decode_32_safe(p, end, bucket_index, e_inval);
 			if (bucket_index >= arg_map->size)
@@ -387,10 +389,18 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 			if (ret)
 				goto fail;
 
+			bucket = c->buckets[bucket_index];
 			if (arg->ids_size &&
-			    (!c->buckets[bucket_index] ||
-			     arg->ids_size != c->buckets[bucket_index]->size))
+			    (!bucket || arg->ids_size != bucket->size))
 				goto e_inval;
+
+			if (arg->weight_set_size && !bucket)
+				goto e_inval;
+
+			for (i = 0; i < arg->weight_set_size; i++) {
+				if (arg->weight_set[i].size != bucket->size)
+					goto e_inval;
+			}
 		}
 
 		if (!__insert_choose_arg_map(&c->choose_args, arg_map)) {
-- 
2.53.0



