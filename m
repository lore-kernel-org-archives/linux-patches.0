Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4524F46551;
	Mon,  1 Apr 2024 15:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986673; cv=none; b=QNfPU7XG8IxCDyVhzNHSaBBlYaOUboIlRRse8xG7ws9MdcSqvFpFd7Sq9RNcqtAwKkOA70Tytwk4Ka2sndr1dham+o66U7kO0O42FJMSTRUMmLHtMFsahTpU9pfndllS4Ahk8ZV6O9cmYdaaRtj5+AMoTBtTYGEME2hieqpx1Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986673; c=relaxed/simple;
	bh=Shs5XQ3HF2Ny6ULkHK7jKaz27pbGygYTBLrp+rNtOKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cd8z3vVr8cpSj/dTisrSoCLfXpP9XxI7oEBly7zKgbmx2Ju4d58xOyebzmKuiWFAg4Cer72xt6AO8lh63iGfcHc8v9yFvseu+LIml3dRKFythztd38jpZU+zgShHOQhPn3OR3COQyxPagWFB817HHIJGtoQ75pispc2M+vr9hHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpRX9b5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpRX9b5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECA4C43399;
	Mon,  1 Apr 2024 15:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986672;
	bh=Shs5XQ3HF2Ny6ULkHK7jKaz27pbGygYTBLrp+rNtOKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpRX9b5mdta1wqACWQnAp40L64Rfw1gsflHxYuCUbRCF/z4UL1cEn4DghfM2sypbo
	 dVV3/E+G+TbzYKeIctPL/yoYB7PzvOXmWMkZINnAG0Pf+Kd7zvku8szPx+TIwX2j9X
	 hZcUENOCQNdGJW40vJlCpZwsuuI7AsWuJjr0eEaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 049/399] mfd: twl: Select MFD_CORE
Date: Mon,  1 Apr 2024 17:40:15 +0200
Message-ID: <20240401152550.648709088@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 3bb36528d46e494987ee5e9682d08318928ae041 ]

Fix link error:
ld.bfd: drivers/mfd/twl-core.o: in function `twl_probe':
git/drivers/mfd/twl-core.c:846: undefined reference to `devm_mfd_add_devices'

Cc:  <stable@vger.kernel.org>
Fixes: 63416320419e ("mfd: twl-core: Add a clock subdevice for the TWL6032")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20240221143021.3542736-1-alexander.sverdlin@siemens.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e7a6e45b9fac2..4b023ee229cf1 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1773,6 +1773,7 @@ config TWL4030_CORE
 	bool "TI TWL4030/TWL5030/TWL6030/TPS659x0 Support"
 	depends on I2C=y
 	select IRQ_DOMAIN
+	select MFD_CORE
 	select REGMAP_I2C
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
-- 
2.43.0



