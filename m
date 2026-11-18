Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022007;
	b=rbOAziPsBIWKiZ8mFy0gKpht+/HF/XR3bzsfxWfGPoormrOv2hwTKrvaDapAYjaKrgZK
	 fRxBfvd17jf6+9/ukh30WkPL3iC5K/Kk43elpI0PZQy33Bv+CZ+K6A+tP9VwG8jpOnSHE
	 51MpTKEQb+z3bm4qC5wuOdLy/x9Q1UggQfRRL1PxtPkmGliZmm3wsRrdT1DMeSE+pFg2u
	 rmK6awCjh6krsn7Qn1zs0UQFtVjmjlCYuMzXIkhpiX+rJA5QfUi6T0qHP/W4aVCwd3gDx
	 wNm8KWaVa/QQJ6nkaMGK9IL9Yobfx2NeugbuC6cczZ1o/DeXF/R0liOEiw3FI5fwgdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2SULwx7DsI6AdH7ZS/LZVsgv2dIWKn9kjOHC7kukL/k=;
	b=0pVxMDJgrlCM+K/pZCDMtSrUEBryFEMSO2Y6bXWPOEDvtKyVEf5+3MrUrVR0m66qAxci
	 yUgXiIMl5fmoi4tZ4FR/N3inHwfvUQXi98Qzjpz8oGjnos6aF2BnKSK0JYuYkh7MqlPBg
	 LE3u7WN6qZbAJYrTCf+V4E5rLQ/kPfehvep3d3Yxmc+cmMDHoEJ7sQZ3xSOXsdrftob2R
	 rHWjJYCKOo9WPRnIAf56ceyal1Coev6aGrYURT3tGZjJGprnAUktk0yyj7qCMkZs4pYuz
	 6+jAOeDhpsbEdGGuxB9WWQYCtXfZXVL2UvH85V5iVHjDmkLDSp1NpNvnncuzcl5PcFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T8D2KSlD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA462606A31C;
	Wed, 18 Nov 2026 17:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T8D2KSlD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040DA1F000C4;
	Wed, 18 Nov 2026 17:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022006;
	bh=2SULwx7DsI6AdH7ZS/LZVsgv2dIWKn9kjOHC7kukL/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8D2KSlDULTNqlt+9Ankhoz6Hsp1WndntdG4cK8/gIWYAs5mmkQYvA+yKdnGmHO54
	 7mBDId+/psKRFcP3oHgA18RcZg9x6SOBYobpEuOpbFsua2+K64yA39zXOFXDej47aB
	 BxZ6fgOBy2skxS6fqrzPbMGtsaBEhhwG47O1jHMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2510/2651] net: dsa: mv88e6xxx: fix 6351 family statistics snapshot
Date: Wed, 18 Nov 2026 16:02:30 +0100
Message-ID: <20261118150415.111597220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a4a8c7e11bf4f..50ce7b7828995 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4610,7 +4610,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -4714,7 +4714,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -5380,7 +5380,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -5426,7 +5426,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
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



