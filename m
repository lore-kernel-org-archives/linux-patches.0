Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF73135836E;
	Tue, 21 Jul 2026 16:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649692; cv=none; b=EmVtgYQA09IBYsPdZeC91OzcU3Fole5L43tWGhq1LRx8b1bvoMfldypM5/OSRX9lCoq6iTWZT4MjeLQ79TDLCh0ij5zdpukRJH3G2gNgZOk83QXL1w/2MEaKwe2HKBvV4Fz2ywgv3ZKO6bxXYfdnV+S8kZ36GR0ucaSiM1HtVYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649692; c=relaxed/simple;
	bh=PqJKGbpXEqdXPfMsBUkEeHEFPMBWgmzACGxSWzzolPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Di+/6OJsELeqR6LhGEVa8SW3R8Of5SQIcedGm3NS/r5QCYi/SvEfuvDzgSeRjfIXY+61g7utGj/7H2icp4Cq2/sGsFBzw/UWsUgIFH+GKkPgtukGEvyhwzL0XWQTgsbtbnsMXJYvnZIKVpMgNEJ1DO1vD7ytYak/ufa7gvhNYTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyqWLQ4P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyqWLQ4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCD21F00A3A;
	Tue, 21 Jul 2026 16:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649691;
	bh=bam463EXzjG0pngq3527633zWZaOS23bCF8YPSZ/IMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyqWLQ4PXmzZDaFKCNXkrPCX/pAIh//qIuOAav/uJv4phKl5MJpIxSNhnGfsxE9HB
	 Xn9HQMjgJ5PIo1avHiiyzImVvI0KiFj2I6+Z+dGS5chp8JJX8RGPD5cBv76yrGrUgA
	 KPd5kB+rc6CzWrDs7amCljfngHohbR3Y9hYdvIgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0672/2077] pinctrl: airoha: an7583: fix phy1_led1 pin function
Date: Tue, 21 Jul 2026 17:05:45 +0200
Message-ID: <20260721152608.650647869@linuxfoundation.org>
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
index e66b608c4803ae..b73ab60d006596 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -1754,7 +1754,7 @@ static const struct airoha_pinctrl_func_group an7583_phy1_led1_func_group[] = {
 				LAN1_LED_MAPPING_MASK, LAN1_PHY_LED_MAP(0)),
 	AIROHA_PINCTRL_PHY_LED1("gpio10", GPIO_LAN2_LED1_MODE_MASK,
 				LAN2_LED_MAPPING_MASK, LAN2_PHY_LED_MAP(0)),
-	AIROHA_PINCTRL_PHY_LED1("gpio1", GPIO_LAN3_LED1_MODE_MASK,
+	AIROHA_PINCTRL_PHY_LED1("gpio11", GPIO_LAN3_LED1_MODE_MASK,
 				LAN3_LED_MAPPING_MASK, LAN3_PHY_LED_MAP(0)),
 };
 
-- 
2.53.0



