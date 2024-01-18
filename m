Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0282122F0F;
	Thu, 18 Jan 2024 10:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575544; cv=none; b=m6KXm5dpZyKMFji2q7zpCAwlAfrKf84pTcj4lYc0Z0m4mti3TLr78quoE4FeY6xaX9j3eiY7wOK3x0gdSrGu0tsMgnnYBAbkzKHnRc1xv5mE8IqWN6+eKlCxh6zYZGschaJLDxsij98QkPxGjHeSt5RODDy6PmtSZPXpzzbhVxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575544; c=relaxed/simple;
	bh=R3lDUZ6pytjuWilZpskhG5uXEUkI6RHLVk/RCLEJvbk=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=hTu50QomP2/Tgx2jxIOqnusWNwZ+BrkaQn1FqcIpaWt4QksI0iDV/nCJew3kVAszZWgIxb1MH9I5OKIGZeMkRMjdhvb9VIEduNSzhsCEl6883Sl2echtTTFq+xqlRxat1bS2iJOzzpMPIoZnsWjhj7ZUn+CPX1T07Ak8/LvUmlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccWN2x32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccWN2x32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B079C433B1;
	Thu, 18 Jan 2024 10:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575543;
	bh=R3lDUZ6pytjuWilZpskhG5uXEUkI6RHLVk/RCLEJvbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccWN2x3274BOIYcqxjT36JEaXGVajD4uFSWYFlurd6U7iPpF1ZR0pwvUWihkzkPaZ
	 +i7KPSOcT8eMnhWUIj043k5tuTmywCgkkuIFjSQebCW+r7guSli2Ie8T14hhG4HJgk
	 0nDkyH/kIQA5Bid4dn2TPT3jnvaR70/9jQkU3Jhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/100] pinctrl: lochnagar: Dont build on MIPS
Date: Thu, 18 Jan 2024 11:48:10 +0100
Message-ID: <20240118104311.004149272@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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



