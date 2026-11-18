Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038644;
	b=qa5i/q7XVdfmiaD3eqymkaiJN/zCMvEPjIoTTMKxOapLEDmsNMUi4owvJ2Gk9ybJbYHu
	 QoqSrYFSupScg58kRWODi//4d7Z9atoga6dRWZFVcFnmDPEI44Xj14W/eCeA3bsK9q1+c
	 QeFgcAqhcQSi8jYdwMOb9GyXWWqH+y1QX9FkJNl2HfkVm5Ixgs+C+1wpc2C8lCFvIQcwG
	 redAkOygridH64TrZBPKE9Tbd3FYvJCIcvtskoj9iOQNG8+tcBFTBVPh+a36Fc+9o/V5v
	 HhCNVXbJKk+XS2455rXyYGTEOcaVu3+tROWy/JhTT20onURdGJv2j1mecJC8I2Zk/XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B+d4+JC6plElbns9r8H7SE7OeGNyW9RRJDzEcFplenM=;
	b=5C3mru3P91XCQSPFXxizYboQRRBLB56Q5pThA3q/zK9ptEcXzt1fKcnIdHoYuDH+NJtM
	 LolHX8ZbhwUQk5oxYvUfDsQBgW0g8zpvs+LyLrN+3cnnnyLMbJNqWqUxM33T4hzcwyF5P
	 d2RdGz8qBuwMYkKRoZ8q0mMFTZblqmRxxyECxecNG/EW+hr6dU6FMHu+k/79kKeQ7wCu/
	 AzloJ7qxcgevZeFfLl2k9DfLQD8IbkeVDVyHEpl6Pz4x7S6XT0l2skyR34fZ5q9UahLPF
	 y35eV64Ijh9fDwVH6lEf0Q4UIZKPLJ76Nl95DMwq87wU5ckxYxkTSl+ysCMWWV6iKbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l2fFlEZQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D275606A325;
	Wed, 18 Nov 2026 21:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l2fFlEZQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D681F000C4;
	Wed, 18 Nov 2026 21:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038643;
	bh=B+d4+JC6plElbns9r8H7SE7OeGNyW9RRJDzEcFplenM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2fFlEZQBr64IPOiAml1VG6rwLTweMKyCtCKVar/DCLEuuV3z46R17llU1oM2u1+/
	 geWVa4RqFdAxUcuxdBatb14IPvGat4sIA3UHxX0cbzYXgAzzf2O2keNO0YPS4MUKDl
	 1U+aVhIgnOie1otQceDIpbDcHQDDwTkyqxu8PAII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Huang <ychuang570808@gmail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1815/3318] clk: nuvoton: ma35d1: Add missing WDT/WWDT parent clocks
Date: Wed, 18 Nov 2026 15:40:37 +0100
Message-ID: <20261118150416.307754612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



