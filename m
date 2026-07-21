Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B001546AA8F;
	Tue, 21 Jul 2026 15:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648429; cv=none; b=oXNebFhQKks/inLkTHFdkj1y7SkaGeuOJjSN7TMoay2qXaIKWFSYN3gx+LnIU8XBQebBlmRRsyaY3RTCwMCXUIrJHLjc9k91dW/5LRF0itXWquAOdC8kPhg3JVD4sOWbAKfRHK+f1GYTqNVG9skECxOCG/rkg53bs/h6QIo6uxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648429; c=relaxed/simple;
	bh=LtKLKztWkdvs4NxWl1jjXlXAkuTehHETgHsg1QHjJAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5gLD2J1ZACwgXAYJanJ351eMI06ak1YAnfT7qLcnSLWs7VhjlG9d5Pw2bn7+zu9qbU2SMG3XxkLIU9I625g1NaKWLd+V5l9qYaF8qGaQtJLntzb88Q2fNhH+pqwT+b4dYh3Cq8tBZIjiVl/Iy5pf41qPPd47/YlT74ImgBw9gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtL7Vml1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtL7Vml1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209811F000E9;
	Tue, 21 Jul 2026 15:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648428;
	bh=AdzvLNNpRdiily2qGewz1DXxJNJ54KeHz1RNWuXjir8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtL7Vml1MZCGI2067sTRFJbPN7+hEJjJ/l7QpQfs3xkc5gBqWvqBfluI3eANoltOu
	 k6wPXQOCYTXUlTsjbI/CR+WsAHV+7ar1oOCoBVUJ+1aULjnkVtJFhFcbqG3UbNp5L1
	 fshcre6jPvkcp7AYe3gsT0rS8atR0Ig5/Ox9Go9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0196/2077] arm64: dts: qcom: kodiak: Fix ICE reg size
Date: Tue, 21 Jul 2026 16:57:49 +0200
Message-ID: <20260721152557.303687068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

[ Upstream commit fa9c7403af64d3e56a6c20dedc60e0a55b527509 ]

The ICE register region on Kodiak is currently defined as 0x8000 bytes.
According to the hardware specification, the correct register size is
0x18000.

Update the ICE node reg property to match the hardware.

Fixes: dfd5ee7b34bb ("arm64: dts: qcom: sc7280: Add inline crypto engine")
Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260402-ice_dt_reg_fix-v1-1-74e4c2129238@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index 988ca5f7c8a0ec..fdde9f065199ee 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -2578,7 +2578,7 @@ ufs_mem_phy: phy@1d87000 {
 		ice: crypto@1d88000 {
 			compatible = "qcom,sc7280-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
-			reg = <0 0x01d88000 0 0x8000>;
+			reg = <0 0x01d88000 0 0x18000>;
 			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 		};
 
-- 
2.53.0



