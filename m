Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215233;
	b=QGduGi6/GxzXGKqrGPHUrYrAeUXmOxpC+5jJ/Ds8UxDR8jZAcPBGEXep9jGysRKXk1Bi
	 wTAMVFXpshLa9NSOroXK9qMpcDBt/aPqqbay6eZWBrVGZp0lNaIr4xVMbG3qLKTANP8gl
	 s7V0ZDKtCKdwKMqd5gAULZOcW+XAbAMgsKKJjTsmpXCowSReBN8d8fWlAqVJ3ZtgEGC96
	 TpGEH3oyYU3TehAfGdKJ7EBNMaRCLIPbbZ+y0K+nZ/7RMEIb+emfnXgRyymo6/NHUX1H/
	 vVF8nJWVVOgMXHDfiMWHUc2aATfqCR6769RoLE9kZrY+81AH3xCxQRk+wXniEBveVyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O9mbJvHfLgtFdlZZAhAGZ6S/d4oWWYkgqGVSm+ZrHeU=;
	b=Eg5t68Rqwp4mxX8wMC0vlQa2J5pgDDq+uzrebvgSQiUxRMrQs5uNFHf/MOnp1XrnBYFM
	 HlIHoIszoPeu6PTF7H2q3Y/ZaH91RptyyUA6cI2X37d5t7ds15Sy7T0vHAwmywqnrJTHT
	 RuDXuWKVkFTyG6odGNvMgPwZSiLVs32VjPsJEm703kKqIMM5tPIMMp/hReijKUqdayj12
	 fXW8gI1jEF79bvgvaqrH9fWZxqJPU8HvTeA9PPtlnIjMaI15wWvo/YX3dhf4TfN5XL2bH
	 zPwis+LkbrDiOFkI4VavX8aHCJHOkzpzqsI8FVutuENgxsMnodoNXnUP8DSPvatfIpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQHgCLgR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3FB606A31C;
	Wed, 28 Oct 2026 19:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hQHgCLgR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD9E1F01825;
	Wed, 28 Oct 2026 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215233;
	bh=O9mbJvHfLgtFdlZZAhAGZ6S/d4oWWYkgqGVSm+ZrHeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQHgCLgRbGFnZ56j7hwzbNtv332s4cU6z4yI7WK8mBrUe5k79z0Tk6kNOHkhhaHwW
	 MFx6HLTsx0fRbDNlkg0C+1UZipRqT+TCoBi6UEGKkPhp+tSODJmBKocoCM5Xvm51ZN
	 zxexYHe7RpwCs/ETCWE7NhuBBp+Vir+NHcMbhnhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1095/1887] net: phy: clean the sfp upstream if phy probing fails
Date: Wed, 28 Oct 2026 17:53:11 +0100
Message-ID: <20261028170524.325523656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit 48774e87bbaa0056819d4b52301e4692e50e3252 ]

Sashiko reported that we don't call sfp_bus_del_upstream() in the probe
failure path, so let's add it, otherwise the sfp-bus is left with a
dangling 'upstream' field, that may be used later on during SFP events.

This issue existed before the generic phylib sfp support, back when
drivers were calling phy_sfp_probe themselves.

Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Fixes: 298e54fa810e ("net: phy: add core phylib sfp support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260604092819.723505-2-maxime.chevallier@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 96dcd1d70bf4a..b6161175191af 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1399,6 +1399,9 @@ int phy_sfp_probe(struct phy_device *phydev,
 
 		ret = sfp_bus_add_upstream(bus, phydev, ops);
 		sfp_bus_put(bus);
+
+		if (ret)
+			phydev->sfp_bus = NULL;
 	}
 	return ret;
 }
@@ -3143,6 +3146,9 @@ static int phy_probe(struct device *dev)
 	return 0;
 
 out:
+	sfp_bus_del_upstream(phydev->sfp_bus);
+	phydev->sfp_bus = NULL;
+
 	/* Re-assert the reset signal on error */
 	phy_device_reset(phydev, 1);
 
-- 
2.53.0



