Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B25343D98;
	Tue, 26 Aug 2025 13:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214115; cv=none; b=nWq55YBkStlWGBpdvMW5/qULzYDuJsAvI+QnPzzrpYo5emw2mC3Nwzq0KnFrCDe0JHrtNL+x803hyb5lPz5V/YvWUn8Qt9g18rl274Pc4QRvGgjQfvofa9cwp+GgRs0HXpm1DVQmbQBjaAR0jqt5AAvAQ4covMMtGKBZynko/Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214115; c=relaxed/simple;
	bh=64wcry0BA0MvWdUx6Qhj/CcX1X6OjO6ygjYBdmHuOKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCHFOCPmwi4u39yxVlmavzbQglC3F54Arlkm/tWAg7hyiC32ECNnBCf+d7C0sAUbzIFLaEBPx/4/TuPfHWOBqI+WHvNbrTdobVxDKMIJta/wO1+d5yLJERphnoEot6/awMXAb7M2FOVSb1DMU2mrLfaMpQnh30yDabP+SIYjZNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUUtVrXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUUtVrXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8D9C4CEF1;
	Tue, 26 Aug 2025 13:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214115;
	bh=64wcry0BA0MvWdUx6Qhj/CcX1X6OjO6ygjYBdmHuOKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUUtVrXtUDxiYzPzKXlOl6jfUWLBl0aKqeK6vwqXWLQbYpCKKvr88paqxgTL6Yz9q
	 2z0EQ0i+8KCP+gqMxUEGAIy0wT4FXPkg70W0HkHjzGNj0fR4M/5F9UNR8/ragVsQ2S
	 SCBB+VEvvrCHs0sP3g840JiNuJqyY0STd77et8is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.1 009/482] gpio: mlxbf2: use platform_get_irq_optional()
Date: Tue, 26 Aug 2025 13:04:22 +0200
Message-ID: <20250826110931.011722817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

commit 63c7bc53a35e785accdc2ceab8f72d94501931ab upstream.

The gpio-mlxbf2 driver interfaces with four GPIO controllers,
device instances 0-3. There are two IRQ resources shared between
the four controllers, and they are found in the ACPI table for
instances 0 and 3. The driver should not use platform_get_irq(),
otherwise this error is logged when probing instances 1 and 2:
  mlxbf2_gpio MLNXBF22:01: error -ENXIO: IRQ index 0 not found

Fixes: 2b725265cb08 ("gpio: mlxbf2: Introduce IRQ support")
Cc: stable@vger.kernel.org
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://lore.kernel.org/r/20250728144619.29894-1-davthompson@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mlxbf2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -374,7 +374,7 @@ mlxbf2_gpio_probe(struct platform_device
 	gc->ngpio = npins;
 	gc->owner = THIS_MODULE;
 
-	irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq_optional(pdev, 0);
 	if (irq >= 0) {
 		gs->irq_chip.name = name;
 		gs->irq_chip.irq_set_type = mlxbf2_gpio_irq_set_type;


