Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036931;
	b=WCHBEfBI1jcFOfuVF4qq6/Q0SjwtMWBy/Ca96RiSCHunHQCUEJwiWR6DJys0Tyrb3EJW
	 awdeiUbl54Bp3rSa7FcezpR2ongfYn7Mhra9MOhZQBe46LJ4wzvGseXw/gvOF7MdNMVhv
	 lw3viK4bLm27b226yAkNxo0HTYprl06Ze5xS1+O2h5MsffF8YDbh/zaVNFH8nBWe6M4Y0
	 4sn+WVJ2gN+18AFTMWRIROPCvt9hbwtpwAfqClqE7Uj3W/QOATfLxl5810rX6vDH62pKO
	 cH5jtOBx4YwF+KxtXloMKOG8CMzF4r5kCEcD/5HmZEFEuxaQINa7W5q+05YNrvURKzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U3hnfS78GhpzxWnqzUiWmFfZ76+Rx2h4bunQWu9XTvM=;
	b=lBIfpNEQdD1Gp3J/NyRipAKB1O4/hbMIBAkxU8w78IvRkhk7v//M696srdOvzy8N1Crr
	 7UIAy6ERW2ZRa5pHUcV1kdEqKxcG0iDKITu+AA1vVu3O0xf7IGnBPnlCq1mcwPCIpafcj
	 rRxY1ZeSdC3WXkiM8h6beRK/YjlmxskG6fQHmixSfwc4VjUTotBwvJqzItFZiYJqzTuXp
	 btZbDe25YvRUW8sLtZERneY6whaPy4ByosQAgooJlyrWfTpchplTEo+ywQnr3tc/+5dBZ
	 uQPtRYobC/8gpTjKCD8ReOvuo1MH+b6+qZlSq2BNk2Vm0ckqjXjYtTFvuu7gyA5ilVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxqxNgbu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCA8606A32A;
	Wed, 18 Nov 2026 21:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxqxNgbu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8B81F000C4;
	Wed, 18 Nov 2026 21:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036931;
	bh=U3hnfS78GhpzxWnqzUiWmFfZ76+Rx2h4bunQWu9XTvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxqxNgbuzxUqcPWV2qHUnE9ph98ugDCy7IvZtLuuk3Zlur1Ub7SbQPsKSTLwLkDZj
	 nW2kmMIXYqvMnj/1H+aE5LNpK0my3KwuGW8pcoUVjQMF998l0kNxYGmcw1AhCUQzqa
	 CXHv7Chn3vK3iEEL6r6pf0/rR4YUyNQUlvxUwhk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Hoffmann <f3lix.dev@gmx.de>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1233/3318] libceph: reject mismatched CRUSH weight-set sizes
Date: Wed, 18 Nov 2026 15:30:55 +0100
Message-ID: <20261118150357.185249149@linuxfoundation.org>
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



