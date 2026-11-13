Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591324;
	b=CQLCW791Y4PpEMvRDOb/I1oviyv1kymTDgQAWz6lxcATs/UG8kjGB8VzUPcI6Qg1PdBY
	 nXRTQEREFb313iq8Aim0pXZ4FPltOyPBPgY5UH1f9hXFrP+1cZPWBrl0FGSNvKyXemQOB
	 eIOtV/2HMMi1fZnBhaHP0aHWlT77z/DXYyfm8GnCrQczv6UObLVcUwkBbYrcflA5gZaDO
	 QGAcGgB9m9xrhnd5id19YzC9ZLIuS5J5LGGoEK2XnQzraA82L3DsQe3SHsNLF8ERBmD7j
	 X1CuhL9HqZae71i5eP5dMNFklGCq0geGLhusRIfn8j3NuHtyL2kK2Hw/ds+ZLsi5/ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=077TiCmw/VbMkWrW3l6fPkjpWR368ek+0nacswDRK40=;
	b=HnZHGL6QtyrixU8iNtAbEkQC+7GKzm3bbOIjZOOdlR6/xuRqZLhPhdf3bcGJwmlfAfXe
	 7Jc2ODo7jYQnSQMPiAANFOkA3h5x4sq/HP5S7lQOFFkMBFXu5YcpXeZMsqnRJWQTZoJ6r
	 mgidgOCBmaFuIBV/k57FpRLyh2pz7+LyIgfijiykl0T5jf188XexT3NUJ1quQwySrhSN1
	 XaGcfZfJmqQ7PrKWJNIca7/XS0p9uSq4VYq5nmqt5+uwhTuGNLRMfU1hth00m58rXF1VS
	 zCIUoyIDNS2otevQKCgZpDOMWugs8ZZZ71FgMH2Yml2QqEsg/BPV4qOQWdiYzt5J2EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K+Ow7Ypy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66572606B21D;
	Fri, 13 Nov 2026 17:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K+Ow7Ypy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130791F000C8;
	Fri, 13 Nov 2026 17:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591324;
	bh=077TiCmw/VbMkWrW3l6fPkjpWR368ek+0nacswDRK40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+Ow7YpyUgIZQluRURou3xquBlmCTIkWuSs7G1a8HOcxlyca3PxNtlHIpATaB5QKx
	 ULvcP6MKV3tMKkJgdYsCECKaVzq6u10oXleHx5ct5qzQ+e9DNkw7TbEa8YudgNln5Z
	 C++jlo2MhG3XYmPectJy21a6BDstciXTcb76yalU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 437/670] arm64: dts: qcom: ipq9574: Wire up USB3 PHY PIPE clock to GCC
Date: Fri, 13 Nov 2026 10:50:01 -0500
Message-ID: <20261113153826.694552780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

[ Upstream commit 117d8d40be1ded4f35f3252efa83607a7134d5e0 ]

Connect the QMP PHY USB3 output to GCC so the USB3 PHY pipe clock can
propagate to the USB controller.

Cc: stable@vger.kernel.org
Fixes: a98bfb31f676 ("arm64: dts: qcom: ipq9574: Add USB related nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-ipq_clk_changes-v1-4-d242e3d49648@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ sashal: Adjusted context to preserve four zero placeholders where upstream has PCIe PHY clock references. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq9574.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq9574.dtsi b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
index 81ccd0600c5ab..31f97309c5330 100644
--- a/arch/arm64/boot/dts/qcom/ipq9574.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq9574.dtsi
@@ -315,7 +315,7 @@ gcc: clock-controller@1800000 {
 				 <0>,
 				 <0>,
 				 <0>,
-				 <0>;
+				 <&usb_0_qmpphy>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#interconnect-cells = <1>;
-- 
2.53.0



