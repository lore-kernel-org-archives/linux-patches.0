Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1808826B098;
	Thu, 13 Feb 2025 15:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459552; cv=none; b=WMdtW87yJnwfGg3qH/EFwjyS5+OYtjdWRtR8Kq/MvHU2fwillfpwMxxPigCDi2hF0uVqC1snF8JrXvwmUxUjidsXWb2UPNJuRykKo79j3ZaUpNG4HDfIRn6zPal7gw0/7Fy/XQ1PvsXpxF8J6v6+Eos/rfLnjs0YSba4ZCw9qRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459552; c=relaxed/simple;
	bh=odCQG7GkFQSfbV+4xjnTW8H3qXTEui0lTJ/aspYWWGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNgw3yokGTU6G7K4OtWMKiYuIlLJgVC4ssDQMnflq4fu596ugg8tpRt0i475OumShSd8rNPapUEBovf3TElqB/n/6qVE8BdpHrDTepLHU2qu41HeS0jfBQpBGXl6miVhx9zGrK5SYXGs4w1TYTCgpVLposji+/eQKslVqd5GVjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntgGN8EN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntgGN8EN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D53C4CED1;
	Thu, 13 Feb 2025 15:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459551;
	bh=odCQG7GkFQSfbV+4xjnTW8H3qXTEui0lTJ/aspYWWGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntgGN8ENGgeS91gR97X0KalaJ6QcQCtdRHmfGo4i5RR6fy1LdT1eri9avLjLRi7tZ
	 zVmYHn9txziq+s540I/FZMc5yUS283COIWMh+Jg5VqDZBFyKaVmjUCSFXLpq+9lRO1
	 VpRfDZ7YNmNw70KNOoTZW9QFTQepgGZ8UAqA+5QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 298/443] arm64: dts: qcom: sdx75: Fix MPSS memory length
Date: Thu, 13 Feb 2025 15:27:43 +0100
Message-ID: <20250213142452.115742888@linuxfoundation.org>
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

commit 9a27f0e1869e992e4107e2af8ec348e1a3b9d4d5 upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x4040 was
copied from older DTS, but it grew since then.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Cc: stable@vger.kernel.org
Fixes: 41c72f36b286 ("arm64: dts: qcom: sdx75: Add remoteproc node")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-20-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdx75.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sdx75.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdx75.dtsi
@@ -893,7 +893,7 @@
 
 		remoteproc_mpss: remoteproc@4080000 {
 			compatible = "qcom,sdx75-mpss-pas";
-			reg = <0 0x04080000 0 0x4040>;
+			reg = <0 0x04080000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,


