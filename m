Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060924;
	b=yKRv6EcPz8YQmQm4315qO46l/6gMW3yjIknswq2s1XxucQY+1SnSXC/5ifWVZJoPMWxZ
	 b6yQcHuR8+w4ytAH5QhmrmkcgwJ3aSm5e3pVdNIFFsgYrhnWxO6a/qX/uFmKMkb19UCgk
	 PnsKTm4UVfUDk4LhYusn/uFA5NJrzkqg3j5Cvy+UQV9/aGsV81q5FtAbvonnpPNojX6Jy
	 fLcdpEc9rD7d34WcuCGZhm70Cq5P9HvzN1Gi5IYvVuDhUqxCbnlnmNUnYcObTq7hJjNQT
	 amxKaJPPNZ5oAf9fczxWdVTl5VLqTiH978i8tZehsoUp1Rf9Kz4O43N5Gkuzs+ZUvbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+0svLT2+IyxJGm49z0Abg/CXyYxXJaxQgqQr45sJQBQ=;
	b=suLD3D02PWAXSVO4spzcr4C+S3fSZhOH3fqe/lHrg7ySEq2lFv+btSX4dZl+YvPMhdEe
	 pMv3KYzVX6etW3QAEeVrBorKedXWTI4Aa2laFZCIswqGnoWIHh2XFLsYiPTgtRjQXeXkM
	 L4TfAkBCQGWdp94ztNyvjW1rTVQZN1l5rGdsrTlRuFCoOhE6BJmqbPHABTfYvJ46x202Z
	 5nYG1J6j+J0925QQT6H8B9OmPe6qcwagccJ+n/f5zr7hh03tokVbYT2fAHXqnZmgRQ3a8
	 XDRVPGNX1RSwyta4MLVMdxvWgJhXyZd/CslNqDuZvH7z+g7TqDxaJcYei1b9ra+LDLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Td51Iart;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE021606A32A;
	Thu, 19 Nov 2026 04:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Td51Iart
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CAB1F000C4;
	Thu, 19 Nov 2026 04:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060924;
	bh=+0svLT2+IyxJGm49z0Abg/CXyYxXJaxQgqQr45sJQBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Td51IartbHRSaSqE69PHfcUr7H7hiBWwAnkX7FRmOz3yBWAaqsD2NMEXDYyQtfSF7
	 DzknZtbjPUDPCtG3cf3x3Kvm5YtzPKZ/h3yoQHpPug4aeJeoCub5nEIE54urTVxZye
	 Dwop8v+uIR8/190Qn9jOjeo6I+tCLQ4OegFvrJRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1371/1848] drm/msm/a6xx: Fix secondary rail vote in ARC votes
Date: Wed, 18 Nov 2026 15:56:49 +0100
Message-ID: <20261118150016.942470625@linuxfoundation.org>
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

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit 128a0edde50780ed9eb93ab5d2e18ca24c1f1c43 ]

Using the requested level can pick a secondary corner lower than the one
required to support the chosen primary corner, under-voting the
dependent rail. To fix this, match against the selected primary voltage
instead.

Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/755592/
Message-ID: <20260923-hawi-gpu-v1-2-0c3c79a1a470@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index e3b36e2373567..7ef0223e622b3 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1252,10 +1252,14 @@ static int a6xx_gmu_rpmh_arc_votes_init(struct device *dev, u32 *votes,
 		/*
 		 * Look for a level in in the secondary list that matches. If
 		 * nothing fits, use the maximum non zero vote
+		 *
+		 * The secondary rail depends on the primary rail, so match it
+		 * against the quantized primary voltage (which is >= the
+		 * requested level), not the requested level itself.
 		 */
 
 		for (j = 0; j < sec_count; j++) {
-			if (sec[j] >= level) {
+			if (sec[j] >= pri[pindex]) {
 				sindex = j;
 				break;
 			} else if (sec[j]) {
-- 
2.53.0



