Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8497179CD;
	Sat, 30 Dec 2023 12:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTaq7VqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E913C433C8;
	Sat, 30 Dec 2023 12:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938157;
	bh=d8ysfuN2CYMRxFWGR/B7XJYfPJ6Bla0TQp9TzBohOn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTaq7VqQnYK54nZZcZbTCMuYcPkn3idjD5lUk3IP1Wwf4zpON20w0JGgDx9+Osbig
	 okqgXHHRFTlPzD+uYrd4f/Qvx/4T/pp5qaOlYPBxrD7T1xhqkETTIWrP1h/8qPP1ko
	 FU8WibkHlgGvfS1V0sBhV8o2YEKbfkguOEWNpOD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/112] net: mscc: ocelot: fix eMAC TX RMON stats for bucket 256-511 and above
Date: Sat, 30 Dec 2023 11:58:58 +0000
Message-ID: <20231230115807.563830817@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0066219bb0e89..6b95262dad904 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -216,10 +216,10 @@ static void ocelot_port_rmon_stats_cb(struct ocelot *ocelot, int port, void *pri
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
 
 void ocelot_port_get_rmon_stats(struct ocelot *ocelot, int port,
-- 
2.43.0



