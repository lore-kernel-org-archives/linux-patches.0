Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE99C2B9D2;
	Tue, 23 Jan 2024 00:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970699; cv=none; b=Y2zMc2j6xx4gzkgbHqsIbPO8TstPljfnh1XOYQaDVGqlrbPrFFBxvvR99I1vxNLW7XDQeL8DR5LKC03ca4hbf3iMiuoUt7FWAlwVbJ5iY1ppqWxRnYijS1hefhYoSXlSbjzRKjDjRNSgA7VFz2cQ4a7SftXb3K3/8+kvt8JHa/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970699; c=relaxed/simple;
	bh=XrdWh6FVakHCADOaVzhw9s5KDB043Wb9G8niKyXKwrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZpiVkft8r1nddsLErLUYQhF19SNF7Did/rPpQ9z+pLU2zk6pTWsfLSVlk8HEZ3H5WXj9OhRycO/akHcqnMl2NBZ5WLpgbgrroiMzX/4iaoCOjhiNT3kcqeD/66kdmdpoCKmHTi8t89uVoYRCqixWAx7wzd+krc6tok+uELYw0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7eL6Icu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7eL6Icu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC44C433F1;
	Tue, 23 Jan 2024 00:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970699;
	bh=XrdWh6FVakHCADOaVzhw9s5KDB043Wb9G8niKyXKwrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7eL6Icu468ihr/T6m+mijekUv3xFO+x8mfFREbpRDgHPgec2cjKycKxpIy1yGRZ9
	 iTT7Xsb2M2VKNlBDoef1mp3Yya/niFNYQzMcLqFIrHVhMrjGvlS0IjkMcilp8S8G5j
	 oTHsHlaEizISCKSYqSj0mzNRuW+sAbRjuq34OCA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/286] pinctrl: lochnagar: Dont build on MIPS
Date: Mon, 22 Jan 2024 15:55:08 -0800
Message-ID: <20240122235732.094446572@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 6588732445ff19f6183f0fa72ddedf67e5a5be32 ]

MIPS appears to define a RST symbol at a high level, which clashes
with some register naming in the driver. Since there is currently
no case for running this driver on MIPS devices simply cut off the
build of this driver on MIPS.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311071303.JJMAOjy4-lkp@intel.com/
Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231115162853.1891940-1-ckeepax@opensource.cirrus.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/cirrus/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/cirrus/Kconfig b/drivers/pinctrl/cirrus/Kconfig
index 530426a74f75..b3cea8d56c4f 100644
--- a/drivers/pinctrl/cirrus/Kconfig
+++ b/drivers/pinctrl/cirrus/Kconfig
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config PINCTRL_LOCHNAGAR
 	tristate "Cirrus Logic Lochnagar pinctrl driver"
-	depends on MFD_LOCHNAGAR
+	# Avoid clash caused by MIPS defining RST, which is used in the driver
+	depends on MFD_LOCHNAGAR && !MIPS
 	select GPIOLIB
 	select PINMUX
 	select PINCONF
-- 
2.43.0



