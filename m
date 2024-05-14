Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2E4139584;
	Tue, 14 May 2024 11:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687019; cv=none; b=GcYiuG/SqYHwVQjeyOPiT8uPBJ2xkfBemfOk6gr/qkcrW4RYjx5FHgITrF+ZiCW/4I6Mcn1L+cEB12oJVwDZ2MT/kbDnKnuJfx35F3C1BAKEMRJPbeOE4Nb3c6qVfNxnq7E8Bs8TjC1R/P8Y98+A4R+tTIlb/qrQ+SAE2fUYl+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687019; c=relaxed/simple;
	bh=YB/qCZtd0F397uBtWs1Yhms8fZwSYOYKBHSgMmz7Qlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uw01isHYELNjUyhFLfbDzOp3FwayP6wI7PasgcfDUlRXRcYiojVcfZYUe8ihdCcEvK06aaCMmtXIYF34PpcOmoIaseRMtBupvcwktgpxrdRLRJBv1E7pdHdULHv3tOWj+WTcVRcwsqRvPlFBEm91/pcKUkDHwFQJqo2WHr7B1uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdYw4ucE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdYw4ucE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724E7C2BD10;
	Tue, 14 May 2024 11:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687018;
	bh=YB/qCZtd0F397uBtWs1Yhms8fZwSYOYKBHSgMmz7Qlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdYw4ucESyC5Qg5rQmwADITk2Bf1ai5vvAgEq7LzwPrq3WUNYxdLK4aU8ronMu8OU
	 wQC7gxzl7gOg6hpm8oSLDeoUdherAOmrh+j7tleHO2xGRStLuzGpdJJ0uWjabWpxj3
	 azGfXOpffBg4Jmpt3NPvozidj1PWaQ5F5/5+aQ7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 29/84] net: dsa: mv88e6xxx: Fix number of databases for 88E6141 / 88E6341
Date: Tue, 14 May 2024 12:19:40 +0200
Message-ID: <20240514100952.792660943@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit b9a61c20179fda7bdfe2c1210aa72451991ab81a ]

The Topaz family (88E6141 and 88E6341) only support 256 Forwarding
Information Tables.

Fixes: a75961d0ebfd ("net: dsa: mv88e6xxx: Add support for ethernet switch 88E6341")
Fixes: 1558727a1c1b ("net: dsa: mv88e6xxx: Add support for ethernet switch 88E6141")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20240429133832.9547-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9ee144c117267..81e6227cc8758 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4310,7 +4310,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6141,
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6141",
-		.num_databases = 4096,
+		.num_databases = 256,
 		.num_macs = 2048,
 		.num_ports = 6,
 		.num_internal_phys = 5,
@@ -4716,7 +4716,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6341,
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6341",
-		.num_databases = 4096,
+		.num_databases = 256,
 		.num_macs = 2048,
 		.num_internal_phys = 5,
 		.num_ports = 6,
-- 
2.43.0



