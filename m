Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD6921ABBD;
	Tue, 29 Apr 2025 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950191; cv=none; b=a95LTMahJUXYiVZYOpulDOWLmUcIFsvxHLtXYNwzI8dja2ZAQfqzR8H1fy4UDw1y+DqHlZSaRdbJpDjoT+fs4a3Sg3WUXZZsqztstt4NFK2vKx9/K8gZfWfZotIPd0WaYlqTDMFdoY1UxLBFPjJ0eYxIi9scdukMTvsVoVAQG70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950191; c=relaxed/simple;
	bh=xlmQVDDtR2yhB4TadYqn86d5Ur3ZxgHld76IVCPSbPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ht01Y4Jto46UYpUynfmTc1i3mE+82TpQdArUEBVLCsGK8M59AH0TC3mciQH5Y7W4kX5KF46730i+no4tgo8FYHJ0GwGau04vxOfxX7+uA47OMdPeDaIcsUoPdJegeMhUY3SWcKcK4ck7NWV1ScBDYYyNH1uFfMfN55dbpNFo9BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kYMu03s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kYMu03s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4ADC4CEEE;
	Tue, 29 Apr 2025 18:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950191;
	bh=xlmQVDDtR2yhB4TadYqn86d5Ur3ZxgHld76IVCPSbPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kYMu03sGO4afTVvsdtwhpYwkTLbXDAzCy33rd7fStXrCMOGbebXnS95y2GdGN079
	 eiQmtf8JhKi42ZlVmQiOZ++YT9ok3skLz2rqqk40rTPg2fPEYRQmKERmNAjDLsN58p
	 +ja0HsstrLhrZjMk9VGgquuzfJ9HQcaguwI8cwl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/204] net: dsa: mv88e6xxx: fix VTU methods for 6320 family
Date: Tue, 29 Apr 2025 18:41:45 +0200
Message-ID: <20250429161100.130554218@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d66448f0833cc..bf93d700802be 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5071,8 +5071,8 @@ static const struct mv88e6xxx_ops mv88e6320_ops = {
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
-	.vtu_getnext = mv88e6185_g1_vtu_getnext,
-	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
+	.vtu_getnext = mv88e6352_g1_vtu_getnext,
+	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -5120,8 +5120,8 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
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



