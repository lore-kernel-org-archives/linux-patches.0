Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DE6184535;
	Tue, 30 Jul 2024 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355783; cv=none; b=ABl6taqb5ujyo0ZSoY3vVLmFTvu7ptDbxJb4CXYkl9QHBhbGCa1knroqJUtcqMKg04cqO5VBTBZJ4q8u3MVtOIeTzZCBST06CRHpXSTsixo5Ii74vCchGlevM0prO6isGuryTEmFYRtuTvg5xSz+v8viApP19aZ4kCVlBs/Hh7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355783; c=relaxed/simple;
	bh=/TisCXGcqmaHONbqvz+UBjeHpksiQOlcEQ4DIoapjYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APsspmTPFSFdmzcXk9SbG4G7rl5v+hhFhxMbb99C9js0MCViRUORvmdAY+kExQ/yCbzivbHTgvdAFjTnQYvnOW54QjK2npP2FPqlPVEHc35HaPWQFSbOyDFfI80UjHXxR9hNFz9yTaKgRUYCtbH5HQRoU0K/+h/eKpb3pSP9Gpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNPIdOry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNPIdOry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10437C32782;
	Tue, 30 Jul 2024 16:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355783;
	bh=/TisCXGcqmaHONbqvz+UBjeHpksiQOlcEQ4DIoapjYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNPIdOry4vhQPy0jXdI73vmVFI5PEfiUZMSwumpQOuafjnHk3Ng2vlKt+f/QA3ETu
	 MDW+tS8mPCF6A26qrPn4Po+Gvd3XeqJAd6zcW14M1IU0C7Dq95fh0puZYHqgDoXC52
	 7hP85ELMr5mZK28q2xunhUvtvlVWSHYthjGVZE7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Komal Bajaj <quic_kbajaj@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 088/809] arm64: dts: qcom: qdu1000: Add secure qfprom node
Date: Tue, 30 Jul 2024 17:39:24 +0200
Message-ID: <20240730151728.113631561@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Komal Bajaj <quic_kbajaj@quicinc.com>

[ Upstream commit 367fb3f0aaa6eac9101dc683dd27c268b4cc702e ]

Add secure qfprom node and also add properties for multi channel
DDR. This is required for LLCC driver to pick the correct LLCC
configuration.

Fixes: 6209038f131f ("arm64: dts: qcom: qdu1000: Add LLCC/system-cache-controller")
Signed-off-by: Komal Bajaj <quic_kbajaj@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Link: https://lore.kernel.org/r/20240618092711.15037-1-quic_kbajaj@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qdu1000.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qdu1000.dtsi b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
index f90f03fa6a24f..1da40f4b4f8ac 100644
--- a/arch/arm64/boot/dts/qcom/qdu1000.dtsi
+++ b/arch/arm64/boot/dts/qcom/qdu1000.dtsi
@@ -1478,6 +1478,21 @@ system-cache-controller@19200000 {
 				    "llcc7_base",
 				    "llcc_broadcast_base";
 			interrupts = <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>;
+
+			nvmem-cells = <&multi_chan_ddr>;
+			nvmem-cell-names = "multi-chan-ddr";
+		};
+
+		sec_qfprom: efuse@221c8000 {
+			compatible = "qcom,qdu1000-sec-qfprom", "qcom,sec-qfprom";
+			reg = <0 0x221c8000 0 0x1000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			multi_chan_ddr: multi-chan-ddr@12b {
+				reg = <0x12b 0x1>;
+				bits = <0 2>;
+			};
 		};
 	};
 
-- 
2.43.0



