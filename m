Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A843F22655B;
	Thu, 12 Dec 2024 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021297; cv=none; b=ij4wx01C8WOOy/bEGYHLvcPRn3UXUUGverZYkRyaFYBqyZz9WkQCqO01U9rmlnUPSJyccSMDCYQYzNdeMsj3Fz34ksYV9F//wbLkpu/1ijlGfecNzHIvaZlUfTum0MoZ0HfFXEUeweYMLFBEWSkxoW1LORXMDdpC5hcB1OmsFbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021297; c=relaxed/simple;
	bh=CThHrp3fYJ5QMmQYzsBAsk+/UY19C1n+QftQc6ghwU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttYvMi7w/wgHgDZfgf6VK2SNRXHN+cyTUH2DjiX+0kGWhsYTn40XeXNU90lbO6NLbOkp3JOcdiZ6VfIg378s9I5Ty+bfAGZct03T2wMqu/bTs3oNc7Y3gnTyPAH/5dIoPxlAk2Laa4dSSw7014y1swIEE5UjHUaC/cGh5DynXeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOvYBWzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOvYBWzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155E2C4CECE;
	Thu, 12 Dec 2024 16:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021297;
	bh=CThHrp3fYJ5QMmQYzsBAsk+/UY19C1n+QftQc6ghwU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOvYBWzzRiJsz6kIG+U4RZwJQ+Adl6GP4yeEl2HuGjThS/QZ6WakSlSFWCHDTE0q/
	 sUI1mMmf3QfWUYwdsgPakAOSWybNRqSnt5t9/oIUfw0Jo3u8tFdqkgdylEz2ErZj3h
	 Lg0+dGtaN1d6WvjLZzwk7XG1TIb5kjqvC45gz+7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 699/772] pinctrl: freescale: fix COMPILE_TEST error with PINCTRL_IMX_SCU
Date: Thu, 12 Dec 2024 16:00:44 +0100
Message-ID: <20241212144418.781252987@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 58414a31c5713afb5449fd74a26a843d34cc62e8 ]

When PINCTRL_IMX_SCU was selected by PINCTRL_IMX8DXL or PINCTRL_IMX8QM
combined with COMPILE_TEST on a non-arm platforms, the IMX_SCU
dependency could not be enabled.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410031439.GyTSa0kX-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202410030852.q0Hukplf-lkp@intel.com/
Signed-off-by: Esben Haabendal <esben@geanix.com>
Link: https://lore.kernel.org/20241003-imx-pinctrl-compile-test-fix-v1-1-145ca1948cc3@geanix.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/freescale/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/freescale/Kconfig b/drivers/pinctrl/freescale/Kconfig
index 7a32f77792d9a..86110fc3c1465 100644
--- a/drivers/pinctrl/freescale/Kconfig
+++ b/drivers/pinctrl/freescale/Kconfig
@@ -9,7 +9,7 @@ config PINCTRL_IMX
 
 config PINCTRL_IMX_SCU
 	tristate
-	depends on IMX_SCU
+	depends on IMX_SCU || COMPILE_TEST
 	select PINCTRL_IMX
 
 config PINCTRL_IMX1_CORE
-- 
2.43.0



