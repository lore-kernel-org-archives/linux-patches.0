Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEED7710A;
	Tue, 14 May 2024 11:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685610; cv=none; b=VakMzOXXWzfUE7WXRXYrTBvR/uG5woGou2OWlhEg45wecjOaDUAu8h/JokxYcl1Dhiwujv8HcWzaw4BIaCJGnYYtJNiNi7v1nQphO8luGxR8We4F8hryUo/HRGshPahdjqkxr6MTwpFXVAj9eV2WHcol3zLDg3x/yXKVAhmlIJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685610; c=relaxed/simple;
	bh=YHSz928glg8TQG7PpCtDVWUPwjU/RgUpOLhgMLDxaVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnzEdWsPdx7CGLA8/2QB50NpLcIde+tOtRkFIh1JxFQ5fSzRLKkX4cyOe7+/VN+OkZ8a9lJ22FTkmX0257KPsZPTLNXMNVAoiPnGjEGqu2oAbnipm322jPRVz7yw3RyK3dIB8BBu2x12obA5rtPg6vVSylER03e+tGV33tvKre0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfJghu8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfJghu8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E562C2BD10;
	Tue, 14 May 2024 11:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685609;
	bh=YHSz928glg8TQG7PpCtDVWUPwjU/RgUpOLhgMLDxaVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfJghu8aTmQdcr+nYK9NW0zGHxdJlFQMEC9e3YkJWVW8X/okQWykkF+n9KZNiquRK
	 j3zAxELOzogQW62K+Z3nOg1kEUxrJyw+dBDctr8SISAJ6mH2M3t6Z0/f70c2/50pws
	 UxjKTqOERwfFuN68W4cuonkBPD3Qn8GNOwtKw190=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Simon Ser <contact@emersion.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/301] drm/connector: Add \n to message about demoting connector force-probes
Date: Tue, 14 May 2024 12:18:05 +0200
Message-ID: <20240514101040.340314953@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c44d5bcf12847..309aad5f0c808 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -2925,7 +2925,7 @@ int drm_mode_getconnector(struct drm_device *dev, void *data,
 						     dev->mode_config.max_width,
 						     dev->mode_config.max_height);
 		else
-			drm_dbg_kms(dev, "User-space requested a forced probe on [CONNECTOR:%d:%s] but is not the DRM master, demoting to read-only probe",
+			drm_dbg_kms(dev, "User-space requested a forced probe on [CONNECTOR:%d:%s] but is not the DRM master, demoting to read-only probe\n",
 				    connector->base.id, connector->name);
 	}
 
-- 
2.43.0



