Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704986;
	b=eYM36UadMdQUi9juvFL5pCQBKsVONL43ywl8o0JZZ4mL70NOcYHMqpVzlfRN+sAeIpP1
	 xmaBIIb8TP5bQ4yme5ynOFgsnNaTTC6CNtpASdibdXYZ4rmwweZx7L9LfRmCSG6GJUjrI
	 a0D+fmjy6QMlDnjFAZ7H49+Dqc/vBG4HeCkSsr2cnRUVkGWgDSa9R4XdRgkF/K15tLqfV
	 kDy+SIeBN2aAVQBq6ID9rpSD8hki4dSE4Re6btqJ9tANNqSUgT8M/sOYyZYb0AxWiJHPS
	 6iYropspsvGl4Dafft1i+hGzn/ThtTfXOZ8mumyoF9HxzvrS9WNm/i7aEGseB2mKlqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UI14w+wdC9OgIUzhcNExOg1zm/dhbvEUdP/Km0b8Ia8=;
	b=a7PLtWbRYtguIts9wrwh9OuvLsj+5Vl3wQ638Dkfy0XcYSBmhHHJ5N2FRxsgt7SuCzYv
	 /cwJ/NHBqXi2qmRv6uMZJEW4E2/ZroFpei59xoNTBkHATeH3+boz161iKzs6D2Xsz5Ti1
	 iVeB1HNVWZ+BTgFDCs95bvdhNLxbUOTMSzmTd1YOLoudUmxwi+XPSKY4ECT67lfJsCtso
	 EWbHWFE4+lLAFaNo01u0C6D0f0MaUWKP7NKOBIQNGxrxQ+Y04UIGt3kQlewba6f5hxnPC
	 YTTiv5xlbQOh2/WXgahKfthpQXTncRCVDQIHIb3Jdp4JZ1NbnOs8acsFkbfHnWxEqRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=orCgv5TG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24063606A330;
	Thu, 26 Nov 2026 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=orCgv5TG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26A71F000CA;
	Thu, 26 Nov 2026 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704985;
	bh=UI14w+wdC9OgIUzhcNExOg1zm/dhbvEUdP/Km0b8Ia8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orCgv5TGS2YKb6sGuhVosjyaPQbfVoSRz3DEf2TzeZFQzXoWaSGK1m4Cryta6NAgw
	 boMextTm/FMdky8Q91eD64XQo6iPHDX2mNJU3oXavegYYigTYN/IGrE58C/UkpJHbs
	 Y+R3pGqBKczYIeS3c/cSDN5z/D/vHueSevgJunoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/319] spi: Remove unused function spi_busnum_to_master()
Date: Thu, 26 Nov 2026 15:36:52 +0100
Message-ID: <20261126144007.731077238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit bdc7ca008e1f5539e891187032cb2cbbc3decb5e ]

The last user is gone since commit

	2962db71c703 ("staging/fbtft: Remove fbtft_device")

in 2019.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20211007121415.2401638-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2d0953ab69d3 ("spi: acpi: only look up the IRQ of confirmed SPI devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/spi/spi-summary.rst |  8 -------
 drivers/spi/spi.c                 | 35 -------------------------------
 include/linux/spi/spi.h           |  2 --
 3 files changed, 45 deletions(-)

diff --git a/Documentation/spi/spi-summary.rst b/Documentation/spi/spi-summary.rst
index d4239025461de..aab5d07cb3d7e 100644
--- a/Documentation/spi/spi-summary.rst
+++ b/Documentation/spi/spi-summary.rst
@@ -336,14 +336,6 @@ certainly includes SPI devices hooked up through the card connectors!
 Non-static Configurations
 ^^^^^^^^^^^^^^^^^^^^^^^^^
 
-Developer boards often play by different rules than product boards, and one
-example is the potential need to hotplug SPI devices and/or controllers.
-
-For those cases you might need to use spi_busnum_to_master() to look
-up the spi bus master, and will likely need spi_new_device() to provide the
-board info based on the board that was hotplugged.  Of course, you'd later
-call at least spi_unregister_device() when that board is removed.
-
 When Linux includes support for MMC/SD/SDIO/DataFlash cards through SPI, those
 configurations will also be dynamic.  Fortunately, such devices all support
 basic device identification probes, so they should hotplug normally.
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 490dfaad46e1e..a23fa86493299 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3119,41 +3119,6 @@ int spi_controller_resume(struct spi_controller *ctlr)
 }
 EXPORT_SYMBOL_GPL(spi_controller_resume);
 
-static int __spi_controller_match(struct device *dev, const void *data)
-{
-	struct spi_controller *ctlr;
-	const u16 *bus_num = data;
-
-	ctlr = container_of(dev, struct spi_controller, dev);
-	return ctlr->bus_num == *bus_num;
-}
-
-/**
- * spi_busnum_to_master - look up master associated with bus_num
- * @bus_num: the master's bus number
- * Context: can sleep
- *
- * This call may be used with devices that are registered after
- * arch init time.  It returns a refcounted pointer to the relevant
- * spi_controller (which the caller must release), or NULL if there is
- * no such master registered.
- *
- * Return: the SPI master structure on success, else NULL.
- */
-struct spi_controller *spi_busnum_to_master(u16 bus_num)
-{
-	struct device		*dev;
-	struct spi_controller	*ctlr = NULL;
-
-	dev = class_find_device(&spi_master_class, NULL, &bus_num,
-				__spi_controller_match);
-	if (dev)
-		ctlr = container_of(dev, struct spi_controller, dev);
-	/* reference got in class_find_device */
-	return ctlr;
-}
-EXPORT_SYMBOL_GPL(spi_busnum_to_master);
-
 /*-------------------------------------------------------------------------*/
 
 /* Core methods for SPI resource management */
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 9ab3dab9568ae..da88bbc7e9982 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -763,8 +763,6 @@ extern int devm_spi_register_controller(struct device *dev,
 					struct spi_controller *ctlr);
 extern void spi_unregister_controller(struct spi_controller *ctlr);
 
-extern struct spi_controller *spi_busnum_to_master(u16 busnum);
-
 /*
  * SPI resource management while processing a SPI message
  */
-- 
2.53.0



