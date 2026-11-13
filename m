Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585935;
	b=qpdENloeVvtKeFWhmQxCrUO3U25xA4c3quKnkNYhHvg4Mbzew9I1qC7v/mmu72O7ShCs
	 IVTYVW4sw4CnUN66jeP5NEIPv6ng6cg/54Zxeh2r3M3VKz6PDfHPDg8M67LYcVdq5OTAc
	 hbUsv9fR6/UjHuOp94ZFN+EzAodbZZ/az7M4D7fWUAybqt2E+ADZJyyoFBXAqN92xbXI7
	 WHRlQSaHn70+CDM3AbHMANpHVuLnlIxPLSQ0R/fsE6jxefP9+VQeRxhU0zlZK/HLpTDJH
	 er8rEF4BK54aKSxPp5uxI/MiwQpKzM1wUsGMLOaLv1EBKDZYx4zrdaZ1D87u0PrgT/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZWM/CoovrJPy9bEsgxywkorbHgTNJ+2In1ULSGDx+eA=;
	b=LZXplS+8C0SI5covU1S8JQzskkwVE2xR0cLjAFALs7P9U4+clYdXlvu3OSnj9HKBUMtE
	 TXzIA8AmP0jbqQyE7v6LuDqv6tn4NZhf4dfGZFvFXLuOo+7Ot8sh+VMBseB5o28ko+wX0
	 ukz1gPSEtunka6wodLPP6aP8mFa3wYF8eD3X7SwPBUJp4X5NPAWSwIw+p3zrmm6bLqPgs
	 ri1i6K5A1A1Vx8v0R5x17lWWeV1kQHKjehopcPsHlhveowFPswtjtS8SUk/KJlwz3lOUw
	 /+QB1hd/21FM0e8xsE6bgRhDAGNWfEBlG0lzXO0eMJVjsNQlyGYdN2j6CvvxUGLNHcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEd3RLSd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA6A606A889;
	Fri, 13 Nov 2026 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HEd3RLSd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2551F000C4;
	Fri, 13 Nov 2026 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585935;
	bh=ZWM/CoovrJPy9bEsgxywkorbHgTNJ+2In1ULSGDx+eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEd3RLSdQbSkrc0pc9JijoT0nyRYChi5u2eB1ufhX77lLfnP5Uglws8gqF/mbu6oq
	 gs/M/BVddYen5jw3XT9KsUV5HeV/TMOngc0xpLCU5orqYD+uEUhGsP2W0Qq26GwDSH
	 /ohitcjLouCYTnZ5eeFCV/byYNOfKe3CctGzstXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 492/507] clk: nuvoton: ma35d1: Keep the clock count in the driver
Date: Fri, 13 Nov 2026 10:53:16 -0500
Message-ID: <20261113153813.748860745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 26ec588063d9b6c70773b8729372e2bf6d3ea95a ]

The number of clocks is not a binding since this is a value that can
change. As such, in order to support the missing watchdog clocks and
allow the deprecation and removal of CLK_MAX_IDX from the bindings, we
need to switch to a local definition first.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-1-48937ee6c9bb@bootlin.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Stable-dep-of: 1dc3871ce7ec ("clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/nuvoton/clk-ma35d1.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/nuvoton/clk-ma35d1.c b/drivers/clk/nuvoton/clk-ma35d1.c
index 9f65d0623517a..6aa42a3e1be3b 100644
--- a/drivers/clk/nuvoton/clk-ma35d1.c
+++ b/drivers/clk/nuvoton/clk-ma35d1.c
@@ -17,6 +17,7 @@
 static DEFINE_SPINLOCK(ma35d1_lock);
 
 #define PLL_MAX_NUM		5
+#define	MA35D1_CLK_COUNT	236
 
 /* Clock Control Registers Offset */
 #define REG_CLK_PWRCTL		0x00
@@ -467,12 +468,12 @@ static int ma35d1_clocks_probe(struct platform_device *pdev)
 	int ret;
 
 	ma35d1_hw_data = devm_kzalloc(dev,
-				      struct_size(ma35d1_hw_data, hws, CLK_MAX_IDX),
+				      struct_size(ma35d1_hw_data, hws, MA35D1_CLK_COUNT),
 				      GFP_KERNEL);
 	if (!ma35d1_hw_data)
 		return -ENOMEM;
 
-	ma35d1_hw_data->num = CLK_MAX_IDX;
+	ma35d1_hw_data->num = MA35D1_CLK_COUNT;
 	hws = ma35d1_hw_data->hws;
 
 	clk_base = devm_platform_ioremap_resource(pdev, 0);
-- 
2.53.0



