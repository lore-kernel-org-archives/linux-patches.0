Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91D28476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45864C4339B;
	Tue, 28 Mar 2023 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014674;
	bh=AcpU7M4zJ5tALBeAxCB8KAykICbRG8jA+9GdkDMSFgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAA13dgO/hDyVRSx868Ep0pl1zsW3lW52wIp08rIaxUlqhY2jV74ztTHRMxl/ZcIN
	 +g9nINN2hxgR0SoqTUasSFm+aloUUEGzjXmQ31qpf7VqVWGPBb/teDLxsDJzIztbDN
	 p/cy26zWL/WrDWAXcl3P2CVZXECrUZKIAIzqVOx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 012/240] arm64: dts: qcom: sm6375: Add missing power-domain-named to CDSP
Date: Tue, 28 Mar 2023 16:39:35 +0200
Message-Id: <20230328142620.170424156@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 11d5e41f5e129e39bddedc7244a0946a802d2e8e ]

This was omitted when first introducing the node. Fix it.

Fixes: fe6fd26aeddf ("arm64: dts: qcom: sm6375: Add ADSP&CDSP")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230109135647.339224-5-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6375.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6375.dtsi b/arch/arm64/boot/dts/qcom/sm6375.dtsi
index 12cf5dbe5bd64..419df4e3ac91d 100644
--- a/arch/arm64/boot/dts/qcom/sm6375.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6375.dtsi
@@ -1209,6 +1209,7 @@ remoteproc_cdsp: remoteproc@b000000 {
 			clock-names = "xo";
 
 			power-domains = <&rpmpd SM6375_VDDCX>;
+			power-domain-names = "cx";
 
 			memory-region = <&pil_cdsp_mem>;
 
-- 
2.39.2



