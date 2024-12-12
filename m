Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA29222D67;
	Thu, 12 Dec 2024 17:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024894; cv=none; b=C8wGKmTO+flXryIvZWbHDyrtlx4QyCSn3iyithGECcoi/rsaAUlAPpKfD7MfpJgNTjUkTkcbfw4uQlcWgHngxv6qpJbDdZ4HtUaiMVEaWloB7Ql1a6DL08KU8Vgh3KGH4s8DCtKxFCXffLgOmpPyOGB8LNTk/z7l15LsAYRKAic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024894; c=relaxed/simple;
	bh=FwrqNOK9hoYAPa4aUMYY/44Q5pXd726NCOIkVDJ7RvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrcCYr6dm7ddZJnglLBIsiVB77YXNwufRU1QcndYioPXp/KMB2b09J19MQcrfgExOw+xVwZAiZJdNj/8jD1M1UT8URBsgLT0BjRaF1eYNHAdAkRPWyTywVjsrYtzXXV4iWvjhO9+tokrdlJvKtk7emvuxewFiufoi+OQzIQVsEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYbNO+ya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYbNO+ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A6DC4CECE;
	Thu, 12 Dec 2024 17:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024894;
	bh=FwrqNOK9hoYAPa4aUMYY/44Q5pXd726NCOIkVDJ7RvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYbNO+yaPwiKhQl0aayELE2PlecicMVOqWz3x63Gdf6cXegx7ilF99/qBFxINXQfI
	 cgMhuGfJQoNBlkXkYK/iz3hO4/Qzum1HrurOHw0lO3ZS6gEyKH2Om04UfysPZNybKw
	 me2cdGIYTpaoEBLvKSsaA43vwBPA6yxitpSg8evE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 417/459] pinctrl: freescale: fix COMPILE_TEST error with PINCTRL_IMX_SCU
Date: Thu, 12 Dec 2024 16:02:35 +0100
Message-ID: <20241212144310.236125235@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a1fbb3b9ae346..eefc786d08b45 100644
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



