Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040623;
	b=W3ea+NBBVhA06eUjWWSBepFhEpNJqu6do5nr0TR67AcKfF4k7HzhMHjmzRcO7jLl7JM+
	 zlCGqDyuER+fLgwbCZmS9WD7JIAalxhurGRfoqX5xMLRQ5KUz9M3JqwxRhUbtx5vL7TUo
	 YvYf2M+VFHYuh2w3YTSETP8KKq6FOW724tLPBv9TcBZzwW9bzzycJIFQt5rj3dq2VGkYH
	 ho1/rri3Y6xqbmdV4IcXFyyhGzLCC0rbvv+d/v6Lc9qbl9DHewMelSdQCmyGibOgNoRu8
	 LF2Z5w3uRaZetIvKPxKmcg9FukSnMaOkOTypzLfdb+JUqJTwf10rSuSpjBey6ylZX9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SEwkqygkSS6aZOWAzQ5PSth2d42UcuTai1pc0ZhoxAM=;
	b=s6FExngpSLf1zQ3aYUCUHsBqk3NoFFa1+N/QJpPHE9/fL8Iwvg+JyUgwfUc2hXjUYaEZ
	 /k2AURcmkOBUxNNBXmwO4kL2Z07eoO2/JmTF+HGC/hX8qHgOTmJoBUPxrE6xijjQCqzk1
	 T7V3zSM+4RvzpvXtScfNv4fiWyinvmMFxu8Fw+noeEHMnSqzaNB6ZlkcVmGBXkit1e4AD
	 y/gjJrRJRrUJwJf/xeI7AkNrRpejehl3l0miVSriDg9hngtwy0kBPrNo47WSebiu3Uina
	 7fZkxNkezJpsBVY1ezulfqj5Zjw+C93CTktPx0HRBwrrPSXvg8oNc3P0+8Z9fSEGWIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDHwglFJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CA9606A325;
	Wed, 18 Nov 2026 22:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDHwglFJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137A11F000C5;
	Wed, 18 Nov 2026 22:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040623;
	bh=SEwkqygkSS6aZOWAzQ5PSth2d42UcuTai1pc0ZhoxAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDHwglFJ8x4bORjbwGceS4+AtfUCCAzPsL2YYfJWKoQl2hut5d8X7/dKcLIVg8zm7
	 LQdU62tAkwknLgRTscOXP2DrmIP+iwa1xsqSM+NZ+jJr4YRWG78/0IrFZlWktOLHRJ
	 O7OXMeGvq80HW1+VLBlbqmxDadGzRWXyYEKQPlwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2523/3318] drm/msm/dp: dont report link training success after a reinit
Date: Wed, 18 Nov 2026 15:52:25 +0100
Message-ID: <20261118150437.049380497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7472dfd631b83..1e731b7ebc05b 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1833,6 +1833,9 @@ int dp_ctrl_on_link(struct dp_ctrl *dp_ctrl)
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



