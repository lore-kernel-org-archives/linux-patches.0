Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DF5320F;
	Tue, 14 May 2024 11:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687607; cv=none; b=bKh5d8ZTT07rHvtKcdqbU5Lk28qZLe9o5zjxOJmfxerCyMeYUMWNmWJU061Y+mBHEIQMx6wGRRlIqf3a3A9wrgZvOMwPPgznsVIY0RepuRAjCIC+90c/hoGsELshUM22WaNWzJOdWv09EMwpCLJoDWDeKdic3one/jWBeQjgoTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687607; c=relaxed/simple;
	bh=5Hp+eHHTp8052850g8Lt7uPe+9unr7mJ3+KgxhgJtbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R09l/iDF0pxj6daBG0UmwRf3CwDzytayN+hHVfFKNsRRn//pL37IuOfUgc1avp52qL9cgB/wo+GxHsArRTSsd1B7bNLMH/CyAEBP9oEmVlfEQ6M21O9AHjWRjqdIUCWwgrRlYULaiFk0AQw2geEzghNJ+2//VVoUADzHHODnC7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0F8SZw6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0F8SZw6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D59BC2BD10;
	Tue, 14 May 2024 11:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687606;
	bh=5Hp+eHHTp8052850g8Lt7uPe+9unr7mJ3+KgxhgJtbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0F8SZw6Ecp8Qpfr1K9VMN8zl5RNjZ01zZxv6l/8g+Nws309OJxv5ad32xarZfBuCF
	 zx/vOv1zhhFmyEu/OR4Ljwsuo7ieE19jeZPd9y1KDFpJSpCX3V8diSV4RWoWr8TWJp
	 Z63/i4egayu2iRgchDWWGy2O0hMJsQIELbVPQDPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Dakinevich <jan.dakinevich@salutedevices.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/168] pinctrl/meson: fix typo in PDMs pin name
Date: Tue, 14 May 2024 12:18:29 +0200
Message-ID: <20240514101007.113418461@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Jan Dakinevich <jan.dakinevich@salutedevices.com>

[ Upstream commit 368a90e651faeeb7049a876599cf2b0d74954796 ]

Other pins have _a or _x suffix, but this one doesn't have any. Most
likely this is a typo.

Fixes: dabad1ff8561 ("pinctrl: meson: add pinctrl driver support for Meson-A1 SoC")
Signed-off-by: Jan Dakinevich <jan.dakinevich@salutedevices.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Message-ID: <20240325113058.248022-1-jan.dakinevich@salutedevices.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-meson-a1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/meson/pinctrl-meson-a1.c b/drivers/pinctrl/meson/pinctrl-meson-a1.c
index 79f5d753d7e1a..50a87d9618a8e 100644
--- a/drivers/pinctrl/meson/pinctrl-meson-a1.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-a1.c
@@ -250,7 +250,7 @@ static const unsigned int pdm_dclk_x_pins[]		= { GPIOX_10 };
 static const unsigned int pdm_din2_a_pins[]		= { GPIOA_6 };
 static const unsigned int pdm_din1_a_pins[]		= { GPIOA_7 };
 static const unsigned int pdm_din0_a_pins[]		= { GPIOA_8 };
-static const unsigned int pdm_dclk_pins[]		= { GPIOA_9 };
+static const unsigned int pdm_dclk_a_pins[]		= { GPIOA_9 };
 
 /* gen_clk */
 static const unsigned int gen_clk_x_pins[]		= { GPIOX_7 };
@@ -591,7 +591,7 @@ static struct meson_pmx_group meson_a1_periphs_groups[] = {
 	GROUP(pdm_din2_a,		3),
 	GROUP(pdm_din1_a,		3),
 	GROUP(pdm_din0_a,		3),
-	GROUP(pdm_dclk,			3),
+	GROUP(pdm_dclk_a,		3),
 	GROUP(pwm_c_a,			3),
 	GROUP(pwm_b_a,			3),
 
@@ -755,7 +755,7 @@ static const char * const spi_a_groups[] = {
 
 static const char * const pdm_groups[] = {
 	"pdm_din0_x", "pdm_din1_x", "pdm_din2_x", "pdm_dclk_x", "pdm_din2_a",
-	"pdm_din1_a", "pdm_din0_a", "pdm_dclk",
+	"pdm_din1_a", "pdm_din0_a", "pdm_dclk_a",
 };
 
 static const char * const gen_clk_groups[] = {
-- 
2.43.0



