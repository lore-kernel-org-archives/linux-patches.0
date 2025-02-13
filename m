Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AF826B0AD;
	Thu, 13 Feb 2025 15:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459572; cv=none; b=cAvQuw7qeu/484F/dNxIKvMnkAywsfg3b9RhU3F/Kio2CpoDzbOU+GcFaT1dY9hfmCoQCUj3CG+CC56k2TvmruXDxfdN0EC7xidpGRrC5tCxjwEg3poFsoeoND5Khu8LG4Jrgo1g1a3Ma+/G8oObngTkrx2UYvCJiDn3PnADoiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459572; c=relaxed/simple;
	bh=VenfMYYUM9/qLVf/i7YwylE8WeMtlSFe667C2t0KFtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uldQk+DbJYeCwleMsaNiQ4GcJ/oALo7Wh/q8meTTqInTaeKv4hGnCqF5XiLDpN7fSn/3MMYZ3jAtEQiKTckX2Of9pSRpKJg6N1cup5NfJ8JQa2xcb4c8jf0uaSwPbxgSaZtzryHsoVAUw7v1upbXHETXHz7sKcZh6oCoJMbNYXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhCqNgoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhCqNgoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB76EC4CED1;
	Thu, 13 Feb 2025 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459572;
	bh=VenfMYYUM9/qLVf/i7YwylE8WeMtlSFe667C2t0KFtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhCqNgoXaZCB+xYoB1BY1tE1r/UtWeFMGwIxR06wfMlKPUj0L3nrjPyAeEW5yqjhf
	 II1IKjKzalZGxcZ1FQDCjov4BjbpuiFlE54iKurV4szBbYQzYXhqterbM489m6Iqkm
	 F5r4XvLHoilYGBqzBdbWl+o9+ufdcZrKiZMlxbN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 303/443] arm64: dts: qcom: sm6115: Fix ADSP memory base and length
Date: Thu, 13 Feb 2025 15:27:48 +0100
Message-ID: <20250213142452.308033925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 47d178caac3ec13f5f472afda25fcfdfaa00d0da upstream.

The address space in ADSP PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB): 0x0a40_0000 with length of 0x4040.

0x0ab0_0000, value used so far, is the SSC_QUPV3 block, so entierly
unrelated.

Correct the base address and length, which should have no functional
impact on Linux users, because PAS loader does not use this address
space at all.

Cc: stable@vger.kernel.org
Fixes: 96ce9227fdbc ("arm64: dts: qcom: sm6115: Add remoteproc nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-23-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -2670,9 +2670,9 @@
 			};
 		};
 
-		remoteproc_adsp: remoteproc@ab00000 {
+		remoteproc_adsp: remoteproc@a400000 {
 			compatible = "qcom,sm6115-adsp-pas";
-			reg = <0x0 0x0ab00000 0x0 0x100>;
+			reg = <0x0 0x0a400000 0x0 0x4040>;
 
 			interrupts-extended = <&intc GIC_SPI 282 IRQ_TYPE_EDGE_RISING>,
 					      <&adsp_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,


