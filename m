Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276D0250BFE;
	Tue, 29 Apr 2025 17:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946134; cv=none; b=S8yQ6+GLKTB4YjLYKGPlJHGMGGpMQdET1lsylCOE2uerACALm8ErO62fNLNvP1UpmO4tz+SGC2cOyt8IizP/KFx1bZvfkegjE87qp200iQs6MCWfV2B+YScd3jW9ZzomOxdYawXHqtDQYkeLNMdiyGBaN6Hn4xRML55cYQZjllQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946134; c=relaxed/simple;
	bh=6eQWRJbDXYFM6pwJdEOAByDjBbPFrqoE51sB0p0xc7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kF8lw7bmoOROXwldudlKixP3LpRX9B1npXjm+HpkEry1Tr6bTtlLpygZzeGsfxSuiPw81dfsofTn6P5RSAArqSDtg+dDg+vJqJF2tWovLPBGDM81grCVU53kFaNQfVfDrKt/tii/BM5AHfi+u5AMQccaQLTbTTm8LSThTSDJwW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaP0cpZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaP0cpZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE90C4CEE3;
	Tue, 29 Apr 2025 17:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946134;
	bh=6eQWRJbDXYFM6pwJdEOAByDjBbPFrqoE51sB0p0xc7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaP0cpZdTAT/FWvb+h+jgssvMHk+RGaEOMxReHAF88Qrv65hcoLIMC+iny6Oab0De
	 cXSDK2v0ZSFqGSCocFSGVp8HwTjD0JDGDngPOh6z0MiU59YYhekV7FXHjF8QwV2yfD
	 qjD3rLYq/5OmCmUpxOAm+x5ZEkdU3bkBS+dNNOTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.14 167/311] usb: quirks: add DELAY_INIT quirk for Silicon Motion Flash Drive
Date: Tue, 29 Apr 2025 18:40:04 +0200
Message-ID: <20250429161127.880499510@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Li <limiao@kylinos.cn>

commit 2932b6b547ec36ad2ed60fbf2117c0e46bb7d40a upstream.

Silicon Motion Flash Drive connects to Huawei hisi platforms and
performs a system reboot test for two thousand circles, it will
randomly work incorrectly on boot, set DELAY_INIT quirk can workaround
this issue.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250401023027.44894-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -383,6 +383,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0904, 0x6103), .driver_info =
 			USB_QUIRK_LINEAR_FRAME_INTR_BINTERVAL },
 
+	/* Silicon Motion Flash Drive */
+	{ USB_DEVICE(0x090c, 0x1000), .driver_info = USB_QUIRK_DELAY_INIT },
+
 	/* Sound Devices USBPre2 */
 	{ USB_DEVICE(0x0926, 0x0202), .driver_info =
 			USB_QUIRK_ENDPOINT_IGNORE },


