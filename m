Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D478235691C;
	Tue, 26 Aug 2025 14:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219039; cv=none; b=jCi4ji6KiLHqdzp1QpIMhXnvxMXEbO+Rvoyl8puc/VZqNM9ldOQjPNtHM1fM+JBM+bfj7J9+jxFaNwUDy42xtKn+6Vogi37cSWpEKRTWz2eoagJRm5P9E708TqCHJyWkjSV+Alteq7TAoaocLuvoE6h9jRMW2dwPNzQNVwAkYw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219039; c=relaxed/simple;
	bh=IVL7TcHUtD+N0DgBcusP5UZ189nrYVhuTOJwLEJ9Yek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X/3oNnpr3Avj3PEmMJKSG3UgM8lXRR1rv53puBRfldJpeK5/BbzT8vdzZaK2FHdia2w/nfZgDDWEhoUqcjnyuQj1eiRIHBfqiIP9UF+xwSs5woUUZKrpTOELPNGTuWVfmcXe0/Si/Qj3/1LsicYxMTaBdTuuXWfuefa8E3FvuNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMS1yZaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMS1yZaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D6BC4CEF1;
	Tue, 26 Aug 2025 14:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219039;
	bh=IVL7TcHUtD+N0DgBcusP5UZ189nrYVhuTOJwLEJ9Yek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMS1yZaD6+44TmcvpG7dHbE1rcWU0fhJNgCN2jHlS8+tBfEDzLa67CStr98OEbq4c
	 vrcxc0J4U8aV/HQkWxJtbN+7pq8d3uTnukHW16jdplvms+Lslo/hkelF/P7mc2WLtb
	 tvbqY13Qj7V1ULi/YcHVSaiXOERJzkFQSnwUe8wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 230/403] net: dsa: b53: fix IP_MULTICAST_CTRL on BCM5325
Date: Tue, 26 Aug 2025 13:09:16 +0200
Message-ID: <20250826110913.183592999@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 044d5ce2788b165798bfd173548e61bf7b6baf4d ]

BCM5325 doesn't implement B53_UC_FWD_EN, B53_MC_FWD_EN or B53_IPMC_FWD_EN.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://patch.msgid.link/20250614080000.1884236-9-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 18 +++++++++++-------
 drivers/net/dsa/b53/b53_regs.h   |  1 +
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 43726157dfe2..fea28b24a1a0 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -342,14 +342,18 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 		b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, &mgmt);
 		mgmt |= B53_MII_DUMB_FWDG_EN;
 		b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, mgmt);
-	}
 
-	/* Look at B53_UC_FWD_EN and B53_MC_FWD_EN to decide whether
-	 * frames should be flooded or not.
-	 */
-	b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
-	mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN | B53_IPMC_FWD_EN;
-	b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
+		/* Look at B53_UC_FWD_EN and B53_MC_FWD_EN to decide whether
+		 * frames should be flooded or not.
+		 */
+		b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
+		mgmt |= B53_UC_FWD_EN | B53_MC_FWD_EN | B53_IPMC_FWD_EN;
+		b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
+	} else {
+		b53_read8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, &mgmt);
+		mgmt |= B53_IP_MCAST_25;
+		b53_write8(dev, B53_CTRL_PAGE, B53_IP_MULTICAST_CTRL, mgmt);
+	}
 }
 
 static void b53_enable_vlan(struct b53_device *dev, bool enable,
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index b2c539a42154..ea6897c3f6f7 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -103,6 +103,7 @@
 
 /* IP Multicast control (8 bit) */
 #define B53_IP_MULTICAST_CTRL		0x21
+#define  B53_IP_MCAST_25		BIT(0)
 #define  B53_IPMC_FWD_EN		BIT(1)
 #define  B53_UC_FWD_EN			BIT(6)
 #define  B53_MC_FWD_EN			BIT(7)
-- 
2.39.5



