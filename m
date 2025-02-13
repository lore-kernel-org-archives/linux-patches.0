Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C4213D8A4;
	Thu, 13 Feb 2025 14:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458038; cv=none; b=S6VmkLp4u2qg3sre/IWIVKTGFaV2ZRoNCx68cb/podeaoakEHW03XVVJXqjAbfvig7WNnUoswnNwYDvCVlecrDopWeH2PgEHQzwRH4nlIOQw+7CRfGu8KZ4KAYSRW1o9LwrIciPm8ODg7y/362yNXfoxqaXwhjTd19+ZCLMBX3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458038; c=relaxed/simple;
	bh=/HBa2XgjcE/JMEMvl2tW2dfqOOx92Ba6m0Lq0CrctfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAn+yGSCtToLfJWyev3kWGBskp8mhbczbo7V8xe+ruh79qwaLTULsGBFQ7Eq2S5dsRQqlZFHKjNm40RK2sN8v6r5gMf4DBKQ3znSGPz/ML/fAmq3IZpcBwaAZ+8YDhZctUDMZXyDXFMCAoYUxQW+prTRRqiOgUOeW3mNPaKBQT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwDM8D4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwDM8D4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB9DC4CED1;
	Thu, 13 Feb 2025 14:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458038;
	bh=/HBa2XgjcE/JMEMvl2tW2dfqOOx92Ba6m0Lq0CrctfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwDM8D4MQpf9FpA5kyKxw66loj64U+jGcCPJNBdnu/Mj4YI4iYivmXI2BfyAcilMP
	 gvJhN5b+DXin/szzltr5Ltbr6njkoWFQms/zmdKgTxUqVxuuf+P6OhFx3T1EPMmySS
	 lzxwLFuL9EaP2VSqufkb2RqV28FsKYo1On7GGUjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 283/422] arm64: dts: qcom: sm8350: Fix MPSS memory length
Date: Thu, 13 Feb 2025 15:27:12 +0100
Message-ID: <20250213142447.464812765@linuxfoundation.org>
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
@@ -2214,7 +2214,7 @@
 
 		mpss: remoteproc@4080000 {
 			compatible = "qcom,sm8350-mpss-pas";
-			reg = <0x0 0x04080000 0x0 0x4040>;
+			reg = <0x0 0x04080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 264 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,


