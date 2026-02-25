Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBF5284884;
	Wed, 25 Feb 2026 01:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983881; cv=none; b=OwfeX03c/plM9Tn48bJ8igADGG3+P35Hv1VaPYXno8Jg0tCQNDwkLBxzc28WKZ5WyOtwElkFncUm/sT7b47DAXrQaf0aTxKcNHQVFq4dafBtRfPKa36OawlMclreQzJZwZL11iqveS2eSopWa91gkddZgGf8aMwK9iOH4MLLLVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983881; c=relaxed/simple;
	bh=rnwuYltwt4AoKnFmNXNkdknbGIClw0+j07FQRzfjn+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHQUpHnUZwCHvxspt9xTI3mieUzLhhNGHdeBgXfU+TXGhxVPQSO5RpJdwXJfVNY2qs7Qgy86Sodogf165vNQBxF9Dyhv+IIdiC3/gqTMyeMDpVM9p/uoGQ/6+f1rIDp9H/tPZDkbQ/MAYHaRU7O2+RcnB4yu4Of+Uq4cSQwo0/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGqFJdgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGqFJdgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAF8C19423;
	Wed, 25 Feb 2026 01:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983880;
	bh=rnwuYltwt4AoKnFmNXNkdknbGIClw0+j07FQRzfjn+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGqFJdgNRcCjwILKj6D9Mgw8hlsHWJMFbb2ey+Yh6S11nxCH5DdE7xUxtoYwnk+2u
	 uLCYRTJ+R3NTtoSlhJosQMPbQC5O10q3B5N8crFfKkoELLXAAE+qyEiV6MQr5s33wl
	 l4qbI3ZC95LgTmgmylypWx9eIMDgLqClajXevSVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 155/641] arm64: dts: amlogic: c3: assign the MMC signal clocks
Date: Tue, 24 Feb 2026 17:18:01 -0800
Message-ID: <20260225012352.841213510@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 69330fd2368371c4eb47d60ace6bca09763d24a0 ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clocks to make sure they are properly configured

Fixes: 520b792e8317 ("arm64: dts: amlogic: add some device nodes for C3")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-1-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi b/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
index 07aaaf71ea9ae..f226df3ce153b 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
+++ b/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
@@ -969,6 +969,10 @@ sdio: mmc@88000 {
 				no-sd;
 				resets = <&reset RESET_SD_EMMC_A>;
 				status = "disabled";
+
+				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_A>;
+				assigned-clock-rates = <24000000>;
+
 			};
 
 			sd: mmc@8a000 {
@@ -984,6 +988,9 @@ sd: mmc@8a000 {
 				no-sdio;
 				resets = <&reset RESET_SD_EMMC_B>;
 				status = "disabled";
+
+				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_B>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			nand: nand-controller@8d000 {
-- 
2.51.0



