Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577E91802AB;
	Wed,  5 Feb 2025 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766691; cv=none; b=c1MWlNycUUkLmQFUWwBrzgO+KOtztmLnkKICG3TMXd7GifjmBbZzDE/mopSr0ipHvD5zMH1JFr1ExbngsU8FA82qpVSGjAVL5ae2rvOf1OQD059aBLSvHipGcAowviBSDnKeQc63xwiIvrPigbUHggWZYsBkeZkMtqj9B54d7FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766691; c=relaxed/simple;
	bh=ORNGp7/pHSP2QYievUVFg9Tt86A49dJNxFw0b0Hq27U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idLbloCswS5gWFL+rgWE+qC+LTzyOEwyrjmHPCZfkrbdeLhxKuBi6OUckMrT35cZRwbBiWs6l3v3kt4z0DurFZBtGqCSoV8+/5Ccgm4VdEODx68dnoIguRR0BeZNQPxwg1WTMNtmIFvhWdA3QHvEqRu+6sA2jr5YFqVPkIVfqB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FiDpOdhq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiDpOdhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6EBC4CED1;
	Wed,  5 Feb 2025 14:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766691;
	bh=ORNGp7/pHSP2QYievUVFg9Tt86A49dJNxFw0b0Hq27U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiDpOdhqojD/R/nOv3AK2JxSsoqExweGdfxclWIJgWY6puVEsmde8+FrXLnLGdw9q
	 V9jTvxGOKPAA0acoiRO3vtAexglqcUiJyx6xXl5FyN5tudsR+hVhVqxx0wJtB2i1ke
	 2qkiGX8WIM/MA/hQPPY/n1qIZgvKN0zfXao9UKXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/590] arm64: dts: qcom: sm4450: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:41:46 +0100
Message-ID: <20250205134508.700430023@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1e05cd00b635e..0bbacab6842c3 100644
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



