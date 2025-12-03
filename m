Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9F435BDB7;
	Wed,  3 Dec 2025 16:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780431; cv=none; b=P1/EiBz0Guy3RlNOoq9xqPcxh9pw4kWPrCSAaXalxBQuplDcu7JtCAm7AF3HOSIfy+92612hV8YUUoACwJ07zKYNIIxjFf2TsTdiTL0Bq9x4RDx1Ne++ubvAsnaMfht29Qyh4pV4QITerVdWEV1Nxs6dBIFVq3lqDsF6AGF19aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780431; c=relaxed/simple;
	bh=XW20O8zJIyi9l//aUNEfW+GGnKhIdywkxgsH2rbbOmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIJtNTpTrEtTX50zJxHN23UzOntarH2azjjw3kHzVMMurV14vTM3HiVqT+CFZ9K2NAidyQ5uqEr1pL4+Bfi7LzaFTiUCpKsJ/w550iVZb5FiCkEN6CKA/T07aceT5pVVxDilXPJ69H0TRNcubcFF7Fouc/JPVF8L+XSMRYix/zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmlJuEUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmlJuEUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E73EC4CEF5;
	Wed,  3 Dec 2025 16:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780431;
	bh=XW20O8zJIyi9l//aUNEfW+GGnKhIdywkxgsH2rbbOmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmlJuEUGNW3aAMqVQKLmqmz6px+ih7o+oYl6z+HcD/0sfUJyBx5ZBphfe/VlAz+JP
	 lvRAuHt70ZeJoyY6VQiYWupSphhsClsDR/DuCDdVqVxLhbFciQVdL5J+9xUw0zZlfQ
	 Me32jo0AdHfkMzqLxaUMpAEM9flkaZRIz2qEwrmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 554/568] usb: renesas_usbhs: Convert to platform remove callback returning void
Date: Wed,  3 Dec 2025 16:29:16 +0100
Message-ID: <20251203152501.000969472@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -790,7 +790,7 @@ probe_pm_disable:
 	return ret;
 }
 
-static int usbhs_remove(struct platform_device *pdev)
+static void usbhs_remove(struct platform_device *pdev)
 {
 	struct usbhs_priv *priv = usbhs_pdev_to_priv(pdev);
 
@@ -810,8 +810,6 @@ static int usbhs_remove(struct platform_
 	usbhs_mod_remove(priv);
 	usbhs_fifo_remove(priv);
 	usbhs_pipe_remove(priv);
-
-	return 0;
 }
 
 static __maybe_unused int usbhsc_suspend(struct device *dev)
@@ -856,7 +854,7 @@ static struct platform_driver renesas_us
 		.of_match_table = of_match_ptr(usbhs_of_match),
 	},
 	.probe		= usbhs_probe,
-	.remove		= usbhs_remove,
+	.remove_new	= usbhs_remove,
 };
 
 module_platform_driver(renesas_usbhs_driver);


