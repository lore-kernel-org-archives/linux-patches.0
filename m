Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B9B26AC5;
	Tue, 14 May 2024 10:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684249; cv=none; b=tG/ejqUM/FbFONFqE2GyKyT/qq562AexYzg+pq4lggdx4q70OcD1wCwTsJGeVLV1dNvjSsqOIz0HejuBCT68Hxmr+M83RTDX00DBLtiQqx0ovS0ftkwEJK1R3W5UmMnzd5F8hjSLb+dW8SGNo22s4vKNEaFH3CjghgQKxMhCemk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684249; c=relaxed/simple;
	bh=KDMR2Mgc5XU+Mf6r4nI0krjwgvBYWvgC0OmtnW3RCo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5AhVc/VZO14Jc/k9+dI5OXFWWDhKQcE1xPy7uCqr3GLe5ZgXV4yKvL2Xfl4a+aa4PBmNQskfYs0xzd+vgtbU6jtljNjs9k+1BvX9iWO9b+dCq0kTz+4OU6R/+U+UmVmzCJxU8kLZxx3dZRm1ZjowySo+5qdGyhhFwCimU13FYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQjgNKeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQjgNKeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901BAC2BD10;
	Tue, 14 May 2024 10:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684249;
	bh=KDMR2Mgc5XU+Mf6r4nI0krjwgvBYWvgC0OmtnW3RCo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQjgNKeJN8JPoIOKINlHUEUZ8dmur/W7if8V5hywuk8WXlGT1GzlAy0qq18rNrM19
	 YyV0DCHwsImvvhmIGKE6/Y+6b8BKhVsfLYCXCXrzEUOW4GBtjtnsccz2ZRxHrKO0Vb
	 atbhmnW+e/Cfo6Qq4vMQgMnnzpm8XkzKZlqSONZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Dakinevich <jan.dakinevich@salutedevices.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/301] pinctrl/meson: fix typo in PDMs pin name
Date: Tue, 14 May 2024 12:14:44 +0200
Message-ID: <20240514101032.736066490@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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



