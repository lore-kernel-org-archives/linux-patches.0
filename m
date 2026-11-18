Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061134;
	b=u0XCR/YtQ9Hmmxga41IPeQ86rIvuZakmXNIdTk9wuA/WtGQvvEflMAEn5yVQ27z2zIuv
	 /20PlXEAfryR9aXRz0b6P+UCsgCv+0Bxwzp3EiwyW+nzjaZpAl+2Ib+PJjwW/PaXYo8m/
	 KAUnUEX5sQ7XOi3WUcWkm1H0AU9yUtQ7yssvx3QBZWQuVlSl8OGcfP40NrEWS5JpNoMaW
	 vM5Aqg/nkS+wdBxKP5jv7GOMc1ggI8G/w/sWonmFLW5QCHvtKf+aSdnI1W1M/rF84gYjB
	 rUBMlTHxDuW8ZYqd8P/DRIitwofJ5AFf+HQjQ58nev5U6K+Wq9bxdqqnQsCjQgA/fpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ci05772Kp1Zm6gbuDrdCRYbuptqShnNwIF8IMixlfI=;
	b=vNCj5++sWrvPFAUjLBE76RkWWGgGG4xh5DKJNIt1zoPVUq1RBEbBBZ/5KdBQqP/BodN6
	 26IdTdG3T67uDSSMR3UZ+Z1i1bAjd/ZslP7Vs5alzOpvT+9axDz+cf1WH6V1081rVKsUU
	 17qH2+2M9AmG26JeyfPBJo8s0LfCy6akCG93+RNTpx2J/vezu+50INO7MZo4OHR4rYBeF
	 kHRaEha7yC1rtBtqZtTKcALiKaFoJvob273mXyK0yrdhG16VJq4EvJqZdoJC5bOv+VjrO
	 ry6yxADyr31UuBxv3rk4ShtDYX8w4xWV0Oh66/KC8RtZGRn6092gkOiyGA59f+EFJTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WpHyn6o0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E24606A325;
	Thu, 19 Nov 2026 04:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WpHyn6o0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B781F000C5;
	Thu, 19 Nov 2026 04:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061133;
	bh=4ci05772Kp1Zm6gbuDrdCRYbuptqShnNwIF8IMixlfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WpHyn6o0xAh5ULc9XKR4403TEM8mJIXvPdD3tWdf9LJC7uC6yxk4z+y8QlIKt3DfV
	 G06zwWPR1ZAozRrEymM0VRQSspm14EGbsU9evK/P9qmtsfNF1HlP+T2mB79astrR4p
	 ikCa/+zovNXGaGjkaZnkdG8BZdM0ZOt6ThV43PjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1444/1848] drm/msm/dp: dont report link training success after a reinit
Date: Wed, 18 Nov 2026 15:58:02 +0100
Message-ID: <20261118150019.908330831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 76a4da82c24ca..bc1bd7cf818d1 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1744,6 +1744,9 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
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



