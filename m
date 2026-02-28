Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CD4347FC0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302355; cv=none; b=Yzu0TjhwzDMd9A7xP27nqXaK6/MnKAsleh6ioWDmXBj/qh3t1ikI6nu833kyDaGms33c1F3DxUI1MpnqkXnSXs3OmnyVp13uQsqAZK0fXEbRTXQ/xsmiUQ1bKvkQjP42NqsPDM7jsXGVg3L+pyMFA2Tn4YC2E0Vm9pebr6xGons=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302355; c=relaxed/simple;
	bh=s64DHG7Nm7hZVgYROKZec2bgd0yBIQ/w4hG/iBsriio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lglz+E8GqwIMsl1RECyeL9KJmQYRaituShuOn+SkDGWcgPetUpAgvUKlLts19f2XuzFnt4B3gqcj7EHm5IBf2DYXjJ+gXYwAD1hfevbHqCcjNrgDSeagVxyXVsW73U6DuLabeGazqg9Q/uoDxNnU1CpiCMAPezMDLVYhRU7hZmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/quz8nR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/quz8nR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1A5C19424;
	Sat, 28 Feb 2026 18:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302355;
	bh=s64DHG7Nm7hZVgYROKZec2bgd0yBIQ/w4hG/iBsriio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/quz8nR/tz2GUXEubtiwxZJPqH/ADF0hf9K8Ksbz5VSBFhxsimos/2C3MgF+UHme
	 /uXHuoqQnmO99pQdWZbYDaV9TXWAdzDah4e6TFw9oZIwkLgdr4Mrat+gX8YP8rmO7C
	 IgO/brHtkIcGWCN1R7/0E47gkRGMM/AwgKs/aK3Vz8Ahucp6QUNmhdEEiiPcy8AloI
	 PEeSB+6oYfSuBGeOxnBb+yiU7/8D0KhXxPjJhDWDhmhC4B7MBxv+YXABokZUxbt0ck
	 vTAScHc7290fxec/VFZst7PH6nZeiO3QLBoMUCCfo7VqGNgardvHaS70DmPErkobtU
	 6sT216qh3wsIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Alexey Minnekhanov <alexeymin@minlexx.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/232] drm/msm/dpu: fix CMD panels on DPU 1.x - 3.x
Date: Sat, 28 Feb 2026 13:08:54 -0500
Message-ID: <20260228181127.1592657-81-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index e05c3ccf07f8e..7581e418418f1 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
@@ -685,10 +685,11 @@ static int dpu_encoder_phys_cmd_wait_for_commit_done(
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
 
 static int dpu_encoder_phys_cmd_wait_for_vblank(
-- 
2.51.0

