Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412223382DE;
	Mon, 20 Apr 2026 15:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700027; cv=none; b=q4BuQYYbzZajmePhkgyvAGct459qQkZtKVUNizw78V36bUu1imz3VLhUXCtbpcheg7kFWUPYH+5RKJuZd8Qx7MDGUoahxUHDtqUJR27K73qMiVwo4ZhLGNI5JiKZ3A8oXba34MPBthWMGzFaH7Hc7W2eVC6qFdn6LMFfvuhcx5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700027; c=relaxed/simple;
	bh=HPj/w9zmg65SCa86eUE1ovxoidnpnz7T1JEzYlw93OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJxkn7LGdMu/jEzQVtpuyR0hhs7UOKNLUTE59LzvVC7fU7FubxMITU1EPF/bKu71ng9/yhtsSwigBPDI9pWt+QoEMX/DCs15ykPjdLxRu3a06ht8/i4l1ptmYY63YowaYvykxgfah9LV+PKMCR5PgRjq8/JMO+EOkLnDCO620X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRi6KWM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRi6KWM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D4BC19425;
	Mon, 20 Apr 2026 15:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700027;
	bh=HPj/w9zmg65SCa86eUE1ovxoidnpnz7T1JEzYlw93OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRi6KWM63J/FtNkaR2pADSVy9Ihofm9JZ5+htr5XkhaKWfl9lVNS4zXpG9293Wqdf
	 1WjX4dJ0BMXbbv97EMsU1FexegXt69GThGmHZuEDZFUU7zv02CiyorPIke/KBUcExi
	 J5aU2uoOwYJUaJStS/2M8h8MAd5UzCtmjE2XUOH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Zhang <rmxpzlb@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 014/220] ALSA:usb:qcom: add AUXILIARY_BUS to Kconfig dependencies
Date: Mon, 20 Apr 2026 17:39:15 +0200
Message-ID: <20260420153934.540236881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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



