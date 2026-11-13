Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591599;
	b=cQARSZl85a0rb46yZiKvASX0Jf+gVx80vJyITsnQju4ZSmqT0VhP47MZYri/bluZlFRe
	 jl1woSD4M/u7p8VbIwkA2BTL7LArqmC/5N7Y8TjA18ZfJssDU9o+tvm2Q6xHXbia6vtAc
	 YWelDqi86HeFqrC9uLAsHZ57/Htce1WyySXxV1W4MTtk1l4dsscNZqbZinngiGWNM/+Ho
	 wikEkcIE4la9/XETztU9lq/qlZQA6oMmONx9q1ar111vdAw2OrgGaOv7zeCV9CZyjdKme
	 GwlAUWqy/QyR6lFx86+24PEG1DEVFxu1LAT7gJDG60w6fKCLpGFxq9auiDwdmaHrBbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4xKlbjmKups0nGdj1pWQNbZ3YTflW4gqA4JbmWTsrc4=;
	b=5M8MmUkP9OLrqSrfybGBFxYdzc64yps0baxd8yt0OvsaC8laE0CrlrBup8cMMZBefv8b
	 GDou81a5sFme0mCiQhUqghJYrpDeVNqPVJMW+eKd7IyThYmytlGfRIO/OugIvgDq5t49I
	 blxsb2EMwmgm6ZChgevBXMBOhIv0mqT/bXKHS7o+yj4Cbi+EjR3JP1uFkR3FguzA8RNhO
	 T59cI9XqbZ4Jpj3f+aaF3cdy2szavSbbTLxYaeIckvnfDeuYzwtZ6FthyGZ8/umH9UxdK
	 vkm4lavMFAW2lgyzNqF2DbICc+wipU76g4CDZiNTaoqHQJB7ZJOntfZpBP7L47v9wUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtQtkhcW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4C2606A89C;
	Fri, 13 Nov 2026 17:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtQtkhcW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187351F000C4;
	Fri, 13 Nov 2026 17:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591599;
	bh=4xKlbjmKups0nGdj1pWQNbZ3YTflW4gqA4JbmWTsrc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtQtkhcWAhrglAhd9aEYUOOmuLCyRUzPbZnznNhM1NteuEiZaOs2We8nnZj9iOBpa
	 ezLczK1BrNnkUW/z2FfS/8TLbf0ckHxL0N2ErBEI8bNyCjc4YNsyec/RcU2vvC/MUj
	 RdfT5aQkHKaAiA433cDgbIkcCeziGr5i6VH1IIpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Huang <ychuang570808@gmail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 642/670] clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks
Date: Fri, 13 Nov 2026 10:53:26 -0500
Message-ID: <20261113153833.549582636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



