Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B77346E66
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302106; cv=none; b=fbLCXGNLRrMDIPx28DJHBwu01PEwjKZwT6AmFWdvFjgJoBBS/rhnXgzKNtkMA2JNSizgpDyOwhsUUU6cK5hv1Jft6aFWn0i23D6eg0DOt/EkeRV3n/4XEvCyKtx8tYagVT24VKcAKdraUlyKZNC2ORL4gygOzhBswjvPag9d468=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302106; c=relaxed/simple;
	bh=M73fkeFO/Awv509urLNj6yBLDbowa8gvnl6tGLLNoKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZTFcsQucDHtYHsBo0fHb0y/SB3FKGTQ5UCVfPBvi4WlcgmlJJPkkSNDER6BDOTERo5KT7NJ5qD4Ng613E0HIx7hxhuErtTALDcuQjYBAJ6zN7hdO7pT3lWR2IUma/Fp598rYarZpaezcW6FfI6ChhCQxDC6PfBRembENTZYUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgvWfwmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgvWfwmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B503C116D0;
	Sat, 28 Feb 2026 18:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302105;
	bh=M73fkeFO/Awv509urLNj6yBLDbowa8gvnl6tGLLNoKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgvWfwmQlwKmbk6pmjQLNjIyXx7kt0LbwhYu31i2Lj7vs5z9VAF55cAhmCQYzJiNE
	 mkHTDQvgdyJYyctlTkl2FEbyK+3lWB92+4zXmJTheZDY54XhaI9ygJVQdBX9E0AAlw
	 88DniRtGbOsKtE/raYRUPqHhJrWKWHWeVAjCagwtRXL4zoqFD7OdENWdyDYT2AuUC8
	 7I9F9LTLZQFUPC+w+ZI3IZZ6UWuRMk/4FUqnwSoJNspGukMIWlsmlceSpX9bmFU9Zt
	 hJgH54Oj2TuWPl/SP2RCpZhnMxOyDTeFcXs1o5QebhcB2ZjpdvwMJRiFlzYLeYAFK8
	 Iv70DIuPBn5Fw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Alexey Minnekhanov <alexeymin@minlexx.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/283] drm/msm/dpu: fix CMD panels on DPU 1.x - 3.x
Date: Sat, 28 Feb 2026 13:03:55 -0500
Message-ID: <20260228180709.1583486-93-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 59ca3d11f5311d9167015fe4f431701614ae0048 ]

DPU units before 4.x don't have a separate CTL_START IRQ to mark the
begin of the data transfer. In such a case, wait for the frame transfer
to complete rather than trying to wait for the CTL_START interrupt (and
obviously hitting the timeout).

Fixes: 050770cbbd26 ("drm/msm/dpu: Fix timeout issues on command mode panels")
Reported-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Closes: https://lore.kernel.org/r/8e1d33ff-d902-4ae9-9162-e00d17a5e6d1@postmarketos.org
Patchwork: https://patchwork.freedesktop.org/patch/696490/
Link: https://lore.kernel.org/r/20251228-mdp5-drop-dpu3-v4-2-7497c3d39179@oss.qualcomm.com
Tested-by: Alexey Minnekhanov <alexeymin@minlexx.ru>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
index 83a804ebf8d7e..fd2400c4665d2 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
@@ -675,10 +675,11 @@ static int dpu_encoder_phys_cmd_wait_for_commit_done(
 	if (!dpu_encoder_phys_cmd_is_master(phys_enc))
 		return 0;
 
-	if (phys_enc->hw_ctl->ops.is_started(phys_enc->hw_ctl))
-		return dpu_encoder_phys_cmd_wait_for_tx_complete(phys_enc);
+	if (phys_enc->irq[INTR_IDX_CTL_START] &&
+	    !phys_enc->hw_ctl->ops.is_started(phys_enc->hw_ctl))
+		return _dpu_encoder_phys_cmd_wait_for_ctl_start(phys_enc);
 
-	return _dpu_encoder_phys_cmd_wait_for_ctl_start(phys_enc);
+	return dpu_encoder_phys_cmd_wait_for_tx_complete(phys_enc);
 }
 
 static void dpu_encoder_phys_cmd_handle_post_kickoff(
-- 
2.51.0

