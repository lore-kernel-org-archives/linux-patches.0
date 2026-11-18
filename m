Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062113;
	b=TpY84pmesFcPD+b7JyGaFvdP5j9iB36jv3NiocvyxlAxWSdqSmPoHduzOqSzyd9ho0nH
	 4fNnoNVQzHa739u7dWtCPunjWjQ8iw3UjJxJVNxTeq4/tZzDKqnzpRiJqRBC5uhzgpWYk
	 xaQnmI4NUz4dkiVmvt/enLUvDzBE3J0C+hJT1Ai07pLBQMWRsSX+fzTyC1BCH1e4rdIzJ
	 Li04HUVjpaMrWdao4zSFPcfKx3jwfnZfNvSzzMDWqod0v+HgFGLGWYw9xZmhAcih3jn/p
	 Bdxv1/1Tx5KSzKbNUg+WsJkLJ4my7/ni0BFvZw7PL9LrrUdFga1mvV3nGG4wfctn8nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l0OrgGILN3AgIINN/7rGlXlv+9EXt8iy/J/tXhb6Sok=;
	b=IAwfQUMe8Wr6sX0yJgh+ACqyaqEGx7sUyfqme+v5wZFJLjC3140s0CBlo3M3S5ZTs4z4
	 S4vLzR/k5Dgy/v+jz9eur/MsubbXdMCHA45h1CJt0ROCdGpZvXRnuFycBtigsC9YhpsW6
	 4wl3Z1M/5qUTXDyFXhlI+8vQbAF9LoDJWbbQfV+8dt6+DtGOkQPzyzZfoF3A+R96KHmAa
	 b8OQHC85Of90g3Q/u+ZG7879yFKPXqxdTg74Ah6zR5no3cGXm8rBN1N2Prp9dKKsi05V1
	 L/NQtNCL9ERyANVth4jZYF91g98ISIDT5Np37f+P0moe+ksochxI+As3O8zBAvz+jOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAO3WGs6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BCA606A320;
	Thu, 19 Nov 2026 04:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EAO3WGs6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68D91F000C4;
	Thu, 19 Nov 2026 04:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062113;
	bh=l0OrgGILN3AgIINN/7rGlXlv+9EXt8iy/J/tXhb6Sok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAO3WGs6znqWJM0cDncpPIb4W9ajZCSp2ucIVTcKjkdbmUrxSBmhA0bnODFlqK/HJ
	 G14g6EJ9F25Ikx9YbU7wsiErOWKqkUhZ1cwMLRrVDdkDshnPXJLXmF6ivz6mLqr+vx
	 ZFLgt6ZtFn6ToIyYG6lgWU17JArVhFrx3ggygMLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1794/1848] net: dsa: mv88e6xxx: fix 6351 family statistics snapshot
Date: Wed, 18 Nov 2026 16:03:52 +0100
Message-ID: <20261118150034.384862230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1822c8e137c52..0980466ce5f29 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3608,7 +3608,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -3702,7 +3702,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -4315,7 +4315,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -4356,7 +4356,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
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



