Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC949242D9B;
	Wed, 25 Feb 2026 01:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983101; cv=none; b=XvlpDI6BAXORhDApboooSs4hh1xUBoXDZ3iXUtbb+lf/TmBO0zDXBSyYR5yxSYnpudR7yRtMgxVnH4l0Snve+zBgLvb/ve64LVwNvSI5sZulCQKRaqwzeW6Pemsut+Wbgi+dnGAtfvZ6e23h3kO0ZCV+omvPsUzRU9kEf+nMEdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983101; c=relaxed/simple;
	bh=gqLd06KWEOdJdrbnb/aADRG9JF7s/3D0Uo3Zk8be0C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okLk3segiBuZQxQ9KSpdsf1zxzGiVQS2tUJN0o6Qhw3Dv73XWAkE/nyxeCIa2AQXPr3YenlNqISfak4JNOPUQAOl6EIdvu36QSl25kPbBEpUsI26wbNGbe0E6afr2KGUqWUXql1tFmdLzmEPKoN6xj9LQC2I2FFSxBSGo2HOnXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUBZKri9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUBZKri9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0D8C116D0;
	Wed, 25 Feb 2026 01:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983101;
	bh=gqLd06KWEOdJdrbnb/aADRG9JF7s/3D0Uo3Zk8be0C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUBZKri9lK5S03ZyQg6No8jduIuYdj6uq0Z3KAtd3WCQnB2qYLmMcpbT4utuNZaLs
	 QIBCmm1qu+uL6onZDyXC5pARswEdypqQqiWy01n3IsmYqOsHRVYsZltniht3pV0BGP
	 wGlrV+7hcLhgZeOozejlHSuovdVqaN31JMdWaJfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Minnekhanov <alexeymin@postmarketos.org>,
	Alexey Minnekhanov <alexeymin@minlexx.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 263/781] drm/msm/dpu: fix CMD panels on DPU 1.x - 3.x
Date: Tue, 24 Feb 2026 17:16:12 -0800
Message-ID: <20260225012406.149889237@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 0ec6d67c7c70b..93db1484f6069 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
@@ -681,10 +681,11 @@ static int dpu_encoder_phys_cmd_wait_for_commit_done(
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



