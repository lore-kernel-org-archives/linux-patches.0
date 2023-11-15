Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE99E3307B
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7Qhkw4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B587C433C7;
	Wed, 15 Nov 2023 19:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077467;
	bh=ZYOT37jNH+9z9couR4yj4M2oOJ5uMJq34Gn4MJpezGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7Qhkw4w1HtdzenQW9605TvCM/jWWK+yykcZgDsv5OLQLzsbqmbsxHuE81u/6gpY7
	 bjxN+paoJ5Xa428aNgcJ2fvS4A1Qi2LZfSP6+HlCTj1rMutGMNwepz2SJeyKuySRtf
	 tNB7f3CszAcqERwumPC6xtz7f9i1IcUT9/LReEs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Matti=20Lehtim=C3=A4ki?= <matti.lehtimaki@gmail.com>,
	Luca Weiss <luca@z3ntu.xyz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 296/603] ARM: dts: qcom: apq8026-samsung-matisse-wifi: Fix inverted hall sensor
Date: Wed, 15 Nov 2023 14:14:01 -0500
Message-ID: <20231115191633.864210802@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Lehtimäki <matti.lehtimaki@gmail.com>

[ Upstream commit 0b73519790d29e4bc71afc4882a9aa9ea649bcf7 ]

Fix hall sensor GPIO polarity and also allow disabling the sensor.
Remove unneeded interrupt.

Fixes: f15623bda1dc ("ARM: dts: qcom: Add support for Samsung Galaxy Tab 4 10.1 (SM-T530)")
Signed-off-by: Matti Lehtimäki <matti.lehtimaki@gmail.com>
Reviewed-by: Luca Weiss <luca@z3ntu.xyz>
Link: https://lore.kernel.org/r/20230922011211.115234-1-matti.lehtimaki@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-apq8026-samsung-matisse-wifi.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-apq8026-samsung-matisse-wifi.dts b/arch/arm/boot/dts/qcom/qcom-apq8026-samsung-matisse-wifi.dts
index 884d99297d4cf..f516e0426bb9e 100644
--- a/arch/arm/boot/dts/qcom/qcom-apq8026-samsung-matisse-wifi.dts
+++ b/arch/arm/boot/dts/qcom/qcom-apq8026-samsung-matisse-wifi.dts
@@ -45,11 +45,11 @@ gpio-hall-sensor {
 
 		event-hall-sensor {
 			label = "Hall Effect Sensor";
-			gpios = <&tlmm 110 GPIO_ACTIVE_HIGH>;
-			interrupts = <&tlmm 110 IRQ_TYPE_EDGE_FALLING>;
+			gpios = <&tlmm 110 GPIO_ACTIVE_LOW>;
 			linux,input-type = <EV_SW>;
 			linux,code = <SW_LID>;
 			debounce-interval = <15>;
+			linux,can-disable;
 			wakeup-source;
 		};
 	};
-- 
2.42.0



