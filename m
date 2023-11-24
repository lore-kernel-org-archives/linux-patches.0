Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7233833CFB;
	Fri, 24 Nov 2023 18:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OG0+b0DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9530C433C7;
	Fri, 24 Nov 2023 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851118;
	bh=w/f4zRt/JshF1vU8YbZc5JgXEObrUr6z3QdWnUyddSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OG0+b0DYLkttIoaiGCjL7wdeGjdAkSyd18tSroU2/XdYkNaPok8LhHD5fifGzE3Y2
	 Dco3RWMPolZBT9wPLTMQ6fqbKrpyXloaYVYenavSerFq3Dx1sS+lpR7GrC627ebsuy
	 zE+KJKyCbOt2uskura1shEb20AeT8QhAtoeQ+tFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Viswanathan <quic_viswanat@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.5 320/491] arm64: dts: qcom: ipq9574: Fix hwlock index for SMEM
Date: Fri, 24 Nov 2023 17:49:16 +0000
Message-ID: <20231124172034.186385343@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Viswanathan <quic_viswanat@quicinc.com>

commit 5fe8508e2bc8eb4208b0434b6c1ca306c1519ade upstream.

SMEM uses lock index 3 of the TCSR Mutex hwlock for allocations
in SMEM region shared by the Host and FW.

Fix the SMEM hwlock index to 3 for IPQ9574.

Cc: stable@vger.kernel.org
Fixes: 46384ac7a618 ("arm64: dts: qcom: ipq9574: Add SMEM support")
Signed-off-by: Vignesh Viswanathan <quic_viswanat@quicinc.com>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230904172516.479866-5-quic_viswanat@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/ipq9574.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/ipq9574.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
@@ -174,7 +174,7 @@
 		smem@4aa00000 {
 			compatible = "qcom,smem";
 			reg = <0x0 0x4aa00000 0x0 0x100000>;
-			hwlocks = <&tcsr_mutex 0>;
+			hwlocks = <&tcsr_mutex 3>;
 			no-map;
 		};
 	};


