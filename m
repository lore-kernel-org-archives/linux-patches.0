Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C9024113C;
	Tue, 29 Apr 2025 17:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947221; cv=none; b=tPe6VPXbWVScPNgaWXuIbQt60OAF2fCaifbIJq1kGEOzvArRRg/nQF5uXg74Lejh3GMyPq+KimwaHFSqQOuTtiRQmr/LrILnKLjMiCuz8nqRp8VBV+hqGeng2IIfyHCEjdoNEGZkwIlo+86djS7DrTeZkOwvWb6xEyQZJgx3wQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947221; c=relaxed/simple;
	bh=M5S5EVU865IxRQcglhJDOSA3SbJcIeW2W2kAzfIE5dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdpTE2Rfat6NVTaezi1LTsCV7PaShb8mHBK0PPgfJ3tp29pjV4c6EYqyXkgzFwZ3VjJIRtKxaqoSMktyhljpst2ktk/pRnBISTzf2flBHnr07bpH30vgnpCq5cTlCXAs0XG5RVM6sRBWUoWcONYjnJ20IoR001byiDhcf5/zv1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUC7XwN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUC7XwN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A87DC4CEE3;
	Tue, 29 Apr 2025 17:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947220;
	bh=M5S5EVU865IxRQcglhJDOSA3SbJcIeW2W2kAzfIE5dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUC7XwN1bE22Va36WAHE6zCwzdwZJUO3oq96YiOrorrCvjdm38zwQGuzEu43klgEm
	 bGuQnIf7ygZhcTRK75OqYe6EiOoJAEDLqO6ic8LOhviiFILH/MBqkmnQKt2qweEI80
	 2GEgzFvdilk2V4M9mhmoZsKAWYR7mHlEI8qS3mgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/286] net: dsa: mv88e6xxx: fix VTU methods for 6320 family
Date: Tue, 29 Apr 2025 18:41:55 +0200
Message-ID: <20250429161116.629318842@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit f9a457722cf5e3534be5ffab549d6b49737fca72 ]

The VTU registers of the 6320 family use the 6352 semantics, not 6185.
Fix it.

Fixes: b8fee9571063 ("net: dsa: mv88e6xxx: add VLAN Get Next support")
Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250317173250.28780-2-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index e590ea87b6ea2..ebc8580873940 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4170,8 +4170,8 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
-	.vtu_getnext = mv88e6185_g1_vtu_getnext,
-	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
+	.vtu_getnext = mv88e6352_g1_vtu_getnext,
+	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -4212,8 +4212,8 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
 	.reset = mv88e6352_g1_reset,
-	.vtu_getnext = mv88e6185_g1_vtu_getnext,
-	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
+	.vtu_getnext = mv88e6352_g1_vtu_getnext,
+	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
-- 
2.39.5



