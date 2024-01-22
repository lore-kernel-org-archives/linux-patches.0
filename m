Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C530E131748;
	Tue, 23 Jan 2024 00:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969446; cv=none; b=n+6vLuLzexh2ZmulSNlGODlsvdvyYKFtseouCjnzz8hp12Hh0rGho/Krsh/Tn00aPfichEJdikvFHxnlH4XoQzJlKtoAzUPbgIS8PzyraQo5MyyoGUJEpfXadXoW8Mu4FFetDwrafAGvf/gcp4x6OfmeJzjCq4wqFxzRYtnVHec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969446; c=relaxed/simple;
	bh=AkWFk+dQ/yew7wVjQWTdJ16FboIHwpseWZ7D5eMyFeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kH2AuHA4WREDBuLHQGHyJ1aIVrbmukrqZP2fgPVRtacvKsPUTgg0e5sFtckxoX9VHEDz3BbMnMIgqTFfyFYp/jPhWJwfTuZOUVn9c0R5duy6AyIC4PeQNfKv55IYxcYv3I4rGP/mjZ+996KbCazy5WcDTUOIV1t4WvwV40oS+sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvz7rJKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvz7rJKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A969C433F1;
	Tue, 23 Jan 2024 00:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969446;
	bh=AkWFk+dQ/yew7wVjQWTdJ16FboIHwpseWZ7D5eMyFeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvz7rJKDwniGKqhGZsiOww2LtoV5qTuG43ts4+SCjLM73WoAgDx0tZ5pn6clJkCi2
	 Tgp2QfkQaEysGBwhW/R9PhKqr/uSq378cVlbo5L7YCPReXJKVFrASMtgWhCLeqq8do
	 0NLa/gf6I6OMMsBriTGWkgSMrKU/eNMEnR20q5/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 252/641] drm/bridge: tpd12s015: Drop buggy __exit annotation for remove function
Date: Mon, 22 Jan 2024 15:52:36 -0800
Message-ID: <20240122235825.806907435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



