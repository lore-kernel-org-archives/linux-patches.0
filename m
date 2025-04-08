Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A592D2690EB;
	Tue,  8 Apr 2025 12:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116445; cv=none; b=Buc03NSPfxCqtbuwD12kP3JeHkS4YFJYlBDxZhdvXmwXLTQEo34i1EPNEIC/oVCyhoTVhl+9sp1CkI5MIJKqWOiVASCCssA4jAxqhQt0zGeQPJkpwlrwZP5Sj77kLgEbK5S+zvqDPuBVLaxHjpCtREBIvSHmK6TMdtEQP1yigxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116445; c=relaxed/simple;
	bh=1MIMfGdD3CqNQvCNJzOkt+XNPU9IaqgU3IfHPPiZUmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVx3TnP+2qzRu9R3iKV12R0I+WptLLQ8p9LBkejhKlhpbUd8ukT6D6JX+5HWOnEdEkRMkJ7gLSn+MQ2lAWighE4FmwT4OZod1ef3Y1Bo5MxtUw8dm/3YFVplKAK5yuxkvqp+JBUkAz0t/A2K7LLAaCG5xuDO5JsMZ/jzYAQQlsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYXrLCeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYXrLCeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA74C4CEE5;
	Tue,  8 Apr 2025 12:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116445;
	bh=1MIMfGdD3CqNQvCNJzOkt+XNPU9IaqgU3IfHPPiZUmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYXrLCeJmc9mFaeUGlVz0F6PWQO9nGo1g8/4xwag2HmFTmDD12R3BJB4mXO41RytH
	 7OzZFbHVC2HcxFnh8XoUay/YR7e2EPVF95103EcoJlExLjYAS6iiQ5Z8eu7dW48zHy
	 6kajAaARbmAKhcJcxUL7XiNjGtaw8eOiAgOQWmPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/423] pinctrl: npcm8xx: Fix incorrect struct npcm8xx_pincfg assignment
Date: Tue,  8 Apr 2025 12:47:50 +0200
Message-ID: <20250408104849.086659495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 113ec87b0f26a17b02c58aa2714a9b8f1020eed9 ]

Sparse is not happy about implementation of the NPCM8XX_PINCFG()

 pinctrl-npcm8xx.c:1314:9: warning: obsolete array initializer, use C99 syntax
 pinctrl-npcm8xx.c:1315:9: warning: obsolete array initializer, use C99 syntax
 ...
 pinctrl-npcm8xx.c:1412:9: warning: obsolete array initializer, use C99 syntax
 pinctrl-npcm8xx.c:1413:9: warning: too many warnings

which uses index-based assignment in a wrong way, i.e. it missed
the equal sign and hence the index is simply ignored, while the
entries are indexed naturally. This is not a problem as the pin
numbering repeats the natural order, but it might be in case of
shuffling the entries. Fix this by adding missed equal sign and
reformat a bit for better readability.

Fixes: acf4884a5717 ("pinctrl: nuvoton: add NPCM8XX pinctrl and GPIO driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/20250318105932.2090926-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index 17825bbe14213..f6a1e684a3864 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -1290,12 +1290,14 @@ static struct npcm8xx_func npcm8xx_funcs[] = {
 };
 
 #define NPCM8XX_PINCFG(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q) \
-	[a] { .fn0 = fn_ ## b, .reg0 = NPCM8XX_GCR_ ## c, .bit0 = d, \
+	[a] = {								  \
+			.flag = q,					  \
+			.fn0 = fn_ ## b, .reg0 = NPCM8XX_GCR_ ## c, .bit0 = d, \
 			.fn1 = fn_ ## e, .reg1 = NPCM8XX_GCR_ ## f, .bit1 = g, \
 			.fn2 = fn_ ## h, .reg2 = NPCM8XX_GCR_ ## i, .bit2 = j, \
 			.fn3 = fn_ ## k, .reg3 = NPCM8XX_GCR_ ## l, .bit3 = m, \
 			.fn4 = fn_ ## n, .reg4 = NPCM8XX_GCR_ ## o, .bit4 = p, \
-			.flag = q }
+	}
 
 /* Drive strength controlled by NPCM8XX_GP_N_ODSC */
 #define DRIVE_STRENGTH_LO_SHIFT		8
-- 
2.39.5



