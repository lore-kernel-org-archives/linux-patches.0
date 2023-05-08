Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B85168D6
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B1EC433D2;
	Mon,  8 May 2023 10:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541803;
	bh=+OwJ4bySb0jCs2FjTuDAgfsOumPMXfxAeWB/utoOJTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7VDUrGgc/7fDoStqX6MKcldT8nBTdzT0w8KyAHq1DpaBIE4/uK/8x8haj1ezj/72
	 q0LrW+MM3TfIVkGJEmgJlZzd1YO+DAM9ubSqhtliJXJAdziBHPiqva9YDvHaG+OcAI
	 kesHcQm1qUk/9mMsazuISfjZjIRDm/orvpdwMlE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 231/663] arm64: dts: sdm845: Rename qspi data12 as data23
Date: Mon,  8 May 2023 11:40:57 +0200
Message-Id: <20230508094435.794735820@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 37f7349b56decc91c66f8039712e63740b1f25f9 ]

There are 4 qspi data pins: data0, data1, data2, and data3. Currently
we have a shared pin state for data0 and data1 (2 lane config) and a
pin state for data2 and data3 (you'd enable both this and the 2 lane
state for 4 lanes). The second state is obviously misnamed. Fix it.

Fixes: e1ce853932b7 ("arm64: dts: qcom: sdm845: Add qspi (quad SPI) node")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230323102605.3.I88528d037b7fda4e53a40f661be5ac61628691cd@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2705,7 +2705,7 @@
 				};
 			};
 
-			qspi_data12: qspi-data12 {
+			qspi_data23: qspi-data23 {
 				pinmux-data {
 					pins = "gpio93", "gpio94";
 					function = "qspi_data";


