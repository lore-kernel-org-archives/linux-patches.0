Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630A51863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB554C433D2;
	Wed, 28 Dec 2022 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239477;
	bh=wAJh6NFGxgffYs+GWGWvdFjhTZ2PvIioEJs3elPeJHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMiZ3cSRBuwA9clDj6RoI2bLNZxUcWZP5tk7QN6Eufl3wMtBRGqUNqp9pN7DZjTqg
	 d6FWTG2q+ZEGsCJZGZapahnGqHyXCDfZ21e4mW1b9TexP93Tlv0I+qGXN/fgU2iFz0
	 ltBtaMONzKNLJe28eICtD5hFJp85nGG3l5x8dlLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0036/1073] arm64: dts: qcom: msm8996: fix sound card reset line polarity
Date: Wed, 28 Dec 2022 15:27:04 +0100
Message-Id: <20221228144329.114374116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 76d21ffc5d425bf7ea9888652c49d7dbda15f356 ]

When resetting the block, the reset line is being driven low and then
high, which means that the line in DTS should be annotated as "active
low". It will become important when wcd9335 driver will be converted
to gpiod API that respects declared line polarities.

Fixes: f3eb39a55a1f ("arm64: dts: db820c: Add sound card support")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221027074652.1044235-1-dmitry.torokhov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index d3cf0677ea28..5cf04c350a62 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -3358,7 +3358,7 @@ wcd9335: codec@1{
 					interrupt-names = "intr1", "intr2";
 					interrupt-controller;
 					#interrupt-cells = <1>;
-					reset-gpios = <&tlmm 64 GPIO_ACTIVE_HIGH>;
+					reset-gpios = <&tlmm 64 GPIO_ACTIVE_LOW>;
 
 					slim-ifc-dev = <&tasha_ifd>;
 
-- 
2.35.1



