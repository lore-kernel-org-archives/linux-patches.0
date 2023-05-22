Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D367171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C5BC433D2;
	Mon, 22 May 2023 19:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783396;
	bh=jaTcnNgO2W/iwfT9gBPiV7sM7E+TJUEztJb6Gac4Zx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twpxfVnr1eSMoSb5N3KTfO9zexV67tDZUWkRfhsoU304LhqWH2oOsobRF6Z8joMYw
	 O7NSlYLEL0CO1c7U+V37faxwoophZBwzw70B06LQdgWVoPtReriFwkPE4QzHX/cdxU
	 R7wlfPvJOtC/dELWqUOaeWfUSD7UG4N7erJotdso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Foster <colin.foster@in-advantage.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/292] net: mscc: ocelot: fix stat counter register values
Date: Mon, 22 May 2023 20:06:19 +0100
Message-Id: <20230522190406.448648346@linuxfoundation.org>
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

From: Colin Foster <colin.foster@in-advantage.com>

[ Upstream commit cdc2e28e214fe9315cdd7e069c1c8e2428f93427 ]

Commit d4c367650704 ("net: mscc: ocelot: keep ocelot_stat_layout by reg
address, not offset") organized the stats counters for Ocelot chips, namely
the VSC7512 and VSC7514. A few of the counter offsets were incorrect, and
were caught by this warning:

WARNING: CPU: 0 PID: 24 at drivers/net/ethernet/mscc/ocelot_stats.c:909
ocelot_stats_init+0x1fc/0x2d8
reg 0x5000078 had address 0x220 but reg 0x5000079 has address 0x214,
bulking broken!

Fix these register offsets.

Fixes: d4c367650704 ("net: mscc: ocelot: keep ocelot_stat_layout by reg address, not offset")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/vsc7514_regs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index 9d2d3e13cacfa..66c4284196143 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -252,15 +252,15 @@ const u32 vsc7514_sys_regmap[] = {
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_4,		0x000218),
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_5,		0x00021c),
 	REG(SYS_COUNT_DROP_YELLOW_PRIO_6,		0x000220),
-	REG(SYS_COUNT_DROP_YELLOW_PRIO_7,		0x000214),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_0,		0x000218),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_1,		0x00021c),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_2,		0x000220),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_3,		0x000224),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_4,		0x000228),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_5,		0x00022c),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_6,		0x000230),
-	REG(SYS_COUNT_DROP_GREEN_PRIO_7,		0x000234),
+	REG(SYS_COUNT_DROP_YELLOW_PRIO_7,		0x000224),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_0,		0x000228),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_1,		0x00022c),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_2,		0x000230),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_3,		0x000234),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_4,		0x000238),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_5,		0x00023c),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_6,		0x000240),
+	REG(SYS_COUNT_DROP_GREEN_PRIO_7,		0x000244),
 	REG(SYS_RESET_CFG,				0x000508),
 	REG(SYS_CMID,					0x00050c),
 	REG(SYS_VLAN_ETYPE_CFG,				0x000510),
-- 
2.39.2



