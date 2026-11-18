Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052868;
	b=X3Dm2UjVz41HkKSeRoaQiQ9UbggOv0cNUtLrplaTn34wOXdbSZfpp3yBaX6og4j2t1mP
	 Xxclk/K4bh0NmVqHk7CoSkhJs4oFjh0bV4CFEV4uPCAnK1VTXpAW4BmgsEI++h+i7pt++
	 dTALIifnjWSETGt/1rGh3dMAcpibgXGpQ4Vpxlc+/mkBlnEVQ9cnOnm/nPhMRcZX7txG6
	 Fr7dOmt1dXEoEp08efKny9to/O7BPhjgQSNDnmYdehKc2Yg1DfrBSqkViZigMIy6Hblgb
	 s4rZOZcCUT8VMAq2Jop0bjjwReDJB/xHk0q9PLCl8GxSzwhYyNJXhLh/vi3o5ZUJqVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d1/q4hZc5vjM876TpSUr0Cv8juZ1+ukFuhYUNxMOO2M=;
	b=sGTBwnq/wSx3U6Jk7YYQ+L1PoakVhtYCmt3mHhdReKbABXQRnHHAiDSUdN03kq2+M9f/
	 QXfNbrIrgSFyzgX3tEuJVpeR/KTLE4xYwIgK1DNGaCvi2YCMYJHKxQnfONP/sLmep9r3G
	 52wFX7GVq3BQVJ6iS3091rvFGvZBQuZKhjWo84dejWhnGuuPOYHORCwtWereAyRjzAzbz
	 PoVJMFG6zn6If52zu8qGB1ovHjYrYPoR/Y3nqJreX4mefx06UKhG3nDt0cDm6pKyGYeEo
	 XerZUosWBgL3Xvev6eM26oOQLyLshmo5PJ/cqN+GvNH1YPC1IyeMWssc1yTaYWCbrHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LBov7kdJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A6E606A31C;
	Thu, 19 Nov 2026 01:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LBov7kdJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A6F1F000C5;
	Thu, 19 Nov 2026 01:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052868;
	bh=d1/q4hZc5vjM876TpSUr0Cv8juZ1+ukFuhYUNxMOO2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBov7kdJhheOu+27tV6MXlxrddN3HsQ+Zc3no8sqSA4NXhkZcgEJquX+u68q74Od/
	 DUNiJdJtddlYy2fqb6KxGLjn+ntGvp5PZz+vqPGRbtz8J9n6Jok5almdXogqjuNTD1
	 RDRfh9io3B2T9N66ACvNhydjc9r982WWoOqIGMEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Hoffmann <f3lix.dev@gmx.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0715/2214] libceph: reject mismatched CRUSH weight-set sizes
Date: Wed, 18 Nov 2026 15:39:51 +0100
Message-ID: <20261118150040.407321440@linuxfoundation.org>
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
index 306cf13318eac..13d0ad66e3896 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -362,7 +362,9 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 		ceph_decode_32_safe(p, end, num_buckets, e_inval);
 		while (num_buckets--) {
 			struct crush_choose_arg *arg;
+			struct crush_bucket *bucket;
 			u32 bucket_index;
+			u32 i;
 
 			ceph_decode_32_safe(p, end, bucket_index, e_inval);
 			if (bucket_index >= arg_map->size)
@@ -373,10 +375,18 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
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



