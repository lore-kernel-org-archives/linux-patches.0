Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE381D0956;
	Wed,  2 Oct 2024 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875897; cv=none; b=mjNE3uAFac2Yl+0gMfXQ9i8ZdHZCr+Ao11+NMv7mvKt4nmhcjmEWP1uCCRXIcAiQbgcf1NYx7xzwiRcrXzilOXtXCUxQXizvybSMaQbTBqGi/7lXf0MJPIXM76xTUH7U/7He0mEaAstRSc+02YruWCqqgJW7Y07MCAQdZPuH7Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875897; c=relaxed/simple;
	bh=Oz3diKBAv1GtTZx+ItJb+pDTkYXV9mrxCC8/ecASXvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiOQlKJATQW5vrxeIPF6nm5geeV1URRFC0gGVup2dtoZKAovOiVPwuq4huoSjY71pI4WXZkTIsAi33QrMER8lkAYv7OtU5qeAQYSFq3U6TRlTWX6bYo2dqnfyY2MfBqWW57ihYoZMdPNjAZMERNYh3HfNBgUKkLoWu8RL0t1m6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiA2K7SJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiA2K7SJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76689C4CECE;
	Wed,  2 Oct 2024 13:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875896;
	bh=Oz3diKBAv1GtTZx+ItJb+pDTkYXV9mrxCC8/ecASXvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xiA2K7SJJ9kJI6FujaeRcIFopu+YPZyfjd8O2EoA0H5rjhyGrc/VveeaASNJ+qPF/
	 fmFlS5/H16rK3MwphSrCt+fVJx1s7e6bBPPHTnxVynAagGGAkoyuQraoB3BHC72qTv
	 Ojr32BjMetme3dWNkG0AO+dUtHh8qOdCpspHJc84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 227/695] drm/msm: Dump correct dbgahb clusters on a750
Date: Wed,  2 Oct 2024 14:53:45 +0200
Message-ID: <20241002125831.516138625@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Connor Abbott <cwabbott0@gmail.com>

[ Upstream commit d8c17d7aadc2463a395f9340f44c7c34399f1d48 ]

This was missed thanks to the family mixup fixed in the previous commit.

Fixes: f3f8207d8aed ("drm/msm: Add devcoredump support for a750")
Signed-off-by: Connor Abbott <cwabbott0@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/607393/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index f2030e521a03a..0fcae53c0b140 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -663,10 +663,13 @@ static void a7xx_get_dbgahb_clusters(struct msm_gpu *gpu,
 	if (adreno_gpu->info->family == ADRENO_7XX_GEN1) {
 		dbgahb_clusters = gen7_0_0_sptp_clusters;
 		dbgahb_clusters_size = ARRAY_SIZE(gen7_0_0_sptp_clusters);
-	} else {
-		BUG_ON(adreno_gpu->info->family > ADRENO_7XX_GEN3);
+	} else if (adreno_gpu->info->family == ADRENO_7XX_GEN2) {
 		dbgahb_clusters = gen7_2_0_sptp_clusters;
 		dbgahb_clusters_size = ARRAY_SIZE(gen7_2_0_sptp_clusters);
+	} else {
+		BUG_ON(adreno_gpu->info->family != ADRENO_7XX_GEN3);
+		dbgahb_clusters = gen7_9_0_sptp_clusters;
+		dbgahb_clusters_size = ARRAY_SIZE(gen7_9_0_sptp_clusters);
 	}
 
 	a6xx_state->dbgahb_clusters = state_kcalloc(a6xx_state,
-- 
2.43.0



