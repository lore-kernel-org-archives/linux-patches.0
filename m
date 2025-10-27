Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B20D328619;
	Mon, 27 Oct 2025 18:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590755; cv=none; b=Op0P2u3zw5YoGbrP0rhUiSPCY+38fXnVUuEryxW0dAmSabi5daDDSiaO3mFoZAzVzYW/UUE17EOjjO8VDOMDKHJBtlv+8qmEro0PIylaXOyLKeQ/Jna7yg0iHBu31aDGRX/p0xW0WRxaGl6p0I7TVZ2NszV8lxWPs3mxyf8TlTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590755; c=relaxed/simple;
	bh=O8HEWM5Xq4KTRz9q5rMLn+yZYSrmPSbAlbNWIcAnDUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TvrDXVmFD94jB5SpH9X3jvptC8HB2TKvQ/5nW97aUrfZP1ezJz0wmmKxpGrai+1zXD9ZHBY9anNniClAViuI+cF/odR9Dj8IR67Twp2zi8WkCVDEG8+VUHcWuFA5EQGqVSzp04Vhe14+ksnuLd6Zg3Clm078Zly1+DuAUZovM4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqLkPE/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqLkPE/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDC4C4CEF1;
	Mon, 27 Oct 2025 18:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590755;
	bh=O8HEWM5Xq4KTRz9q5rMLn+yZYSrmPSbAlbNWIcAnDUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqLkPE/OksM8T0R7eY8G9Olubcc8xTz+9eRaIloewlMSwMqp1aFeSpxk8K0Q71hs7
	 hUYF1HZZiWvlS/02FbMCWVxu1GEG8OLY4nOZxpLQTIdj1xEDDPa9JOSAI0dq/WWuf0
	 jEVetsZVCtH7FndCzkvvoet6i7jXnScAEtnzNFa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/224] mfd: vexpress-sysreg: Check the return value of devm_gpiochip_add_data()
Date: Mon, 27 Oct 2025 19:34:41 +0100
Message-ID: <20251027183512.588681801@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 1efbee6852f1ff698a9981bd731308dd027189fb ]

Commit 974cc7b93441 ("mfd: vexpress: Define the device as MFD cells")
removed the return value check from the call to gpiochip_add_data() (or
rather gpiochip_add() back then and later converted to devres) with no
explanation. This function however can still fail, so check the return
value and bail-out if it does.

Cc: stable@vger.kernel.org
Fixes: 974cc7b93441 ("mfd: vexpress: Define the device as MFD cells")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250811-gpio-mmio-mfd-conv-v1-1-68c5c958cf80@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
[ Use non-devm variants ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/vexpress-sysreg.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -160,6 +160,7 @@ static int vexpress_sysreg_probe(struct
 	struct gpio_chip *mmc_gpio_chip;
 	int master;
 	u32 dt_hbi;
+	int ret;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem)
@@ -195,7 +196,10 @@ static int vexpress_sysreg_probe(struct
 	bgpio_init(mmc_gpio_chip, &pdev->dev, 0x4, base + SYS_MCI,
 			NULL, NULL, NULL, NULL, 0);
 	mmc_gpio_chip->ngpio = 2;
-	gpiochip_add_data(mmc_gpio_chip, NULL);
+
+	ret = gpiochip_add_data(mmc_gpio_chip, NULL);
+	if (ret)
+		return ret;
 
 	return mfd_add_devices(&pdev->dev, PLATFORM_DEVID_AUTO,
 			vexpress_sysreg_cells,


