Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5905F55C2E;
	Tue, 23 Jan 2024 01:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974030; cv=none; b=KBNLl8A8tDk02pI3nU8OCn3Lu1c5QhhE1J4C57UWrJBgqBuAkH0o9XYOy+oWk+kMqCHRftgZRwiWe5+TszDBhrTcZSs7noAiB2g37v/Pr4ppJXcEZapoRN/YDMzZQtnR/6emtIssADFZwrSCoiCsu5qxD8QMMmxsV1SJNghmdn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974030; c=relaxed/simple;
	bh=loCHDhtGjFYvXe5j9ftTfx+cGJhbtJkLlKrnTi5ijFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGVAQldF81BQB7pqmR5nuPs3XPmakQKubmb6rccwuxGTUgNNveQt7oXwoUKpmEXN1P/8HoGw7KoyuktE1eDfuzogbSNCK21TIXi4rWWPDxMz+fpAPTX8sv+kqnXmT1wSiCmrvsp9giWMP3PESXRpUZ9GuPHmRX43PKcL6KOvd8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hLJyjcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hLJyjcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E5BC43394;
	Tue, 23 Jan 2024 01:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974029;
	bh=loCHDhtGjFYvXe5j9ftTfx+cGJhbtJkLlKrnTi5ijFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hLJyjcvwegOevTqYYWTpO1Jt9q208rJ1+Y1k+veZDqmRQTtGchRqChtp62FJe9jG
	 K/2DBKAT3C7FHAV9y1sRSvPZvEApw5cVjatYtoyH0zKd5M65dpoyp3aZp1ox4bLEXg
	 Z/QaSahaCKBRBPqltCaFqTPaHuV4R4W8Aqc3Q/7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/374] arm64: dts: qcom: sdm845: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:56:28 -0800
Message-ID: <20240122235749.239439195@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 263b348499454f38d36b9442c3cf9279c571bb54 ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 36c436b03c58 ("arm64: dts: qcom: sdm845: Add watchdog bark interrupt")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.3.I16675ebe5517c68453a1bd7f4334ff885f806c03@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 6a0e30cbf88f..5a78ee8622c9 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4725,7 +4725,7 @@ watchdog@17980000 {
 			compatible = "qcom,apss-wdt-sdm845", "qcom,kpss-wdt";
 			reg = <0 0x17980000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		apss_shared: mailbox@17990000 {
-- 
2.43.0



