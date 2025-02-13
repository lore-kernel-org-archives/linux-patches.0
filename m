Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AA51547E3;
	Thu, 13 Feb 2025 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460670; cv=none; b=nVG6YA/AjNvBIXqBWp2HCdIj8ga9IZdAXzsuQ7trTbUnk/s/+KsE4C2eb9Ca/a9dLHpZ93auhdlmJKskNNZ5DYggctVhDGfMfIWQ1nZq5jRfqVdJGPF7K75cFAenpbWtOjZRxHl6+9gVR6/NaG11id+Q02uILnTP75EpJVNfOk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460670; c=relaxed/simple;
	bh=GRtFZ+2baNPpy52od+5d5Jzsw7HkCi6m7MxbZXvt8TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWXbqD5st9R4nO1Xqo1SZEHrbuTyY9fUEBJHMsG5d24Q14Mt8gs/1bPyUS/wQWAJBdEiut1vT36b7q3lKFLjNpjgPbk+nxqH8eWZ8AyfB6aBQhnzhVkYheeoRa8KnoMlHeEdoOzUQuAZ1y/N6D7E1qgKfydP9Os55UMUk9nHVc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnV4+MNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnV4+MNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D43AC4CED1;
	Thu, 13 Feb 2025 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460670;
	bh=GRtFZ+2baNPpy52od+5d5Jzsw7HkCi6m7MxbZXvt8TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnV4+MNFqV4in/1GYgi4e3jhPbZN+FGPxi355sJmAhrYnh1Np1nhI1AHZ5yTySIrR
	 B6UXN+bl1OqqLHrmMjHoXdE5ryKkhMOKO82PFFjiKDpbhS5CYgiU5LzLD+XblLElwS
	 kH/TWDKtc0ZYuXuMIz0KgsJoJGwVm3RSOL5JjkaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 179/273] arm64: dts: qcom: sm6375: Fix CDSP memory base and length
Date: Thu, 13 Feb 2025 15:29:11 +0100
Message-ID: <20250213142414.403902663@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit c9f7f341e896836c99709421a23bae5f53039aab upstream.

The address space in CDSP PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB): 0x0b30_0000 with length of 0x10000.

0x0b00_0000, value used so far, is the main region of CDSP.

Correct the base address and length, which should have no functional
impact on Linux users, because PAS loader does not use this address
space at all.

Fixes: fe6fd26aeddf ("arm64: dts: qcom: sm6375: Add ADSP&CDSP")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-18-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6375.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm6375.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6375.dtsi
@@ -1550,9 +1550,9 @@
 			};
 		};
 
-		remoteproc_cdsp: remoteproc@b000000 {
+		remoteproc_cdsp: remoteproc@b300000 {
 			compatible = "qcom,sm6375-cdsp-pas";
-			reg = <0x0 0x0b000000 0x0 0x100000>;
+			reg = <0x0 0x0b300000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 265 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,


