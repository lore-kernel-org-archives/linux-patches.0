Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C5F57321;
	Tue, 23 Jan 2024 01:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974022; cv=none; b=YrbGGrnPQSS5CHPjHwFvEzbL049oGRxnFKYf174C2Uhyx+x9UpRbhukzGzQir0bsDfqgDouKaRLLyJZ0FWighD21Dm0Bz9rRkg2tOLSRduJT6UYGFV/Bu3stjLpF4/S4r8fE90rUgXLxT1Fs7zU1ozBM40q9jBhSkthuQVWy49A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974022; c=relaxed/simple;
	bh=UiWEhw/hjN5dBOBBt7Ewx3HI4GCoTxGN3CqIu8RzwxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxnQfaf5Ia42whjbJrgoZyXI5cAPmX+0Aa4TSSFViQ0T/fzVui6guJIilRErgYttvHcPA5NtBJVlql+Wv92NfdxxTKN53D3sPYjuGOZDkCbZuzDQYP94rZNHlwkPz1kwSy6xWk/DB978EGlKR0udn5X1tmWau7r+lDjTccUOf1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rr40R0y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rr40R0y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCD0C43390;
	Tue, 23 Jan 2024 01:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974021;
	bh=UiWEhw/hjN5dBOBBt7Ewx3HI4GCoTxGN3CqIu8RzwxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rr40R0y/tYgpVjHx/727OSIRd5PPr0I0Od18H15p0EJwbM86rwyqjMqxvKfezqGgQ
	 tz2aJzpU8NyVWDvo9n/eiycwjt37APmb0cED/FpY1gWUvkzJkkDH2f+2QfWpCDM7RY
	 ETQxEtggw07/rlVw1c8s3ClrskRXYr0b0fOrLMZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/374] ARM: dts: qcom: sdx65: correct SPMI node name
Date: Mon, 22 Jan 2024 15:56:25 -0800
Message-ID: <20240122235749.132258136@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit a900ad783f507cb396e402827052e70c0c565ae9 ]

Node names should not have vendor prefixes:

  qcom-sdx65-mtp.dtb: qcom,spmi@c440000: $nodename:0: 'qcom,spmi@c440000' does not match '^spmi@.*

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230924183103.49487-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index 9d62487f6c8f..73fa0ef6b69e 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -457,7 +457,7 @@ restart@c264000 {
 			reg = <0x0c264000 0x1000>;
 		};
 
-		spmi_bus: qcom,spmi@c440000 {
+		spmi_bus: spmi@c440000 {
 			compatible = "qcom,spmi-pmic-arb";
 			reg = <0x0c440000 0x0000d00>,
 			      <0x0c600000 0x2000000>,
-- 
2.43.0



