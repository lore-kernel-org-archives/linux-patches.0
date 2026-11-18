Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018305;
	b=bsTHKKC9ksvESm0suNxPiEXq8gXa+hRCF1nmcSQA8BPzpY/Gja0cAOl6ZMC4qy61tORG
	 4GCQfF1EHh7KwZvzA5iGoDB6Vl8xNP2F56GjzF8yDQA4JZoZa0XQ9pwsInJ9ikb08yhzK
	 patjlVfzFt/TQm7BH6WTOJ+fqhQrYHMcngaE9yT2GOEquI46Ih/EUjBI/8iZqUbRzbmnY
	 1cZUjRaonhTuljrZaFYkgIzQ5t2+UsDz0QN6++pOrxieB5BAeoO2vwH0MXJikry7zm5qV
	 sC1vbLNZE49T8B56aMJL/dnpAzzRxUCOWLC/SGrLdpCZCnwFzYRcTBU8OHraqnn0cYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CIeFvpdIaypLVSEFIHvaZRC1SdxWha1xXxTpHL/BAt4=;
	b=AZqvIb5yxROQPp8Ki76I5exH3utS8PGxpqxzIW0u1XNKp3T0XbCUrxJz409WkxeoGS6Y
	 DeOSxxdLxVw0oe2huE1GMHSMvPM+WP3r3wRsfjFiKVXTp9uUuMYXVlVPjvo4RxuX9uK7H
	 22eqnrLJqdB5SLmkZliZCeOLFUojX+YsAp27O0MAmsedUlogjC0ehG8eTOePmyzBxGtNf
	 sHwWmAZAwjAqjZl1RDYFEfOJiAWWkvoJmAGtK3nG3LTpPdTs00j7N8bjWpGEP9svYFl7l
	 vk6zDW2viQ3a8l5+ybk3LHCKnD3ISME8M52J5pclC149PiO1oJJqmZY3uaRPN1af+ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVcKzYXc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB0B606A31C;
	Wed, 18 Nov 2026 16:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVcKzYXc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E8F1F000C4;
	Wed, 18 Nov 2026 16:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018305;
	bh=CIeFvpdIaypLVSEFIHvaZRC1SdxWha1xXxTpHL/BAt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVcKzYXcWcO8lCDMzpQGh95IoKQGE/rnwrjNd+b9OIsn4M13N+nllYig4kDDa/Hge
	 5iZ23HY/uKdcm0tCFBWylbOR10GI8JO5E5/e1f3qFXVYfqpr+cv3HCY+942hKanLdH
	 ewc/4t7ZzC+G393tdtqaQiuAzIAw0+CKZfFQ7asI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Keri <okerixx@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1193/2651] drm/msm/dp: dont report link training success after a reinit
Date: Wed, 18 Nov 2026 15:40:33 +0100
Message-ID: <20261118150330.946513102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 59070f399e2d3..fd4f753848290 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -2434,6 +2434,9 @@ int msm_dp_ctrl_on_link(struct msm_dp_ctrl *msm_dp_ctrl,
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



