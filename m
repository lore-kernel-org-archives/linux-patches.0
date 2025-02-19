Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DBD1DFE34;
	Wed, 19 Feb 2025 09:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957072; cv=none; b=C9KApIokHZ6WjXy+a49e2BIK85RgdzCXBgXdrEp/ejrVlul3a8JvCbZpoFbz/wwa1ErSetCnXiRdRDy66SWN6ZqiiwcUQIzTk1t/vvk5VTwa0lwIHwv3NguLWZh/H0LlNc/Wur8YFT+b74OUqP3ZpGGT0TqWvr15kjRGWufkRAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957072; c=relaxed/simple;
	bh=A/coXbBMZHc1q8nZzViNFjFax2icNtL+eSn4J0IyKGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCy5EEo01vPOMU0qGY4SlDpcB71n+U6NZbl0L+ySIfOsnNuuaeMhjniAua4Cv2lNA+HwIOGfvps113oSnZxhAn/igep9L8TvsBu2/nXJCC2xFmmm8DOfa0SfZ2A9q5NdCKjW8vuikFsUNDoHCccuUOUxmGYeBKK0MuZNmvrl9uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMEnQ1qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMEnQ1qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B97C4CED1;
	Wed, 19 Feb 2025 09:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957072;
	bh=A/coXbBMZHc1q8nZzViNFjFax2icNtL+eSn4J0IyKGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMEnQ1qfWegDQwaPiVgcLAX/V7U9glz9qXZcgTYvy7uT4tubOHNsXn3qOLrYhZhIV
	 0G8kh6JGql7Z8A1LWl2o5dFsruFurf0C3/OE9y+woMCJKgQ57zT9FMku5YxSp1RFwf
	 AzBh3/smONef7pgoSmALfnRjP68Nkn2FFV3rKD5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 399/578] arm64: dts: qcom: sm8350: Fix MPSS memory length
Date: Wed, 19 Feb 2025 09:26:43 +0100
Message-ID: <20250219082708.720123876@linuxfoundation.org>
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

commit da1937dec9cd986e685b6a429b528a4cbc7b1603 upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x4040 was
copied from older DTS, but it grew since then.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: 177fcf0aeda2 ("arm64: dts: qcom: sm8350: Add remoteprocs")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-3-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1641,7 +1641,7 @@
 
 		mpss: remoteproc@4080000 {
 			compatible = "qcom,sm8350-mpss-pas";
-			reg = <0x0 0x04080000 0x0 0x4040>;
+			reg = <0x0 0x04080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 264 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,


