Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EEE768F0;
	Mon,  8 Apr 2024 13:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582802; cv=none; b=Wb5ktZ0v+C0VDBkOs+AwyQaZDI8Vf0RjSbL44vIw9xa157Y/fNnZh2KcMpBbK4AhUf5CUCyI1G9BiGk6giHo28El0U3m3yOTburM3HVL2iTXROIKwRvgpZUgp+XDwXaT4squzo8g1dMiJqEJNJDoePTL/00tcPXs9Ti4u/2VCYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582802; c=relaxed/simple;
	bh=Ce2wzsgrvi0irEpaiWBiPibYCP35NBY3zuIv4abL1aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o17WYjL7X9yURcFnAPn0PbqkX3f0eowQXVjs8H4gUE+1EIOSa79jsTlG6fO0YA2jTBQWIVBbmtMHhCxtVy80GxKSSoisTYUxVMIxVj7dyHVtudQLBm5TKSClTuabpJGXVLLgpuNBfXnmav0HuIkqmA/lFUiCjJb0y7b8e7x9bJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehoeorfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehoeorfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6667CC433A6;
	Mon,  8 Apr 2024 13:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582801;
	bh=Ce2wzsgrvi0irEpaiWBiPibYCP35NBY3zuIv4abL1aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehoeorfDJMrFnhhKLrVujW+B8OMOBFHDdpE9m6MK4Otv9mO1Jl4nuhe8TfXv5WFnG
	 /zPu/CeVdTNTud1dVJT8bS8ycV36m7E9EbpyWkrz0R9+ByIHsiY1jvmVXmNJuq68cq
	 eTxp4wDHzchB6mCBtQz3lkmzCH8dDulO6IU4hI64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Krummsdorf <michael.krummsdorf@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 106/273] net: dsa: mv88e6xxx: fix usable ports on 88e6020
Date: Mon,  8 Apr 2024 14:56:21 +0200
Message-ID: <20240408125312.598654044@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5500,8 +5500,12 @@ static const struct mv88e6xxx_info mv88e
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


