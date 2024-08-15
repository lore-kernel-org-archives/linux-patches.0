Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220FE1714A8;
	Thu, 15 Aug 2024 13:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729326; cv=none; b=fzAlktqrUEYE0HylYx6Dr+XJbujza+vX8xCyHYqMVjq7kla64PpDUEhWA7aokqM4F6dNjCvgAEfs6rVnLkjRAaLkWWZbg3GulHtfZFmuOG2Ntpxj0jiJIpU07UOrWUMBwTmndUI8x1FIMuEkoA7cnaE7i0rOIb1/I0+F/pcdbWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729326; c=relaxed/simple;
	bh=ECZ3MVrgEgd9Sx75S14xKKfzEO0/p6nKFnpNnsOHqnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6N2bwTdMtuFAzp/i3tVzVjoU31Xf87OvOtP6FnFCxsqsdObIMQ8iz2sJLt36zidcVX1kIO+yMBFAufVf11+NHVdL9RO3vx8nJTtgLWnl1SdTEyh9o4+tNs4lR/QwwZWo1E/mv8zei/rJrrK1B2HlCqfrvuyoyteCc8GKCBuKZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijDRztaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijDRztaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC3CC4AF0C;
	Thu, 15 Aug 2024 13:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729326;
	bh=ECZ3MVrgEgd9Sx75S14xKKfzEO0/p6nKFnpNnsOHqnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijDRztaTJnHt6EEb+7WWClcHy+d6bbkhDHEFBhAK2CUFG6R+lMDStbLokJ1OR7M/n
	 b6dye+6QskOhVfJvwI0WzD0sAfEOueVZzs1gZ9FQffmAqHNCZwehDBZsfcNeFmRjHj
	 RUw9XAKz5ZubnyfQFVMrxVb0UCkqLGKuCYAzqYAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/484] ARM: dts: imx6qdl-kontron-samx6i: fix PCIe reset polarity
Date: Thu, 15 Aug 2024 15:18:09 +0200
Message-ID: <20240815131942.477903226@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit df35c6e9027cf9affe699e632a48082ab1bbba4c ]

The PCIe reset line is active low. Fix it.

Fixes: 2a51f9dae13d ("ARM: dts: imx6qdl-kontron-samx6i: Add iMX6-based Kontron SMARC-sAMX6i module")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index d9f4321055165..81e9b39bac20b 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -732,7 +732,7 @@ &pcie {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_pcie>;
 	wake-up-gpio = <&gpio6 18 GPIO_ACTIVE_HIGH>;
-	reset-gpio = <&gpio3 13 GPIO_ACTIVE_HIGH>;
+	reset-gpio = <&gpio3 13 GPIO_ACTIVE_LOW>;
 };
 
 /* LCD_BKLT_PWM */
-- 
2.43.0



