Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055423;
	b=Wn3ypy140sSMKTXHzxweBy/QvXQfEzr9V209u4qLo+yaaxPLx4vFkJkoQWs05eRmygP1
	 rPrPranBLdDK6jl5zoQsbEIhX00UYTpHph8OfS1TwQ3S8pjYn1F+whQmFJ/GVh0WcpNcY
	 YeCt95zUw3R3e/7Hgg537rRVGsQbO6E2XKzQtiX2ydteTP/2ip8wsz8A02l1tK7DbCf/4
	 13jcYACXTipwd9vIoyUcG0Dsffuqjj1O9DCpC4hDhIpIJvcVS0pfIsEjmgAJNXVcs9FUG
	 KAU9ut4IBqfKmaQI/UFyFAL0zJfd4JPGxNLedjK2AK0anoa2PlEwbGuopLNfegqvbcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055423;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ysx/XjViVkLvF2mytDIhvokOIVYSU8MoPOkYCPMpPM=;
	b=GvuE+qjwAGjDdxHVfBhJRdNTiXunR1SsuLf+CEcYWepTbZl4txnnjO9AaRUabM5ZSrbM
	 +/tNsYpIvc4JNE5TmDJZp7BhwKfeAn5qNPSeGm8lxo+kYh6hmC4o8tvMdozjqr3f6mUjQ
	 I339paRuc03WvS5zK8Akftg54bBWyTTyCjWMGTyY7jvfyoH2zRre/b3lytMkBe/NBbhiZ
	 Gdk01UKrt1A4I3sN+hIZymmdGp/41Gt9hveX5g8yfkM9djwnM4BxM0acdjSBzNkdA71mh
	 pfRH4K8rfFlcpSisKqapstcz8lxnnuthf6NLW96Y/ki24F9VSFXwtoN6xTlC3zveGug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o4AdsMSX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BE3606A325;
	Thu, 19 Nov 2026 02:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o4AdsMSX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA9A1F000C5;
	Thu, 19 Nov 2026 02:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055423;
	bh=/ysx/XjViVkLvF2mytDIhvokOIVYSU8MoPOkYCPMpPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4AdsMSXfdqXwXQ7/BrJqNKftt3Q/EhfQZmBc/c80DhYNrOJLWqceeo1K5TGDoyHs
	 BrJrLhduMCZTdYGVYwdMUrT3DSkSvbOE6maCGFnaqYJbI0wwfi13C6XOQSgTNud/V5
	 NP0SECPFX4dpSKWr3mHCadR0h/K+b5C7IGSSuNRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1625/2214] drm/msm/a6xx: Fix secondary rail vote in ARC votes
Date: Wed, 18 Nov 2026 15:55:01 +0100
Message-ID: <20261118150116.972128863@linuxfoundation.org>
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
index 8fa2b9e051002..a5aa7750a280d 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1304,10 +1304,14 @@ static int a6xx_gmu_rpmh_arc_votes_init(struct device *dev, u32 *votes,
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



