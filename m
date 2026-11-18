Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028065;
	b=T8Boh1sPAFp/bHozUvBEjv5vRky8hs4S07cMzqUfxBJK6Wqf6vLnWaBw3KWpJwdSdIje
	 N1fGdUBOYdnenD6dQiTqtzvo8XaJrMnxTs7NrwGL7RFlEmLfwiYIZPUACyt1gC+luvwCj
	 6N2IYaIF1x1j3IbIC508ATinCBjzbJ0DJfAXoWJfXBLgMtFe0CRl1FDqAptixndbV43VF
	 3Z4wEoqA+yuqx9K39sA0WGEqAlFJAO+/sj+z8ixxRyCur+y3yEB8jCEVSYShLUJxBZklw
	 DbPbH4TxT5oNpbW6gRfEsxQXZ+yJyTJe/OjATU57UfFIUnQ0/wSfVjJIJLgX8JInA3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vjPME3fvanON9IWHcByM4HxAuQH/A1ik+6dqdyZlfVA=;
	b=aUe203TPc6xQXJGKPXz5tRCD6nLkNv/4NTM5nCCsLHW+u8BHl2/Y7XofaR6nOm7hanAV
	 1oLEv/jgrfP0vQgRQJTjeXTC4/R6V9O+NoRV6L6YLlI5EwIcwou/QGh9ssBoVu8XQTec0
	 H2SwqAx2qvDt1BQZmQHSgsEgEM6uByD8a3FMuY2He3V4okvv+bv3QJ5jlbRZaBq3tS43Z
	 CCkZsmjJ7PTa5KrhbUDiso7e9Yl+royJ4ukHoTbIiJFZwysBg5bYFaiDAO2+Q7E/Qxt+v
	 jTJyxsDQe+jH6mwAkCPcuU3eZwQn5P4B829FAxeDsrML0jLRuAG/nhLoFs8Eud3vAZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JEXTZZ/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CFF606A333;
	Wed, 18 Nov 2026 18:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JEXTZZ/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4AD1F000C4;
	Wed, 18 Nov 2026 18:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028065;
	bh=vjPME3fvanON9IWHcByM4HxAuQH/A1ik+6dqdyZlfVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEXTZZ/O4vkFqlqfmTh2M9SN2Dx6jvkooGgmuYLEvBpFvTSdx1ULmL5XkKyxRzu1S
	 Q2tiRV3lOmeu3d340v1ipu2E81u1ZTcoWnWgRMtw7BefDlDNkcaq/YmkdiKXQ1XtGK
	 Tq+KRIT/F0VgSjI/h1vn2b7uCr5e1b6iQXtxIk4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2013/2151] net: dsa: mv88e6xxx: fix 6351 family statistics snapshot
Date: Wed, 18 Nov 2026 16:02:28 +0100
Message-ID: <20261118150235.053775596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 9663edfa71e8807890203578dab6db60c6b548c4 ]

The 88E6171, 88E6175, 88E6350 and 88E6351 take the port number in the
low bits of the statistics operation register. The 6320 snapshot helper
instead encodes the port as (port + 1) << 5. On an EA4500 with an
88E6171, this causes ethtool -S to return physical port 0's MIB counters
for every user port. Traffic on other ports does not update their
reported hardware counters.

Before the snapshot operation was moved into the chip operations, only
the 6320 and 6352 families used the shifted encoding. The refactoring
incorrectly assigned that encoding to all four 6351 family chips.

Use the unshifted snapshot helper for the entire 6351 family. This
matches the Marvell DSDT statsCapture() implementation, which uses the
raw port number for chips outside DEV_RMON_PORT_BITS, including these
four chips.

The original 88E6171 change was tested on an EA4500: pings through
different switch ports updated only the corresponding port's hardware
counters. The other three chips have not been hardware tested.

Fixes: a605a0fe7115 ("net: dsa: mv88e6xxx: Abstract stats_snapshot into ops structure")
Link: https://lore.kernel.org/all/404d5f2d-24a5-4edc-897b-b1b3c54a20e1@lunn.ch/
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20261026164733.737299-2-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index e9270c266884c..92f291bb183ce 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4580,7 +4580,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -4683,7 +4683,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -5343,7 +5343,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -5389,7 +5389,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
-- 
2.53.0



