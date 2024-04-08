Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE527172F;
	Mon,  8 Apr 2024 13:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582168; cv=none; b=rzmqlHFFdT1yQEGoz/AlAd4hKDcc2JHJIZqYhVEHf0A85gS5/l/zjYgKig6vmR1nm+Ls3bbtekFeHuEJj+JdhEIFAx/LKqS9EjK17NHXd7eZmTsx99/njFQiYf8D5ZmIBTOBk4cPR5Fb20FcQnKZ1sTWQ/8KQJmBA1pnHa59gBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582168; c=relaxed/simple;
	bh=8Eauqu2DPaLa+CyBiHUXBbzlFU3ZH9nerxdejMi9Pnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPauNcOTTHrE9bSwxjzfhybcKIrBKCQaNaPEXMGGnmYuRLbK3nknrcufVLrCnYZUbgbJGdWAIoudkIMsrSR/VklGtsQ0hYb/Nkxn8ZlAMeAIYhK7b7EqzejulT02jlFR+5F78lpiM84ydtq1lfIXpyQbOzjufE3YEJh+9Sv1SMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ibg3FmRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ibg3FmRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA646C433C7;
	Mon,  8 Apr 2024 13:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582168;
	bh=8Eauqu2DPaLa+CyBiHUXBbzlFU3ZH9nerxdejMi9Pnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ibg3FmRra7tfxC0/lJZ6RtFg/GOl6amKLXRJ4MclU8SkHvTbmvW8elhSBe68g6yW+
	 6Xm6zr36yQU3ONF4Qn9sLDL1k33HZ+g8ZJugwfjxOOo9x7PtkJaordWiXlBqcfOAUU
	 Fj869eJ3FFEv9LuQCvdso7lixib+T5tXLVKDrels=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/690] drm/imx/ipuv3: do not return negative values from .get_modes()
Date: Mon,  8 Apr 2024 14:49:24 +0200
Message-ID: <20240408125403.036933588@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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
index 63ba2ad846791..5423ea4c1ef9a 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -70,14 +70,14 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
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



