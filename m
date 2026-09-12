Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFEC353A75;
	Sat, 12 Sep 2026 11:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212711; cv=none; b=nrPavNvBA2BvcztqBjIgCdehIkt3LbDOXC/olGEOCOIuF2Zx4wD29uSkhyZ29FWQJ0wXYD27rfmdUliYP8kqdWXEnXxUEXGS/QAYjPJdB1K66po1jwqEQxg3wn+ym0y2uu7tK/n9qy/cImEY81bE2CgY1urotZwQXg1cqmbvHfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212711; c=relaxed/simple;
	bh=6+WfVVFDs1d6grYp3ZMrWLqTuq52ghNExJY+/bIhhuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DffasMTSNZVpJ3xTi4E2Q5VkBTdgt141GrpcznQiAiK39Ii4/S5m9eWczdH1lIzYKEdvGnPYhLpiOjtnNyGyzuTtzQ8OY/ndU85UJh37PtnIcfUGyg1f5jhv2suLmLb6zYiM3PJ2X15UKebb7UU9hLbLCTglH4T+dCTsuauDhC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxXlUwSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxXlUwSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219CE1F000FF;
	Sat, 12 Sep 2026 11:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212706;
	bh=fVaQqI+maRIMA2tMs90GUNHVZfrxqSO3qmOVinG+e0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxXlUwSk3DNAtca1sJR23Ry/l96glWTO9cANBz5I6w4yOzvPCbZR+WiFdiZmhNt7v
	 Ta43JhyAXBfTXOuf2q/pviOcIFbg85Ecs6hldKsNBrlcmY6t2O4YNhyQDkfOuf9Lyg
	 mRwiASRFQFQKAv93XtCyqnFW9SZ+pdbEFRc13e7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1491/1518] pinctrl: airoha: an7581: fix incorrect led mapping in phy4_led1 pin function
Date: Sat, 12 Sep 2026 09:01:00 +0200
Message-ID: <20260912065657.290267060@linuxfoundation.org>
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

[ Upstream commit e20c85c79cc2f45b87eb3dab38d4c641bbf83ed6 ]

phy4_led1 pin function maps led incorrectly. It uses the same map as
phy3_led1. PHY{X} should map to LAN{N}_PHY_LED_MAP(X-1).

Fixes: 579839c9548c ("pinctrl: airoha: convert PHY LED GPIO to macro")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index ba5647f6328eb..9821e2f6f27dd 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -1834,13 +1834,13 @@ static const struct airoha_pinctrl_func_group phy3_led1_func_group[] = {
 
 static const struct airoha_pinctrl_func_group phy4_led1_func_group[] = {
 	AIROHA_PINCTRL_PHY_LED1("gpio43", GPIO_LAN0_LED1_MODE_MASK,
-				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(2)),
+				LAN0_LED_MAPPING_MASK, LAN0_PHY_LED_MAP(3)),
 	AIROHA_PINCTRL_PHY_LED1("gpio44", GPIO_LAN1_LED1_MODE_MASK,
-				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(2)),
+				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(3)),
 	AIROHA_PINCTRL_PHY_LED1("gpio45", GPIO_LAN2_LED1_MODE_MASK,
-				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(2)),
+				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(3)),
 	AIROHA_PINCTRL_PHY_LED1("gpio46", GPIO_LAN3_LED1_MODE_MASK,
-				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(2)),
+				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(3)),
 };
 
 static const struct airoha_pinctrl_func_group an7583_phy1_led0_func_group[] = {
-- 
2.53.0



