Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9056879EE;
	Sat, 30 Dec 2023 12:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjlaMa+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194AAC433C8;
	Sat, 30 Dec 2023 12:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937738;
	bh=By1T0EH2GjbiqJPiS6jf9M2HlrKfrhxhTRUNnbuIe4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjlaMa+d83GSDDH4UDY/JS8Jmi2Bm8APZD2touZZXpURkLuLp5y8xExjX+Eo523Tz
	 fplmKYvaZgl3hutO3jwFrXuGGTDxX55vNryudz28dcJb6UGC5WBRINnN825W89oUcc
	 tQVvQQ4Fy0NZZigpUO/P4cnlJ3rFpyUwYQW4Gd14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/156] net: mscc: ocelot: fix eMAC TX RMON stats for bucket 256-511 and above
Date: Sat, 30 Dec 2023 11:58:18 +0000
Message-ID: <20231230115813.797051099@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 52eda4641d041667fa059f4855c5f88dcebd8afe ]

There is a typo in the driver due to which we report incorrect TX RMON
counters for the 256-511 octet bucket and all the other buckets larger
than that.

Bug found with the selftest at
https://patchwork.kernel.org/project/netdevbpf/patch/20231211223346.2497157-9-tobias@waldekranz.com/

Fixes: e32036e1ae7b ("net: mscc: ocelot: add support for all sorts of standardized counters present in DSA")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20231214000902.545625-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 5c55197c7327d..f29fa37263dae 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -582,10 +582,10 @@ static void ocelot_port_rmon_stats_cb(struct ocelot *ocelot, int port, void *pri
 	rmon_stats->hist_tx[0] = s[OCELOT_STAT_TX_64];
 	rmon_stats->hist_tx[1] = s[OCELOT_STAT_TX_65_127];
 	rmon_stats->hist_tx[2] = s[OCELOT_STAT_TX_128_255];
-	rmon_stats->hist_tx[3] = s[OCELOT_STAT_TX_128_255];
-	rmon_stats->hist_tx[4] = s[OCELOT_STAT_TX_256_511];
-	rmon_stats->hist_tx[5] = s[OCELOT_STAT_TX_512_1023];
-	rmon_stats->hist_tx[6] = s[OCELOT_STAT_TX_1024_1526];
+	rmon_stats->hist_tx[3] = s[OCELOT_STAT_TX_256_511];
+	rmon_stats->hist_tx[4] = s[OCELOT_STAT_TX_512_1023];
+	rmon_stats->hist_tx[5] = s[OCELOT_STAT_TX_1024_1526];
+	rmon_stats->hist_tx[6] = s[OCELOT_STAT_TX_1527_MAX];
 }
 
 static void ocelot_port_pmac_rmon_stats_cb(struct ocelot *ocelot, int port,
-- 
2.43.0



