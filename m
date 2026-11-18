Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024668;
	b=K7iKTLIqQ6fWBhf0OjjL8sBMC17taEg36LByLaLvV3vBJbBSq+Psr9zRikytzBjLdQqO
	 BBEKMVc7iJ7DHvVBuY82V1Woyg5Q9XGZWpuP3KB17hPk84T3wn+NI4u/PlGwqNuwnWVY6
	 0tdKobudxRiZ4o4Cakeo2Lk1YUOLM3apaEj4XaeLbbc0xs/XYZPwwJ3y2Jg6uutM/8RYf
	 uQLh+KHozAhkv6P9usDH3eEUwvkX5vkIAMrMUR4OX+WKkl5bCdLa08IC3C7cqBz9Jy6Gd
	 LjPYaYxEADlX1HLxkRpYXTK72DYoVO4oXNFD/0gkqJIrgAA6GxE55fkkN7/OD4hB2GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=axYCHnpoUKgXoWuLjGAGsw82fj8wmBioE8zysTr9TSE=;
	b=oSnBadNI8hdp0zZElxHMWX9nGkWlFqLYmYZbpXmVh+P8wRyY+7hawjXdXfyIOBT0NL+x
	 DQlV5w9xICRFlorcQ/DdraP0YpEEIlGCWlfJI53qWPUmY9246OeCv3IC7hzdt1397FLsu
	 WSigOWH6UowCPBL0wTjnGCgeKf9MiMbuJ20mJbrjqNfItep7iJ7Njy7UDHaA2b69gZyea
	 +tUQz1eqoUEtVwN4Wa1Zb3H0oF1X3Y64v5D33X2i0H7PcTgY8hLXtGTSlg9yxws87VFyL
	 gR4Cdqwhyt9z1gSl+GCYB5/ulo2hENYClRPTUlJ2aFDflTsRs+mFnboAZoRuuTUjQeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTw4p4U6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6B8606A31C;
	Wed, 18 Nov 2026 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTw4p4U6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7A41F000C4;
	Wed, 18 Nov 2026 17:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024668;
	bh=axYCHnpoUKgXoWuLjGAGsw82fj8wmBioE8zysTr9TSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTw4p4U6gOjcbcI8tZplEdNtNFoZ14gi/5n7DGngChzkOKGasqI5UstCBOWdye5NX
	 7AAqkvau2boFzyIHzsRqflhinG8wh9e/Ap7cyCB5clVAxlMh+JnfgrUq5xGutKv1k/
	 58wcnL5JLbUxBnPJmy3eQbFZQyqftrw40Q7FpPeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khalid Faisal Ansari <khalid.ansari@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0780/2151] arm64: dts: qcom: hamoa-iot-evk: Enable TPM (ST33) on SPI11
Date: Wed, 18 Nov 2026 15:41:55 +0100
Message-ID: <20261118150150.531835642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khalid Faisal Ansari <khalid.ansari@oss.qualcomm.com>

[ Upstream commit 54b5415739300c89cdd6b1db152bb5acf047ce40 ]

Enable ST33HTPM TPM over SPI11 on the Hamoa IoT EVK by adding the
required SPI and TPM nodes.

Signed-off-by: Khalid Faisal Ansari <khalid.ansari@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251112-arm64-dts-qcom-hamoa-iot-evk-enable-st33-tpm-on-spi11-v3-1-39b19eb55cc3@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 723ce02feb13 ("arm64: dts: qcom: hamoa-iot-evk: use on-board crystal for PS8830 retimers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
index 1cb4a51f5d508..6d69f239928ce 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
@@ -959,6 +959,16 @@ &smb2360_2_eusb2_repeater {
 	vdd3-supply = <&vreg_l8b_3p0>;
 };
 
+&spi11 {
+	status = "okay";
+
+	tpm@0 {
+		compatible = "st,st33htpm-spi", "tcg,tpm_tis-spi";
+		reg = <0>;
+		spi-max-frequency = <20000000>;
+	};
+};
+
 &swr0 {
 	status = "okay";
 
-- 
2.53.0



