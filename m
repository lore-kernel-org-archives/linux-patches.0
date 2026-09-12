Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E9B355049;
	Sat, 12 Sep 2026 14:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223881; cv=none; b=MiUKtpRK2WazkGxFQi+c5dSBsLitwLo4lWXip7MxncoB3hosEsQO+e6t5gQg55G6HGRhizFaBqZ66K1LEFueHtWVmhfUHpN7vkmB+gr+iFOVx055+Ks264jyBkK9WzaaJ6n7sNXEVVr6CdMsFYhQDujrh7lRoZkkJuql0IpW/IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223881; c=relaxed/simple;
	bh=0Q1jipmU1/CCq4H3TiqDhslhqVB8UA+kB5MNSR+S1FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEmoxW2PQCiVcmSYEatUPRQskwfHitVNSZ2s7uhPvLMrAiiPUNhQCNUQmVDg10fpWhiNdehg6IQ8YzGktaiVvo6jEbo1LCPAOhHzJUNDJwibM9UYCz71OX3JVGcRaccOOgcVuddX8pIeI89BTMb8a1kQAKsaMWUwQr/tJs6S87k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNuVq6e7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNuVq6e7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9971F00893;
	Sat, 12 Sep 2026 14:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223874;
	bh=LH6RulHeVIwXAKnvstPyMrgexmTlvZYiOAoVJ4WDHkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNuVq6e7BdPjAZx4Ryr3EhwE8+Re69jQX3Ao0efTSTgapa9/vVgGL0VuDxwzuCGBV
	 4EDpLHsA6CQIeq4eydWqQVg95IA2aLN1pgHp3hOpZqWaPdSQ+Rsx+WCgVn7z5KaTIC
	 mtEB7JUh8zOLB0w7qVUOWjTFCn2VzthwaC0GRj7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0878/1424] pinctrl: mediatek: Use C99 initializers in PINCTRL_PIN_GROUP()
Date: Sat, 12 Sep 2026 08:55:10 +0200
Message-ID: <20260912065626.984802387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit bb5eace1562fcef3c7ac9d0bd3e01af1187e46d0 ]

For the better flexibility use C99 initializers in PINCTRL_PIN_GROUP().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231211190321.307330-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 88292b7103d2 ("pinctrl: mediatek: free EINT resources on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-moore.h | 12 ++++++------
 drivers/pinctrl/mediatek/pinctrl-paris.h | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.h b/drivers/pinctrl/mediatek/pinctrl-moore.h
index e1b4b82b9d3db..36ee0021cf7ed 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.h
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.h
@@ -37,12 +37,12 @@
 		.funcs = NULL,				\
 	}
 
-#define PINCTRL_PIN_GROUP(name, id)			\
-	{						\
-		name,					\
-		id##_pins,				\
-		ARRAY_SIZE(id##_pins),			\
-		id##_funcs,				\
+#define PINCTRL_PIN_GROUP(_name_, id)							\
+	{										\
+		.name = _name_,								\
+		.pins = id##_pins,							\
+		.num_pins = ARRAY_SIZE(id##_pins),					\
+		.data = id##_funcs,							\
 	}
 
 int mtk_moore_pinctrl_probe(struct platform_device *pdev,
diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.h b/drivers/pinctrl/mediatek/pinctrl-paris.h
index 8762ac5993292..5c4e5b74e43e2 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.h
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.h
@@ -49,12 +49,12 @@
 			__VA_ARGS__, { } },				\
 	}
 
-#define PINCTRL_PIN_GROUP(name, id)			\
-	{						\
-		name,					\
-		id##_pins,				\
-		ARRAY_SIZE(id##_pins),			\
-		id##_funcs,				\
+#define PINCTRL_PIN_GROUP(_name_, id)							\
+	{										\
+		.name = _name_,								\
+		.pins = id##_pins,							\
+		.num_pins = ARRAY_SIZE(id##_pins),					\
+		.data = id##_funcs,							\
 	}
 
 int mtk_paris_pinctrl_probe(struct platform_device *pdev);
-- 
2.53.0



