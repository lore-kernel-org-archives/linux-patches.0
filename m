Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE5E69D09;
	Wed, 21 Feb 2024 13:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521343; cv=none; b=XW/lpbuzWjxDtbOBe8FKXVLcmCCNTU0izlOgm983lkXRX1b8nCUwcq7fZjDc5v2QJDPHxeHXqvRdGWndKs2uF5j1AiJHOjlb6ikp5dhhIjEytP54PJZt5ilUveRkkPaTRxpd8QbLii9QiXvdcTP/UbOjof/7Rop4xGvsU8PSZkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521343; c=relaxed/simple;
	bh=Bq7yhqBPNA/oJzl0wS5Ukv3XUZpNDCDM9WCrMDbLjH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8Gesa5fEvBh+52t1AITH1o1mGBBlsnlRRBGkXwzUlTEglO1VZfZkzGmPboTs2MTpvPRt7aHjI9yYfs9ezZlkX9t7pq00Li53yNYPbGrfqrJFY0P/BMz3QGvSyNjC3IHHmDJdt7TZbaH9j/knw6hHm3vjlsrKFzrEmEc8hBUX1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOwSSKcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOwSSKcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D523AC433C7;
	Wed, 21 Feb 2024 13:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521343;
	bh=Bq7yhqBPNA/oJzl0wS5Ukv3XUZpNDCDM9WCrMDbLjH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOwSSKcdPRnrL1PzxFUcaKrbp5Vcx1hGw7L2LmrBYILiqDtFzEZQyu+TDmr4Ebl8V
	 zgOY7LT6FXqzWDvC3xB3LFvucEmW5jh/Qb96/PWUYlnmyOk+B4t+QhQ7gKhJbtSpIG
	 iho2/Epe2mqtL8/ztwilghX9PLuAwBK9MlxHHZeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/202] ARM: dts: imx27-apf27dev: Fix LED name
Date: Wed, 21 Feb 2024 14:06:30 +0100
Message-ID: <20240221125934.666844453@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit dc35e253d032b959d92e12f081db5b00db26ae64 ]

Per leds-gpio.yaml, the led names should start with 'led'.

Change it to fix the following dt-schema warning:

imx27-apf27dev.dtb: leds: 'user' does not match any of the regexes: '(^led-[0-9a-f]$|led)', 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/leds/leds-gpio.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx27-apf27dev.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx27-apf27dev.dts b/arch/arm/boot/dts/imx27-apf27dev.dts
index 5f84b598e0d0..167f21434fbf 100644
--- a/arch/arm/boot/dts/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/imx27-apf27dev.dts
@@ -53,7 +53,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_gpio_leds>;
 
-		user {
+		led-user {
 			label = "Heartbeat";
 			gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>;
 			linux,default-trigger = "heartbeat";
-- 
2.43.0



