Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF1D168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C59C433EF;
	Mon,  8 May 2023 10:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540942;
	bh=jFohSHbQ90/0FsrPv3Uz84Ua7EONv3eJb+p8ynrSSB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frVlY4/ZkPcBcymYGnC92uz4QK9va3hEXoyPVdsXLLuhBSqLuLYwZfpUlAsHyv9t3
	 Q/WW7hgyN7zK8vxeOV3BO6Y7KanMhOVvF+7yhxLI/VQfBvURD5hqZMdnKELPGqUwuZ
	 wbDpw/7z/QwURqb4+HYVicdiGRlMpptkSJmxEcD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hai Pham <hai.pham.ud@renesas.com>,
	LUU HOAI <hoai.luu.ub@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 525/611] pinctrl: renesas: r8a779a0: Remove incorrect AVB[01] pinmux configuration
Date: Mon,  8 May 2023 11:46:07 +0200
Message-Id: <20230508094439.074458958@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hai Pham <hai.pham.ud@renesas.com>

[ Upstream commit a145c9a8674ac8fbfa1595276e1b6cbfc5139038 ]

AVB[01]_{MAGIC,MDC,MDIO,TXCREFCLK} are registered as both
PINMUX_SINGLE(fn) and PINMUX_IPSR_GPSR(fn) in the pinmux_data array.

The latter are correct, hence remove the former.
Without this fix, the Ethernet PHY is not operational on the MDIO bus.

Signed-off-by: Hai Pham <hai.pham.ud@renesas.com>
Signed-off-by: LUU HOAI <hoai.luu.ub@renesas.com>
Fixes: 741a7370fc3b8b54 ("pinctrl: renesas: Initial R8A779A0 (V3U) PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/6fd217b71e83ba9a8157513ed671a1fa218b23b6.1674824958.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pfc-r8a779a0.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/pinctrl/renesas/pfc-r8a779a0.c b/drivers/pinctrl/renesas/pfc-r8a779a0.c
index 760c83a8740bd..6069869353bb4 100644
--- a/drivers/pinctrl/renesas/pfc-r8a779a0.c
+++ b/drivers/pinctrl/renesas/pfc-r8a779a0.c
@@ -696,16 +696,8 @@ static const u16 pinmux_data[] = {
 	PINMUX_SINGLE(PCIE0_CLKREQ_N),
 
 	PINMUX_SINGLE(AVB0_PHY_INT),
-	PINMUX_SINGLE(AVB0_MAGIC),
-	PINMUX_SINGLE(AVB0_MDC),
-	PINMUX_SINGLE(AVB0_MDIO),
-	PINMUX_SINGLE(AVB0_TXCREFCLK),
 
 	PINMUX_SINGLE(AVB1_PHY_INT),
-	PINMUX_SINGLE(AVB1_MAGIC),
-	PINMUX_SINGLE(AVB1_MDC),
-	PINMUX_SINGLE(AVB1_MDIO),
-	PINMUX_SINGLE(AVB1_TXCREFCLK),
 
 	PINMUX_SINGLE(AVB2_AVTP_PPS),
 	PINMUX_SINGLE(AVB2_AVTP_CAPTURE),
-- 
2.39.2



