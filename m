Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058712;
	b=pvqXEyOZww+lyVqHe9ZMxaCx2IPZU2YxlSF36JPKydzxwULeeKNiOJveC77PxRxXEMUA
	 hRcGEPEVgeb34WOB1ChSjb+dvFT8QmRfuJ9DFPjGjvoa9JC5XfHoc7TU8AaeC3XJNSORx
	 7BWRqTV3bAsIYuoypUHVj7zjlSuE6HYgMwFmSEECmLbS7TUevie5PuUQvWRGPDFAJax7j
	 hkVmF0IgBR2KS6+3ctdyUZ15tiZkrxMKKVHfYj6jQeaoC2KB4D3cDNSsEUkJua5axkobV
	 LRZa7UGmt7ok0YTPyLHh9FytOw3dciDOuxATfdrqX1zT6JPmLgPwNl5O9rfhNkZPagA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qmURsdXf+PF3wTwojdPLP+C2tfasv3We8NWOEKhTqg8=;
	b=F7J1Izq3p+dVhQFfavhBW54CCQWk7557WZL18nX/V5ORWDlzkNDK437rozCNL5ny3GKm
	 Dr/6Tn7P+dCdVi+wLW1OuS9m15Jjpjdi8oykcNE6tyaJXxX8OoiRNxnv/Fyf+KO3MJifY
	 Jdw2aXwep/7da6Trstj8XII082+9yzrZZdKFzKimlvl+5mvzlavoWpev49CLgFSN2zZC0
	 gBdw1SGXjXogFlc+r+mJ3FMXkLH8VOISWSeD5asZyk4Hasatroh8kGtDvWQaIa8KE0mHJ
	 767XifyQWAz6yOKZwuVWI1WpMuG+cPI6/NJy3aQYZSPx+m+vsDVFlWjJjZKx4AMaLag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yF7QwXkk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E2E606A31C;
	Thu, 19 Nov 2026 03:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yF7QwXkk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8511F000C4;
	Thu, 19 Nov 2026 03:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058711;
	bh=qmURsdXf+PF3wTwojdPLP+C2tfasv3We8NWOEKhTqg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yF7QwXkk5CJ/8NiDTAQGEmFrbo3E4T8HT3WN4zrLWzQu4mtEG3Hofk9To9X0nsPcJ
	 YZRsfj8RJR/6i6kwuBNn1m0gVqieQDNpEGMVzqNM0zydnXqvWKDVH/wVd+UcPecHNF
	 CT3IaVGTkEzHMi9mtfMP60z9PX2pXIRJpRn6xYaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0584/1848] ceph: bound name skips in ceph_mdsmap_decode() by the message end
Date: Wed, 18 Nov 2026 15:43:42 +0100
Message-ID: <20261118145939.863603114@linuxfoundation.org>
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
index 4f05ac84b867a..6ab3560b06d9c 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -201,7 +201,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 		ceph_decode_need(p, end, sizeof(u64) + sizeof(u32), bad);
 		*p += sizeof(u64);
 		namelen = ceph_decode_32(p);  /* skip mds name */
-		*p += namelen;
+		ceph_decode_skip_n(p, end, namelen, bad);
 
 		ceph_decode_need(p, end,
 				 4*sizeof(u32) + sizeof(u64) +
@@ -218,7 +218,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
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



