Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C9319D078;
	Thu,  6 Jun 2024 14:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683473; cv=none; b=lHOduV+Onwawo4sTMpbIjhwooTxHQvJaVhgCRlZNwb1h61t16Lfw7B8xHELXOTxw4D589w6VWA3xE2b6JO90oepa7nG0Ausy24EC/Hhb7C8kaldvvIObdlazKCgTIoYpZozmYu2cOkKzV1s/ffTWMveYZs0f6bOufNiRH5DNwss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683473; c=relaxed/simple;
	bh=fG3IKlSRsD6k5r5fI23a6wtxL5GIj5XUk0nJ4WXTGHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcNUWF1DCND2y9+Pzx6c5q6Y1GQaJgQuiu3Eaw486qLJeBGV3lkHt+/UmZi5IYN7581FwSXs2k8cxgTbkzSHRHURh5JbmcTbVf+ozkG3X66Uf+YwCltFB2MzllUQce0oMoj10L40LgmbcKzC/ympxE2sB6FKlS7LBI8FHlvM6Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SI49vBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SI49vBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852E7C32781;
	Thu,  6 Jun 2024 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683473;
	bh=fG3IKlSRsD6k5r5fI23a6wtxL5GIj5XUk0nJ4WXTGHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SI49vBA3ZDt9gJUkP0DIp471CrdyACOSIBvk1+tLfoa2sHsUM/BlEA9SEWj5paCM
	 xxCyptaY5qmomUpZAd6k4uCmS1bJcQmqCv/GzmLzbCnnmxqMMF0CS9CSX9aSxqTTDS
	 PVYMNOFJeA/R24akNYhPY7qPGaHFc5Nxlz94nvik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 360/473] Input: ioc3kbd - add device table
Date: Thu,  6 Jun 2024 16:04:49 +0200
Message-ID: <20240606131711.815295941@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karel Balej <balejk@matfyz.cz>

[ Upstream commit d40e9edcf3eb925c259df9f9dd7319a4fcbc675b ]

Without the device table the driver will not auto-load when compiled as
a module.

Fixes: 273db8f03509 ("Input: add IOC3 serio driver")
Signed-off-by: Karel Balej <balejk@matfyz.cz>
Link: https://lore.kernel.org/r/20240313115832.8052-1-balejk@matfyz.cz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/ioc3kbd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/serio/ioc3kbd.c b/drivers/input/serio/ioc3kbd.c
index 50552dc7b4f5e..676b0bda3d720 100644
--- a/drivers/input/serio/ioc3kbd.c
+++ b/drivers/input/serio/ioc3kbd.c
@@ -200,9 +200,16 @@ static void ioc3kbd_remove(struct platform_device *pdev)
 	serio_unregister_port(d->aux);
 }
 
+static const struct platform_device_id ioc3kbd_id_table[] = {
+	{ "ioc3-kbd", },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, ioc3kbd_id_table);
+
 static struct platform_driver ioc3kbd_driver = {
 	.probe          = ioc3kbd_probe,
 	.remove_new     = ioc3kbd_remove,
+	.id_table	= ioc3kbd_id_table,
 	.driver = {
 		.name = "ioc3-kbd",
 	},
-- 
2.43.0



