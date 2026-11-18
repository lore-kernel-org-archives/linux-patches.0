Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022893;
	b=IgvMLpvgVRf5zlQOovHmGLCPj14IEMehGkP6yN+OIk96psGgKmt3QWc04SlWzS+UkBzo
	 PC6SDL/eOpKmRZsaBnHOJ8+075m48rF8g6wsks5tWBZ8W/dTfaQV7IHCLLKVF630YXPHJ
	 r9wWVJ3RiI390Tz5QSSV4pwnl36MX7InzoneSZ4cqbSJBWyTAzlPF0NdKb6A5yfZ+rWna
	 Uw3jhZ3uaMqxI/wDJ7x2/UGaZ7eB/8PNSRdO62p3J+GYJGsc8C9dVqEmb3G4TFHXp0BGD
	 +C19gFiHO8M1YgsuwUeYGmQ4n8HxBdtoGf3bQhmj6HBGg6y7tP0BDAJzA7V5EA9c5Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZcAani4qdBpIVXfjMq7q49CojLfZrIbcZxN5on2m4Ws=;
	b=NRSFweUzhtyWDKryJkY0qV69mP5x/JQiQXFvTqiZGW5lrYPqti7bW9quHcic/P3sk9lw
	 TpYV1hcHhEK0/7Lvb7DVV8/cXRxpZoBWIUM/x/gVyi/P/ZrU5C7ky1s0RcKwHE9pPxlcR
	 tWn6p3SlaLwOwFEVjAVSB2x1ZbTvUa3AC502i7GVt+E/7jNgV6U+JcX/1PKqFC8pwRb7d
	 T3gBof0XG6Sf6uE6GfFL9YdNFsxYrUDgOuODsACMn/hyt4B13WesklguaER4WAHANiUOA
	 YjCIyM3jUJDMMU3tAeZ+ua8CYE/5gyB2cbK/3X6Og3srNIAW7plb0E3G/RegBz2SQcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4g32YPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEE7606B5F7;
	Wed, 18 Nov 2026 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4g32YPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2561F000C5;
	Wed, 18 Nov 2026 17:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022892;
	bh=ZcAani4qdBpIVXfjMq7q49CojLfZrIbcZxN5on2m4Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4g32YPck/t3MdNPKm6M9Al1AJQDFmkFDHXB2PciRUEhEvb+RnyUKN8X5Ag00Tkm/
	 J6pBEM+1r/qIlNHE0p2S7c6DHt0pvvPG6DWre9+E8mTYqhaZiZOA1N22Tt+i8qBWSA
	 kihXmulekbBMLa9r7Cbb1v8DTSeAzMZgbfcyw6Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shujath Mohd <shujath@outlook.in>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0174/2151] arm64: dts: qcom: sdm845-sony-xperia-tama: Fix Bluetooth UART pinctrl
Date: Wed, 18 Nov 2026 15:31:49 +0100
Message-ID: <20261118150128.076745987@linuxfoundation.org>
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

From: Shujath Mohd <shujath@outlook.in>

[ Upstream commit cd0f33393882e2554d46e8e068ab95d00593f385 ]

Use the 4-pin UART6 pinctrl configuration for the WCN3990 Bluetooth
controller on Sony Xperia Tama devices.

This enables the UART hardware flow control required for reliable
Bluetooth communication at higher baud rates.

Fixes: d54331131cde ("arm64: dts: qcom: sdm845-sony-xperia-tama: Add bluetooth")
Fixes: 30a7f99befc6 ("arm64: dts: qcom: Add support for SONY Xperia XZ2 / XZ2C / XZ3 (Tama platform)")

Signed-off-by: Shujath Mohd <shujath@outlook.in>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/PUZPR01MB51413F6FF89A8FA82A9B2755C3A02@PUZPR01MB5141.apcprd01.prod.exchangelabs.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi b/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
index f3f4c0900572a..2306b31edad27 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
@@ -755,6 +755,8 @@ int-pins {
 };
 
 &uart6 {
+	pinctrl-0 = <&qup_uart6_4pin>;
+
 	status = "okay";
 };
 
-- 
2.53.0



