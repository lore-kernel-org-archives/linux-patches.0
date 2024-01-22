Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A3914AD1F;
	Tue, 23 Jan 2024 00:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969260; cv=none; b=Ck5E6uJO1kJkeMwJQxVDxERiu0nqC9+/zl85up26kSIIjVSxLvGsdzfQ8s1WZEY7z33zitWualpqk87+SUYjVBNKNT+Lr+6VfFCS0hC7KkWsP4f7MdNLcxae1zAuKofAFSyAJwe/FGts91rsgqR5TQOnlbdarZKxCQtMzRTwnvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969260; c=relaxed/simple;
	bh=HrxSqcbYzT4U6clPfD2or4shCdyhHBEIa/crGv2B/Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mi3Uxk6wb30sYPSSOGbXxhDZEAMCGSvqRrqhWEp/AeQ6HMTj6zFpLkusvaN3isJ9MkE+JzO87rBJLHmznw5BQAqohMIqdHg64K2tUqj0nYlPQtH0cFzWhhw3EHVL4aJvaPeWW1PyBdDH4ZiFOGujn2wM+SDa8neSJCiZHi9TUyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHlWUafI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHlWUafI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7640C433F1;
	Tue, 23 Jan 2024 00:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969260;
	bh=HrxSqcbYzT4U6clPfD2or4shCdyhHBEIa/crGv2B/Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHlWUafIuqd48l/qq1YTdXoLkZfOYczjKQ3Ex4uHsLjZzB32Pq362E1Bel12IXW8T
	 ZoYP7KUPQyvMJHXhKw6W+YstWFfh76xLzCF96Fz1i82a81ZXdvCjEvl8i4EXr2ZYTH
	 XbIWFseeOmR7FtOLFxvuvufXvA5xqpyYxBNBiH3A=
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
Subject: [PATCH 6.7 128/641] arm64: dts: qcom: sa8775p: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:50:32 -0800
Message-ID: <20240122235822.061964058@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index b6a93b11cbbd..5e1d6756f245 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -2181,7 +2181,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sa8775p", "qcom,kpss-wdt";
 			reg = <0x0 0x17c10000 0x0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		memtimer: timer@17c20000 {
-- 
2.43.0



