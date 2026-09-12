Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82376427F91;
	Sat, 12 Sep 2026 11:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212673; cv=none; b=ZpSIDo8pAEQV4sCJdKy463AzxaK9zJmproIZteViDktmFSITnT28JkYgmTNIJGMdCq3Kj8uTz8uo0hpBdpOOy/6UPK0XDUz7egcx5anzDPy4jy1DgyfLuqp08DWpu6hQfVC4tJPDWKihCcFWtg61yHhSkRFiTlK769JLkGkTee4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212673; c=relaxed/simple;
	bh=2e1mkyB+U2WxlFylL1frQL3w1QjxlGFo0oLYzcSrN+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuXVy9KGJzfCuGMDdz64bs7/z8EohINki7m7xD8NIHcB/gfOGf6IzulzKCC3DWZtdpbgfuv+CWHatxP3qN4cvItdy2dGDapUB3/ZwaRPCBekIfP628b2AY7SV0Jkp0xdzqesoIMxloApl25fP95E8JPf+2JOjY9gRc0Nj7zZxTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFT4oLl7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFT4oLl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C761F000FF;
	Sat, 12 Sep 2026 11:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212672;
	bh=BgN6AkVxY/qmxiZbsbCN4JLiUYX+bGNl8LS/So4gGX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFT4oLl7e27yyLIbFaRznbeyTJ4+8ksco95nsbhZTondpe8WNlHU9kHP2mZEUjLuw
	 UF0j5ENaNEcM92C+5Q1c7n3aNoYrqEXGePEvdw5WqXQkZxz18Apjo5aj2bpEdR2vBz
	 fUFqI7CF/iX8GM7iF+6jNBAGvIszzTj42ky++h9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1485/1518] pinctrl: airoha: an7583: fix phy1_led1 pin function
Date: Sat, 12 Sep 2026 09:00:54 +0200
Message-ID: <20260912065657.156232986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit dbe28a2a22a3455d1adbf9fd61d3537603ac3072 ]

phy1_led1 pin function wrongly refers to gpio1 instead of gpio11.
Fix it.

Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 22986d033430b..0f4626f582074 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -1892,7 +1892,7 @@ static const struct airoha_pinctrl_func_group an7583_phy1_led1_func_group[] = {
 				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(0)),
 	AIROHA_PINCTRL_PHY_LED1("gpio10", GPIO_LAN2_LED1_MODE_MASK,
 				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(0)),
-	AIROHA_PINCTRL_PHY_LED1("gpio1", GPIO_LAN3_LED1_MODE_MASK,
+	AIROHA_PINCTRL_PHY_LED1("gpio11", GPIO_LAN3_LED1_MODE_MASK,
 				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(0)),
 };
 
-- 
2.53.0



