Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028068;
	b=NhNeD6SSa7KhReLaMjjvavQR69bbLE5aTsA7/T03/pApaG2hk4Wrrrwb+VmFqMJfQQ11
	 3yt6WJ9/3tYfjY1/vR1cO1pty/p2p6r0u6OTvlUtAdZf3v7MOyCDTDKOI80L1aUUS80LT
	 eNuodPH8yGdGZ8BY0pHrgl76ABsIiItfCLYJvm2JgYnVuI2vQCBCsxvjMUVF9oWIPyflh
	 0ap3T8OZRi5Nu2p3q2G9zeWgYs94BcDueaKEn182961qxJuMykChuqKdp5qtxsc8Q2SpK
	 HAcNMO/Evjrc8d5MmmSpzeao5eQ0xUwtmD01htIhWrh0GOXKna8DYRkAp2LKxYZi3Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yoax6ayKjmkWJlR1mmN3w41mRiF/pdbOwPjwMqg/+/0=;
	b=YGkLB2xPmJRdO3/9iJ12m+VoCXZAh2kkMosmIwWptBBP4eCDJQ8JEh820UiHFs/HPDHG
	 WS9vJoTnDBQbXNrwLjgxI13xqtLenpqPN4q41pgeAiQ39rsi4/Kp1/qc1b5phhKa0cM13
	 Fk1RiMqxkghB99QSRo/6Hmvx4ooY5wHKr6JWIkU/hWO3MQNSPab28UC+8RKrTAXWzL3EW
	 Z5G7UWcIkdw1nRSkVpEm4tVk3Mvk6A7vz8E/oUM99sRB8Y2v78gQCWll7NXUNCJMKh4UF
	 hNB8kFBCAfZ8DULaxS+LDUGDVVWpytbpfWwpgVvfdFDudv+xdXbUk3w6P1XWA0BUAaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nb1E8mro;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA24606A31C;
	Wed, 18 Nov 2026 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nb1E8mro
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533041F000C4;
	Wed, 18 Nov 2026 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028067;
	bh=yoax6ayKjmkWJlR1mmN3w41mRiF/pdbOwPjwMqg/+/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nb1E8mrowd7zirew/v/I1+hJkHiKXxjGfAOKAGUqKy2Hqpx7LCqVktJfpyQj8c9iW
	 g3TCzG5t1xz3q3uwmb4Fdl0UpmrFbFm1vN4GocJ9L5o9byk480bOUPesK+KRp2xcdK
	 owY0ob1ftnLLdHFMDjQ9o0sNA2exta5Bk+QnlStA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2014/2151] net: dsa: mv88e6xxx: fix 88E6171 statistics type
Date: Wed, 18 Nov 2026 16:02:29 +0100
Message-ID: <20261118150235.089195918@linuxfoundation.org>
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
index 92f291bb183ce..b6f46e8698b2f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5922,7 +5922,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
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



