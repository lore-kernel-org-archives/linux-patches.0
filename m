Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022012;
	b=fOJJ5r9qweMjjLyd1bFKa9C0hlf9HS5CnNIItaAVO63jIDwxx4yw4FWCidGFWel6hpuM
	 jujScB9D+E+sdezuKvOXFwm5UJo8T/X4kmnunqFAe1skcRB1Z/TpALygwvK5nG6MAh3fM
	 KaJrMzNlB/zoXg3z2gjTjUbOgSOyClLRo6CIciUOYwJohtZsPFSLgKLCsn6LmE3WYXXSa
	 lcHLEL7j/qwY+lbmkSfhC6s4Lv7rh38fvt08WjJ+M8sxPmhXoCoW9tB7tgOzfiikaRi/b
	 iOOiyOpcpnOeEiTbD7aFG8HK4qSmi9BaDdm1WemFJHHD+WjCNaVvE2egpxOX4aG2W/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M8m08qFoEwTHZYx3O79RkrP0QnY+vHq8lPMkWzmF2n4=;
	b=a0G9gh6o3pRU1CNCahirujhhDDyYvIVMdi6wIEm/maVo2CmucixErLTKMqpkBZ/OJQjE
	 5kE2dFSeZoePtomax/dmaQXwXVZPP+RFfucbMOzGsfjM+BzAWGzV9kBvaUxi9bw9EULjr
	 9E7Tbv/C17kn4GeHj0+qrMSUkXhsuHb0wbWg83pDs5Jd6wT20nbFSyeTLE0Ulf9xetn22
	 MtNgohGDT2riKqyLrZUOcp9Xd/BHPL7n5SBRxbiGtjeSEiTFQvD2m/rh20npmQ/VTgBUp
	 jTwE748NQWUwCdcDKOBy3gZuVR3GZ+08FZsKEx1oJgbEQkAJsNV1G7EbfS65tmaDOFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2DLhzayX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A633F606A320;
	Wed, 18 Nov 2026 17:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2DLhzayX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91BC1F000C4;
	Wed, 18 Nov 2026 17:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022012;
	bh=M8m08qFoEwTHZYx3O79RkrP0QnY+vHq8lPMkWzmF2n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2DLhzayXDKBvsxxRJWiUIcw08JtgEm//LFGONyu9t49OtBnyVHqEAawMifK49W65c
	 c3zufGvH830c9L/UvBCJc2yiuOOD87jGiHpg5q+KXx3BZDZUiJxcqOaW0KN3gnKiwT
	 OAjl54Q7V56kgbMph4WwdKKZpsUH9VlnQljXPbx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2511/2651] net: dsa: mv88e6xxx: fix 88E6171 statistics type
Date: Wed, 18 Nov 2026 16:02:31 +0100
Message-ID: <20261118150415.140388826@linuxfoundation.org>
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

[ Upstream commit df66431f39426b685f6693f0731cd5881c51679c ]

The 88E6171 uses the 6095 statistics operations, which advertise and name
BANK0 and PORT counters. Its stats_type bitmap instead selects BANK0 and
BANK1. Since statistics collection started using that bitmap, it has
written a different set of counters from the one advertised to ethtool.

For this chip, get_sset_count() accounts for 30 BANK0 counters, three
PORT counters and five ATU/VTU counters. Collection instead writes 30
BANK0 counters, 26 BANK1 counters and five ATU/VTU counters: 61 entries
rather than the advertised 38. This mislabels the tail of the returned
statistics and writes past the advertised statistics buffer.

Select BANK0 and PORT counters to match the chip's statistics operations
and restore the filter used before the bitmap was introduced. Tested on
an EA4500, where the two-bridge forwarding and multicast snooping tests
now pass their hardware counter checks.

Fixes: 5595e3613ea7 ("dsa: mv88e6xxx: Move available stats into info structure")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://patch.msgid.link/20261026164733.737299-3-f.fainelli@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 50ce7b7828995..e647e36dea393 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6022,7 +6022,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.age_time_coeff = 15000,
 		.g1_irqs = 9,
 		.g2_irqs = 10,
-		.stats_type = STATS_TYPE_BANK0 | STATS_TYPE_BANK1,
+		.stats_type = STATS_TYPE_BANK0 | STATS_TYPE_PORT,
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-- 
2.53.0



