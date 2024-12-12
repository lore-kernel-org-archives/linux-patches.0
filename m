Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BE022969D;
	Thu, 12 Dec 2024 16:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022069; cv=none; b=pCPTaSAqtIyWn8afgK80sapPAHtts7aXSqBtas2XvEGflvaGJsHc/FDbbwVNqBTLNgf262eWJKCe4ZPvQ5HgPROLppmwPl2eYAY3oSLl3vvWjznMQej9B/1B6bYsIDWITAbYa2EuCWLNPTv3hdKeXDqf2sL3yR2RvpKs3guI/OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022069; c=relaxed/simple;
	bh=GBPzlYY79WhNrVWGgD4U1xwOOEUEfe9Kjj2E8IvKfp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zoir4PtAuB14kvINyjLp0SDSNFZ8dvWOJS2Feia+CLnYKYx9LpgjklF2FypX2rUAWiYU7nm9SMLKkhe4q3paPZM8BXSzbQBlpMsk8TcEUyZW5BS5fS6oeR9zMBrOtTX69KC6hdBFNVYXlM4pgvfWbdVIjjA9roO5eoohf806OYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4z+g/SE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4z+g/SE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4340EC4CECE;
	Thu, 12 Dec 2024 16:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022068;
	bh=GBPzlYY79WhNrVWGgD4U1xwOOEUEfe9Kjj2E8IvKfp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4z+g/SEtrthKpA1OZphvIL9bmym77dFwOvBgch0d2moL80HusUhyrj1Wsq8MwJoj
	 oNEbJ+2cAs6YCzzTB2YH/JHuuLQaPQ4u0amloGpoy0Kt4WO0Iq2EvCvoNoSugMtprl
	 8YesprN3+jPtedlbgdkgLsYvYq0z+T0hjWutAh1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viswanath Boma <quic_vboma@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/565] media: venus : Addition of support for VIDIOC_TRY_ENCODER_CMD
Date: Thu, 12 Dec 2024 15:55:34 +0100
Message-ID: <20241212144316.975277044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

[ Upstream commit 2f2d6fe83d0346923f0247e15dd51f3257e65edd ]

v4l2 compliance expecting support for vidioc_try_encoder_cmd .

error details : test VIDIOC_(TRY_)ENCODER_CMD: FAIL

Signed-off-by: Viswanath Boma <quic_vboma@quicinc.com>
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 6c9934c5a00a ("media: venus: fix enc/dec destruction order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/venc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 2c23d83273a85..52a7366d7a5fc 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -549,6 +549,7 @@ static const struct v4l2_ioctl_ops venc_ioctl_ops = {
 	.vidioc_enum_frameintervals = venc_enum_frameintervals,
 	.vidioc_subscribe_event = venc_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+	.vidioc_try_encoder_cmd = v4l2_m2m_ioctl_try_encoder_cmd,
 };
 
 static int venc_pm_get(struct venus_inst *inst)
-- 
2.43.0



