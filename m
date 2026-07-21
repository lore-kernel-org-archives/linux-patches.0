Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D970C2DC76A;
	Tue, 21 Jul 2026 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649676; cv=none; b=orzwCoDqUH/b1hiKpwv8u44VecEU4za+a4uzSCEbah5FdUjPR6tiG1p9wQtZJarfnE1debHVVmgQsAUI2z9cUMxzoP7GP/C/4JKBON8gGGQF6yPWlPq9Gh0pGegXvNPnhbbq55XpIAJN0lfmdTRy5tJ00wN88f+dAFZSJEUvfYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649676; c=relaxed/simple;
	bh=bslsoimVzxdy/d1EbjO7HetRphJP7wxOGpouWb0FnFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jd+hWMKQROtSeGigun8b/4ALQWugITrYVHksYELbPMRICvdUuMNqEJSANBGr5tza89en3Ukbn0p6oKXxR6kcTWBADZjFKRQ24C/ric9XS26iYX0p7KBPSnSUjEU0Niag7YDByMneSJ7tkzXgzBXdX8IdlrwfzQsf4sZKd1MJ4No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFom2/IV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFom2/IV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6B71F000E9;
	Tue, 21 Jul 2026 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649675;
	bh=nvh1jfD+N21WTGbuZ5eCKKd4CL3ORT+aZ8KHFPAMh8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFom2/IVojM6xjAe0u9h6utppndxzqJrPuFA37Ecn8p1gZKmzd+LBxW3Ca3qksY5z
	 Ra19xhcVykRXcOw89/ZA9DhsbS5QgNmI5brbWrJxuHqWz46DBLNbs4zEewNn10ycN7
	 VouwD6rWYJll0Lnlx0rDPhiTfwOSMv4pqZjF+hQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0667/2077] pinctrl: airoha: an7581: fix incorrect led mapping in phy4_led1 pin function
Date: Tue, 21 Jul 2026 17:05:40 +0200
Message-ID: <20260721152608.534684748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 34eef79d058f36..9497f5110f61b6 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -1622,13 +1622,13 @@ static const struct airoha_pinctrl_func_group phy3_led1_func_group[] = {
 
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



