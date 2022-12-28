Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1D91C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23903C433D2;
	Wed, 28 Dec 2022 16:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245114;
	bh=XCYAUkk25tpzYLrY7z26zSUToMa1wnEdXMCbDROI2m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzG8XQ6eknAFF7fVgpzzsComGFHhcgSaB2Rn+U4VpktMsBDu/ZmP2WrgwnUuJXAIs
	 fGZwJzcQhFPL7IbpFFFMjtV/xVeK0qW99+94uTL5640TA82vzbIm/Rx1PolhAvAPWY
	 lVcU4Ac99OhwNrR+3duwA2DA78Rf2MapGpvJGXkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Terho <janne.terho@ouman.fi>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0835/1073] rtc: pcf85063: fix pcf85063_clkout_control
Date: Wed, 28 Dec 2022 15:40:23 +0100
Message-Id: <20221228144350.697476599@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit c2d12e85336f6d4172fb2bab5935027c446d7343 ]

pcf85063_clkout_control reads the wrong register but then update the
correct one.

Reported-by: Janne Terho <janne.terho@ouman.fi>
Fixes: 8c229ab6048b ("rtc: pcf85063: Add pcf85063 clkout control to common clock framework")
Link: https://lore.kernel.org/r/20221211223553.59955-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85063.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf85063.c b/drivers/rtc/rtc-pcf85063.c
index 99f9cc57c7b3..754e03984f98 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -424,7 +424,7 @@ static int pcf85063_clkout_control(struct clk_hw *hw, bool enable)
 	unsigned int buf;
 	int ret;
 
-	ret = regmap_read(pcf85063->regmap, PCF85063_REG_OFFSET, &buf);
+	ret = regmap_read(pcf85063->regmap, PCF85063_REG_CTRL2, &buf);
 	if (ret < 0)
 		return ret;
 	buf &= PCF85063_REG_CLKO_F_MASK;
-- 
2.35.1



