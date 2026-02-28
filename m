Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB76346772
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302085; cv=none; b=GYFgKkBmijsCePu4TLtRmLspf40Ht4OCUBZ4PktLkI1f1CoiWisRYatQsdEgCzHXY8HZ306QJX31jv0SwHHCNaQslNnONUg0V9V2BnttC48v33kEFflrCB++gyB0Zq85XxqiuG4pXLnBTq+ZWVQd5yMeKDjmK8211P8+uTD4Vt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302085; c=relaxed/simple;
	bh=fqxRVY6vrQQzP20e2iyICzJz55/ICj+svh+tsKskA88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pp1cHl7ltYuPgyHSsng6ddSe1KJCKaTRLd/xvxUXzcqN1TBm+c5OQoke5PTpVUYBPk1m4AAJcYO4hUaAhlTkhwCFSuimrDkBZ8oaO0POasIh6JUZU2pdG1QJyjpRwyzR3AFcKgf423oOYlU2j05gMIToHEvlgDpXxYJMhnPFAGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nma97uXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nma97uXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95410C19423;
	Sat, 28 Feb 2026 18:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302085;
	bh=fqxRVY6vrQQzP20e2iyICzJz55/ICj+svh+tsKskA88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nma97uXlv7Zm0Tr/xf+uQG2d37Ko8GZrrnDvnNTNVBaAAXS+NmFqUAB2J/rywRRWK
	 dD1b0CDMSCjSOtiRe3UqoUqBqbZzHgfYGKuSr3NteoINBzatZ4VBpRNSA6fTRkBTQO
	 KXfnRVB64js+lcY2Q5atk8wD9+Bav+s+A0c8VH9ESBKQHpTY0zcq/EZKcjrE3E/CYu
	 TLNp0WjZDXLa8Ma4FNghZ0BBirDClil2ZsfgtGc8/CwKqMaCj5eelo9RoJung9sThS
	 HkVkj2AA6WiV0CkkfBxMWoKrrjlj/rpkprboweVEaqro6wZLym0wLMn0Im4RpUTwnw
	 RA5QArfqldLOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/283] ARM: dts: allwinner: sun5i-a13-utoo-p66: delete "power-gpios" property
Date: Sat, 28 Feb 2026 13:03:29 -0500
Message-ID: <20260228180709.1583486-67-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit 0b2761eb1287bd9f62367cccf6626eb3107cef6f ]

The P66's device tree includes the reference design dtsi files, which
defines a node and properties for the touchpanel in the common design.
The P66 dts file then overrides all the properties to match its own
design, but as the touchpanel model is different, a different schema
is matched. This other schema uses a different name for the GPIO.

The original submission added the correct GPIO property, but did not
delete the one inherited from the reference design, causing validation
errors.

Explicitly delete the incorrect GPIO property.

Fixes: 2a53aff27236 ("ARM: dts: sun5i: Enable touchscreen on Utoo P66")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20251225103616.3203473-4-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts b/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts
index be486d28d04fa..428cab5a0e906 100644
--- a/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts
+++ b/arch/arm/boot/dts/allwinner/sun5i-a13-utoo-p66.dts
@@ -102,6 +102,7 @@ &touchscreen {
 	/* The P66 uses a different EINT then the reference design */
 	interrupts = <6 9 IRQ_TYPE_EDGE_FALLING>; /* EINT9 (PG9) */
 	/* The icn8318 binding expects wake-gpios instead of power-gpios */
+	/delete-property/ power-gpios;
 	wake-gpios = <&pio 1 3 GPIO_ACTIVE_HIGH>; /* PB3 */
 	touchscreen-size-x = <800>;
 	touchscreen-size-y = <480>;
-- 
2.51.0

