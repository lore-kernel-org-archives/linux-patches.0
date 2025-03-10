Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0601C5F1B;
	Mon, 10 Mar 2025 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628939; cv=none; b=AZ7+b1UAt3bEn5PREGsHVtJ7ZOBYbdKotGoQR6l+py2+Qfmn+sll+YJvM9qjYezv64SpTLnmp7QKQQ66CawjPOfWmPD+P5U8bRp3D+wCwB/qkw1NmJQWzvrK+tA9kPMMcJD0RZfwDPhysd7X/eDLGU8rGtD7K0ceGm3GHv5Sh0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628939; c=relaxed/simple;
	bh=4+DG6yJnPrzs0GWPcSK5MlDiFzUEoao9YPv06spSAgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJMu4SWoPZSjsxEf3S35SsTTzO/S7qX6NDR2ohGDwdSiBDE3fw1zY9PtMm9z8t8+8cCSSFTBnNuRGsTCTqL+BkoXI5eHeD5+voQLuthNATIH1vlWaaD6rU9XhLs+bjyJYpNro59bLJIsc4T6c+PLAxW09o94BmNd4IF1Izpl4nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ffbexq+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ffbexq+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CC0C4CEE5;
	Mon, 10 Mar 2025 17:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628939;
	bh=4+DG6yJnPrzs0GWPcSK5MlDiFzUEoao9YPv06spSAgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ffbexq+00wzOie7rEQOSZvTyotUx2leM3Bw+S9722khlAGnSWCpR3eCL0AW3jE60V
	 l2X4biKjxQvwu/rQCAB7LGLS8P4Pv2A6rV75MG5oOnIrszrg8PkYuMuy8ml1e9XoeD
	 AshPaIRUmPBQcGXBdIusDRTL0+yk21GveChGLVJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/620] arm64: dts: qcom: sm6125: correct sleep clock frequency
Date: Mon, 10 Mar 2025 17:59:28 +0100
Message-ID: <20250310170550.418880900@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit b3c547e1507862f0e4d46432b665c5c6e61e14d6 ]

The SM6125 platform uses PM6125 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: cff4bbaf2a2d ("arm64: dts: qcom: Add support for SM6125")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-11-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index 2e4fe2bc1e0a8..0f6a9a5cbe178 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -27,7 +27,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			clock-output-names = "sleep_clk";
 		};
 	};
-- 
2.39.5



