Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E49E2ED872;
	Tue, 17 Jun 2025 15:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175137; cv=none; b=Ry6a/9/9yYjwf2M2rsMaSo6h9SzT5Y9eH/eRy3tWla7qz6ISKwAvoRy1r5UipSD4PILhVwdkVs8LGjOWYfxaX73WXtItBuISQ/EGUpXXpoI/BVyfX6gcCwKmeHpnsUz783666X1Pv+uN6qn+Qey/GnQ7oHvPUFLIzGf52a9k9Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175137; c=relaxed/simple;
	bh=Aj6E+fv1/OWcH66QY0dcPP7d66kk0PvBtLzrpnhq8hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJOsEJ7fb0Cje6C/O8C+MIY52yRfjOAuSdTGjiYR6QJCXjiHBEvahmPSN2GtzX0hq+68kE1CciOy7cv6I1qAH34A02nMsbN/58wQ0ou+2jBFJglbi3+jyw730nTd1prjyU6UnILwbgDslUE2Jiew8tfeKIqhPSnqUxpNLkVzg2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaOODZf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaOODZf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E0CC4CEF1;
	Tue, 17 Jun 2025 15:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175137;
	bh=Aj6E+fv1/OWcH66QY0dcPP7d66kk0PvBtLzrpnhq8hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaOODZf4pfmGk2puJKuRunONIczmzZ67tUiESQNBw4bRRv5SQEzF7lBz/ycJPmlMY
	 vbEr8vCoHhgpJ53H7U7od6EHHUooZCmw3Uzig5QhvytJIaWHQ3qGjdinIItyTSGBVI
	 KWsrvazzrMAIKm+V24oWZXNrkFXAyHpo8880Vdy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/512] drm/bridge: lt9611uxc: Fix an error handling path in lt9611uxc_probe()
Date: Tue, 17 Jun 2025 17:20:43 +0200
Message-ID: <20250617152422.704641795@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b848cd418aebdb313364b4843f41fae82281a823 ]

If lt9611uxc_audio_init() fails, some resources still need to be released
before returning the error code.

Use the existing error handling path.

Fixes: 0cbbd5b1a012 ("drm: bridge: add support for lontium LT9611UXC bridge")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/f167608e392c6b4d7d7f6e45e3c21878feb60cbd.1744958833.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
index 4d1d40e1f1b4d..748bed8acd2d9 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611uxc.c
@@ -879,7 +879,11 @@ static int lt9611uxc_probe(struct i2c_client *client)
 		}
 	}
 
-	return lt9611uxc_audio_init(dev, lt9611uxc);
+	ret = lt9611uxc_audio_init(dev, lt9611uxc);
+	if (ret)
+		goto err_remove_bridge;
+
+	return 0;
 
 err_remove_bridge:
 	free_irq(client->irq, lt9611uxc);
-- 
2.39.5



