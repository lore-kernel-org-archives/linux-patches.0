Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D371386D5;
	Tue, 14 May 2024 10:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683563; cv=none; b=L5hjA6t0HD+nlHcKcfyGnSa/YbxXH8HYgrrt91RXGcgzBo73HTowZs728zOke1JPlP9ggfVEY1skdpMWE/khqgrR8++7GtGMrPfD83ODlIkOX5Nr4AuHPeDFEP+PTeme2fTQWRmT24kRwz+RceAPD9qCNAYEt4rdM6iQKAr1bCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683563; c=relaxed/simple;
	bh=sDJFqaXK8clfuV+m3mFzZL4SRuJi695ihJX6vFRYoRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYMXcoBlgc4HTFFxVGxAvVL24ne7OICIKtSn9t6udrejV18l2PBorjUY98fDRtUS/zovf+8BgYhjpr1n7iEXBrWb3ZpWe/lO+yVFU2lT86xDdbAvtIKnvrGiP825LFTH16pE6NCtma1M3JxyRiDqjvA80JUGnCST8RqCctSYp64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DS9keg+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DS9keg+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A70FC2BD10;
	Tue, 14 May 2024 10:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683563;
	bh=sDJFqaXK8clfuV+m3mFzZL4SRuJi695ihJX6vFRYoRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DS9keg+75UtYq35wUfoTOweYsFNCwp91CtOGUPten3VF74bOvw6rI7wNQJ8jgH4fl
	 EWk47qUGk8IFiW/swkVRJXJi46IgDej08pddcsXJ88cCE/saebBNpRcHsdh3aEIHqb
	 f0sjn8S5wAmLoedK/KHiay4XEvSRi95QnryA4wUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Simon Ser <contact@emersion.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 236/336] drm/connector: Add \n to message about demoting connector force-probes
Date: Tue, 14 May 2024 12:17:20 +0200
Message-ID: <20240514101047.524932510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 6897204ea3df808d342c8e4613135728bc538bcd ]

The debug print clearly lacks a \n at the end. Add it.

Fixes: 8f86c82aba8b ("drm/connector: demote connector force-probes for non-master clients")
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Simon Ser <contact@emersion.fr>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240502153234.1.I2052f01c8d209d9ae9c300b87c6e4f60bd3cc99e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_connector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index b0516505f7ae9..4d2df7f64dc51 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -2940,7 +2940,7 @@ int drm_mode_getconnector(struct drm_device *dev, void *data,
 						     dev->mode_config.max_width,
 						     dev->mode_config.max_height);
 		else
-			drm_dbg_kms(dev, "User-space requested a forced probe on [CONNECTOR:%d:%s] but is not the DRM master, demoting to read-only probe",
+			drm_dbg_kms(dev, "User-space requested a forced probe on [CONNECTOR:%d:%s] but is not the DRM master, demoting to read-only probe\n",
 				    connector->base.id, connector->name);
 	}
 
-- 
2.43.0



