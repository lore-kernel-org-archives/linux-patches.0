Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088781A6169;
	Tue, 30 Jul 2024 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357828; cv=none; b=X+6Dknk3ofwQbrH5ts9OuteX7S0E+8crZy74gVuB4w3qHs6OQsvIX5KTj54NHfD9rmO1wOY9XjLwSm7ue76RMAFCUl38NoGzxrJYTa0QTeVDdY7kd/RcOSDss2k7huUUGYMcFl857M978rLsHZBDopQbYZEws+bwIuixUg2Y5PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357828; c=relaxed/simple;
	bh=+njexO7qhtRrJYjqzLbmPHvNMqtoOfYOAjZxNdcyfOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ud+LlechsH5Xe7PBHSNyI7qR4PiWWq5XxSOlvqLZKlioFjLkQqukm02wCFiYw0KZpa8W5g0tga+8I7GWfNFw6hFyl7l3Mz4GxHwBznI4bI5J6qG6R58M7+nhQpTjzhlUKIYDjKmkcsmrHTZWUoClLDfn9FOTpJQeyXWAUyUuPiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1i54RfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1i54RfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851F9C4AF0F;
	Tue, 30 Jul 2024 16:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357827;
	bh=+njexO7qhtRrJYjqzLbmPHvNMqtoOfYOAjZxNdcyfOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1i54RfXoMQB922plJdWYcvyjEHkrPeVx7qYDlT/3ZyBGnMoBQBCeCJ/Zu+nAQQmr
	 lNE1rE16TZVzHPby3kcvjICX9yv1Og/IAN0z57mlno2U09Bs8rjgtyksgdNHwHmiqn
	 mxLyeXDEvfx+yPQUWO/n6iDbD7jyPDKjdyx9tJ5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <trabarni@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 296/809] drm/msm/dpu: fix encoder irq wait skip
Date: Tue, 30 Jul 2024 17:42:52 +0200
Message-ID: <20240730151736.286578107@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <trabarni@gmail.com>

[ Upstream commit e42d518511871ae625b5ff699853a05af1ccccf7 ]

The irq_idx is unsigned so it cannot be lower than zero, better
to change the condition to check if it is equal with zero.
It could not cause any issue because a valid irq index starts from one.

Fixes: 5a9d50150c2c ("drm/msm/dpu: shift IRQ indices by 1")
Signed-off-by: Barnabás Czémán <trabarni@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/596853/
Link: https://lore.kernel.org/r/20240509-irq_wait-v2-1-b8b687b22cc4@gmail.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 119f3ea50a7c6..cf7d769ab3b95 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -428,7 +428,7 @@ int dpu_encoder_helper_wait_for_irq(struct dpu_encoder_phys *phys_enc,
 		return -EWOULDBLOCK;
 	}
 
-	if (irq_idx < 0) {
+	if (irq_idx == 0) {
 		DRM_DEBUG_KMS("skip irq wait id=%u, callback=%ps\n",
 			      DRMID(phys_enc->parent), func);
 		return 0;
-- 
2.43.0



