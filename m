Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39C0176ADE;
	Wed, 19 Feb 2025 09:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957067; cv=none; b=qiwWZ8Fmm9CbVbYPKVMLLAesNvw9/Di1D3z8cAI1KrC3EHmIbxbgGizUmSgx1vOskOz0XwiuUr2IYM3Ff6TTP7vFVA3BVYUx1Obg/SSy4CRas3c8GCZnl+EY9nj0vgLnjTcLtIVri2vY42/qwvyNBjCsUEyUMC+VKsRVErcheSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957067; c=relaxed/simple;
	bh=VsBJJSsxILwoXudEGVpL9ag0v5OsxR7x7Oa+T3IBJcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ij07ouK5JGitx759lKXpyE0jHVHXDONk/zDLfcAUTc8bSLmXbHbwyJZljF+HZQKb1/S2sU0K48xhXerTX59U5oC9xIZq0Yz6EC39PRn+lwWnb5DBbnjVqjNWXDGLKtSIIsKrFjPpts3Ae/QvNKyoSjAbmPjaoHr3PSvWzlRyaSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnKUhXkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnKUhXkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BC5C4CED1;
	Wed, 19 Feb 2025 09:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957066;
	bh=VsBJJSsxILwoXudEGVpL9ag0v5OsxR7x7Oa+T3IBJcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnKUhXkbx/rdlOcy+yDhVnHGDA8nuxNvcQnhqE3efT4shXsFCvPPektPa9MlS3q99
	 NgORkOIwid5acXGxjiym1Pm2tIKUTvdaeD5VmaPCJ/tp/1zuZHRBeS5Li5FE76+8JL
	 qcT6S8bzFW8BTO0UuB7E9w8b8SpVGos7HTA7qPgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 397/578] arm64: dts: qcom: sm6350: Fix ADSP memory length
Date: Wed, 19 Feb 2025 09:26:41 +0100
Message-ID: <20250219082708.640606714@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit b0805a864459a29831577d2a47165afebe338faf upstream.

The address space in ADSP (Peripheral Authentication Service) remoteproc
node should point to the QDSP PUB address space (QDSP6...SS_PUB) which
has a length of 0x10000.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: efc33c969f23 ("arm64: dts: qcom: sm6350: Add ADSP nodes")
Cc: stable@vger.kernel.org
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-15-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -855,7 +855,7 @@
 
 		adsp: remoteproc@3000000 {
 			compatible = "qcom,sm6350-adsp-pas";
-			reg = <0 0x03000000 0 0x100>;
+			reg = <0x0 0x03000000 0x0 0x10000>;
 
 			interrupts-extended = <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,


