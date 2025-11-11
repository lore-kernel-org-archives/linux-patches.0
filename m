Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250F4346FA2;
	Tue, 11 Nov 2025 01:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824243; cv=none; b=jQlVq/9sXZTKcBAAKtjPufMmyaEmv4PoR4H0tx3h13fJvmUeO32MZeLMJqt0P6oKSWtdMK1mc3Vq8qKi2tA3kVAMDxnVd6mQoWnPWTW/OZAUJ9ImyUK5dlpA7U5H7/qaGCZ64EyGw7mA+c6Mvgxj6iLsscAXDGng0Tcvb7+8BnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824243; c=relaxed/simple;
	bh=NiInLx34toYi3ZZVlIugM8NyaYJoU988m+67NURAA8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpK17+zHoXYCR6I2ccVEvk54hUPohLUEjGk5leKDH/5PA3iZXNT6gf3FwUaZeg18FPKTwDP9KsFO9Dukv06IDPvyUim/tIOIo4oGWDBQFZN7dSgd+HgJeXHZEzgGbo0znVreiEav9VZj8Uv82PcuMek+TC5nqVOA+i1yVdw5tnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NyFMOLdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NyFMOLdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A54C116B1;
	Tue, 11 Nov 2025 01:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824242;
	bh=NiInLx34toYi3ZZVlIugM8NyaYJoU988m+67NURAA8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NyFMOLdhGIqwYeLCmeqWOcgVwHv+C+STVmULP5BE+vgLuGUZNtGqEI32+qca7jtMT
	 oCUDKb+P6yjm/51qRm/kMFdntRV1hJD5TGPyemHshj4kinslN9syZQqJb6xa0IEyF9
	 tEv6oGD5ORjTPB2itksrRSU70GtlUCrVMUuTuuUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 469/849] drm/msm/adreno: Add speedbins for A663 GPU
Date: Tue, 11 Nov 2025 09:40:39 +0900
Message-ID: <20251111004547.779655591@linuxfoundation.org>
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

[ Upstream commit 0c5300343d0c622f7852145a763c570fbaf68a48 ]

Add speedbin mappings for A663 GPU.

Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/670096/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
index 00e1afd46b815..2b1c41f6cfeee 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
@@ -1024,6 +1024,11 @@ static const struct adreno_info a6xx_gpus[] = {
 			.gmu_cgc_mode = 0x00020200,
 			.prim_fifo_threshold = 0x00300200,
 		},
+		.speedbins = ADRENO_SPEEDBINS(
+			{ 0,   0 },
+			{ 169, 0 },
+			{ 113, 1 },
+		),
 	}, {
 		.chip_ids = ADRENO_CHIP_IDS(0x06030500),
 		.family = ADRENO_6XX_GEN4,
-- 
2.51.0



