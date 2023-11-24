Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277E33E9;
	Fri, 24 Nov 2023 18:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPoxibHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A49C433C7;
	Fri, 24 Nov 2023 18:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852117;
	bh=NCa7/0XC+EGIZyBcmwIWIUgKMuUl88o60ANck1U2GUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPoxibHs1o8LAHQe1071ROnZVSuMd9z8SGF5jCd1ehE8daR5uo1fe7LpLvrtoljcv
	 89IOIWVBZ223OACQrtHmr3H+PU1j+wVdEIWJCCekYHyQd+XWVszd3oUQNKccfi5NR+
	 3mX6wW7fJ8j4fdBJJD2MiQVS3M6uhuOLgTcBU7BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Viswanathan <quic_viswanat@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 227/372] arm64: dts: qcom: ipq8074: Fix hwlock index for SMEM
Date: Fri, 24 Nov 2023 17:50:14 +0000
Message-ID: <20231124172018.063708906@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Viswanathan <quic_viswanat@quicinc.com>

commit 8a781d04e580705d36f7db07f5c80e748100b69d upstream.

SMEM uses lock index 3 of the TCSR Mutex hwlock for allocations
in SMEM region shared by the Host and FW.

Fix the SMEM hwlock index to 3 for IPQ8074.

Cc: stable@vger.kernel.org
Fixes: 42124b947e8e ("arm64: dts: qcom: ipq8074: add SMEM support")
Signed-off-by: Vignesh Viswanathan <quic_viswanat@quicinc.com>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230904172516.479866-4-quic_viswanat@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -90,7 +90,7 @@
 			reg = <0x0 0x4ab00000 0x0 0x00100000>;
 			no-map;
 
-			hwlocks = <&tcsr_mutex 0>;
+			hwlocks = <&tcsr_mutex 3>;
 		};
 
 		memory@4ac00000 {


