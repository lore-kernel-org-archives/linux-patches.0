Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47A22CCC5;
	Tue, 17 Jun 2025 16:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176433; cv=none; b=FFcVudARmr12uRdchctbB+A0Zgfz1MFY5VtCFFTqrwZxN8XY6oGOB6S0I/KUxDJskY7od7NIpEHMTF3K66GskKsksWq4PA1ovGe0ytn1eZq2bxZzNJYqXGYetvjleTaCGPSqRJmu+p/XIrh5LK6/ecGIgXAGO8525QhabvUo7Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176433; c=relaxed/simple;
	bh=z3k1bQbB8hBiJ9mV3JALf79PHo72WZu3Ve5Tb95EEZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZl5gazVJIYAu20CGYziEKSw4i8TkbVwQwXBKTWqYVS/yi/WjYSVdAWDOu7Q1GnsNOSRyrOQgJtB1aYRA89RNOtt2Cfx3zxwtXoOsm5xmd0YUAQl3FVXNs8Ji16tT7Y5Xt94AGo/v9K52xglmlEbkPsscMQDiGX9SWONTdE86Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3sVBWYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3sVBWYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E25C4CEE3;
	Tue, 17 Jun 2025 16:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176433;
	bh=z3k1bQbB8hBiJ9mV3JALf79PHo72WZu3Ve5Tb95EEZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3sVBWYpVgluTpNHTjGAytZmqqztjiMlOr6vueGQ0UxFHqgdP7+rmFdbRCm37GTRG
	 zDvqyHot0SvZLE0oX6d80DLl1mfgJ3Kyoop0UQndSrxmKhBEOsLsx3UBSUh81HP+fu
	 MIngkcPbeflfwtTfE4j0Bg/16uFt1XA1stq+l3qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/512] arm64: dts: qcom: ipq9574: Fix USB vdd info
Date: Tue, 17 Jun 2025 17:23:15 +0200
Message-ID: <20250617152428.910870586@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Varadarajan Narayanan <quic_varada@quicinc.com>

[ Upstream commit 4f4c905e6a2a4e884f4e9b7326c94fac3500e0f9 ]

USB phys in ipq9574 use the 'L5' regulator. The commit ec4f047679d5
("arm64: dts: qcom: ipq9574: Enable USB") incorrectly specified it as
'L2'. Because of this when the phy module turns off/on its regulators,
the wrong regulator is turned off/on resulting in 2 issues, namely the
correct regulator related to the USB phy is not turned off/on and the
module powered by the incorrect regulator is affected.

Fixes: ec4f047679d5 ("arm64: dts: qcom: ipq9574: Enable USB")
Signed-off-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250207073545.1768990-2-quic_varada@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq9574-rdp-common.dtsi | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq9574-rdp-common.dtsi b/arch/arm64/boot/dts/qcom/ipq9574-rdp-common.dtsi
index 91e104b0f8653..a5294a42c287a 100644
--- a/arch/arm64/boot/dts/qcom/ipq9574-rdp-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq9574-rdp-common.dtsi
@@ -111,6 +111,13 @@
 			regulator-always-on;
 			regulator-boot-on;
 		};
+
+		mp5496_l5: l5 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+			regulator-boot-on;
+		};
 	};
 };
 
@@ -146,7 +153,7 @@
 };
 
 &usb_0_qmpphy {
-	vdda-pll-supply = <&mp5496_l2>;
+	vdda-pll-supply = <&mp5496_l5>;
 	vdda-phy-supply = <&regulator_fixed_0p925>;
 
 	status = "okay";
@@ -154,7 +161,7 @@
 
 &usb_0_qusbphy {
 	vdd-supply = <&regulator_fixed_0p925>;
-	vdda-pll-supply = <&mp5496_l2>;
+	vdda-pll-supply = <&mp5496_l5>;
 	vdda-phy-dpdm-supply = <&regulator_fixed_3p3>;
 
 	status = "okay";
-- 
2.39.5



