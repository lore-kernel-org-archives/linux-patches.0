Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3EFF9D4;
	Tue, 14 May 2024 11:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687867; cv=none; b=itDA8h1VvC2ieGWghas9rEKO0JjFo7reGSi8Ks/xnYem6VCSqMD1/N4gJVJ9eoAkdNdWxpnbAQqLXcsCxaLj6hlWBq1VcBlxMS6mmCBysf87bHn/bMhkUczBcMn4VBBleM/7DcPyi+lwKB+RduWkdabzD/1N42/SjA7JqrooJPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687867; c=relaxed/simple;
	bh=I/UFu5bG6wW616Xkvu3q/McnHOx8p4znNIJVWczuwKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Og8AJTJCwIG+OQGBTKq5O73BUAMY4KxP2GckbTDl8Gh23VBLrxFst4GVJuONbiov/aAUhhqx50z9qEXJyf+AUAlV/HEDVojbEFhlJ3hgA03cH9aA0TRIFTBTFGrN16JmHLuglH/rVlYOPC4jXk0S10Oe3yfVf2kiWOdep3e2O9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moMe4wL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moMe4wL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263B8C2BD10;
	Tue, 14 May 2024 11:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687867;
	bh=I/UFu5bG6wW616Xkvu3q/McnHOx8p4znNIJVWczuwKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moMe4wL8vJLgmjueHP542RGlnzyAZ5LPZrDHDUqaLAJgoE+1plSNqesfOixC1k2vS
	 YajsAU9BxgTWp3pPjGgqdekFVPejJLUYI4ZblOQvgBXWNghDa2f7Q1jvpeYgBJgkNw
	 9S6kPZvH8cLgRtiaQ1PJBBmzf3Cq7UHGTXx0fG08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Simon Ser <contact@emersion.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/168] drm/connector: Add \n to message about demoting connector force-probes
Date: Tue, 14 May 2024 12:20:30 +0200
Message-ID: <20240514101011.665874600@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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
index cfe163103cfd7..1140292820bb1 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -2460,7 +2460,7 @@ int drm_mode_getconnector(struct drm_device *dev, void *data,
 						     dev->mode_config.max_width,
 						     dev->mode_config.max_height);
 		else
-			drm_dbg_kms(dev, "User-space requested a forced probe on [CONNECTOR:%d:%s] but is not the DRM master, demoting to read-only probe",
+			drm_dbg_kms(dev, "User-space requested a forced probe on [CONNECTOR:%d:%s] but is not the DRM master, demoting to read-only probe\n",
 				    connector->base.id, connector->name);
 	}
 
-- 
2.43.0



