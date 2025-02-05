Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F22F170A37;
	Wed,  5 Feb 2025 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766595; cv=none; b=aWT64fd/9HqV/6iix8KADd5jbloS4gcjLVPUnCsycndP6ZSLn1I9MU5pNEoS+sLZH6oViIpCq4/+Y/c+CjDn7yqsku+KwJ8+Tdq9CIvWXUCH/i467XJuxFtnSs1zg2rcF+N3tcUl+j9jJVmET3d01t3YNADzn7xRWsf17dfe0Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766595; c=relaxed/simple;
	bh=ivQeF5sVr7mKA4+9YQNJea5c42NHym7NdZn2iHtDYfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QkTJv/g+3hOKNR/6WsvGD2xAWhSYF9R1bFru7FWbFeG7nRF1w7M3YYSxXlAJshizvexrRoYOqSoIic9JpkkKEhJlVQwtZvijU4clDnkoI8B4mbR22PIwNsWa9DS2EgEa76Y000BuGFiUdYKnMwDBu9QLtRo8k067MAAtdkgRCxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07k9U7eZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07k9U7eZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29431C4CEE8;
	Wed,  5 Feb 2025 14:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766594;
	bh=ivQeF5sVr7mKA4+9YQNJea5c42NHym7NdZn2iHtDYfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07k9U7eZL9rXHMoDdOZNEe4XcQ9j9HifEFz6ABkiJ9S7BocgCWXSxjy5RZjfC9L0T
	 STVFQeVbzdfK4owriO0vP3rUse0Vny42qFbMm5XCYQeqGy+z42oHh0UI1Pvtdw68Xe
	 6lckKMFC5QdWp2C30FGJod1uqIj+6lIEbspA1yBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/590] arm64: dts: qcom: sa8775p: Update sleep_clk frequency
Date: Wed,  5 Feb 2025 14:41:33 +0100
Message-ID: <20250205134508.206976828@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 30f7dfd2c4899630becf477447e8bbe92683d2c6 ]

Fix the sleep_clk frequency is 32000 on SA8775P.

Fixes: 603f96d4c9d0 ("arm64: dts: qcom: add initial support for qcom sa8775p-ride")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20241025-sa8775p-mm-v4-resend-patches-v6-1-329a2cac09ae@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi b/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
index 0c1b21def4b62..adb71aeff339b 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
@@ -517,7 +517,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32764>;
+	clock-frequency = <32000>;
 };
 
 &spi16 {
-- 
2.39.5



