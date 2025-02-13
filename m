Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C498269806;
	Thu, 13 Feb 2025 14:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458056; cv=none; b=bX8QndKMkalFBA+NSFizH0X5YvU8jrDRG6Oum/CyddR7qvXCjh/yZtebmB1h84Xl4XAB0rdBykC6SUnIgAu7IgaowAGQv05Nk6yHaC59KOoYYkVs2YgBQUz6zTqIDHdGbdEJS4EvMfov0DTCchY+KKNR/b31aQSr+VQsDZDDNw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458056; c=relaxed/simple;
	bh=H4rs4WNcfAGINvFjhhGQ0dXCCSZSCi005ICm1hrkhwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBmYVMxeXq8cic8bByR9Ou81Osv1v1KGKrir+GlOY9KHYA0/QvhrMwFxZmWPOV9t3SdNgWGUkb/UnlYg5TcmMgKYc0gmFJ3KdtniF2VT+OJv3ZGiASATjL2dzBeowjnuMt5O6MeO2xHCQwjxDqYUea3NgNeYfqWIOWh4xGAvfW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZX7JKJq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZX7JKJq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3897C4CED1;
	Thu, 13 Feb 2025 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458055;
	bh=H4rs4WNcfAGINvFjhhGQ0dXCCSZSCi005ICm1hrkhwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZX7JKJq96N8uKeuN0GDMhunk9SbniTq50LNUd5/60YK53XmoxfbjFetSQfiWeIgdQ
	 JM0DxNfmEwHejG5u5r179Nfef5XcFpxCDPUN3isTeGlHadyeutIvV+qoWyYaziI49m
	 3s+8gT/mGr9QZ0gJFHxjXMWaP4ZKg+r9n/+AZp24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 288/422] arm64: dts: qcom: sm8550: Fix CDSP memory length
Date: Thu, 13 Feb 2025 15:27:17 +0100
Message-ID: <20250213142447.659191810@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 6b2570e1e43e4acd0fcb98c6489736fe1c67b222 upstream.

The address space in CDSP PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x1400000 was
copied from older DTS, but it does not look accurate at all.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: d0c061e366ed ("arm64: dts: qcom: sm8550: add adsp, cdsp & mdss nodes")
Cc: stable@vger.kernel.org
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-8-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -4715,7 +4715,7 @@
 
 		remoteproc_cdsp: remoteproc@32300000 {
 			compatible = "qcom,sm8550-cdsp-pas";
-			reg = <0x0 0x32300000 0x0 0x1400000>;
+			reg = <0x0 0x32300000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,


