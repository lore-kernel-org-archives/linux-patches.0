Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062593;
	b=iFrbjapoP07Zu3bGjvqwGpVx6XpKxPxlWu2ZkNJ+4fbLzxuk9QDGrCrQrQcbE1un0TWE
	 39zZTQp3dX8ezStJoakGUDSTw7expUupzWXxEdvI9TdesfUpGRGxEt0VXXhUkiG5xTI9B
	 h6wI9cfKUapOhEEVIWDTSCKzAiwnUG+g1Cp8m/xjy2gJR4jLApCXmJCMcVLPacAiNA49z
	 2kGYJ4ab8Kjv9E8WtVUTgu7wa/FMimpFeyQoUtqxLlocUGVMwnlzcyaYrXjHItchvO3HX
	 XmWyPb8CUTm7GLS9u1mkZPn/+FDodXOtI+6VA9ClHIG6WBSfhO3VGPuWAds5xaKWdvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2kszbeZLNlkb399vzp98idrcXVSyTjx6Sf2hylzwJGQ=;
	b=joAe3Uawhka/Kngt3vjSdTMFnFwOux/K4LBBuPN0M2COBddfwrpvd0NNX4JAfvaxcaBR
	 DlQUQafM4vV9R1VOH2cg30LJJtLQ1+IkEiVsTHGNNV/0LcjGAaKodZZEwREGpCveywnyA
	 9gRduM8E8+n5Ov7d9DJ8mH8YnmvG7OhsnvbNB2oxWS4dX5P1OI1yTl288niWhruVe0hMl
	 SqJeNdUbejOA4PGwmG9QPG9gnVmvgIDVhmz0UCZtY2Jm69rH8kKyiI8p3OEeYU0OGd63g
	 j3wXDP8whsFpXWCDPRWof58o0vqeiY/TyLCWxeqP3fuug7VB1b7LwKV9hRZGoknxcSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aTLYHdNP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D7C606A330;
	Sat,  7 Nov 2026 14:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aTLYHdNP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77C81F0089F;
	Sat,  7 Nov 2026 14:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062593;
	bh=2kszbeZLNlkb399vzp98idrcXVSyTjx6Sf2hylzwJGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTLYHdNPW/C/BB1d6ZDPDunJnxwWfhyVIWp7+8Yzilb8KCEmiOUv815U8Z1TLl37n
	 OEjZE8ddbpIW+15QfbWRgR5SLsiln6QynZfppDSXSaKIb7A1TOZ/Jb64X2VkTPJUQw
	 N93iozFAhZhlULlETSgIfzQq4Iz7Ykg/a7Fyu/Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1470/1536] ceph: bound name skips in ceph_mdsmap_decode() by the message end
Date: Sat,  7 Nov 2026 08:58:06 -0500
Message-ID: <20261107135039.133020166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0fd578f0b2cd2..d377d13f854d5 100644
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



