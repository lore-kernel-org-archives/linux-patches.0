Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994B32FDC5E;
	Sat, 30 May 2026 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161956; cv=none; b=lWZpDHcMxBxRUhCfhCEkOZokG/J248myNy0hkel300vWh7uglJ5UUY18IFlL6hZCpEIMf8+Sx2wi8TWqviPy2+F8ueZOun76QVcMb0iZMUlLikH0s9mneIfZxrwDBJ7Q09mUFYEWYKgmM8lZRUydmAY7VDmX7+O8ztPVlgHGvJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161956; c=relaxed/simple;
	bh=UqgtPq7GKjmE4sG5zDlqNL1gLWpT4PvI8Gaqq1MDXn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sf5yk6LK5R/CDL9E7SPCwRR3UP2T+Memiwc27GyrHHQ7N/2nEy/B/vGd27lqgZYqU1Yv4Y0UwgAi7JnM86x0QuR6aA/nXF4ApPgR0PWbsZFK98rOEtT/x1GyQRDELfXVYGDUZtmsAcEKbg0IeVjo5iCZyoPBCmRI55hZwLe62gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROtGY4oW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROtGY4oW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36C11F00893;
	Sat, 30 May 2026 17:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161955;
	bh=Ap4upSWFr2GoKF8w4BCly1C6pLLeYsZLemZ0+GriWe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROtGY4oWMcBDxMTEv4wy3+GbTfvS21H+PMzY4uv4jujdEB2yG6QWTWx8WXQV02WQH
	 MBUxhifYXF41az7zbnm7LlkpKjUIz7qA2tx9aoacF4cig00Y3K4z/asD92wldTx81D
	 xqfZFOzxASH0dOo9tt9Z4wAzWSKaeevAvnOIcubg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jones Syue <jonessyue@qnap.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 778/969] bonding: 802.3ad replace MAC_ADDRESS_EQUAL with __agg_has_partner
Date: Sat, 30 May 2026 18:05:02 +0200
Message-ID: <20260530160322.075506835@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jones Syue 薛懷宗 <jonessyue@qnap.com>

[ Upstream commit 4440873f3655325f849366d75382aa05d09b5575 ]

Replace macro MAC_ADDRESS_EQUAL() for null_mac_addr checking with inline
function__agg_has_partner(). When MAC_ADDRESS_EQUAL() is verifiying
aggregator's partner mac addr with null_mac_addr, means that seeing if
aggregator has a valid partner or not. Using __agg_has_partner() makes it
more clear to understand.

In ad_port_selection_logic(), since aggregator->partner_system and
port->partner_oper.system has been compared first as a prerequisite, it is
safe to replace the upcoming MAC_ADDRESS_EQUAL() for null_mac_addr checking
with __agg_has_partner().

Delete null_mac_addr, which is not required anymore in bond_3ad.c, since
all references to it are gone.

Signed-off-by: Jones Syue <jonessyue@qnap.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/SI2PR04MB5097BCA8FF2A2F03D9A5A3EEDC5A2@SI2PR04MB5097.apcprd04.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c4f050ce06c5 ("bonding: 3ad: implement proper RCU rules for port->aggregator")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_3ad.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 37364bbfdbdc4..29e08415b16a6 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -81,10 +81,6 @@ enum ad_link_speed_type {
 #define MAC_ADDRESS_EQUAL(A, B)	\
 	ether_addr_equal_64bits((const u8 *)A, (const u8 *)B)
 
-static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
-	0, 0, 0, 0, 0, 0
-};
-
 static const u16 ad_ticks_per_sec = 1000 / AD_TIMER_INTERVAL;
 static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
 
@@ -1583,7 +1579,7 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 		     (aggregator->partner_system_priority == port->partner_oper.system_priority) &&
 		     (aggregator->partner_oper_aggregator_key == port->partner_oper.key)
 		    ) &&
-		    ((!MAC_ADDRESS_EQUAL(&(port->partner_oper.system), &(null_mac_addr)) && /* partner answers */
+		    ((__agg_has_partner(aggregator) && /* partner answers */
 		      !aggregator->is_individual)  /* but is not individual OR */
 		    )
 		   ) {
@@ -2033,9 +2029,7 @@ static void ad_enable_collecting(struct port *port)
  */
 static void ad_disable_distributing(struct port *port, bool *update_slave_arr)
 {
-	if (port->aggregator &&
-	    !MAC_ADDRESS_EQUAL(&port->aggregator->partner_system,
-			       &(null_mac_addr))) {
+	if (port->aggregator && __agg_has_partner(port->aggregator)) {
 		slave_dbg(port->slave->bond->dev, port->slave->dev,
 			  "Disabling distributing on port %d (LAG %d)\n",
 			  port->actor_port_number,
@@ -2075,9 +2069,7 @@ static void ad_enable_collecting_distributing(struct port *port,
 static void ad_disable_collecting_distributing(struct port *port,
 					       bool *update_slave_arr)
 {
-	if (port->aggregator &&
-	    !MAC_ADDRESS_EQUAL(&(port->aggregator->partner_system),
-			       &(null_mac_addr))) {
+	if (port->aggregator && __agg_has_partner(port->aggregator)) {
 		slave_dbg(port->slave->bond->dev, port->slave->dev,
 			  "Disabling port %d (LAG %d)\n",
 			  port->actor_port_number,
-- 
2.53.0



