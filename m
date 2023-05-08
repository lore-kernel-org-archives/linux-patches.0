Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A37168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA30C433D2;
	Mon,  8 May 2023 11:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545218;
	bh=+BA7750sAWzzM6mlvisM+T+VeoczYJX2DLbbt1kNYNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCxjxEBznS4jqR116JJx7qtF+ZwU8GfWaOetHKtb+7fT4dm0jTY2kgducBi865nVc
	 iFJiVZcD27xVcbBKUMDsy2Wq0Yqw2JAPE53vKIjykTIqlL1HUZerisYB54rbOr1sSO
	 OYOANwvgdaIkmBBbPD0OhM8WHnGD+MS7VsmvUZ68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 663/694] mfd: arizona-spi: Add missing MODULE_DEVICE_TABLE
Date: Mon,  8 May 2023 11:48:18 +0200
Message-Id: <20230508094457.553666935@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 972c91fd7beddc3f19c8c855f6e60e7dbd435cbd ]

This patch adds missing MODULE_DEVICE_TABLE definition
which generates correct modalias for automatic loading
of this driver when it is built as a module.

Fixes: 3f65555c417c ("mfd: arizona: Split of_match table into I2C and SPI versions")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230323134138.834369-1-ckeepax@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/arizona-spi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/arizona-spi.c b/drivers/mfd/arizona-spi.c
index da05b966d48c6..02cf4f3e91d76 100644
--- a/drivers/mfd/arizona-spi.c
+++ b/drivers/mfd/arizona-spi.c
@@ -277,6 +277,7 @@ static const struct of_device_id arizona_spi_of_match[] = {
 	{ .compatible = "cirrus,cs47l24", .data = (void *)CS47L24 },
 	{},
 };
+MODULE_DEVICE_TABLE(of, arizona_spi_of_match);
 #endif
 
 static struct spi_driver arizona_spi_driver = {
-- 
2.39.2



