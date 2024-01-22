Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6956960266;
	Tue, 23 Jan 2024 01:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974670; cv=none; b=U02kQBgqVcu7/XCGfVg5mIeUx49FNdICxfzAnhhnvaJB9BhJrf7QFNS1VMK7cR/nElDkn5GpWevve5tl0EfJjicfx4yg8jr3+O+zd/Cwvl9F6WPlbkbLXqqe0aSH0q9YUe/AH5ZmTNlSS4yFzgtw0MdwMsXMAIqjo2sLgvUxeAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974670; c=relaxed/simple;
	bh=8VhVNhoMXYYDaTHi7ajAelhgPIUzrvIGKO2t3K4genE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgSYq/K5TCuKjOJy1Plvvj4XtEICPk9Isd4cGJcl0blb12AlmtxD45AgosrUS9VD1lXC9YWpnRN+5LyrfNvmuZDqumfx5UECpjL3bGGN5JKBcDJ75T/YWHjo9w2JixHzVUTu9DHcOD9G7xEkv463cLVfUOHGnqawHXU7tQsZzS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7NpoLhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7NpoLhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD56C43394;
	Tue, 23 Jan 2024 01:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974669;
	bh=8VhVNhoMXYYDaTHi7ajAelhgPIUzrvIGKO2t3K4genE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7NpoLhkhlZdo9FQm1c3xeuOqSm04fgakW3rmh0MUbjoCsY3llReJ7AACUeNKcqpQ
	 T3dRAZHzcKs0Mmtgyp4+4CRfhgW9haRPxAh8D+Sngl1krBqDXDz2hkaFvBNgUgOH9w
	 jwBvz3u53p2riV4LnblsEqg2UB4GlOM6zH+B6Dx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 116/583] arm64: dts: qcom: sa8775p: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:52:47 -0800
Message-ID: <20240122235815.703466348@linuxfoundation.org>
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

[ Upstream commit 48d5cf4772ec6268853158d9ffc54612e988ebe6 ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: 09b701b89a76 ("arm64: dts: qcom: sa8775p: add the watchdog node")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20231106144335.v2.6.I909b7c4453d7b7fb0db4b6e49aa21666279d827d@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index 9f4f58e831a4..be31ef35dfe8 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -2173,7 +2173,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sa8775p", "qcom,kpss-wdt";
 			reg = <0x0 0x17c10000 0x0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		memtimer: timer@17c20000 {
-- 
2.43.0



