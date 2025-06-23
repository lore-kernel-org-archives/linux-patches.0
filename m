Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DDE242D90;
	Mon, 23 Jun 2025 13:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686170; cv=none; b=phTDjceE4vD+en2D3OUX/2zXpcChWuQRYnKJdSjTU4NUjXakHhtICJQs/3bWSaefDu9G/VJ1VLUac9iG5rdbpt+EWn1TmhMRKYL3iAwQrBcckaYT2/bnt24AJcy2VvFlwBEhpFJj19DuCdqe4FMpieYKcavC/f+qIEbFid7G10Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686170; c=relaxed/simple;
	bh=+xJ3mIsovBNQ97nLZMCrva5iMYeNQK3K5gmYUMKDHdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaDBfS/gtSwt9Goj9RD/uxQMbItY/XEM03+YXwFN8YeGBx2GRl4MUAi3DSXm9E6rjKKHgtzDMh0X+JNCBfLW/5/EsjGgxTSzSF87WhjyTQufA0yeOGSZYRxFV2hJCr5SMK/xLt2cn3ykN2xqSoNCyosTd1tf+31r0h9RMAIEJmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLOg9jt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLOg9jt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE59C4CEEA;
	Mon, 23 Jun 2025 13:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686170;
	bh=+xJ3mIsovBNQ97nLZMCrva5iMYeNQK3K5gmYUMKDHdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLOg9jt5W6bwKdZcuI61Gny7KTRHvtddgWhPeFkBoNN8TZEvfzAMm430BLVlDQbM3
	 W0oJft0EzKMl51h6+LxTriY9kYOIEg8oagR2EpmXqjDnuc+8s01544jZjXRa/jRFrh
	 tZRm16lSOxgw/U9ZbVXEQFbcEmfdIFitdSGnPmXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Maya Matuszczyk <maccraft123mc@gmail.com>,
	Anthony Ruhier <aruhier@mailbox.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 147/222] drm/msm/a6xx: Increase HFI response timeout
Date: Mon, 23 Jun 2025 15:08:02 +0200
Message-ID: <20250623130616.510688166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

[ Upstream commit 5f02f5e78ec9688e29b6857813185b1181796abe ]

When ACD feature is enabled, it triggers some internal calibrations
which result in a pretty long delay during the first HFI perf vote.
So, increase the HFI response timeout to match the downstream driver.

Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Tested-by: Maya Matuszczyk <maccraft123mc@gmail.com>
Tested-by: Anthony Ruhier <aruhier@mailbox.org>
Patchwork: https://patchwork.freedesktop.org/patch/649344/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_hfi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
index eda11abc5f011..d437196225457 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_hfi.c
@@ -88,7 +88,7 @@ static int a6xx_hfi_wait_for_ack(struct a6xx_gmu *gmu, u32 id, u32 seqnum,
 
 	/* Wait for a response */
 	ret = gmu_poll_timeout(gmu, REG_A6XX_GMU_GMU2HOST_INTR_INFO, val,
-		val & A6XX_GMU_GMU2HOST_INTR_INFO_MSGQ, 100, 5000);
+		val & A6XX_GMU_GMU2HOST_INTR_INFO_MSGQ, 100, 1000000);
 
 	if (ret) {
 		DRM_DEV_ERROR(gmu->dev,
-- 
2.39.5



