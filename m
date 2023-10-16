Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDD01A29A
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ys2YC+yS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B536AC433C8;
	Mon, 16 Oct 2023 08:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446494;
	bh=GLG5J/NH2zcGw2HfIai20G4BNGRYo/8sR3f9USHvXRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ys2YC+ySQz+wFbTs85/0L9+cIZteArLTKAVV1anvVN7/c3Zbi4BVm15TqZAv+ikJt
	 c1fCvaQvyWPZjR8aIIuCnM3JecLh4ji9Ra7LPyinF/c08+oqloi/NXP9N+7jkybF+2
	 QrP1yfN6h3xMbb4/PFWMH0T2bft3CHD+Q4jxJIfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 014/131] arm64: dts: qcom: sm8150: extend the size of the PDC resource
Date: Mon, 16 Oct 2023 10:39:57 +0200
Message-ID: <20231016084000.422407556@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit cf5716acbfc6190b3f97f4614affdf5991aed7b2 upstream.

Follow the example of other platforms and extend the PDC resource region
to 0x30000, so that the PDC driver can read the PDC_VERSION register.

Fixes: 397ad94668c1 ("arm64: dts: qcom: sm8150: Add pdc interrupt controller node")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230905-topic-sm8x50-upstream-pdc-ver-v4-2-fc633c7df84b@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3701,7 +3701,7 @@
 
 		pdc: interrupt-controller@b220000 {
 			compatible = "qcom,sm8150-pdc", "qcom,pdc";
-			reg = <0 0x0b220000 0 0x400>;
+			reg = <0 0x0b220000 0 0x30000>;
 			qcom,pdc-ranges = <0 480 94>, <94 609 31>,
 					  <125 63 1>;
 			#interrupt-cells = <2>;


