Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951F0E547
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09379C433B4;
	Mon, 15 May 2023 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169129;
	bh=N2uQUP7LCCLTzuE+QF/F2yIpam29nxqnru9j4NyT6pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zo2D1fJOC655roqjIWJ2hz8+WkzSv3QuR90rsR1Nxe7X5KlAaDXPist/JvcT8Yh6V
	 ZFSl8nOrp271Mw7YUYe103secOB+MURzYVJkE+W7u5ia2n/x7MZdE0MQR5BOpbmOeh
	 Dn5v7rbiP1iJ/VcjuDlbM/fOC8ARQfU0tDL3H6us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Vivien Didelot <vivien.didelot@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/191] net: dsa: mv88e6xxx: Add missing watchdog ops for 6320 family
Date: Mon, 15 May 2023 18:26:27 +0200
Message-Id: <20230515161712.863249623@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 9c7f37e5ca14f5b04894b1b699a9903885cdafa6 ]

The 6320 family of switches uses the same watchdog registers as the
6390.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6686317855c6 ("net: dsa: mv88e6xxx: add mv88e6321 rsvd2cpu")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6b310f7235801..fddd7e4f3de71 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3601,6 +3601,7 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.stats_get_stats = mv88e6320_stats_get_stats,
 	.set_cpu_port = mv88e6095_g1_set_cpu_port,
 	.set_egress_port = mv88e6095_g1_set_egress_port,
+	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
@@ -3643,6 +3644,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.stats_get_stats = mv88e6320_stats_get_stats,
 	.set_cpu_port = mv88e6095_g1_set_cpu_port,
 	.set_egress_port = mv88e6095_g1_set_egress_port,
+	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.reset = mv88e6352_g1_reset,
 	.vtu_getnext = mv88e6185_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
-- 
2.39.2



