Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A28B198A16;
	Thu,  6 Jun 2024 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683053; cv=none; b=JS8PRKFNsSi3BuexipOGJWBbPS2rKxmHuNA8sYStHKAaClM8cE2uXeAJotnzi6fbg8g+R7TANcrRdioKkyHMehpZY0oUl4d6aY4HVlxwjobFjlb73pVI2yf99XrKI8RR5cU6yGsOpagt1U7weT8T+3ryr4Q89OISh2Ld1xTGjaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683053; c=relaxed/simple;
	bh=WyjiUSOxG9wuSn558O2V8qfIHTA/GX4U28j1uwQkjuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVmO6HTMEr8y3nvyPzWium6qtRPXKHgN30k5qk+L2+MEnR5QSVs61nOvwsqZSVR4N+6hhtrj98N3gBxA6p/ke0pZnkR4u3vvM5ZkkSpjLPqtA34IMYQrdNYS2sjTTV3GazJqmOejH/By5cpazJSNh5FbL6Bbt9oh+JNeAVjuXhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzcqDcpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzcqDcpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3ACC4AF0D;
	Thu,  6 Jun 2024 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683053;
	bh=WyjiUSOxG9wuSn558O2V8qfIHTA/GX4U28j1uwQkjuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzcqDcpkOsNGFEXSRZXJDmhOC286ImTMcCxad1lLRuspR+cCfqJeZjOdRrJGtYAa2
	 iu1dc/KguVJp0tj4aT1Ptw9zUldGtQsC52O+CSFtF8d9hR1FafTM5DEcl+vs5uGuOC
	 /sQtqHTekxE6VeAQKZcAWUMY4jTmXZmYNb6NTjHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karim Ben Houcine <karim.benhoucine@landisgyr.com>,
	Mathieu Othacehe <othacehe@gnu.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 295/374] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8061
Date: Thu,  6 Jun 2024 16:04:34 +0200
Message-ID: <20240606131701.754032231@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Othacehe <othacehe@gnu.org>

[ Upstream commit 128d54fbcb14b8717ecf596d3dbded327b9980b3 ]

Following a similar reinstate for the KSZ8081 and KSZ9031.

Older kernels would use the genphy_soft_reset if the PHY did not implement
a .soft_reset.

The KSZ8061 errata described here:
https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8061-Errata-DS80000688B.pdf
and worked around with 232ba3a51c ("net: phy: Micrel KSZ8061: link failure after cable connect")
is back again without this soft reset.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Tested-by: Karim Ben Houcine <karim.benhoucine@landisgyr.com>
Signed-off-by: Mathieu Othacehe <othacehe@gnu.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 87780465cd0d5..18dee364e2b31 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4814,6 +4814,7 @@ static struct phy_driver ksphy_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.probe		= kszphy_probe,
 	.config_init	= ksz8061_config_init,
+	.soft_reset	= genphy_soft_reset,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= kszphy_suspend,
-- 
2.43.0



