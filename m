Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045821;
	b=1u9KGav/ML/OuZDuV6JFzMINtlDkFHiuNdGx8RvOznLBoz/IKK0iBWL38Eo1++7fcXhh
	 w2YZxGhNgDTqi9MbZ1wMrXMZjH08HUXxi+eZQg89DyKuhqLhCENWWc7nLxR2gwbu/ESbv
	 OO8whLe+443f2Dz7w7DyiJa39yqRX2B5ux00YLPNkuPrrsEKk2/NhpzefepC2q6H/FTAS
	 d918pRbDKne7PQXaGqd77WDycLddOHrvbGePnSK5UlSqSQeXqV0kVroahghVUpcK7asjN
	 j0929/kg4ovBZiaSM34F/jmUQ/KINN9BTGarAtXFszIcpa9/Z0197vKsbin+EvoiDvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qYZYt1sUk7Kp9kJVUtkvX/Wu3uZsKcDCU/usnaJogYg=;
	b=oFLhTawkCuBWF9aXuhVlGnEcQaLCH1tPJCkrnmNaNiD++tpM87GQOtIkYWI8Uc6lEmIe
	 JJi/gvbDMlo1gnce2W4A5GWWqDnCRLenZ1YDWge3bC2VUWtSea6HKhNpT0oZbzj97SeV2
	 W94cwZObKda7u655St7+YrORPxGngD9js3C+Z3UC2bqkcwyOz7A9sFSSKxeEWpADWm7qQ
	 S+os6MU2Lk8Vtfu6YDg3COksUzFpRCYfOqKpPCBHLZ+ssTEc8INPulJGKQJrqDjRg8t5A
	 7n9UBiAoijlFurjG0rvrbb0afCxaJFIve/qCJY7IjHg7pv8dllvTIKOB+oCEEG8hoTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oWr9RD+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D62606A33E;
	Wed, 18 Nov 2026 23:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oWr9RD+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2EA1F000C4;
	Wed, 18 Nov 2026 23:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045821;
	bh=qYZYt1sUk7Kp9kJVUtkvX/Wu3uZsKcDCU/usnaJogYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWr9RD+W0ehIYzrW91Xgzysv6PxXnUd0jlBtcUG9pHht2P2b1VlBFTNTisbArVwbD
	 u4Wii1KRE0ZBluZjr/J8OLxl/33BAfOFxkckYRfHGpHpFCCVBNMc82RdUKuHMBYHNr
	 nib3umfP/t693EqKgoXryEYkXwm1/PzDF5ahkUw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1059/2857] ceph: bound name skips in ceph_mdsmap_decode() by the message end
Date: Wed, 18 Nov 2026 15:34:53 +0100
Message-ID: <20261118150239.721459308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3c26330a781ee..ed171b3cd2df3 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -207,7 +207,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		ceph_decode_need(p, end, sizeof(u64) + sizeof(u32), bad);
 		*p += sizeof(u64);
 		namelen = ceph_decode_32(p);  /* skip mds name */
-		*p += namelen;
+		ceph_decode_skip_n(p, end, namelen, bad);
 
 		ceph_decode_32_safe(p, end, mds, bad);
 		ceph_decode_32_safe(p, end, inc, bad);
@@ -225,7 +225,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
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



