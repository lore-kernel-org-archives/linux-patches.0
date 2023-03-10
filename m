Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1B8881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970FCC4339E;
	Fri, 10 Mar 2023 14:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459517;
	bh=Mpqy0MfFwjALfinlvC6mTVmP3V8ITErR9Ha4HaHL3jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xq8fGzY+S7D6wTYAhJo9BnuRTxaZixZDnYFrmPW8mFP1omeTkcXwEo6dHy9Jlr5VZ
	 HihBS2f9KSj8IO23g1d5cv4glPIkFf8AYnukF3LziJrYenFSobLtcUKZd6VqJOclAP
	 jtKBUxXeTgeaBtXiwoUmpiCFvB7m78qhJMQM0dSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/529] arm64: dts: amlogic: meson-gxl-s905d-sml5442tw: drop invalid clock-names property
Date: Fri, 10 Mar 2023 14:32:53 +0100
Message-Id: <20230310133806.399570338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit e3bd275ccbacf5eb18eaa311cea39f8bf8655feb ]

Fixes:
bluetooth: 'clock-names' does not match any of the regexes: 'pinctrl-[0-9]+'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-5-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts
index 0b95e9ecbef0a..ca3fd6b67b940 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts
@@ -75,6 +75,5 @@ bluetooth {
 		enable-gpios = <&gpio GPIOX_17 GPIO_ACTIVE_HIGH>;
 		max-speed = <2000000>;
 		clocks = <&wifi32k>;
-		clock-names = "lpo";
 	};
 };
-- 
2.39.2



