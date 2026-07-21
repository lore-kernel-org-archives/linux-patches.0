Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A105746D098;
	Tue, 21 Jul 2026 17:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656448; cv=none; b=EIwCE6tr29k3VlCTEqNNHKrRUaFj67qHp98wG4grJL64+LOXY0Hv4Rtrmq9fPw1sxAPjNUgoQr3eXAjKbOSBP6vJIGjYzoNWjEQXpQBscy033VxRyyRSwF0uWdIIFPltuAQ9hEigNTar39hd8b2II6P8tb3jh0B2hy6/w3Zam+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656448; c=relaxed/simple;
	bh=+Ca9zWiVZRShPW0HW1P8aq/6yuayTLJ/yWL0MpV7cJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omK4fwpy/8hEWhCyg9H8QXryuxf8Tfotae8Ucl5Bq3FV4tmCzcZ3ipNTO8dWsx7XU6Jl8DTyC7itggSMefz1kFK4j4QF77zFjwT25HUh8Lq+E9nAS/hxQbEUAoxG/IaLhmVgV/7K9Somn74Fa+3xQdXsa78YKpAhopHQFg1GOgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcVwOvGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcVwOvGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13ED41F000E9;
	Tue, 21 Jul 2026 17:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656447;
	bh=kMpqHy1xdxNUFXzn+UiqFM3mR/AYSAEvSg/E2XjbbVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcVwOvGWtdV3VJ37dU8lSx0+vz839YUAE6SNMplis0/CBKO+lcASXjMgL8rt099B3
	 U7N6WybB1Qi2/IXCq/M0nU6O5KYw2oU4iz/w2b4cHrOAsuTfjEBfCiNbKWVOPzMPI3
	 1b8GJ2q169mXnJAd8GexZwWc68lnky+y+SXYzf5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <chleroy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0374/1611] powerpc/8xx: implement get_direction() in cpm1
Date: Tue, 21 Jul 2026 17:08:10 +0200
Message-ID: <20260721152523.595765596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 052f67a1ae6ffa6e43c82193bf2e6c0dfd2e6d8f ]

The lack of get_direction() callbacks in this driver causes GPIOLIB to
emit a warning. Implement them for 16- and 32-bit variants.

Reported-by: Christophe Leroy <chleroy@kernel.org>
Closes: https://lore.kernel.org/all/63487206f6e5a93eaf9f41784317fe99d394312f.1780399750.git.chleroy@kernel.org/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Fixes: e623c4303ed1 ("gpiolib: sanitize the return value of gpio_chip::get_direction()")
Tested-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
[Maddy: Fixed the Fixes tag]
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260603-powerpc-8xx-cpm1-get-dir-v1-1-2ae1c9a5b992@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/8xx/cpm1.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/powerpc/platforms/8xx/cpm1.c b/arch/powerpc/platforms/8xx/cpm1.c
index 7433be7d66ee96..55cdf3b8e75665 100644
--- a/arch/powerpc/platforms/8xx/cpm1.c
+++ b/arch/powerpc/platforms/8xx/cpm1.c
@@ -472,6 +472,18 @@ static int cpm1_gpio16_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	return 0;
 }
 
+static int cpm1_gpio16_get_direction(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct cpm1_gpio16_chip *cpm1_gc = gpiochip_get_data(gc);
+	struct cpm_ioport16 __iomem *iop = cpm1_gc->regs;
+	u16 pin_mask = 1 << (15 - gpio);
+
+	if (in_be16(&iop->dir) & pin_mask)
+		return GPIO_LINE_DIRECTION_OUT;
+
+	return GPIO_LINE_DIRECTION_IN;
+}
+
 int cpm1_gpiochip_add16(struct device *dev)
 {
 	struct device_node *np = dev->of_node;
@@ -498,6 +510,7 @@ int cpm1_gpiochip_add16(struct device *dev)
 	gc->ngpio = 16;
 	gc->direction_input = cpm1_gpio16_dir_in;
 	gc->direction_output = cpm1_gpio16_dir_out;
+	gc->get_direction = cpm1_gpio16_get_direction;
 	gc->get = cpm1_gpio16_get;
 	gc->set = cpm1_gpio16_set;
 	gc->to_irq = cpm1_gpio16_to_irq;
@@ -604,6 +617,18 @@ static int cpm1_gpio32_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	return 0;
 }
 
+static int cpm1_gpio32_get_direction(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct cpm1_gpio32_chip *cpm1_gc = gpiochip_get_data(gc);
+	struct cpm_ioport32b __iomem *iop = cpm1_gc->regs;
+	u32 pin_mask = 1 << (31 - gpio);
+
+	if (in_be32(&iop->dir) & pin_mask)
+		return GPIO_LINE_DIRECTION_OUT;
+
+	return GPIO_LINE_DIRECTION_IN;
+}
+
 int cpm1_gpiochip_add32(struct device *dev)
 {
 	struct device_node *np = dev->of_node;
@@ -621,6 +646,7 @@ int cpm1_gpiochip_add32(struct device *dev)
 	gc->ngpio = 32;
 	gc->direction_input = cpm1_gpio32_dir_in;
 	gc->direction_output = cpm1_gpio32_dir_out;
+	gc->get_direction = cpm1_gpio32_get_direction;
 	gc->get = cpm1_gpio32_get;
 	gc->set = cpm1_gpio32_set;
 	gc->parent = dev;
-- 
2.53.0



