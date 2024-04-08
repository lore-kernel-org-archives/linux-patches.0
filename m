Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158928121A;
	Mon,  8 Apr 2024 13:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582670; cv=none; b=Sp1ZiuuFrktWhhX7G0yoJvxg0JTYdn82+eIJeG708ldpvHhCekRcct+7lBqJAcF9aYfoSTIWCfgjHtGZ0sEyvT0TkFTiJERKi8l6nLOZpB4C0cKIYdGSjwi7atP9Y/vO2Od7U1miELLy7Xul8et+CzuOObRcVp/HnHPGEQwsIeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582670; c=relaxed/simple;
	bh=TYQB+ZEH1XAbHseQ+ZEvrkPRZGNw+xliOPd5gxaciDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYDxtl/fDEQ6oNytek3yjYzJC3h2lOnV69fE3uVG2MgPOmjIULsEf+rAVQKEwbx3DxB12CaMVbzEhR5w6XzzYiPSW7N2OqsQeShWx7tKgTPKtwwpzUZOA5do+ivaq18P+86WRGaoi8/5hmp8d1BZ3FrmMZySoo9MJtHmwKL/Lb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWefkkl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWefkkl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94424C43390;
	Mon,  8 Apr 2024 13:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582670;
	bh=TYQB+ZEH1XAbHseQ+ZEvrkPRZGNw+xliOPd5gxaciDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWefkkl1NZp+D6z8XkXWg9KtO86uERtN+Vemc8JKibG44mGFnevDOzZBViDhiiUBT
	 aMhtBaYSOzpviigB0d633WAa60Z+Q1M1FjfHZQZUcVWw+gMVIoyqQ0aez1ecldOSQ5
	 1EoysbGG2F75oYjpmQFzjKCyIorM89so1nyt64ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Krummsdorf <michael.krummsdorf@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 111/252] net: dsa: mv88e6xxx: fix usable ports on 88e6020
Date: Mon,  8 Apr 2024 14:56:50 +0200
Message-ID: <20240408125310.083797513@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Krummsdorf <michael.krummsdorf@tq-group.com>

commit 625aefac340f45a4fc60908da763f437599a0d6f upstream.

The switch has 4 ports with 2 internal PHYs, but ports are numbered up
to 6, with ports 0, 1, 5 and 6 being usable.

Fixes: 71d94a432a15 ("net: dsa: mv88e6xxx: add support for MV88E6020 switch")
Signed-off-by: Michael Krummsdorf <michael.krummsdorf@tq-group.com>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240326123655.40666-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5386,8 +5386,12 @@ static const struct mv88e6xxx_info mv88e
 		.family = MV88E6XXX_FAMILY_6250,
 		.name = "Marvell 88E6020",
 		.num_databases = 64,
-		.num_ports = 4,
+		/* Ports 2-4 are not routed to pins
+		 * => usable ports 0, 1, 5, 6
+		 */
+		.num_ports = 7,
 		.num_internal_phys = 2,
+		.invalid_port_mask = BIT(2) | BIT(3) | BIT(4),
 		.max_vid = 4095,
 		.port_base_addr = 0x8,
 		.phy_base_addr = 0x0,


