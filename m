Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D350429803;
	Wed, 20 May 2026 18:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302859; cv=none; b=aaDzlybJC+hUhEmtkdC10hp3IV29tOwZGxWNBrQy87hXHuKYdSvjgHQ1XcwcboqFhQBR4MLbFWQEl9RkbYMRNA6c1PoyP9W30ShIGT90STDjwV3bRGYPEmMW2IBHrxT0HSlTWDA6mS4IZA3w94R2k+H8LxmbZoWzJyBLM0YRwew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302859; c=relaxed/simple;
	bh=rS7lufg/+qBrYOfxXcOZNJR/XaI90QAhmdiX6hHWZMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcOvNHmausbinsmatU+do4ogUQ97ba4pPQYff5NasRNky+IsusRBRj/zOHFwdYY0SoBEhXMbXeIOMu59PJregpkfw7wVFGVELCpOARRNyuzK++ajFWddm0KJedQNkmgA8324w/HwS7C2fKwNS38Ii4PbBUg6g6eHVSpL9ZzutQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPt84cS0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPt84cS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432BC1F000E9;
	Wed, 20 May 2026 18:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302856;
	bh=3MUzXSR4jA5c9DYRDoG8y9NeV8+spAIfsdCpA0KLcVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPt84cS0q90js423P8lFKuOpANq9a47oUowagufz1vu6TdPhN5CeHw8v+BwqlgU62
	 hHqoq3OXlNHquFXZX1pl9MqNqSaeIm/8KacZsJCK4uum/cskpvV47V8SLsOOXtqa71
	 8hVLugs+eVa0uWDqGmMI+h7hD334gbjqiqGxqjSg=
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
Subject: [PATCH 6.6 425/508] bonding: 802.3ad replace MAC_ADDRESS_EQUAL with __agg_has_partner
Date: Wed, 20 May 2026 18:24:08 +0200
Message-ID: <20260520162107.811205872@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d02a91cefec89..4c2560ae8866a 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -82,10 +82,6 @@ enum ad_link_speed_type {
 #define MAC_ADDRESS_EQUAL(A, B)	\
 	ether_addr_equal_64bits((const u8 *)A, (const u8 *)B)
 
-static const u8 null_mac_addr[ETH_ALEN + 2] __long_aligned = {
-	0, 0, 0, 0, 0, 0
-};
-
 static const u16 ad_ticks_per_sec = 1000 / AD_TIMER_INTERVAL;
 static const int ad_delta_in_ticks = (AD_TIMER_INTERVAL * HZ) / 1000;
 
@@ -1592,7 +1588,7 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 		     (aggregator->partner_system_priority == port->partner_oper.system_priority) &&
 		     (aggregator->partner_oper_aggregator_key == port->partner_oper.key)
 		    ) &&
-		    ((!MAC_ADDRESS_EQUAL(&(port->partner_oper.system), &(null_mac_addr)) && /* partner answers */
+		    ((__agg_has_partner(aggregator) && /* partner answers */
 		      !aggregator->is_individual)  /* but is not individual OR */
 		    )
 		   ) {
@@ -2042,9 +2038,7 @@ static void ad_enable_collecting(struct port *port)
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
@@ -2084,9 +2078,7 @@ static void ad_enable_collecting_distributing(struct port *port,
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



