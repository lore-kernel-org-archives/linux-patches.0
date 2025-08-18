Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAE022A7E0;
	Mon, 18 Aug 2025 13:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524630; cv=none; b=Re44+Gbx+SiuBPwrzTqO1arLihAeH4Tb5gn9ZcI9NVpNkknpPsQQLzuRPnDCTxknWGOAipL3MheD1p4zPIk2qHr+wf4R02UW68Qxv3BIHQC2GjmcpewAGT9+ibDQYLTM1M26UT1IyVfJbT3Bwn1plNxe43QKZE49skwpLRR9tE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524630; c=relaxed/simple;
	bh=zl+mfDQbSSbzPfUbcJzfqqnN2e0hyGbc38L0B1V8BmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+K2clpHZgsd3GxnWzLZlD4QGgpsPESzwPIdkcpQ7MIBUkvRzGzFF9lBcTcSRPERMMaZhit/af6Zs87XA3OTXj6ewXNr1+B6EQO1uKI7Zlnf+xcTaYcIw/WkXwZILto/niCLBoAM2VwQaIj6caK9t9pIoXP+nfglfXOj1Lq3k8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwnwgEmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwnwgEmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27B0C4CEF1;
	Mon, 18 Aug 2025 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524630;
	bh=zl+mfDQbSSbzPfUbcJzfqqnN2e0hyGbc38L0B1V8BmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwnwgEmFDQghqf0P60Xo/vX3VUooVxLClHT9bx+KeRdIDEza3cHiPFB6ZvZGrMBFR
	 PlGfWs/PRYC89k1SotzXQM+03PcruAyNQLNnusSDCaqfHbNWDqYIBlnI0zttwni3rh
	 H5wgF6V6p1ltGqVAFYSzEMMR1GShPb1k2vzzrBHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.16 015/570] gpio: mlxbf2: use platform_get_irq_optional()
Date: Mon, 18 Aug 2025 14:40:02 +0200
Message-ID: <20250818124506.380269903@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -397,7 +397,7 @@ mlxbf2_gpio_probe(struct platform_device
 	gc->ngpio = npins;
 	gc->owner = THIS_MODULE;
 
-	irq = platform_get_irq(pdev, 0);
+	irq = platform_get_irq_optional(pdev, 0);
 	if (irq >= 0) {
 		girq = &gs->gc.irq;
 		gpio_irq_chip_set_chip(girq, &mlxbf2_gpio_irq_chip);


