Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060819;
	b=dnefSOn3e11u+g/anxBV4D22XsYw4XFHkgbrvqYwSo62l0bnUF5EpDzSbJoHEwAXD1BR
	 ggbrT38PwPmpqKJSze1V+erGIutoH/H1clufs4NF+8JHmv+9gSxEsu9IOp5kJFgEltd+H
	 TnpUsZRJ7bNlX2/6975hFKVMEB7EiHY5lPLij2b7kPnVu2J0uaK42xTrNqo+xL6XlO6TE
	 Sj9gvJzy7nOlxzU4TXMXMAJtHLY4KqJPoFWNvVah3NSnsNEII2m7wGoDvv0yq3VYr6Eam
	 EBakY43vdrK/X+qyBxBcMCGCFlXtMsnnsoPIxNzAv3BErIgxB50k3f+7SqTNo8b7xNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wdC5G4I2atTV36K4WoYwS0Mcr9DXY0ZzNOKTgaHiXAI=;
	b=DwtjAeq2POskTuAo773KRd4qAMJtFMmDct6XLZs9Aem8fwevsHz1mwuQQBRAlpVNgeda
	 L2BxHtKbOMoBWCWLGXUiVmQclKylKyEW5467+JAzEpIskhy98tUGgUaFYs30KWGqbH4MV
	 exf6U93Ch0bZzfeymaZKiirj8XF821GwgNLzdSsvluu0MM77pIeJ80dl7M21FPzbYLGqS
	 NtcbpyF8lY98St3k0wJpmu8Yl2VV9VShfkmqquizP0JPqnDIb2ozy/RNOQLLdASmOiKiR
	 Cr1twCs9F6Wu260ngxbXW/meL6v++u2jttPT2Qhj21qiYtDYID+7g4K90r4PDTsWgrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqI6c09b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EE1606A32F;
	Thu, 19 Nov 2026 04:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqI6c09b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434581F000C7;
	Thu, 19 Nov 2026 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060818;
	bh=wdC5G4I2atTV36K4WoYwS0Mcr9DXY0ZzNOKTgaHiXAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqI6c09bRqJ6S5ASV8+Ky/2x5duvc0NbesdXzydOWd3ymcpiHy05/GKHXJdr1OGaZ
	 xGviDP6RXuZD71QVVOeCbEynRheTJUUhzBDFJN6dCljYcVMwCSBSlN/xfIfIM+fp9R
	 j/i8rpdYE10IWdrIQh46xW2aq0P1vIS0QaXbYQxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1328/1848] mfd: intel_quark_i2c_gpio: Remove unused struct device member
Date: Wed, 18 Nov 2026 15:56:06 +0100
Message-ID: <20261118150015.353577144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 2b77ea7a0a42878a0a3f2956cfc657281fcf74c0 ]

The device pointer in the custom structure is not used anywhere,
remove it for good.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 14a7cf1a3730 ("mfd: intel_quark_i2c_gpio: Manage the fixed-rate clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_quark_i2c_gpio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mfd/intel_quark_i2c_gpio.c b/drivers/mfd/intel_quark_i2c_gpio.c
index 7ed697767b888..76743fdc69861 100644
--- a/drivers/mfd/intel_quark_i2c_gpio.c
+++ b/drivers/mfd/intel_quark_i2c_gpio.c
@@ -45,7 +45,6 @@
 #define INTEL_QUARK_I2C_CLK_HZ	33000000
 
 struct intel_quark_mfd {
-	struct device		*dev;
 	struct clk		*i2c_clk;
 	struct clk_lookup	*i2c_clk_lookup;
 };
@@ -238,7 +237,6 @@ static int intel_quark_mfd_probe(struct pci_dev *pdev,
 	if (!quark_mfd)
 		return -ENOMEM;
 
-	quark_mfd->dev = &pdev->dev;
 	dev_set_drvdata(&pdev->dev, quark_mfd);
 
 	ret = intel_quark_register_i2c_clk(&pdev->dev);
-- 
2.53.0



