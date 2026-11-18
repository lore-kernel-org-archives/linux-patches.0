Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025169;
	b=lptSs5urbD4zMgAXbfYiyq6VhT9J8Ddzm077lssCJN1ctkOIUrEYYMzgKbD2IbXcQgPu
	 QvfMwUAi9Oau07eNGv2m4x4lTUv7fRdtT8FIBykcZ7BaGUSCYOJye1081jWngu0t6m+qY
	 n6Fx8lySk0yYKXwViF+/7ExgkMBYKOoUFDXq4ekxPye0cneqhxLNsHdNcO2J+c+hT/bnZ
	 YUWbn5grJtd/gwE0mGUeuGInvWWMWCoec+lQoFWlueRn4FVLYnZXl7UYktrag0IiVo/Mq
	 AeWM2oIQefsX5OeR/5scCjHPlrvKkV0dVxdACqjvkbTkqZC6/JfIKKVSmWkNpkBwU6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NHACfddgMWIIXMRw2jW7m8DqUkxhE/9qLspY2/qqalY=;
	b=Othq1dsFulEnCsURLtCHIOj1thuZXB0G64bB68qHo14VIcCLjbyiXzR5qMMoMYoR8hI7
	 ShGKnSEXvLYNbyy77Q8RKZChvycTb1d1tLFjvmzuUS90FEplrDy/+dE+DLVfPUiYqZqEJ
	 xYWKxxRhmFpsEywqv0fHCm4l9NsVtYuDrpZE//98Rhkr1Np9EsnSQ/09ww6wCjhzWK++8
	 QTV4hBzGxEBUk93wzAWkFJajUXHLmWBcwL/oFjWfXShqOvMvbKfDp53S8LhjQet9cvtH5
	 3Jb0dmMWR1zI+MHwKCmp8C0CXI6dz1hvMSYvmABktwH1ectXaQA2RraQV9ARLzc6jxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B18RiLLj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA1C60A260B;
	Wed, 18 Nov 2026 18:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B18RiLLj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE861F000C4;
	Wed, 18 Nov 2026 18:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025169;
	bh=NHACfddgMWIIXMRw2jW7m8DqUkxhE/9qLspY2/qqalY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B18RiLLj3J8JR9GkxNuhbAUEoF5qsncjJI1UkeWMNK6Di9SKorWM6wgvnQTpC2ioT
	 DzBjFEOXoGlnClkLiMGcbocclihxVhOruZWOTvQ/LK/6o8Fh34kmCoG1bzLLwo4Pig
	 lR4ABmGwBASiyTgw0Er1zjI+X7m3TFz32wRqm25k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0985/2151] drm/msm/dp: dont report link training success after a reinit
Date: Wed, 18 Nov 2026 15:45:20 +0100
Message-ID: <20261118150158.357571687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2ff7db77a82b6..bcbfd7f9d84b1 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -2361,6 +2361,9 @@ int msm_dp_ctrl_on_link(struct msm_dp_ctrl *msm_dp_ctrl)
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



