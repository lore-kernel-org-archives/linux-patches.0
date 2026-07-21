Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52B240587A;
	Tue, 21 Jul 2026 18:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658339; cv=none; b=L41couGNQHKAzu2h6Mf8sXw3bLIGmUhZ3NVLtruIxgSsabij47vGGy+bdj3vU4py9FFlBYEA5bUDRgHHFiZW24RWblCnJjUYhgcb1J/Og80CpkOYd/v2zf7Urq4j6Ad81iNQHEofdoWch3hi5lEOMNI0Hc8mkgp+7uatWJyu3VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658339; c=relaxed/simple;
	bh=9lmP6D4ToGMyXCdz1BIWErgOGkcVUPhWj7qDorDaZL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hStVp7rnDuXXwvHKnxlga7VBD8m2r97vtWu4IFN86jPUG7Az9PZj1DiTtbR/Q5pAKNlnP2p8Dg26irT9TNq2MGCLFgwHBx2UbNpO4SNC9gGgpjC3FYaE6j83M0oTjmn9bXqH9MwrtIAML5ONrqkEcdBkulyfUFfGTm0e/vjlcrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPaTCtid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPaTCtid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EAE1F000E9;
	Tue, 21 Jul 2026 18:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658338;
	bh=eowvfVlhsP3mvg4z41Kp5Wt1TFV0LDa8XlstmN9oaa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPaTCtid0XKDPT37D8r2WXmBWSkHvuywnaEzxHNa7NvLd5Qg5hExSlYLpZH0Jgv98
	 SL6KL0G8lpBrAGfOTFYoUxMPXgWzRnZpLpI3+b+fV/lc1hD8waUs9UCykVR34dO4cD
	 go/0NHr4vyW+WGmN/2F8BR7cIO5RCULPLiOjtpbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1069/1611] net: mdio: select REGMAP_MMIO instead of depending on it
Date: Tue, 21 Jul 2026 17:19:45 +0200
Message-ID: <20260721152539.452752712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 1a3267a8c9ecabb8e27f5cbda6d19295d5e41beb ]

REGMAP_MMIO is a hidden (non-user-visible) tristate symbol. Using
depends on it is incorrect because there is no way for the user to
enable it directly. Change to select, which is the convention used
by every other driver in the tree that needs REGMAP_MMIO.

Fixes: 8057cbb8335c ("net: mdio: mscc-miim: Add depend of REGMAP_MMIO on MDIO_MSCC_MIIM")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260702032653.1580616-1-rosenp@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 44380378911b7d..4da50e55b6be0d 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -123,7 +123,8 @@ config MDIO_MVUSB
 
 config MDIO_MSCC_MIIM
 	tristate "Microsemi MIIM interface support"
-	depends on HAS_IOMEM && REGMAP_MMIO
+	depends on HAS_IOMEM
+	select REGMAP_MMIO
 	help
 	  This driver supports the MIIM (MDIO) interface found in the network
 	  switches of the Microsemi SoCs; it is recommended to switch on
-- 
2.53.0



