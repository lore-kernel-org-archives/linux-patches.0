Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030618;
	b=lLOcL2mwnF26gNlPpqyGBQXhqaIvzdZqqe46GfILjuZFc+6FrxjW7zezewiULLIUIfEL
	 nT8r5y1fMPeRMbS2pz5AGOaAqN1acMSGiq5OyBdHXuaWOOJMppZy5UNBzzP7mGi8KR8pY
	 YqAISLU9/FkgjRp0iavtaoA8GfUBxK8x34YM1HHWnPHlni/opvveSXTtM6Xw5ARD8gtYi
	 wEB5l/NgUChnlaUCZ54Ib8N02ShnuPEM75ve2fvm5L4HDe1MZr1B+gOHOov6SOUt2uCdZ
	 bAL3t1KHrjd342xazuYmU8JuiW/pZONLKhG+9iHEeuZ257JL837k/2x0F9abuEFvk0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pRDdPgSGzRHhnHV626ZcXwbCodTbtZleMusuLWKiB5I=;
	b=E5I/zyc5hr4BZ+e7xJywh29H5VdcZ/tRVsKNnHL4TnbLpbOSlMoeL0GRjyfEPeWUtNDh
	 wrhh8/KX6P7ZgcwoPVb9HxjSqUOpbXcK5JVm8NK8CGLdMZEUb/ZiAPa5Qon0xJAmfLjlC
	 9/+P7dxtOAeuZkrZ2bhfg1iEEKHdelz/djdiR4HR0tEGbQMp4v2aMh24eq6IA7251LFxb
	 TQEoDBmueU22GG8jNizm7sM3dsPjoM5QysdaBe6sOq5HKeuQSWIWPVlZgUtG7aW14dKgk
	 nXf97v4QTVL1XB4hvn2KT/LpcUOFasgjVejLcStK7Db8mJEkvD8THlJrQSV0RjVNhPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iei5XALH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41AAB606DD0A;
	Wed, 18 Nov 2026 19:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iei5XALH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975581F000C4;
	Wed, 18 Nov 2026 19:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030618;
	bh=pRDdPgSGzRHhnHV626ZcXwbCodTbtZleMusuLWKiB5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iei5XALHIdAVxUfJF+Hsll/FxGqwOxNaTn+/yBlHVgMDHlRFbPiq5HQgM0um4i18n
	 BY/ZdFy6JpTtwt+82zEmArgRpReCm/ow+Fc9U9uvPYBzNb+7kSoZYU5AjNpq23TKR+
	 YS3P93ua0Tlaw6BVHBdDRwxcOXdUIGhXhcgywF3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0768/1756] drm/msm/dp: dont report link training success after a reinit
Date: Wed, 18 Nov 2026 15:48:15 +0100
Message-ID: <20261118150040.195680015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Keri <okerixx@gmail.com>

[ Upstream commit a47987366e7fc2c05aeffc97f8e1f776e583f792 ]

When every training attempt fails, the retry loop in
msm_dp_ctrl_on_link() ends on a successful
msm_dp_ctrl_reinitialize_mainlink(), leaving rc at 0. The caller then
enables the stream on an untrained link and the display stays dark.

The retry counter only reaches zero in that case, so treat it as a
training failure.

Fixes: 8ede2ecc3e5e ("drm/msm/dp: Add DP compliance tests on Snapdragon Chipsets")
Signed-off-by: Oleg Keri <okerixx@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/756528/
Link: https://lore.kernel.org/r/20260925125314.16563-1-okerixx@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index f342fc5ae41ec..90deffb9fbddc 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1915,6 +1915,9 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
 	if (ctrl->link->sink_request & DP_TEST_LINK_PHY_TEST_PATTERN)
 		return rc;
 
+	if (!link_train_max_retries)
+		rc = -ETIMEDOUT;
+
 	if (rc == 0) {  /* link train successfully */
 		/*
 		 * do not stop train pattern here
-- 
2.53.0



