Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EBF145FFA;
	Thu, 11 Apr 2024 10:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830759; cv=none; b=m/G8iFmFqLTRntB+caE92ALO2vh1yU1Bd5icTc9Ty/S/COoGXeDpmfDvMdIHJP0w6Rw6eyQyPWOn6YqxXv4zVj3FWrhRYvn0xtJ4hpLkIyzKTRvZo65PQJA+Og2YrsGWO2bF69mCG4rbqaf/1pJCnPDXFDNNd9fjpkwtKHMLOIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830759; c=relaxed/simple;
	bh=TCQm7PZFcH4Eh1EzIipOF46gX3+6O6dp9Sy29+El5qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkUKW6bWcieRV/FUlKuRxIApzo9Q69Q71S+lXzW3gKXp4y05r+22aP4LqCrFD+sBTItWnqiiwHF6x3Ic8nUPZ5uRqhWEdVk1OCxz0qJjERBeiW+pNzzH/pv9nYTr3J/Mhs6J8HYXReBiAZ7y2CGMftTnukS5QxDezRFlKq/4Oy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2GMg92B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2GMg92B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F52EC433F1;
	Thu, 11 Apr 2024 10:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830759;
	bh=TCQm7PZFcH4Eh1EzIipOF46gX3+6O6dp9Sy29+El5qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2GMg92BDU0+YkKnGvrS+XGLsMe4MgF+SIsGXFvjfMXvZ0DEa2vuBv+kWnK2rKejU
	 alp3/7Gct1O7RhecQ+sG2xbXfw1rFhRPZWQVGjsFoN0CU6CdEi9ETbDOJ0khWxwA7D
	 IYjDDAxxKMJ6vM4T6sdBepfQGjaBb/T6l+oPDLb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/215] drm/imx/ipuv3: do not return negative values from .get_modes()
Date: Thu, 11 Apr 2024 11:54:39 +0200
Message-ID: <20240411095427.004299136@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e24272428744c..2165ad545a382 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -63,14 +63,14 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
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



