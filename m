Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228B62FDC32;
	Tue, 12 Aug 2025 17:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020408; cv=none; b=s+PJO2BZq0Lm9gdiEMpuwO2OPfJ58osCrbz85bfL86SOgGBn7vtTU/UeJmmr9+Ty/CWnw2ie2XnyhEnVwa9xrLPTcs/cJt+cScj1Gnl0QNWn9ja54Cds6VYG8o326EyIVgGsI0xLTAdBQQmwFYarcnGdTwsSm9x9Lns9+2b83Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020408; c=relaxed/simple;
	bh=N3yfz90Y4XKWCuCJwQl7WWagTf5pU7UkAW6+LixWU6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um1LzuDNez9TKKo17qw0s6Xs3cB1l/dLBYMIZdYsa6Np+O+2mpwX+LgtA72F2EkDlIeXixLWY6dw+1nfbjdLidzjd/uaphETMQ1B1z+OVFLsJBqEbTcr6jtBxtE05JcjMOFDMckeQ3ERtms6EpwHNWO0S9fAddJBmjVf4TEzUHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFxeUhEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFxeUhEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82356C4CEF7;
	Tue, 12 Aug 2025 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020408;
	bh=N3yfz90Y4XKWCuCJwQl7WWagTf5pU7UkAW6+LixWU6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFxeUhEfPnUPl6qFsOqvNynY8ByBSmsBf4SB6j7yZcltAgM/AbmUPAtXsSfyLSt1l
	 +TBdVmvDCDVSG9wjLTtEfJBfZjgbkZBSbU8PX113H1RFKOHi0LFx3ZF+6V7Wvsbjzm
	 kNATDnPSPokk9vHZ/gDl8MRCIBBYRGrHraAIoQpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/253] arm64: dts: qcom: sc7180: Expand IMEM region
Date: Tue, 12 Aug 2025 19:27:41 +0200
Message-ID: <20250812172951.836374523@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 965e28cad4739b11f1bc58c0a9935e025938bb1f ]

We need more than what is currently described, expand the region to its
actual boundaries.

Fixes: ede638c42c82 ("arm64: dts: qcom: sc7180: Add IMEM and pil info regions")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250523-topic-ipa_mem_dts-v1-3-f7aa94fac1ab@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index a9f937b06847..41f6f9abf52f 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3244,18 +3244,18 @@ spmi_bus: spmi@c440000 {
 			cell-index = <0>;
 		};
 
-		sram@146aa000 {
+		sram@14680000 {
 			compatible = "qcom,sc7180-imem", "syscon", "simple-mfd";
-			reg = <0 0x146aa000 0 0x2000>;
+			reg = <0 0x14680000 0 0x2e000>;
 
 			#address-cells = <1>;
 			#size-cells = <1>;
 
-			ranges = <0 0 0x146aa000 0x2000>;
+			ranges = <0 0 0x14680000 0x2e000>;
 
-			pil-reloc@94c {
+			pil-reloc@2a94c {
 				compatible = "qcom,pil-reloc-info";
-				reg = <0x94c 0xc8>;
+				reg = <0x2a94c 0xc8>;
 			};
 		};
 
-- 
2.39.5



