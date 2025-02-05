Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179A333993;
	Wed,  5 Feb 2025 14:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767282; cv=none; b=NdvyCUiegifAjTcffo+Cj76PuLzug64nR7tEXihuuaSzWwkat/inCK9VY9E25EsWbMBPJTxiV68Hk6pAnFZeYxMF+NzuUr08KcE3NuTsv0ScuToRB+2n0loz1tcK0ZSJkup+6rcwf5H8Wvuk0v/xpMEBGgvBA4bzlHeSTGBTC0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767282; c=relaxed/simple;
	bh=0LJ/r6TaQH1EPADzXFNm63Vr/cH9agfjfm2jjQY1YQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pp2kvCJg88rPNcY2cSRseEj46ncompgag2gkqiqDCMbb1zmF7E24l6Z8uyKzwT5EtlH0hsb7C+WGhL1+IrLm3PnnKshQ022efYSra9KbRSs+RJkndQt9qxodXTAcqYgmP1CH89eGgTNdR7jU4BPd6n3eos7TMFSfoXn27DtlzVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6/o9g2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6/o9g2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772B4C4CED1;
	Wed,  5 Feb 2025 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767282;
	bh=0LJ/r6TaQH1EPADzXFNm63Vr/cH9agfjfm2jjQY1YQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6/o9g2W2fdfS+nFhos/hxZOCKV00nN4RqFbk0HIFMQe9UWUMzJKlCBl16taLFe36
	 nzQOZkHS7MsFqDOGnMqjT3apT1uCvwSTl1OnkQHmI+Ltn+CtZprlFVHDXSA18GmfBb
	 EM3VD/UQcYIiGFcaEmFIA7cI1OcgQ1HNVKuVMBlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 382/623] arm64: dts: qcom: sc7280: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:04 +0100
Message-ID: <20250205134510.839453927@linuxfoundation.org>
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

[ Upstream commit f6ccdca14eac545320ab03d6ca91ca343e7372e5 ]

The SC7280 platform uses PMK8350 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 7a1f4e7f740d ("arm64: dts: qcom: sc7280: Add basic dts/dtsi files for sc7280 soc")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-8-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 55db1c83ef551..d12e0a63fd087 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -83,7 +83,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 	};
-- 
2.39.5



