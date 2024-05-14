Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2862512FB21;
	Tue, 14 May 2024 10:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684245; cv=none; b=ENaxK+pV/RC6lJqUqbaxATCyl2poX1f7az0gvMt3cYLg7h5iRsn+ZNmvVSiBgUrwW4pGqTbOVsq9YVHdhGAo1LCFYKqoB0PZppj34enulfNHBMUAFJy6oxsQjC+nmxci9zlT1VuwFdXibwJKIJQD08Eisj9Tg0Wh+cdieCD5c6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684245; c=relaxed/simple;
	bh=LLqIEYpPf4gsgNOqQfl63N8RsBuB//dSQ+DuRztV/Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGVgu+ixl1m2JZhwTXpn5N9FrM5tLZ5I3cvybv1HjpBHx55pHJgLI4nqVM1dNbGEro2IXqxkZQe+I4vgv29+I+V3y2C7U+8PyDXXHN/3fmCwikfT3+dxadIgGGGpPvJKCnC2rsaiqb2IrNXSo6kj7JtIMWKGA4xSCaxL+mIfECg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMS9a3GM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMS9a3GM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7BDC2BD10;
	Tue, 14 May 2024 10:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684245;
	bh=LLqIEYpPf4gsgNOqQfl63N8RsBuB//dSQ+DuRztV/Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMS9a3GMXsaSE6OaZCL4ZGM/GyETrR5cXZ2fqk7U8f/BrTEpVCVL6GYVG5JN8iIMw
	 2y0E8eEYdKbPrxAatuXOKsxGmZW3vhjUceeyH28U3zpfrba57JFb3pFiDAuZf1I0/a
	 IuhqdbUYwa/FoetjUIINrABlPsWe6UpzOxQaTIL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/301] pinctrl: pinctrl-aspeed-g6: Fix register offset for pinconf of GPIOR-T
Date: Tue, 14 May 2024 12:14:43 +0200
Message-ID: <20240514101032.697757585@linuxfoundation.org>
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

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit c10cd03d69403fa0f00be8631bd4cb4690440ebd ]

The register offset to disable the internal pull-down of GPIOR~T is 0x630
instead of 0x620, as specified in the Ast2600 datasheet v15
The datasheet can download from the official Aspeed website.

Fixes: 15711ba6ff19 ("pinctrl: aspeed-g6: Add AST2600 pinconf support")
Reported-by: Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Message-ID: <20240313092809.2596644-1-billy_tsai@aspeedtech.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c | 34 +++++++++++-----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c b/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
index 80838dc54b3ab..7938741136a2c 100644
--- a/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
+++ b/drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c
@@ -43,7 +43,7 @@
 #define SCU614		0x614 /* Disable GPIO Internal Pull-Down #1 */
 #define SCU618		0x618 /* Disable GPIO Internal Pull-Down #2 */
 #define SCU61C		0x61c /* Disable GPIO Internal Pull-Down #3 */
-#define SCU620		0x620 /* Disable GPIO Internal Pull-Down #4 */
+#define SCU630		0x630 /* Disable GPIO Internal Pull-Down #4 */
 #define SCU634		0x634 /* Disable GPIO Internal Pull-Down #5 */
 #define SCU638		0x638 /* Disable GPIO Internal Pull-Down #6 */
 #define SCU690		0x690 /* Multi-function Pin Control #24 */
@@ -2494,38 +2494,38 @@ static struct aspeed_pin_config aspeed_g6_configs[] = {
 	ASPEED_PULL_DOWN_PINCONF(D14, SCU61C, 0),
 
 	/* GPIOS7 */
-	ASPEED_PULL_DOWN_PINCONF(T24, SCU620, 23),
+	ASPEED_PULL_DOWN_PINCONF(T24, SCU630, 23),
 	/* GPIOS6 */
-	ASPEED_PULL_DOWN_PINCONF(P23, SCU620, 22),
+	ASPEED_PULL_DOWN_PINCONF(P23, SCU630, 22),
 	/* GPIOS5 */
-	ASPEED_PULL_DOWN_PINCONF(P24, SCU620, 21),
+	ASPEED_PULL_DOWN_PINCONF(P24, SCU630, 21),
 	/* GPIOS4 */
-	ASPEED_PULL_DOWN_PINCONF(R26, SCU620, 20),
+	ASPEED_PULL_DOWN_PINCONF(R26, SCU630, 20),
 	/* GPIOS3*/
-	ASPEED_PULL_DOWN_PINCONF(R24, SCU620, 19),
+	ASPEED_PULL_DOWN_PINCONF(R24, SCU630, 19),
 	/* GPIOS2 */
-	ASPEED_PULL_DOWN_PINCONF(T26, SCU620, 18),
+	ASPEED_PULL_DOWN_PINCONF(T26, SCU630, 18),
 	/* GPIOS1 */
-	ASPEED_PULL_DOWN_PINCONF(T25, SCU620, 17),
+	ASPEED_PULL_DOWN_PINCONF(T25, SCU630, 17),
 	/* GPIOS0 */
-	ASPEED_PULL_DOWN_PINCONF(R23, SCU620, 16),
+	ASPEED_PULL_DOWN_PINCONF(R23, SCU630, 16),
 
 	/* GPIOR7 */
-	ASPEED_PULL_DOWN_PINCONF(U26, SCU620, 15),
+	ASPEED_PULL_DOWN_PINCONF(U26, SCU630, 15),
 	/* GPIOR6 */
-	ASPEED_PULL_DOWN_PINCONF(W26, SCU620, 14),
+	ASPEED_PULL_DOWN_PINCONF(W26, SCU630, 14),
 	/* GPIOR5 */
-	ASPEED_PULL_DOWN_PINCONF(T23, SCU620, 13),
+	ASPEED_PULL_DOWN_PINCONF(T23, SCU630, 13),
 	/* GPIOR4 */
-	ASPEED_PULL_DOWN_PINCONF(U25, SCU620, 12),
+	ASPEED_PULL_DOWN_PINCONF(U25, SCU630, 12),
 	/* GPIOR3*/
-	ASPEED_PULL_DOWN_PINCONF(V26, SCU620, 11),
+	ASPEED_PULL_DOWN_PINCONF(V26, SCU630, 11),
 	/* GPIOR2 */
-	ASPEED_PULL_DOWN_PINCONF(V24, SCU620, 10),
+	ASPEED_PULL_DOWN_PINCONF(V24, SCU630, 10),
 	/* GPIOR1 */
-	ASPEED_PULL_DOWN_PINCONF(U24, SCU620, 9),
+	ASPEED_PULL_DOWN_PINCONF(U24, SCU630, 9),
 	/* GPIOR0 */
-	ASPEED_PULL_DOWN_PINCONF(V25, SCU620, 8),
+	ASPEED_PULL_DOWN_PINCONF(V25, SCU630, 8),
 
 	/* GPIOX7 */
 	ASPEED_PULL_DOWN_PINCONF(AB10, SCU634, 31),
-- 
2.43.0



