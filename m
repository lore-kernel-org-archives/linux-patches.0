Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDD51BEF77;
	Wed, 19 Feb 2025 09:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956389; cv=none; b=d6M8A49IZ17NnmLMgWahhqweVyTqWGBmngcQOXtM8aaV+KtEbXJyNmzRP/E2VTTHVEUG2+kKa51qF8KuaBLSLQMAtVAsY8ESB5ptYlSlyFr3VJCSWa3M8aSxt2jubacv4Y29wPlxC+wrMEFDM3NY1xUUHP5OinABEXXt3TJRXsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956389; c=relaxed/simple;
	bh=Ki4IIYcNs+hEoZCY15nAFoZa15LGmLhkNHrQrdjJMZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1wOMxEJbNxhjjqWuXg4Ik5Y113FzqclB+bV6M2FcKDecqOAAHnh2ldjFfjI+/4IR9l2A+VKH/nj0/5nOge0C4JS1Kmf50rQKUQ3ZsyfZqwvnbof2RJwDygvXeXzbLm43dOPR8VLyeWeuX8LYhhz9apEFuIkoauI6YjhxCMcjWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsXJgpsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsXJgpsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B9CC4CED1;
	Wed, 19 Feb 2025 09:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956388;
	bh=Ki4IIYcNs+hEoZCY15nAFoZa15LGmLhkNHrQrdjJMZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsXJgpsf30tdnk3PaRieSJAw5Mkx3Z8emNFdx0E1hTuNBV1xsd+q6/RM4VNtgCijG
	 aYnpZc845qIDZ1Gabs00s/XMN4viDCWveciwTMgHK9WznmsY+8gI0ILph7T3pVlqRd
	 FQTC4Km3G1HcjhwWsADWeAgq2CD367EqihbHKDbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/578] arm64: dts: qcom: sm8350: correct sleep clock frequency
Date: Wed, 19 Feb 2025 09:22:46 +0100
Message-ID: <20250219082659.343797375@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit f4cc8c75cfc5d06084a31da2ff67e477565f0cae ]

The SM8350 platform uses PMK8350 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-14-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 888bf4cd73c31..5e97ede46a3e2 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -34,7 +34,7 @@
 
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32000>;
+			clock-frequency = <32764>;
 			#clock-cells = <0>;
 		};
 
-- 
2.39.5



