Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E5C171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE54AC433D2;
	Mon, 22 May 2023 19:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783920;
	bh=g9ROlWpZ8L8k2Z2kaWaVkgb/UVzValWXEtNtFGUGrcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tf5IlYpxw3plVRUPkz8Ccx7aPj3aFTILng6E+y225K3foRBAYCRnoW77RyupO/ZpN
	 lmww8QzriBSOh5sY3KWXohE53xnycfsoEx3n7BjDYspbKDl5s8PhmUvHjW/RIcsvMy
	 4lvlWke33c+FXkKgI0OtXOgcMqC9UJkuhJY8ieFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Piotr Raczynski <piotr.raczynski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/292] net: dsa: rzn1-a5psw: enable management frames for CPU port
Date: Mon, 22 May 2023 20:08:55 +0100
Message-Id: <20230522190410.413668198@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit 9e4b45f20c5aac786c728619e5ee746bffce1798 ]

Currently, management frame were discarded before reaching the CPU port due
to a misconfiguration of the MGMT_CONFIG register. Enable them by setting
the correct value in this register in order to correctly receive management
frame and handle STP.

Fixes: 888cdb892b61 ("net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/rzn1_a5psw.c | 2 +-
 drivers/net/dsa/rzn1_a5psw.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index ed413d555beca..92a3ac78ab1e5 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -673,7 +673,7 @@ static int a5psw_setup(struct dsa_switch *ds)
 	}
 
 	/* Configure management port */
-	reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_DISCARD;
+	reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_ENABLE;
 	a5psw_reg_writel(a5psw, A5PSW_MGMT_CFG, reg);
 
 	/* Set pattern 0 to forward all frame to mgmt port */
diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
index c67abd49c013d..b4fbf453ff741 100644
--- a/drivers/net/dsa/rzn1_a5psw.h
+++ b/drivers/net/dsa/rzn1_a5psw.h
@@ -36,7 +36,7 @@
 #define A5PSW_INPUT_LEARN_BLOCK(p)	BIT(p)
 
 #define A5PSW_MGMT_CFG			0x20
-#define A5PSW_MGMT_CFG_DISCARD		BIT(7)
+#define A5PSW_MGMT_CFG_ENABLE		BIT(6)
 
 #define A5PSW_MODE_CFG			0x24
 #define A5PSW_MODE_STATS_RESET		BIT(31)
-- 
2.39.2



