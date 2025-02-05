Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD83916DEB1;
	Wed,  5 Feb 2025 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767346; cv=none; b=axo7hpZKG49EcaT1kjB+qxw0Ghg4JbaofHXvGiuibMY3ch4eBElIMIEYS6akX8qBNXKo6+8awW74+ZrhoFAWDWvjFa817F9warTdJbbYR6uY0WCld/PdTHshHAvE0vT6UhwU984zWarIlWpe4QEgTZJD0pHcwg64DqWgzan8ZeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767346; c=relaxed/simple;
	bh=6GaKGWKdenWQsyWjMYkmzQJcXq7HuGJ4Jyr5+NZQJMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gf2eWd0VqeA3zi6Vt38nrRSB6Rc+/E62v23uNF6un5hvvIBy1MtBKHs+Y2HllRfC6FsXYL/h5ErtEwMhrzAnTGei6SWjDQL/8mj3WlY0KcPxSL/VN33O9xNkg1OiYlxn1XAl6H9R45BBnDLjds/Hr3Xq39Cnxz43aN2xuW955Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUOvTMsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUOvTMsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC208C4CED1;
	Wed,  5 Feb 2025 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767346;
	bh=6GaKGWKdenWQsyWjMYkmzQJcXq7HuGJ4Jyr5+NZQJMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUOvTMsvzf3PQBUaVIH7WOSSZr8Vd0bJsM/3017LvEX5309xELUn4dLKmfUuGGmru
	 X11NCl+Q0geVWTuI0dpvyVtYh7JRZ1BDEXRPS32Fad//ujblxwvXDHrTJWjZqq0cVk
	 FDA2D+HlVhMcYAUImqi15vncDWCbLZL5yHMYXphQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 391/623] arm64: dts: qcom: sm8650: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:13 +0100
Message-ID: <20250205134511.180581866@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 448db0ba6ad2aafee2cbd91b491246749f6a6abc ]

The SM8650 platform uses PMK8550 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 6fbdb3c1fac7 ("arm64: dts: qcom: sm8650: add initial SM8650 MTP dts")
Fixes: a834911d50c1 ("arm64: dts: qcom: sm8650: add initial SM8650 QRD dts")
Fixes: 01061441029e ("arm64: dts: qcom: sm8650: add support for the SM8650-HDK board")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-17-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650-hdk.dts | 2 +-
 arch/arm64/boot/dts/qcom/sm8650-mtp.dts | 2 +-
 arch/arm64/boot/dts/qcom/sm8650-qrd.dts | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650-hdk.dts b/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
index f00bdff4280af..d0912735b54e5 100644
--- a/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8650-hdk.dts
@@ -1113,7 +1113,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &swr0 {
diff --git a/arch/arm64/boot/dts/qcom/sm8650-mtp.dts b/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
index 0db2cb03f252d..76ef43c10f77d 100644
--- a/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8650-mtp.dts
@@ -730,7 +730,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &swr0 {
diff --git a/arch/arm64/boot/dts/qcom/sm8650-qrd.dts b/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
index c5e8c3c2df91a..71033fba21b56 100644
--- a/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/sm8650-qrd.dts
@@ -1041,7 +1041,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32000>;
+	clock-frequency = <32764>;
 };
 
 &spi4 {
-- 
2.39.5



