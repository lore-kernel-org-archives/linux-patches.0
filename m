Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC904566F;
	Tue, 23 Jan 2024 00:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970668; cv=none; b=ZwHONpQDsPmPq3RVYxwlVf3t2NtxPS1VMavD2xUMLq2ZeJydil7RcBggUbqMCtbyaG3Ppwm1fHK+/md2ybU8oKX2TzBm8Q29hq7x0iDCQpbGeaZYtvp4708sNlryPGI1SV4A5uAk0AYivb2+8BJAV7rmaEJ1d++ILMN+7fHvvH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970668; c=relaxed/simple;
	bh=5+3n8Y5E53nM5RQMJJc6FGYFlORJFzxOQMwe7CLPRRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGNfOUD8PwsZwsM5qh0cIXJu2rhX/lPE8Tt//n96GFqhDOZILeMDWXwd2lQuHjNHMNNp+d7/S2LZt5ROJFRsMKvMvOmv5NLi+Z6xCcivaiDLx2rAlyZuUVqwPtLajCgmBz6NskwFAssNZfrEixobcQkKvs5hdWSwUDgb+okqUp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6IMI5gP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6IMI5gP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E671C433C7;
	Tue, 23 Jan 2024 00:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970668;
	bh=5+3n8Y5E53nM5RQMJJc6FGYFlORJFzxOQMwe7CLPRRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6IMI5gPKbaW49sTJ+BWTM2nti/W0b/KXncClcUdsveMbGRGSq+JMGyTVmLv1zK3z
	 xlCHzN4jFEMCWKpMPW8NXPpdU0790vozUAvsN8B3/Gb5wl9XLCIsn/4SRYaERNnQ6x
	 IBztAU3942l5NlJh4qm7vxzpMJi8slKXGucv14oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/417] ARM: dts: qcom: sdx65: correct SPMI node name
Date: Mon, 22 Jan 2024 15:54:12 -0800
Message-ID: <20240122235754.616001166@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
 arch/arm/boot/dts/qcom-sdx65.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx65.dtsi b/arch/arm/boot/dts/qcom-sdx65.dtsi
index ecb9171e4da5..ebb78b489e63 100644
--- a/arch/arm/boot/dts/qcom-sdx65.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx65.dtsi
@@ -401,7 +401,7 @@ restart@c264000 {
 			reg = <0x0c264000 0x1000>;
 		};
 
-		spmi_bus: qcom,spmi@c440000 {
+		spmi_bus: spmi@c440000 {
 			compatible = "qcom,spmi-pmic-arb";
 			reg = <0xc440000 0xd00>,
 				<0xc600000 0x2000000>,
-- 
2.43.0



