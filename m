Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65D75B5D5;
	Tue, 23 Jan 2024 01:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974339; cv=none; b=hF8jcxj7WAWbpwRKwmWZG5Gc4N4QbQvcoU1lYvmOP10bXb7fjwzZzqlxagdAowhf+yw3cFlrSroXNyB528LpoLIF2wwg7HmDUcQLfvRp1Jq9r5bZAYtTT5PTMPguqZOixqq+xfBIlz+3QaqjAsDx2FzhBmq7AznrC8b2GsPs93c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974339; c=relaxed/simple;
	bh=lo3ovHxrEtFbo8yist3VLhFK1u80DChUemkVTLDk9VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jk3jL/6ACJ14fCsajD2TYedDBNJ2irodNN6PsZ7kuBrjBq2k6GEhFJXuM5mym6FfUUxtTRki/3Xp/+O5ejk6rC4hJjEXqSMllCcv8o6g/tzusq7t4FcCb6K1EJQ/zsyjhN/pFVhFzYAtjiiQA2dzaaIbgpF84gM1uiuWMCqeDCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZN6LL193; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZN6LL193"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81C4C433F1;
	Tue, 23 Jan 2024 01:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974338;
	bh=lo3ovHxrEtFbo8yist3VLhFK1u80DChUemkVTLDk9VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZN6LL193bHSmD1biK1Y8EGdjSg+DslRNE3Rim3842CvEzfFvfKiATdswOOdLk31lZ
	 pafY4UgYxfAVOSt8/XP1rABDdJRsvU+SivGqKrjtz5eVDvhp4r55zfK3IJ1CgfVIXR
	 KzSzoM5E/rBRAEAO1TqiqUY7kcqU4Cm+lBnxK9Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/374] drm/bridge: tpd12s015: Drop buggy __exit annotation for remove function
Date: Mon, 22 Jan 2024 15:57:18 -0800
Message-ID: <20240122235750.965066035@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit ce3e112e7ae854249d8755906acc5f27e1542114 ]

With tpd12s015_remove() marked with __exit this function is discarded
when the driver is compiled as a built-in. The result is that when the
driver unbinds there is no cleanup done which results in resource
leakage or worse.

Fixes: cff5e6f7e83f ("drm/bridge: Add driver for the TI TPD12S015 HDMI level shifter")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20231102165640.3307820-19-u.kleine-koenig@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-tpd12s015.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-tpd12s015.c b/drivers/gpu/drm/bridge/ti-tpd12s015.c
index e0e015243a60..b588fea12502 100644
--- a/drivers/gpu/drm/bridge/ti-tpd12s015.c
+++ b/drivers/gpu/drm/bridge/ti-tpd12s015.c
@@ -179,7 +179,7 @@ static int tpd12s015_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit tpd12s015_remove(struct platform_device *pdev)
+static int tpd12s015_remove(struct platform_device *pdev)
 {
 	struct tpd12s015_device *tpd = platform_get_drvdata(pdev);
 
@@ -197,7 +197,7 @@ MODULE_DEVICE_TABLE(of, tpd12s015_of_match);
 
 static struct platform_driver tpd12s015_driver = {
 	.probe	= tpd12s015_probe,
-	.remove	= __exit_p(tpd12s015_remove),
+	.remove = tpd12s015_remove,
 	.driver	= {
 		.name	= "tpd12s015",
 		.of_match_table = tpd12s015_of_match,
-- 
2.43.0



