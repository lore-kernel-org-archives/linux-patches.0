Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063659;
	b=K16N2+J+xHoF2Cyiy44Tc8wUfdX81aLNtXJZtvimitsZRL2eW41wUf6WgaT1RIyibrbR
	 Igm7ETSILYizz6zYdNHA3R8Xjk2+1tpMWcUwgQuNwRI7HqUhYYsibMrsLmbdmTmLi3/c6
	 Du2/fc41demdrf/mO/dtrR8dZyDaDdHzQRyHIDmRAiaTfbkImSgZAFVbVD+kKIXUrNZ8a
	 BDWv2slz8R6ZZmE3i2GoAHeohjzgjSqDmBp9UnvqCdaY7l5rA/FGI8YHW7jKZ3hswBXXQ
	 9nTnnhWDVH1APP10RHiCbHNGiFY0vwv8657z38VF0ZFygxtDufrT5MW3HXhQxaXhebQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xAJI6RWf3kgt9nI8Swdj+7KvkhkbUi5IeQmkA9WCMH0=;
	b=sLkyj5odRfVct30wYZkc/2tt4JRqbu8ZCqLDz4/vnw2vdQbCCdlCPKuda3h4+knoP7Sj
	 FkvWbNesnduwhUsVa2I9ECM9BXt5AEhcfRzwfExKOhl6mD3qIN2pXOnT0qTJZs2ZEp42N
	 u93VR0KkqYwRB7C4xGFp19FXCfvy79xKmUZviBHhQ61N5pRamiKat0vC5Fbfbkdyl5WOX
	 tbWpMy51zcyW8Y/q7hYihVQxMpk/sXqLPbbEaXpzx+Ik3soMcb4EMmlnrmwWNRM0YNq+A
	 VIhFoPbKkJorQHepIYuVLhKmZI3mEhPJV/yD3symDSkxHLU0jN2qqIngRKQg8b4Vh9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHHBQuO0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8ED606A9DA;
	Sat,  7 Nov 2026 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHHBQuO0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8511F0089F;
	Sat,  7 Nov 2026 15:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063659;
	bh=xAJI6RWf3kgt9nI8Swdj+7KvkhkbUi5IeQmkA9WCMH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHHBQuO0JKeo+vLOdPJmO7dbV2WWQiguj948E3b7ojAB+R1aydbmr0NqmV2SZTzOs
	 wd3FVXB3kF8WJ5Vt19KOLz6KUugmVyrUBsVKtQyIS6xOjHeALKHbYv9vTt6LrNQyzB
	 v+nv0/Xr3tMid42vQi1XWgho+dUAVaNUkf6KG2Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Hoffmann <f3lix.dev@gmx.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 773/869] libceph: reject mismatched CRUSH weight-set sizes
Date: Sat,  7 Nov 2026 08:57:35 -0500
Message-ID: <20261107134918.906954938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 68bd45852fc37..e812b30778d57 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -378,7 +378,9 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 		ceph_decode_32_safe(p, end, num_buckets, e_inval);
 		while (num_buckets--) {
 			struct crush_choose_arg *arg;
+			struct crush_bucket *bucket;
 			u32 bucket_index;
+			u32 i;
 
 			ceph_decode_32_safe(p, end, bucket_index, e_inval);
 			if (bucket_index >= arg_map->size)
@@ -389,10 +391,18 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
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



