Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037104;
	b=Jxnq4YK/Jcz0CtGNehRPMa7hw2osSjnbQLiEX4seFExSDsHfFvbrb4RwDV9MPrXNrlRC
	 oGCbZ35HA9HjM0B11mQS9h7Kg4IgkWhXqhGwyKbQDgxxybo5B68OWassyTuS/0jadgSfE
	 f8T7Jp0gct/S4qzZIzU5Oz8paOaEzRCjSirITItvalxeu2hCYHPtX/kE8VoEmeH88cpqf
	 CTpR2B92lIhDuZccB458HiivzgYFEIGTiZg5UzKZxXXxSlyElvXwaOq3JpDCZITIYCgIF
	 Lfr72NJ7qh31DHPL7kuaP2gZ8pHICJy2SkRFbHAfaQpg0WjaxJMIz6/g0QR0EDemiOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dWrBqj+W37tQjCUGCwakLjBVEbCHT14BAaf9mWthprI=;
	b=0D/6491CknNuy11MmYMastf+QOkeKjGMzDa1vcqVEoqjUWfMC9kRYh33wuPvcYrfIJEb
	 CCchuSERNKbAsHE2RArYD4GA7OgMLPo76qeNM4pY9WFVDNIc65fMaXCSP2uGocB8bmzOV
	 Bn9MDwpjPi+jOyFGD9ANcb2oLUd31dwhuliWeTRuuO/iSQpPH5QynQ1Li52vnLvyBmJ58
	 yZVOIF27+jLycvM6h/CJme1D5nSE0B5RkPz/sLXUoRkdQmU0oc2gPgDQMXvetjgtJDwI7
	 LTzqwmzx6gm1zAFxsOfqoP+GjWI+kiENogV4MnRgqN/vOtoFoLK/Nf4utqmbi8Cea/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C8Rn+M1+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B401C606A325;
	Wed, 18 Nov 2026 21:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C8Rn+M1+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1644F1F000C4;
	Wed, 18 Nov 2026 21:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037104;
	bh=dWrBqj+W37tQjCUGCwakLjBVEbCHT14BAaf9mWthprI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8Rn+M1+2codvtv9yhe1+V5cieyx+qTWVCWRnYfb7iJnvxwMwADPTdSMTV/Tkac6t
	 pOjhwVojB+HjQo6bgFXiDzMV46sq6vwUftBtcvb9eE4L+4k3xSjWzLvgLkBpECKYUx
	 YD8b4q+ysoUhxEHZPt/SPTUgxmm4sCCcPPY62ZQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1243/3318] ceph: bound name skips in ceph_mdsmap_decode() by the message end
Date: Wed, 18 Nov 2026 15:31:05 +0100
Message-ID: <20261118150357.480022080@linuxfoundation.org>
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

From: sung byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit 7f702e1703c9648fcb02a217d66c880d00417150 ]

ceph_mdsmap_decode() reads two remote u32 name lengths and advances its
parser cursor without checking that either string remains in the message.
On a 32-bit client, a sufficiently large length can wrap the cursor below
`end`.  The following numerical bounds check then succeeds and dereferences
the wrapped address.

Use ceph_decode_skip_n() for both names so the remaining bytes are checked
before the cursor advances.

The issue produced a page fault in ceph_mdsmap_decode twice on the tested
i386 baseline.  The same frame was rejected without a fault twice after
this change, while a normal MDSMap continued to be accepted.

Cc: stable@vger.kernel.org
Fixes: 2f2dc053404f ("ceph: MDS client")
Assisted-by: LLM
Signed-off-by: sung byeongchan <tjdqudcks0424@naver.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mdsmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 8ddbe33306d19..6e5b929ad7fe9 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -209,7 +209,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		ceph_decode_need(p, end, sizeof(u64) + sizeof(u32), bad);
 		*p += sizeof(u64);
 		namelen = ceph_decode_32(p);  /* skip mds name */
-		*p += namelen;
+		ceph_decode_skip_n(p, end, namelen, bad);
 
 		ceph_decode_32_safe(p, end, mds, bad);
 		ceph_decode_32_safe(p, end, inc, bad);
@@ -227,7 +227,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		laggy = laggy_since.tv_sec != 0 || laggy_since.tv_nsec != 0;
 		*p += sizeof(u32);
 		ceph_decode_32_safe(p, end, namelen, bad);
-		*p += namelen;
+		ceph_decode_skip_n(p, end, namelen, bad);
 		if (info_v >= 2) {
 			ceph_decode_32_safe(p, end, num_export_targets, bad);
 			export_targets_len = size_mul(num_export_targets,
-- 
2.53.0



