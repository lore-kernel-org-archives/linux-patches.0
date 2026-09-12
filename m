Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6371B41169F;
	Sat, 12 Sep 2026 11:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212688; cv=none; b=Bd0RxIo1n002MiDYmA2IXqAgsJ/sShB9HiVRArLWErqZjK2+rjQWF+/tNPyt5uqK6ILmBEObPLuQ2FZzAR30Y2daWDytI/FlJKeoOZHYo/f3OHu0gwfrIFOPemALLIznYn9abD6b2CppatpwD+xtjfmmOFNGT7K6/uQ8yxnFErE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212688; c=relaxed/simple;
	bh=zITNCri4Ex86X60c+6Z9MpwCU5Y3+sekO0uPJCKfe/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDFyQwSooNlP/mZIe6AeCaOpUcqCEo7GNwyJzNtyXVcMvT4Ypnmi7F8UPNzsh/zTapxkxSu4agldxSdOdZUmuvO61dWayXjw9IhXpNmilCCsREtDsCy/J14gqIIGcr+sInSmXxzuK3kQV0atHe/tSxi9w3k0yGlV439dGfGdM9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEHgWlVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEHgWlVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600B61F000FF;
	Sat, 12 Sep 2026 11:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212687;
	bh=RMRluDA9VUwP661LZuMeXcU4EFcyiThB5TO50QjmSwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LEHgWlVccV70K9x0FN12+Ty/68VEcesWn0h2E6NRLnMDG8gf9mhV8qXxdZhhMd5qK
	 Jh/KsF9qKisSIX0J1PiL+F7YNOwEbddQyqMuBwSkR5MDQVbU+hHVaSCdaHTpC+GW0+
	 eXPLZnJHG0f76ta7Ix427Z3QTPvNifJ/KwXyUMIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1487/1518] pinctrl: airoha: an7583: fix incorrect led mapping in phy4_led1 pin function
Date: Sat, 12 Sep 2026 09:00:56 +0200
Message-ID: <20260912065657.200994092@linuxfoundation.org>
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

[ Upstream commit a3602577fdfc49c6dc08d67304426d5ef6d7dec6 ]

phy4_led1 pin function maps led incorrectly. It uses the same map as
phy3_led1. PHY{X} should map to LAN{N}_PHY_LED_MAP(X-1).

Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 7bdebb4f7254a..f10b2d1eb56bc 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -1920,13 +1920,13 @@ static const struct airoha_pinctrl_func_group an7583_phy3_led1_func_group[] = {
 
 static const struct airoha_pinctrl_func_group an7583_phy4_led1_func_group[] = {
 	AIROHA_PINCTRL_PHY_LED1("gpio8", GPIO_LAN0_LED1_MODE_MASK,
-				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(2)),
+				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(3)),
 	AIROHA_PINCTRL_PHY_LED1("gpio9", GPIO_LAN1_LED1_MODE_MASK,
-				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(2)),
+				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(3)),
 	AIROHA_PINCTRL_PHY_LED1("gpio10", GPIO_LAN2_LED1_MODE_MASK,
-				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(2)),
+				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(3)),
 	AIROHA_PINCTRL_PHY_LED1("gpio11", GPIO_LAN3_LED1_MODE_MASK,
-				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(2)),
+				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(3)),
 };
 
 static const struct airoha_pinctrl_func en7581_pinctrl_funcs[] = {
-- 
2.53.0



