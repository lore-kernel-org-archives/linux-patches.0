Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033011;
	b=yZKeWYavVcjEyXCT1RUv1hlWs/kCGo0mPG8UnmRNsQNY7nKA3eBnkF0K+CWczm6OLzs5
	 GRyvqstbGX5ArYk1UmpyKtpXqsb4xt1iOF5UOeipEgKj081PfAi4bPkJKJE58BbAA+d1k
	 VG94dkQ4xzZetibPh2Kc01cL6/lmih1+xBHUiER1M9cDXX3kHzJeqibjbTfIrc3EWT58u
	 lHHnhNu82FarLVxJ69FZbIOAn9mjbL/gzxpXTsaZjl8Oxca+Z2OWgIYACt9+325u24u4k
	 /J9cWKquqB4Dzq9F00Sk1odhIrEx2AW8iWcuEIp8hkSohFBZPGKawQME+FbNd89Qzxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VNxvvP4QKrti2em66B3zefMSxV418OJwRMCu2S8VMO0=;
	b=frct/KW4CkjT49/2FKw1S7ncEdiyo66BhzHZfuwVsSRsI9n7VGGTWkkA2AotXVx7ThMW
	 xSkzPzhYc8mcincx89RWZ0hpHr4uNfwWFHERCj13lGmqUGI3b481qN1hK0OwGKu5sgud6
	 /g0kK7p5uAxOOdrHI4Q3nh7TU+36SQc6eafEWuSobmyL5FGZtexgEedHhKOkIoGxNrZG9
	 x+djZ9VGK3UCe7cMaZrZszrUfbYBuFST332IpBGJLa5Pyo/iFz+3DEvGNTyX2K1b4rwe9
	 X4LtF7sgt15qBkZBj+TzdcLExzAxR6d+iMc8t9eb7dqTGXgflTka/1m4HVhXSQ/K25w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T3/Lq4Cj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A13606A325;
	Wed, 18 Nov 2026 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3/Lq4Cj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122661F000C4;
	Wed, 18 Nov 2026 20:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033011;
	bh=VNxvvP4QKrti2em66B3zefMSxV418OJwRMCu2S8VMO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3/Lq4Cjk7gpdmpz1JuEKBBfRZrakyyZKpf1zFeenS97JiVOHKTpOZqfik4CwqAjC
	 n9YNnKIkdYM9dtm7jhwuUTyAGPIFkQ9oNheV8bzF6LejwhIXfCMvwuZK7xN3Kd0zsQ
	 kqoTESWjTSSEgM9PyUtkKyW3vMQkU5HByMDT/CfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1617/1756] net: dsa: mv88e6xxx: fix 6351 family statistics snapshot
Date: Wed, 18 Nov 2026 16:02:24 +0100
Message-ID: <20261118150114.213144216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 63d40a40ad0c1..29dc1ecb5eebd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4613,7 +4613,7 @@ static const struct mv88e6xxx_ops mv88e6171_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -4715,7 +4715,7 @@ static const struct mv88e6xxx_ops mv88e6175_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -5375,7 +5375,7 @@ static const struct mv88e6xxx_ops mv88e6350_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_get_cmode = mv88e6352_port_get_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
-	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_snapshot = mv88e6xxx_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
 	.stats_get_sset_count = mv88e6095_stats_get_sset_count,
 	.stats_get_strings = mv88e6095_stats_get_strings,
@@ -5421,7 +5421,7 @@ static const struct mv88e6xxx_ops mv88e6351_ops = {
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



