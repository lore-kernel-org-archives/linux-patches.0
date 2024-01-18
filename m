Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA74D1B96D;
	Thu, 18 Jan 2024 10:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575151; cv=none; b=tT3iq4uIwIHreK/9smjG8UJN7sXXZUpABJjr8YTBGJ2C6643m3p5/PUFUOd51ZMRpLnEkG90EIWKoyQXxghTpR1U/4LAgo+Q2PhYuMdNYQyTfwzW+IE26yAcsyAVG8x31UBo953C/VSu1ZGC36k2B6zQvV6W4TAGndbPzaCkVtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575151; c=relaxed/simple;
	bh=QjTTekZRQwgLG0/mOMRcV5l7cnHl57KHxC8OcCpeYCA=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=Entmv/Gb8bW7xKtYtAhC1PyG/BskkdIQhPziMNfJ0ce8Uy4RuB3LwwcUC26jyY1lYJyT+RYaZqZiPDB6QR4iF6ZXaTDuXnr2MXUa6gFMLgLlQosDxKZ2otnpiUfIAZAdPBx5NPqAhJJ5/9fKmvruvA9N4+Qqdv4ikyAdWg8bzGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CB9pXtr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CB9pXtr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B372C433C7;
	Thu, 18 Jan 2024 10:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575151;
	bh=QjTTekZRQwgLG0/mOMRcV5l7cnHl57KHxC8OcCpeYCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CB9pXtr3XXUZm3UlK2ykxnJu+Lr9/h3fdycaLtVsoa3yzF4kE0odeyMnw+Ew0jE7J
	 qGPHqH5AX0sRvcAY+uupn75EBCcSuBXleqzOMaMuiKEur57yFcWFZS6xq3Ju4k5AE/
	 aYxswYLIKDSjVxz5ZTxt68sF1Q+BC0kjVoXzJlMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/150] pinctrl: lochnagar: Dont build on MIPS
Date: Thu, 18 Jan 2024 11:47:07 +0100
Message-ID: <20240118104320.285276150@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d6318cb57aff..e7e827a8877a 100644
--- a/drivers/pinctrl/cirrus/Kconfig
+++ b/drivers/pinctrl/cirrus/Kconfig
@@ -12,7 +12,8 @@ config PINCTRL_CS42L43
 
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



