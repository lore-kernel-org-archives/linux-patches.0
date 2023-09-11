Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7814911710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E71C433C7;
	Mon, 11 Sep 2023 14:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441260;
	bh=TDaBuXMyCoo57jtLVaisMhhF0dmZ6KACD7e+H1RAJ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DkU+bSePm69FNKKp88ZFBs9SwOK2TKjsw2xEgYpaxIydZ8cyEEvmtzYxmYiZNmY82
	 ORNwJe2xEdjt36wmqIKDHylzCcgNIAFba6bGq8sSc9EWPV6dxhQu6E+cLrWPxsaF45
	 mpc4Tw4c4wWjSj0q7C47FgIWVs8PRTqFAQQka85U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 351/739] drm/msm/a690: Switch to a660_gmu.bin
Date: Mon, 11 Sep 2023 15:42:30 +0200
Message-ID: <20230911134700.925818544@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 18ff50e582a08eb365729b7c5507a86c41f2edf8 ]

There isn't actually a a690_gmu.bin.  But it appears that the normal
a660_gmu.bin works fine.  Normally all the devices within a sub-
generation (or "family") will use the same fw, and a690 is in the a660
family.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: 5e7665b5e484 ("drm/msm/adreno: Add Adreno A690 support")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/552406/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index ce8d0b2475bf1..6e3c1368c5e15 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -371,7 +371,7 @@ static const struct adreno_info gpulist[] = {
 		.rev = ADRENO_REV(6, 9, 0, ANY_ID),
 		.fw = {
 			[ADRENO_FW_SQE] = "a660_sqe.fw",
-			[ADRENO_FW_GMU] = "a690_gmu.bin",
+			[ADRENO_FW_GMU] = "a660_gmu.bin",
 		},
 		.gmem = SZ_4M,
 		.inactive_period = DRM_MSM_INACTIVE_PERIOD,
-- 
2.40.1



