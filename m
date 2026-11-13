Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590763;
	b=GnD9HIbmxovJ9lI6irINHV5eOUUDwFxZ5Atw0MLUgQTajD5YPywsV3R5i4+BsOAiV9O0
	 KpcO3izgjODC5N0nd/SRwnaSOTXAoF+ojXGLWPEaULA9O1azbnr/1DWC1ULakbiRhLnuP
	 4RADhS2+7Xkq6IwNmhTjGCgRtQGzTxJcA+jPoEr5LSwEIrOAW6btQZUON1SbYJ83Xpk7w
	 wrI8BTSlwmr0N+ZiprNLLjfOXJ2/kMVIewANwXlZ5TKVMnPPskJUNFk1it0fGB4W3zBLa
	 YgBJAN72gFrBujiRfO9zNQXNFRAs0wo1/RhdHucaUgcNOjT/zRh7XnlF3WJn4O9bSUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n0YHYjBa2CtnrQFfA8EQVjX5dU3oS0rkjqmBQlquWBQ=;
	b=mn2460FDRQYcmA2yzZxpoCqghD/x9gF7WCf5zEzI9JLOMb9C7h2z8qFf/GK2VHcUoEpK
	 iGjOvxtwEv21TIWcnk+sessi5rTUZE1C6RwGh4DFbOx1VjOXkki2ELpKiBzRjTQd5H8NM
	 vrURNZzTd6KUhf1m14wBfCld13o99DOptLWo+1wYrd68RwL0M2WQS3zeZ1sDLwHCCr09j
	 DH8Zz+n7lURso7L1iqEW1UqkiXYmYeZunYtRxN6cqOMMneP8KqPQr3a+7o88JgkZb0cDQ
	 mylnUlJ7xKYkLu7tfjTr9Y2Goxcko4wH92YnCTVhFCzYCXpEy/H7se1g6jp/LUWj4OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0o5KgcEK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE52607C34F;
	Fri, 13 Nov 2026 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0o5KgcEK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C571F000C5;
	Fri, 13 Nov 2026 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590763;
	bh=n0YHYjBa2CtnrQFfA8EQVjX5dU3oS0rkjqmBQlquWBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0o5KgcEK2LzbLgtZzPA6o6Jsb9sh/7OG8apolpHlDFfZO172kVEJ1aqVF2IxK1UsI
	 8XoU5ijpA5OcCuELO3rKFuoA1T13tJtqqomFYor75XO9k8QRfHs1HLskWll62/boK+
	 +zSBOMn8/87vcBGK/noccRbOzcpw7f9BRuQSRzGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Huang <ychuang570808@gmail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 663/686] clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks
Date: Fri, 13 Nov 2026 10:53:16 -0500
Message-ID: <20261113153844.177333936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 1dc3871ce7ec819030c22297f8960c61cc42a990 ]

The WDT and WWDT muxes list PCLK3/4096 and PCLK4/4096 among their
possible parents, but the driver never registers the corresponding
clocks, so these parents could never be used.

Add pclk3_div4096 and pclk4_div4096 as fixed factor children of pclk3
and pclk4 and expose them through the clock provider.

Reported-by: Jacky Huang <ychuang570808@gmail.com>
Closes: https://lore.kernel.org/linux-clk/b8a8a65b-e302-4747-bc90-4920fc48795a@gmail.com/
Suggested-by: Jacky Huang <ychuang570808@gmail.com>
Fixes: 691521a367cf ("clk: nuvoton: Add clock driver for ma35d1 clock controller")
Cc: stable@vger.kernel.org
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-5-48937ee6c9bb@bootlin.com
[jbrunet@baylibre.com: removed stale link trailer]
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nuvoton/clk-ma35d1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/nuvoton/clk-ma35d1.c b/drivers/clk/nuvoton/clk-ma35d1.c
index 6aa42a3e1be3b..c914079cee2d4 100644
--- a/drivers/clk/nuvoton/clk-ma35d1.c
+++ b/drivers/clk/nuvoton/clk-ma35d1.c
@@ -17,7 +17,7 @@
 static DEFINE_SPINLOCK(ma35d1_lock);
 
 #define PLL_MAX_NUM		5
-#define	MA35D1_CLK_COUNT	236
+#define	MA35D1_CLK_COUNT	238
 
 /* Clock Control Registers Offset */
 #define REG_CLK_PWRCTL		0x00
@@ -544,6 +544,8 @@ static int ma35d1_clocks_probe(struct platform_device *pdev)
 	hws[HCLK3] = ma35d1_clk_fixed_factor(dev, "hclk3", "sysclk1_mux", 1, 2);
 	hws[PCLK3] = ma35d1_clk_fixed_factor(dev, "pclk3", "sysclk1_mux", 1, 2);
 	hws[PCLK4] = ma35d1_clk_fixed_factor(dev, "pclk4", "sysclk1_mux", 1, 2);
+	hws[PCLK3_DIV4096] = ma35d1_clk_fixed_factor(dev, "pclk3_div4096", "pclk3", 1, 4096);
+	hws[PCLK4_DIV4096] = ma35d1_clk_fixed_factor(dev, "pclk4_div4096", "pclk4", 1, 4096);
 
 	hws[USBPHY0] = ma35d1_clk_fixed("usbphy0", 480000000);
 	hws[USBPHY1] = ma35d1_clk_fixed("usbphy1", 480000000);
-- 
2.53.0



