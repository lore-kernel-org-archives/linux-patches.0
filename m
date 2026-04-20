Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBEF3F1643;
	Mon, 20 Apr 2026 13:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691537; cv=none; b=K9NLXw9sI0Hhz/haYuggitezoe1zT17NhX2GUMgWEx+6kVBnFSjktKWrr4U/MKAcd9x5I2o/Gn0rAMkZJzhoX4CnQjGWwG7xWCDL63KK6j0w8axklbaMUzBGb2BTx5C5zv7dEtseuZJ4IPhK5NzOmqR5Lxhxa/lVqw9jTYzgASs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691537; c=relaxed/simple;
	bh=/lnYTBpqCE+fSTH5kiJNSBZOxdmL/SdHucyHsrDIkQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+DKikfHFtj3CTA9Gd35BMgkuJDyrxfKboqFYeh+lERubzFnddwOCFhmCbv7X/rRrL9tTf7yKD8laNvcmTzXy8/G18IzGqWfZoJFFazgct1S7usHkQSvzk/WBTGP2bYH4rs8gx0VFpLjNDVLg8b4AF76BQYYu5VPjVtw0m51KZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6YccxFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6YccxFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F868C19425;
	Mon, 20 Apr 2026 13:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691537;
	bh=/lnYTBpqCE+fSTH5kiJNSBZOxdmL/SdHucyHsrDIkQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6YccxFoib6L+gSw3XPHkRFHC59TdLj+wxV8mGTaf+m12Xvso/DXuevcsUzrqlGlU
	 sFvN1cKIpN1XcolFTIwlwTnDkQtOnsQw+DI9qSPTX/noU2Xo2A7l4a82uQBzgaV26D
	 OL93Pub3Q9ZDG8Tfa7GTG6VE9U3caX9I730DT1xenJyTBTUtpPQ0IoqXThHJW05FYj
	 7NG8EJq/Z1OJIC5VcDm8fmzczef0ITJQJIIKTPsZh7nIyoA2GTdzGTkp8dZH5MrbGI
	 2AS57Lvppejul8mn23NsaVq4UcmDCfFd7bNofQr+QReHy18BreOL4JmnpIgynRemvi
	 UR3iZ51hYa8fg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Frank Zhang <rmxpzlb@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA:usb:qcom: add AUXILIARY_BUS to Kconfig dependencies
Date: Mon, 20 Apr 2026 09:18:02 -0400
Message-ID: <20260420132314.1023554-88-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Frank Zhang <rmxpzlb@gmail.com>

[ Upstream commit b8bee48e38f2ddbdba5e58bc54ef54bb7d8d341b ]

The build can fail with:

ERROR: modpost: "__auxiliary_driver_register"
[sound/usb/qcom/snd-usb-audio-qmi.ko] undefined!
ERROR: modpost: "auxiliary_driver_unregister"
[sound/usb/qcom/snd-usb-audio-qmi.ko] undefined!

Select AUXILIARY_BUS when SND_USB_AUDIO_QMI is enabled.

Signed-off-by: Frank Zhang <rmxpzlb@gmail.com>
Link: https://patch.msgid.link/20260317102527.556248-1-rmxpzlb@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/usb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
index 9b890abd96d34..b4588915efa11 100644
--- a/sound/usb/Kconfig
+++ b/sound/usb/Kconfig
@@ -192,6 +192,7 @@ config SND_USB_AUDIO_QMI
 	tristate "Qualcomm Audio Offload driver"
 	depends on QCOM_QMI_HELPERS && SND_USB_AUDIO && SND_SOC_USB
 	depends on USB_XHCI_HCD && USB_XHCI_SIDEBAND
+	select AUXILIARY_BUS
 	help
 	  Say Y here to enable the Qualcomm USB audio offloading feature.
 
-- 
2.53.0

