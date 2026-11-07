Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065418;
	b=Ryz29m42BVWd9TL6WYFjI1toMlu2YqJDE/M+DWpFjxjr0UteXMq39KUhwp85EzsJgopZ
	 AD/FxUvqFTizIrYJeKWY0/E2QQgg8uCoPwyWH7pAtccF/xJT7nwgHdaajzxKt9bZ/t1QZ
	 8PupEMuEu5u5XvftEmrb4tU8FE5z1fpLOYu2iO+j+99h7tMGAGxshi32VjQ7bgoP+0+jY
	 UvW8a79ltTAZ/+60XVgZ9eirL6lzHKSJSL9AyEwEi6pEycouAMsy4SScb6gqhvFcbO0Qu
	 RWBZ5X0UN4JD3EUucm0vrihUyQyFAawAV02MjWV6D03Ygnt83JwBerGaXMRVCrDNx/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Af+sTaewNEf1X3zSAxuq6k+cY/u52rfC1dVIbVFwD84=;
	b=07V0+QMc0F1xCwZxQbhHUdlYrzoA3pXfeHOi2vzlJpRG0k7FAkaFDON8PX8AwRHTUAVc
	 8ga0CjOovqhmTSisYLjeXux3bl9BOkqzpqKxhJiA+NNd0M5n+FMMOIfzodTS3ru3PkXI5
	 8jhiBGpmRZT8ghyqNc4Lg1gbIMAjdRhxGcolOBhbBZjfJL+cyOoatj6R5NDRqe9/Lr//l
	 wVBnBHIKHxdvB84AiEDC6jcA4X49s7MdlcyouX2qc9v+6d6nfRSMEkaDfknixPaFdB4le
	 m2XGcibUAU+PGjW8yoJ9dsjlcgalUVffv8V/33UjNtFghBH0bwP35IFT9C2XWt2OAbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OAF2VvMh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410D2606D80F;
	Sat,  7 Nov 2026 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OAF2VvMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499F01F008A2;
	Sat,  7 Nov 2026 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065417;
	bh=Af+sTaewNEf1X3zSAxuq6k+cY/u52rfC1dVIbVFwD84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OAF2VvMhUXyB8kXDnwbGI8pk/NmUg/+H35MKcCAKb58ZguwMd9kGx+f6kYjlyy9M6
	 GYpkm5zwIyi2/DB3j0CcuhgsrjoYELfDwCTQwprCpWcJZ/nlQrBonWxutjgfsOjAzN
	 uyfgSgMUVbvDDJMrRuqPFfbDVyaZTYe4ZQXKbkMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1133/1257] ceph: bound name skips in ceph_mdsmap_decode() by the message end
Date: Sat,  7 Nov 2026 08:57:09 -0500
Message-ID: <20261107135010.523232121@linuxfoundation.org>
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
index 5e3b8c3ca5021..8e2937e4e5628 100644
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



