Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3175B24EF85;
	Tue, 29 Apr 2025 16:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945809; cv=none; b=LdTud4MDCZzChpiMP1nM2koIT3rznDkTJaXU3AVzFx4Qu9lYbGNeZcLbuBMpJN3ozORF2GEdqvu0+H/f0ooyxCB6ySKKV+3gqT4jWQDxAErUqx5ricoUPcjFtmdmKWum7fpo2dY865pCcYhNwzn+URdbn8LqVZKmhSPXd/ugOhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945809; c=relaxed/simple;
	bh=kLOxEay2YJcA5NCyfNzfnWw5/EGp5h6LnBooKZqtxBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOkH5lsl909SjclwySG+NTIY+shO3LsQ41aJjHpOcv0FylTSxdlVSqGV28y+iltofUnO808uNjdiAG+idCtO5VPtTWKtH15uwFCPr5k9CiRVNH0oUaX1eSca4mQA40PiV1A72MFLxN/iartzXAYUxsNI2tz3eMDdyV3PbrjDASU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TR3Celr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TR3Celr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00BCC4CEE3;
	Tue, 29 Apr 2025 16:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945809;
	bh=kLOxEay2YJcA5NCyfNzfnWw5/EGp5h6LnBooKZqtxBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TR3Celr15sJht0dpoTROhqUXyYN4/v1xqVZ9MtO10QrFH5vAMoZc75Fc3LmZKMw5D
	 BxmV+Lxe8kvXixAJoSFLLjlEPNJI1nZ5Io31aYjABE+8Vc/vxM/QTpae3J8lJ/TZMC
	 00T+7PHMzit4SPXUGInmmqpbSWmqM6A0XJOacT1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 027/311] drm/xe/ptl: Apply Wa_14023061436
Date: Tue, 29 Apr 2025 18:37:44 +0200
Message-ID: <20250429161122.150571232@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 92029e0baa5313ba208103f90086f59070bbf93b ]

Enable WMTP for the BTD kernel to address Wa14023061436 by setting the
proper TDL Chicken Bit.

v2: Apply it on engine_was[] as this register is not part of LRC(Matt)
    Apply it for first_render_or_compute in case this gets extended to
    compute only platforms(Matt).

Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250108141323.311601-1-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Stable-dep-of: 262de94a3a7e ("drm/xe: Ensure fixed_slice_mode gets set after ccs_mode change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h | 3 +++
 drivers/gpu/drm/xe/xe_wa.c           | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index 162f18e975dae..b4283ac030f41 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -500,6 +500,9 @@
 #define   LSC_L1_FLUSH_CTL_3D_DATAPORT_FLUSH_EVENTS_MASK	REG_GENMASK(13, 11)
 #define   DIS_ATOMIC_CHAINING_TYPED_WRITES	REG_BIT(3)
 
+#define TDL_CHICKEN				XE_REG_MCR(0xe5f4, XE_REG_OPTION_MASKED)
+#define   QID_WAIT_FOR_THREAD_NOT_RUN_DISABLE	REG_BIT(12)
+
 #define LSC_CHICKEN_BIT_0			XE_REG_MCR(0xe7c8)
 #define   DISABLE_D8_D16_COASLESCE		REG_BIT(30)
 #define   WR_REQ_CHAINING_DIS			REG_BIT(26)
diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 2553accf8c517..ac471e2454d34 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -613,6 +613,11 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 	  XE_RTP_ACTIONS(FIELD_SET(SAMPLER_MODE, SMP_WAIT_FETCH_MERGING_COUNTER,
 				   SMP_FORCE_128B_OVERFETCH))
 	},
+	{ XE_RTP_NAME("14023061436"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3001),
+		       FUNC(xe_rtp_match_first_render_or_compute)),
+	  XE_RTP_ACTIONS(SET(TDL_CHICKEN, QID_WAIT_FOR_THREAD_NOT_RUN_DISABLE))
+	},
 
 	{}
 };
-- 
2.39.5



