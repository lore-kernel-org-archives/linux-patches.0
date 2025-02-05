Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68534198845;
	Wed,  5 Feb 2025 14:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767296; cv=none; b=CSbrD3XnX03E+FfmlBRmh/Km/pxUs6OLCsfzlrMT3q21wByLE6yX62zMFlMA6cdli5Qpe5hwD4t9mBvbSgH7dYucZ4qByFSyhvx0Ynr/h5mn/h868YRPkd2zkPH2OrfmfWvxbuAm1DK+32j1o2DmPOFAyMIpWW+qWEBfKTFqGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767296; c=relaxed/simple;
	bh=OR3sSvSmwPXAgG380Gm31MKX4C263Nv8rfD4M+b8KD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gET7OrGFRFDY6Bv/rf7om5Iyb09kTVZBTYcghGk87l5x6/DlYazO58urdASR5htdBYMXecRjGvL/XwbHcmweKBkUyeJaJQRTd7f8LQkbBOkq+8iC6RVMGvaHx1ppXOyRwdAFm9yDEai0ffanA0U+K7hYMz6iA6qdZ/H5x9zGU6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZF/ONEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZF/ONEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676EDC4CED1;
	Wed,  5 Feb 2025 14:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767295;
	bh=OR3sSvSmwPXAgG380Gm31MKX4C263Nv8rfD4M+b8KD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZF/ONEUtANT3c3Bif86vPjB/IiW+OVtDtKhEd7dY/41PLH1+KwasumxQtVfbEdkE
	 UnzaFJoshtDCBgaZCwFn9EkGYVTdykw/ggGImOKJGN0nAuIscelqr+ZVSqXXbqJ5hz
	 LqIMtPZNKBdaeAXfmAXLnrvCmsLX3XCB6T1qXW3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 384/623] arm64: dts: qcom: sm4450: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:06 +0100
Message-ID: <20250205134510.914669902@linuxfoundation.org>
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

[ Upstream commit 158e67cf3619dbb5b9914bb364889041f4b90eea ]

The SM4450 platform uses PM4450 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: 7a1fd03e7410 ("arm64: dts: qcom: Adds base SM4450 DTSI")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-10-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm4450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm4450.dtsi b/arch/arm64/boot/dts/qcom/sm4450.dtsi
index a0de5fe16faae..27453771aa68a 100644
--- a/arch/arm64/boot/dts/qcom/sm4450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm4450.dtsi
@@ -29,7 +29,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 
-- 
2.39.5



