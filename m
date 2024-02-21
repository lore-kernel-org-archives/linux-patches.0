Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20EE6A8D6;
	Wed, 21 Feb 2024 13:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522546; cv=none; b=GqRJPk2UBgm5yHVddpDAC15q/AZ7EgKpxuE2DAfhcB0RQzczYnFyPPxpIUPBvOTUh2HX73n3H26O/H3MfXq4/Qlvb+zBsfzt1s0CEv4+tpRjunZfzzPgsCy7w1+IYFL6nHUaHGWzS1a7rXTvf6LAg7rl7AllfFWdsxlSktq1Jnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522546; c=relaxed/simple;
	bh=UDFh7LraWKsbane2TXP49SBG95G88vRTK4THOm+y8X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9pdZeDvBzrahLGXXzx97OE3lBZMfGBRLpGCC17WLGKPnWx0CPYBvP/GZ7zR/g98mLvXpDyu7nqeEl/6gtcrlYh913FWWVgyD7on9ASI2rYovM7MNVh6NN8R/ZZLZHbIpbw8oo4qdw5wvi4NleHy6cC1jDWqMg9AF3mXwgCig1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgydNUuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgydNUuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AE1C433F1;
	Wed, 21 Feb 2024 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522546;
	bh=UDFh7LraWKsbane2TXP49SBG95G88vRTK4THOm+y8X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgydNUuIAQCfTfzwt6YSOUC1uqeQ7UdYv1CpIyfCjugagv/domVaYS10caQsMRT7D
	 BtAPtezTwrzantgw7SJNjnzrVk1T6f5PrwdZPqZLzya9FgJCuuNXpY3SkZL1BXyYBh
	 KzqqTWmC7YuXdViL/O1iThBYqTdb0B4nCWpsf5P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Tobias Waldekranz <tobias@waldekranz.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 193/476] net: dsa: mv88e6xxx: Fix mv88e6352_serdes_get_stats error path
Date: Wed, 21 Feb 2024 14:04:04 +0100
Message-ID: <20240221130015.046820543@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Waldekranz <tobias@waldekranz.com>

[ Upstream commit fc82a08ae795ee6b73fb6b50785f7be248bec7b5 ]

mv88e6xxx_get_stats, which collects stats from various sources,
expects all callees to return the number of stats read. If an error
occurs, 0 should be returned.

Prevent future mishaps of this kind by updating the return type to
reflect this contract.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.h   | 4 ++--
 drivers/net/dsa/mv88e6xxx/serdes.c | 8 ++++----
 drivers/net/dsa/mv88e6xxx/serdes.h | 8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 8271b8aa7b71..6b7307edaf17 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -578,8 +578,8 @@ struct mv88e6xxx_ops {
 	int (*serdes_get_sset_count)(struct mv88e6xxx_chip *chip, int port);
 	int (*serdes_get_strings)(struct mv88e6xxx_chip *chip,  int port,
 				  uint8_t *data);
-	int (*serdes_get_stats)(struct mv88e6xxx_chip *chip,  int port,
-				uint64_t *data);
+	size_t (*serdes_get_stats)(struct mv88e6xxx_chip *chip, int port,
+				   uint64_t *data);
 
 	/* SERDES registers for ethtool */
 	int (*serdes_get_regs_len)(struct mv88e6xxx_chip *chip,  int port);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 6ae7a0ed9e0b..e0e1a1b07886 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -338,8 +338,8 @@ static uint64_t mv88e6352_serdes_get_stat(struct mv88e6xxx_chip *chip,
 	return val;
 }
 
-int mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
-			       uint64_t *data)
+size_t mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
+				  uint64_t *data)
 {
 	struct mv88e6xxx_port *mv88e6xxx_port = &chip->ports[port];
 	struct mv88e6352_serdes_hw_stat *stat;
@@ -787,8 +787,8 @@ static uint64_t mv88e6390_serdes_get_stat(struct mv88e6xxx_chip *chip, int lane,
 	return reg[0] | ((u64)reg[1] << 16) | ((u64)reg[2] << 32);
 }
 
-int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
-			       uint64_t *data)
+size_t mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
+				  uint64_t *data)
 {
 	struct mv88e6390_serdes_hw_stat *stat;
 	int lane;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 8dd8ed225b45..02966e520dd6 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -163,13 +163,13 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
-int mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
-			       uint64_t *data);
+size_t mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
+				  uint64_t *data);
 int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
-int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
-			       uint64_t *data);
+size_t mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
+				  uint64_t *data);
 
 int mv88e6352_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
 void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
-- 
2.43.0



