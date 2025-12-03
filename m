Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A6E352FA4;
	Wed,  3 Dec 2025 16:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778602; cv=none; b=fLGSqk64+/WxRRPYzxNMxWDf8HzFS3F4bh00kux/VJQpSno3/wO+HRLQjQ1HdkHtSwEG8G8/FEPaEn2R1RDU/R1PWsa2ccraVApMbntjKznpYbcMVlzg0QklTgzwApdEi4UNhIZwiGioyf9i8V8/yTUBsODcuvYFifyMCscm7Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778602; c=relaxed/simple;
	bh=PaE8zb1Xh6bx9NyX/twwj5rPFYLXPZPBsrzUp4laVlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZensG0gPuYZALRjARcGcEOIISFtkKdyNx+qqZOv9vs1hchy9Qy2uZDqp5jkzmEhKUsQ3hFmYMTQur5N/Rs040YJjL/WRTx6E4mbgbJqZ/qCLWBWsd41XWAhY/S07uNW7tsJJaFNTFR/YthqtsGIq/HG0BqoHFqMkmR/TxN4OrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+0Ufcl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+0Ufcl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB530C116C6;
	Wed,  3 Dec 2025 16:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778602;
	bh=PaE8zb1Xh6bx9NyX/twwj5rPFYLXPZPBsrzUp4laVlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+0Ufcl4NIhyXpkwZFZ1QBUMMc+FvbIBv/fQSTiiBieru5Exiw3UKVc0jXmgwT/ha
	 6X8D2nZ0uCIX8HtOT4B1tbJK6/RfYs80MHWC6n8wZzhBu0Zu2rE8+hpegdUm2UBa0O
	 IqnLPlDS676wuwxLzll3GKQj3Cl6CFsV7y697TI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 384/392] usb: renesas_usbhs: Convert to platform remove callback returning void
Date: Wed,  3 Dec 2025 16:28:54 +0100
Message-ID: <20251203152428.325763861@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit 456a91ce7de4b9157fd5013c1e4dd8dd3c6daccb ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart from
emitting a warning) and this typically results in resource leaks. To improve
here there is a quest to make the remove callback return void. In the first
step of this quest all drivers are converted to .remove_new() which already
returns void. Eventually after all drivers are converted, .remove_new() is
renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20230517230239.187727-89-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: eb9ac779830b ("usb: renesas_usbhs: Fix synchronous external abort on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/common.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -794,7 +794,7 @@ probe_pm_disable:
 	return ret;
 }
 
-static int usbhs_remove(struct platform_device *pdev)
+static void usbhs_remove(struct platform_device *pdev)
 {
 	struct usbhs_priv *priv = usbhs_pdev_to_priv(pdev);
 
@@ -814,8 +814,6 @@ static int usbhs_remove(struct platform_
 	usbhs_mod_remove(priv);
 	usbhs_fifo_remove(priv);
 	usbhs_pipe_remove(priv);
-
-	return 0;
 }
 
 static __maybe_unused int usbhsc_suspend(struct device *dev)
@@ -860,7 +858,7 @@ static struct platform_driver renesas_us
 		.of_match_table = of_match_ptr(usbhs_of_match),
 	},
 	.probe		= usbhs_probe,
-	.remove		= usbhs_remove,
+	.remove_new	= usbhs_remove,
 };
 
 module_platform_driver(renesas_usbhs_driver);


