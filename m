Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0488E26C399;
	Tue, 11 Nov 2025 01:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824268; cv=none; b=ktXzzb3sds3zr0iAbL0sZVuGAwwlnAuVeS/fId81FGF9Z70q9JJZqG89pLQocvjg0PMM9qovbQwe+iFSmjW/yntdZ/LB7zXtfWx36/fA6RttiTeX4DE6nsPSmGWE5j7M2w+Kym9dyhL8ceVgvsuBS/Nl5cs+xwrCFNpetIYDec0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824268; c=relaxed/simple;
	bh=60vlrtQRvVFIr4jOFUNwB63k+2hikOwpiBVgebQ7EMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulVQ9lkRtGJNLng0dUFXj+XA4N0LhUcOIQR2iaeTd9q6vd8eIpz72FTwj88YXyW64OURmyi1OrgE297dRIdifYxRwAsOqCKP4q2NLvO3ZqUDtR1XwfK088skLCOVATbKcCbyDa4KXLI1xqE/7J2eYso7jr9Hat4RHIPRl1spr2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXrmLHY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXrmLHY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A89C113D0;
	Tue, 11 Nov 2025 01:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824267;
	bh=60vlrtQRvVFIr4jOFUNwB63k+2hikOwpiBVgebQ7EMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXrmLHY35mEcfur2ctpyNdSA40WpSgzxRh0gDapRtmA0x3YGK613ZafDcGKpCy+hA
	 7NINcfA/PbLC0g+OJAFROCplmHseb0YPDZmMq8Xt7/APJ/GBKJeI6CObCQcULZl5NE
	 CNMLbsPEK+THYseVhiGAtp5TfeXp3fNw4OPWQltI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 474/849] drm/msm/adreno: Add speedbin data for A623 GPU
Date: Tue, 11 Nov 2025 09:40:44 +0900
Message-ID: <20251111004547.906908984@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit 0584da4515dbb4fec69107ce837eef36a7be5d7d ]

Add the speedbin mappings for Adreno 623 GPU.

Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/672462/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
index 2b1c41f6cfeee..3c82b3f320e3a 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
@@ -913,6 +913,11 @@ static const struct adreno_info a6xx_gpus[] = {
 				{ /* sentinel */ },
 			},
 		},
+		.speedbins = ADRENO_SPEEDBINS(
+			{ 0,   0 },
+			{ 185, 0 },
+			{ 127, 1 },
+		),
 	}, {
 		.chip_ids = ADRENO_CHIP_IDS(
 			0x06030001,
-- 
2.51.0



