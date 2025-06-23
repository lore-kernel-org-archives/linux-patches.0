Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365AC2236EF;
	Mon, 23 Jun 2025 21:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713451; cv=none; b=RtM+0TX8XL++nlKcbZWluQukX7gDQ4SvE0uUcgimozFP8zvXmmZlTBYI6AszvAdHW+4fjYpaXOaW8JFVafksEly2gaPazBWuitbhjteWHlPEz/zjQP/IMrni1pHYPK9nx22vIltFco8GRN3dFNjKXw8cer/r79Fh1wmIw4OiDWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713451; c=relaxed/simple;
	bh=fo+n+TjGy5iiJi1VuasNT7ro8+v3VoLjXcu4hfsuJB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9BCl5QqpC9nOvNKT90zF82NQlR32LgUimt1jxz5K9enR058OZoxAjFKjfpakGtFTcNG4QAmvLvouoF70z+v10fFD8D4AAZdC9fx5BTKJV0evumt2FBMCUplVQdXQjJxcoJnJJI+aRMg0vYSZIYPkVORh3yQAq9yeGlLGyuId/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1w1elyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1w1elyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B4CC4CEEA;
	Mon, 23 Jun 2025 21:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713451;
	bh=fo+n+TjGy5iiJi1VuasNT7ro8+v3VoLjXcu4hfsuJB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1w1elyE9Zgaav/PlUW36FGOFmKJ/juy9lZS/vwoI6vquY43AiKOhXxWXrRfJ4CEw
	 9n1jOFprgtmKdqu+GeB/3m5q9RloTVKj+v8WrL0ZCPXS58XE9JxbuEmb7/7GROn+Kl
	 3YmmxuwKICUyjZBn7m6Zu1V61XF0iCgdUNOV/ol0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/508] ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select
Date: Mon, 23 Jun 2025 15:02:32 +0200
Message-ID: <20250623130647.913608666@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 67ba341e57ab158423818ed33bfa1c40eb0e5e7e ]

Dataflash did not work on my board. After checking schematics and using
the proper GPIO, it works now. Also, make it active low to avoid:

flash@0 enforce active low on GPIO handle

Fixes: 2432d201468d ("ARM: at91: dt: usb-a9263: add dataflash support")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20250404112742.67416-2-wsa+renesas@sang-engineering.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/usb_a9263.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/usb_a9263.dts b/arch/arm/boot/dts/usb_a9263.dts
index b6cb9cdf81973..c9d0058e90813 100644
--- a/arch/arm/boot/dts/usb_a9263.dts
+++ b/arch/arm/boot/dts/usb_a9263.dts
@@ -58,7 +58,7 @@
 			};
 
 			spi0: spi@fffa4000 {
-				cs-gpios = <&pioB 15 GPIO_ACTIVE_HIGH>;
+				cs-gpios = <&pioA 5 GPIO_ACTIVE_LOW>;
 				status = "okay";
 				flash@0 {
 					compatible = "atmel,at45", "atmel,dataflash";
-- 
2.39.5



