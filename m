Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049019;
	b=ssmBFrJoAyixoHq54rlTl/0ins2Hf8hiIBfRUc6Bzo2WGWDNRMhywpqidE58LoKiRvNQ
	 7Kb7X7mq/ddHh9HnkjmkI3fZwZg5SoOGib5MwVAI0hnhDzcebSns+j1eJZW/Ifv1zKwBd
	 uwZjrAokX4YOLGuniOngNu+pqoPSpX//IDaB8ikgc923HDNxpxy1JujntMMiYO8q5AFLv
	 b4iVdgBq+jeuhbkkY8nl+eignzZPgRi6XFJR7SR30eiarjeInPVMXu7JP69VFrsM3ZXXc
	 DN4kDXxJtbFgTgdy0JwaTc7cs4e1xMQnAfgXC/pDB3ASdVYWwSLuSKXziDFiR2RjlpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YeznjIlO7hZyurY6sieFokZtiGpdZFdVVwt4CQ/w7Yo=;
	b=t6E5vhhqE4btzIIUW/XgOpNPIKy7//1i3rJ+oQthL6IIB7h5BZKK7pfA57JgEg4K3eOI
	 5sU/1z5X9NBSDhoG8WqeM4JrHlsmJwyRKSiS9gsHgqKdV9B/gwXOY0Ak/q/nQ4djzsl54
	 UMFrU6+CA38t4OZXQrGrGBe2wODoqXUYlEurqpUGj9kefiJ7LOBYhqOKzQemH98sJiRVI
	 h3PtRdyW71kmuI7hrVUxbb4nfzRQ2CH6wItqtNovv9agcjbotrGDAW1sjzkLkQXc4awwm
	 ThaqLXA0d3dXWDyFdaWKTwmcipn7VuiC00p/JVOaP5nlyWx8RB/EnJHqHPCAKAnBiKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfs3hhCH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6315E606A31C;
	Thu, 19 Nov 2026 00:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfs3hhCH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73351F000C4;
	Thu, 19 Nov 2026 00:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049019;
	bh=YeznjIlO7hZyurY6sieFokZtiGpdZFdVVwt4CQ/w7Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfs3hhCHd0NoFurJOUcccCaBqWV2EPeWS+5kSLSVwyHCTbZ5/Gu8MyaM0vQO5ZaDl
	 E6yCWRRmydRTIaz0kT9aIRcyFSTtwvDMOkzyK4e0Ulg2N+7JLccZvXipjiobfFnyQc
	 c4YTCEO3TxRugSA7FAWfIH2rvjTTF1iPSKae7bRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2185/2857] drm/msm/dp: dont report link training success after a reinit
Date: Wed, 18 Nov 2026 15:53:39 +0100
Message-ID: <20261118150320.077406302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3c001b792423b..8abd5e512cf6d 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1770,6 +1770,9 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
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



