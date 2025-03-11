Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0FD1EA80;
	Tue, 11 Mar 2025 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706537; cv=none; b=WOKvEhIdUzGJGkqym3WsL1FD+vDaioGDWni5hr+Wm2JD2DKcJUm9yRdTCM1Tn+qr2DUwqlKih5wq/pEPNQ318YglE32/PcPLFNkshx4zGIoUW1wxh4FJEbiHxj8EA3CwgZ6UhdefOIc5ZzVnfIDmgjZdNzsfLNgQAhxnuAk4kEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706537; c=relaxed/simple;
	bh=8y59aGgDHX5Nx9U2siixcPL3j0SE8IzlqX3C3p3yh1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pevdeV0gxqZR58V9IL2jZDobM5gJDqIr0jItFhD5Lxgc6x252lwSMXsv3Ghw9WsNeccokHnqvCEuoXi/c8N/5GE5vbRCdR1xb03ugJ8Bs/bH56mmdeV1zIaPATKMZk+zGF7C2JLNsk5FomHz3gw5SZxJcsvInXKMs0UPYwxXbPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcVMauMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcVMauMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E160FC4CEE9;
	Tue, 11 Mar 2025 15:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706537;
	bh=8y59aGgDHX5Nx9U2siixcPL3j0SE8IzlqX3C3p3yh1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcVMauMJ+82TNaYYJ/JzmFtsNQ5AiF84eMCH8IE1KYsjJFdawWkp3nSzixT+B1mnB
	 CR5gPJhCMyYF5w1S6DwOkwA9XGxzswd3Iocw7IL2Ch38k+/puxFUUKKIT6+jpvUtqq
	 PSJGu3ot+6nOyoYdfqdaYqYCjH1rcDHIcnDmirTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/462] arm64: dts: qcom: msm8994: correct sleep clock frequency
Date: Tue, 11 Mar 2025 15:55:41 +0100
Message-ID: <20250311145801.312157587@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a4148d869d47d8c86da0291dd95d411a5ebe90c8 ]

The MSM8994 platform uses PM8994/6 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-3-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index caaf7102f5798..9a8c365abbda4 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -24,7 +24,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 			clock-output-names = "sleep_clk";
 		};
 	};
-- 
2.39.5



