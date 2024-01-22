Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037DD5FDBB;
	Tue, 23 Jan 2024 01:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974663; cv=none; b=CjvBHQO1XSkC1BzaoWzE4Gn5SLWKCiqBCTceBAwCmXTU8ihZ8mwTDc2tcyVhzYPOIiWqPRZ7LA81dJ0hUiI8ROazFHKgo+VAxfcjWAEZZ8J3run08KZ1JaxbcsvDI6pAvm1LM+sIWnbZqVrJK1/u4HzX70MxLRuJIRAApi792cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974663; c=relaxed/simple;
	bh=TqPd3W6oqqMVDeWvphtlljEtXwHoztKxgMVKUj/Xlgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYX1UNe5DFctFvOyUXN/FpGMCKVWfZebuTKtrt57vYY8PQ9VCUXvNIIlAOuR3E0zI37EIhlsk1AStEtAiofMBHQXlBufWwAjwYUU/7lEX+r+0YcZJA+RVjQ4Pe4qJ4PXsE3hOqy8BIwwrXYjuX0TpT4AkxbeN8fZuw6kiWKaXV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBdw5vcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBdw5vcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFCFC43394;
	Tue, 23 Jan 2024 01:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974662;
	bh=TqPd3W6oqqMVDeWvphtlljEtXwHoztKxgMVKUj/Xlgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBdw5vcSOa5iTs0Rkfr24pmhjeBW9s/uyNgc8gOvV6OtXqcWLa16o1JQIhpzOruwF
	 mPdr7je2JbjmLMeVCI8SR+avWD7zDHxibsMliVofafuz//f6wV9tycUK5wpD3CoJIz
	 4tWWomLVEqNo64raPv6EsoMM+EX6G32lFhwwpQ7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/583] arm64: dts: qcom: sc7280: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:52:43 -0800
Message-ID: <20240122235815.590984442@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 6897fac411db7b43243f67d4fd4d3f95abf7f656 ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 0e51f883daa9 ("arm64: dts: qcom: sc7280: Add APSS watchdog node")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.2.I11f77956d2492c88aca0ef5462123f225caf4fb4@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 6f2a8f60856d..95c35892fb85 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -5204,7 +5204,7 @@ watchdog: watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sc7280", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 			status = "reserved"; /* Owned by Gunyah hyp */
 		};
 
-- 
2.43.0



