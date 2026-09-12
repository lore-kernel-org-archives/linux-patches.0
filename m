Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B41630C60F;
	Sat, 12 Sep 2026 16:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230053; cv=none; b=ql3ZNJgLqGMbadDF6dLbBqqUYQjYRa6T0FSLks9AyI/bnxV7bHrjUYKAEyg1n7Pp8JvO2MjfXDsPPXM1DcO94B1bFtKiSoum5mw9K61GCLYI8LkwkkOKU0x18O4p451HCLxVk50NQN43zfrSLPC7g0lnwsuAjNPtoCO97jbLPVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230053; c=relaxed/simple;
	bh=KKT/a8VqnwJ2p8JsEJ6rIwmBXSrJ2+HeitkxTJanwnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1utOxeomijbxvqwUL+wNOOlSr+gu50ADhnSJg4Cu5xz9OLxyYa4XOqp31c9+LOZH5Jg2v2eUXSAvxVYEOPUmS6QfC181ItnWLrvqZuv2UhoLw3lbUohoLEtB1iFNFWk7EuyiMqfZOMmwF3BrFfudEWFgM2m0rkVMY0aPi3Inxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9o1LYyL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9o1LYyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4601F000FF;
	Sat, 12 Sep 2026 16:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230052;
	bh=BwWZt1YmytPYyrxLexIo3tWkVlyIlO2gHSZSUjip2a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9o1LYyLzSefisvYGqbC15yImAndO5SKaebcLeJKFERSy8uVXC6WMDGlarMPlzK3d
	 HZOBqmkhaL4uwuCW13bB9xcWcrDiugwTRfu6b9jYCrn0yUvWU7jVlnMU7VZOOmnBS3
	 2pdtVR0c5gKAX1IpoU2TOupUdNM31gSfuZ+2mN/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0715/1191] pinctrl: mediatek: Use C99 initializers in PINCTRL_PIN_GROUP()
Date: Sat, 12 Sep 2026 08:57:23 +0200
Message-ID: <20260912065604.338471139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



