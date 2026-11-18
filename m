Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018415;
	b=WVNbJiXf1q9c07qsh7lUyYhbhGAu0RcU1DotX4Ii27AnvYHiOmhnfdNqLoYdb3YrBSe2
	 +2d8VCvLAoXcnuUNNk7/wiPUaNX5tmJDao8n3JFNGfmY4CKYsx7Zqn6F8pteBzNInYPyu
	 nmx99WlxtNoukJ3UF55ZJmHWspenrtV9NXBPhH4TmEaaeWsk1zjVdhzcVEreD90vSYOFH
	 65cNjOtK5O2XVtHyBfKDzyYj2gKK3KaW1I6Ozvlq4/yHE+CDHsZtmYECQQONEKAw/h3A+
	 om3YUtgiAOk0r9lCUssHcVVPhHTd7cj49tpCLeAwLB7r73c/ZvWqRk727LRjc5Qc+tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VzVoMhW2Z/wTM2zT4FsQSCjliBxRofotmrfbvsfNQ0Q=;
	b=GCgepJ8d719+3ODTVqnL7g+rQC/jdJ41qkpquZ6dEh9T6SyMfkqQyVhknPcnVqSt8SAj
	 kVWtxbd2c8YMH7RUyXaFqDCJgd7Fqda4DSAg5KzHgIskFfkd+Hbe9lSvxCvH/IvtWZ7lF
	 i2+E7DZWKHy0KzUVMYTRl0AJhie2mlV2RLq0BKi0cgW3mWUmzA/svgBKoK0bEZwT8cYsW
	 Ex/hZz9RkidtnUPY5p8NypM/8v5gjaVHQDGVkY1HwD2eyGzYzJhSVOR3Cb9IeJHT5nj9+
	 6iqXuN2GB6uQPBcGXZ3fkro09bG1dSVBsXvOdgG3FvA2JDVzm2iGJq+JgAocHPao5gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hVD0296;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA51B606A320;
	Wed, 18 Nov 2026 16:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hVD0296
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CD21F000C5;
	Wed, 18 Nov 2026 16:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018415;
	bh=VzVoMhW2Z/wTM2zT4FsQSCjliBxRofotmrfbvsfNQ0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hVD0296fO1R7U7lrun5xtT5tVrVi/pVcUXy5e8aAhNM7UGIR4psDKGv/ri9YDS2a
	 Zg2Kjwbr/EGRPwiFP9NhFmNQ7R8j3H9Qb7C7x2cZMG7uuLUNzyhnr1Y2TlDILs2d8V
	 jR0NAXizawNXIeUCkjuTXutihCpmhpiAx9q9LnYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruno Banelli <bbanelli@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1233/2651] phy: spacemit: fix K1 USB 2.0 PHY Kconfig dependencies
Date: Wed, 18 Nov 2026 15:41:13 +0100
Message-ID: <20261118150332.399414932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruno Banelli <bbanelli@gmail.com>

[ Upstream commit 882af55e42a4cd5bd61db0244c0b78941884518a ]

phy-k1-usb2.c maps its registers with devm_platform_ioremap_resource()
and wraps them with devm_regmap_init_mmio(), but PHY_SPACEMIT_K1_USB2
neither depends on HAS_IOMEM nor selects REGMAP_MMIO.

REGMAP_MMIO has no prompt and can only be enabled by select, so a
configuration that leaves it off fails to link.  In practice the symbol
is usually pulled in indirectly, which is why this has gone unnoticed.

PHY_SPACEMIT_K1_PCIE, directly above it in the same file, already has
the HAS_IOMEM dependency; without it PHY_SPACEMIT_K1_USB2 can be built
under COMPILE_TEST on architectures that provide no I/O memory.

Fixes: fe4bc1a08638 ("phy: spacemit: support K1 USB2.0 PHY controller")
Signed-off-by: Bruno Banelli <bbanelli@gmail.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260825065007.69353-2-bbanelli@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/spacemit/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/spacemit/Kconfig b/drivers/phy/spacemit/Kconfig
index 5fdf18fce4995..cd7ae48d8ea2f 100644
--- a/drivers/phy/spacemit/Kconfig
+++ b/drivers/phy/spacemit/Kconfig
@@ -18,8 +18,10 @@ config PHY_SPACEMIT_K1_USB2
 	tristate "SpacemiT K1 USB 2.0 PHY support"
 	depends on (ARCH_SPACEMIT || COMPILE_TEST) && OF
 	depends on COMMON_CLK
+	depends on HAS_IOMEM
 	depends on USB_COMMON
 	select GENERIC_PHY
+	select REGMAP_MMIO
 	help
 	  Enable this to support K1 USB 2.0 PHY driver. This driver takes care of
 	  enabling and clock setup and will be used by K1 udc/ehci/otg/xhci driver.
-- 
2.53.0



