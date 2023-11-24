Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50BA2E84A;
	Fri, 24 Nov 2023 19:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVwyx9qN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B27C433C8;
	Fri, 24 Nov 2023 19:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852829;
	bh=iaLDceU8vodkIsCar/t/Lm9/BAVPyI3I3scM19y9Pc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVwyx9qNbDDqgqgYMQ6O6WI8Mm5jKVNmp3BcfybItvQxcsytxrwmK4xBT8EXCZ08H
	 GjWiq+ciWouE/pIeFg3Bcma7d1saai9s+GX+UqNH6ZsAPxxlTO8sxUMXjZahVm4WfZ
	 zC+IilbQMdsvoZXNjf6PPgorjmf1VhThWgXjmWjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Viswanathan <quic_viswanat@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 115/193] arm64: dts: qcom: ipq6018: Fix hwlock index for SMEM
Date: Fri, 24 Nov 2023 17:54:02 +0000
Message-ID: <20231124171951.835887028@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Viswanathan <quic_viswanat@quicinc.com>

commit 95d97b111e1e184b0c8656137033ed64f2cf21e4 upstream.

SMEM uses lock index 3 of the TCSR Mutex hwlock for allocations
in SMEM region shared by the Host and FW.

Fix the SMEM hwlock index to 3 for IPQ6018.

Cc: stable@vger.kernel.org
Fixes: 5bf635621245 ("arm64: dts: ipq6018: Add a few device nodes")
Signed-off-by: Vignesh Viswanathan <quic_viswanat@quicinc.com>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230904172516.479866-3-quic_viswanat@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -175,7 +175,7 @@
 	smem {
 		compatible = "qcom,smem";
 		memory-region = <&smem_region>;
-		hwlocks = <&tcsr_mutex 0>;
+		hwlocks = <&tcsr_mutex 3>;
 	};
 
 	soc: soc {


