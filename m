Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C195779FD;
	Thu, 11 Apr 2024 10:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831706; cv=none; b=dsFY6x4HVotOREddXtOMiVCMx/ugi9yhpRGrCfPD6zZnCYUAU4V2XFgcljPWFIrJcR501PKs5guPCwsnSkm3HbHHzzxN5f1IjZAC2QIwa719hkYTqkcoYP4MVuVHgr1phQmwy3ibzoY7a96o4zZF1zuaRKDOCOyTNxlBdc0H5UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831706; c=relaxed/simple;
	bh=KK7Pdoaje21BU50+346O9weHyWaTjt3cRRzf7GV2o0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3PV/1Un8AI3i075U2gWU/hIZKyJhYnRhJANG6gkK2SjvLfOqHWD+M8XxEVKpn7s1xfuXq3kB+6zR0oVrNbsi+kPzzBEsDt0RLGnKyhr34gG5C/cPpV5jLrUa+PbrkaP4epIQHpLDixYOGTtSoPwcNdtqrUdS9b/lOCn0iUzLJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guQH1AV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guQH1AV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481E3C433C7;
	Thu, 11 Apr 2024 10:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831706;
	bh=KK7Pdoaje21BU50+346O9weHyWaTjt3cRRzf7GV2o0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guQH1AV8pGFJ32FNoNTkpUmcOzBM0aJ/QGIxO2icUCb3gsEgs6o63sodLP14nq9QS
	 zpJwtrWPfaba/5RMeZ3J5D6VO0pXMtR8MXB4GpeQkOvWQcaE6MXweWiM5ZQC1/nZHH
	 MCLvH4Pvz2xtopuvzYOONvYwpPszVfE6nYWo8s4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/294] drm/imx/ipuv3: do not return negative values from .get_modes()
Date: Thu, 11 Apr 2024 11:54:21 +0200
Message-ID: <20240411095438.625074278@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit c2da9ada64962fcd2e6395ed9987b9874ea032d3 ]

The .get_modes() hooks aren't supposed to return negative error
codes. Return 0 for no modes, whatever the reason.

Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/311f6eec96d47949b16a670529f4d89fcd97aefa.1709913674.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/parallel-display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index b61bfa84b6bbd..bcd6b9ee8eea6 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -65,14 +65,14 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 		int ret;
 
 		if (!mode)
-			return -EINVAL;
+			return 0;
 
 		ret = of_get_drm_display_mode(np, &imxpd->mode,
 					      &imxpd->bus_flags,
 					      OF_USE_NATIVE_MODE);
 		if (ret) {
 			drm_mode_destroy(connector->dev, mode);
-			return ret;
+			return 0;
 		}
 
 		drm_mode_copy(mode, &imxpd->mode);
-- 
2.43.0



