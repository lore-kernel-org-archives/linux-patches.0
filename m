Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9F91487CD;
	Thu, 12 Dec 2024 17:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023496; cv=none; b=BbtVfGUW7tDhMu5SiStTgga8zCKCs2vbckAPZU9C5cOSjvGJgZbJmLG5i8NlAAfD690G8V0BLCQnOObSIZACuyvkeLDhJAE5G3e8bXREYdSxkemnzeS5m8UMujBKBFa2YbEkXk6saqIBdjFnc5FO23yKnXrxSlKNXDz9gYE0YPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023496; c=relaxed/simple;
	bh=f2Wtk7JNAK7h5UEquF8Q2ZD4Ko1V1oVYlnLo/Ofy2fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dec2cYJTIQq34u373lRVWatI2QNUkFaoJvzDtsDztXsHNJFJr4sIZXZC66ZYjHZWqNdZ+6wcdwg8EiItemBY7FJjEqRDf554JbHbWZTa7yGCkk6bCZwJ3h/qwvj48bW/x9Qownd7gYTXwu44UuRH8S1s6FU5T1C+UaqHtiGOEBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPNGsaB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPNGsaB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DF4C4CED0;
	Thu, 12 Dec 2024 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023496;
	bh=f2Wtk7JNAK7h5UEquF8Q2ZD4Ko1V1oVYlnLo/Ofy2fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPNGsaB62Kw/hRxhDiQ7ft2ieQqzOo7AqGict3M6Jb1nyd4m1PZzimKuV7emmFAH7
	 yWvKpEyN6yd+Rnkcmx1yOn5qc4P1J0HwYbSjDp/MhxxF5ZBPrIkCNWT1HFiu5Y33lF
	 cyPHSCrP+zo4DCnzT2lftynGOGP6I9kRDL5YpC8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 512/565] pinctrl: freescale: fix COMPILE_TEST error with PINCTRL_IMX_SCU
Date: Thu, 12 Dec 2024 16:01:47 +0100
Message-ID: <20241212144332.017739137@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 21fa21c6547b1..93b38d97a7263 100644
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



