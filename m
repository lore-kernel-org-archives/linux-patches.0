Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC31E26F2A7;
	Mon, 18 Aug 2025 12:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521515; cv=none; b=IZwbAFMDc9E50XJ6NQi0HulDxhXTkguruvti5ALsjZq6Bugizl6GyrKkraN9Yc+8g6iuowDHYyuzgjqoIiVldY+Gr/dDQY/bwdvUSQrn/3ljkDeGz0eb3IhBlwL0EMwoIIiJ7O/BRbqLprzoXE5fCwAUzJyGzuLW8iuaZIMt4iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521515; c=relaxed/simple;
	bh=xIFA2T+d370GFc9BpSRx/OUqysaQBM/ygF4wgizt9g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkH4n39xHdxvakvuUsUxsXo8lNMyw0BI4i79T1nJ2fp5i9hGWS1Zsg30XnR2ecu8qjfJ44zmFnFmDr+ko3UJwtO5AuSFvmGe5jvTNpi2Fud4GTaPS7kHUYZ1wQTE1gBAGSN7HzOakiMNa484QYrfl9wa6RikklthCcqmMuBsZFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/5T+oaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/5T+oaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DE0C4CEEB;
	Mon, 18 Aug 2025 12:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521515;
	bh=xIFA2T+d370GFc9BpSRx/OUqysaQBM/ygF4wgizt9g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/5T+oaGOUOf6lH7/GDiCNBZhR9uOXFhnTDmWia1oy5zoH+qrZUP5LJsyr8mvF5MZ
	 n/LTr8RUY68p8uGnrscZTvyd8inCl6eUUJiFH9N5mJGDZz4PjzJAU6XVQ8K6m/D+Qs
	 A/t0bxpjHOsdgrsjRqkCV5g7EiOUyY+m57kk3gwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 009/444] gpio: mlxbf2: use platform_get_irq_optional()
Date: Mon, 18 Aug 2025 14:40:35 +0200
Message-ID: <20250818124449.254123716@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


