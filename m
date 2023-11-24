Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CEF1A5A4;
	Fri, 24 Nov 2023 19:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXLA/BN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1397CC433C7;
	Fri, 24 Nov 2023 19:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853588;
	bh=p4i51Mk+f2CDNSLS1HR3nVIGW3kQf25WieVs8+QQ254=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXLA/BN/7ocJk4rSNLy8JGgngfV/5CJj9y5Qut643KWDxhI/nQ2TTen+8oTXNxKjo
	 WBHLUqJSUbo0MuIBwS1iru0VQZnxSW47CEuogEBCUn+ttYuUmhjqd9J5zGeHBIB56D
	 DIVdYCbX3GhLWBthyE5XRwrJ5IWS/8x9EQHCePbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Viswanathan <quic_viswanat@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/297] arm64: dts: qcom: ipq6018: Fix tcsr_mutex register size
Date: Fri, 24 Nov 2023 17:54:51 +0000
Message-ID: <20231124172008.895541797@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vignesh Viswanathan <quic_viswanat@quicinc.com>

[ Upstream commit 72fc3d58b87b0d622039c6299b89024fbb7b420f ]

IPQ6018's TCSR Mutex HW lock register has 32 locks of size 4KB each.
Total size of the TCSR Mutex registers is 128KB.

Fix size of the tcsr_mutex hwlock register to 0x20000.

Changes in v2:
 - Drop change to remove qcom,ipq6018-tcsr-mutex compatible string
 - Added Fixes and stable tags

Cc: stable@vger.kernel.org
Fixes: 5bf635621245 ("arm64: dts: ipq6018: Add a few device nodes")
Signed-off-by: Vignesh Viswanathan <quic_viswanat@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230905095535.1263113-2-quic_viswanat@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 43339557d7e5a..dde6fde10f8d3 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -249,7 +249,7 @@
 
 		tcsr_mutex: hwlock@1905000 {
 			compatible = "qcom,ipq6018-tcsr-mutex", "qcom,tcsr-mutex";
-			reg = <0x0 0x01905000 0x0 0x1000>;
+			reg = <0x0 0x01905000 0x0 0x20000>;
 			#hwlock-cells = <1>;
 		};
 
-- 
2.42.0



