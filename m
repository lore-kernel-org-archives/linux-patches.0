Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029441;
	b=UtuFSPcEnIjtqu7ueNQGx5ExlVZS6Fr5doc8aZL+FDcT/Yf0soWfGmgmeyZiCr02AR7W
	 n3+GTvcA1r5ZTI4dYWq1F2Mw7qgtVQGkBRfz4elg1RNjKbtNcym4A2OfBWlpeNdvFr+23
	 QCVnCmhIWjUnEBId/23KUa7qZn6pSMMdZJ12FTasFof2H5Cm+dZkYPuUyVx30HMP1k0tB
	 p1yc4Xyvm1YKBIVPVXkR82mhonAsqn4Gti5UfftEXbKgqeOsy9GN0mHkx4bI0nFUc0QqE
	 PLTPBX0CiO1N0wm89DRdp7DuDouub9X+BUzbu/B2L5QpM9uW9EpgkeSF21HAgFaaNwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4cPV/jhitoHWw5Ogts2ae0D7lhyG1grR7AyQm8FlGWU=;
	b=YrKPvEjVSYV69RwP0u58p6Z2TcgKm9vBb9Iys1tH3r/CPAFHjxf6zhgLiKr7Qf8Eh+yV
	 8+Uh6e9qGxcRsDX7stVXx+jc+eC6wp19G/TCupmBBUb/Lkla+JsnZjy7Y3FB3AVLrscOK
	 BUjI6PnSR5q8QhpG55v7/yVCyLUxMPp2cJI09ECPnaEg7L6/1dRNssSQNKhLoUcfwt6LL
	 mF3teeH9jQEUvbIStI8kLSd5Fwz4uwCeo0FHxbLOderYPukqHOB/aSOa4ZTppk4TLRbfA
	 kEJlJJ0F2m4CD3Nj+q60dT3i2r0F8Ttt7/uSWcTKHlnfDJEG9DNrhN5/Ily3IxWDPIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T30GmbpD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D089606A320;
	Wed, 18 Nov 2026 19:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T30GmbpD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74DF1F000C5;
	Wed, 18 Nov 2026 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029441;
	bh=4cPV/jhitoHWw5Ogts2ae0D7lhyG1grR7AyQm8FlGWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T30GmbpDbhApbC9R8G0E6tLZcPjZAgVh9uRGVWcqjPJaH12ofOCnMbRsam3E6jl9I
	 pbvkeNcqNDx3GaEYl1aLeoQiGGXN+onl1HujJYncYnbtxHBI9uotSN9qMqDibmMDqa
	 BMlnoYecCNhlkYnMnfWO6Y+C2WY1r7DwGAg+s0xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0350/1756] arm64: dts: qcom: sm7225-fairphone-fp4: Disable PMK8350 PON
Date: Wed, 18 Nov 2026 15:41:17 +0100
Message-ID: <20261118150022.298190258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 5c088a33e3a9bb236c475b7230df275fc1e51eda ]

Two PMICs on this phone have a PON block, the PM6350 and PMK8350. Only
one should be enabled at one time, so disable PMK8350 PON and keep the
PM6350 PON.

Fixes: 582e7c1026fa ("arm64: dts: qcom: sm7225-fairphone-fp4: Add pmk8350 PMIC")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260901-fp4-pmk8350-pon-v1-1-e05937e9c860@fairphone.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index dfa3b111ae10f..4c73893e26931 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -924,6 +924,10 @@ xo-therm@0 {
 	};
 };
 
+&pmk8350_pon {
+	status = "disabled";
+};
+
 &pmk8350_rtc {
 	status = "okay";
 };
-- 
2.53.0



