Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039197;
	b=IPcyM5JkB1apiBotkL3g3Jm+JvbbP9YogdC7LGvUYVSJ/UcCWt0Ykv0NPbZQyH2I1fxW
	 xEiA2Qq1iqYGHbCU21W7Hsd1QjIsPcNvJP+dj4T4lh3Sz8T+e3FZTAM7b1fu5nBig1wRM
	 iWYlE9QjvGmFV2hIDzGTlMO3IRjw5+qIdSVGGrkpd1oIoUyzHdt8dLsrxN9T29IJuIrkJ
	 K8oPJdiY4vJi+FsTY+tn/RTUOdf4ravpmV5gIbvcdHPG87vm1j7DSdWJ7gbyOmzE2zpCx
	 G6CSNrn0EEr4jUXVwmOz0dz08urMHw0Y3NUWn7+1O9LRo6w3es1dSSl82XnmC723MwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OydLdAxFzIwo5plwoZUjhENxADElvIa9+7tnRcezMd8=;
	b=s4d1xQ6YykNBdKPMxTrK6LRDO8n8AIWDSGHtR2qaHfZ8KNmuY7RLtNQTnh4ZVUcSTnYf
	 YSrAlmXGe5wiR5tquziKTD444sk+mwtn4MLJ/L8m59JnAcDcNcAEW06fTAoFeLA44Lm+N
	 EiGwq/Q/CwaaRSwEqGZvKkwqXMryX5z+q2cIvcJOma5dEMTpwBRxiOz+2gFkivo+CZ0Se
	 9/Forc8ikQt0P/JkMLbOGTLJPL56Z632vWmy9EFacFD3LX5cZB/UsujxYixaa1sBaIcpy
	 1eN/6UTZ//9Gqilj53TCjMaenNvZYs0Uv6NlxqZJW21K7yU6FkIwn2YZqKSiC8Bh9Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+4EUUb1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61698606A325;
	Wed, 18 Nov 2026 21:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+4EUUb1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80F71F000C4;
	Wed, 18 Nov 2026 21:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039197;
	bh=OydLdAxFzIwo5plwoZUjhENxADElvIa9+7tnRcezMd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+4EUUb12mpL4iGkc3bPkpugAKz2W7AvEgHNuvIx5tidC8FlWgHtVB7S40zrSdcVx
	 uFmvP9w6syAkbQaMI/Q1MRwFk1/x+a47cio8D3/aB5tfQZxKmGxhYUYsCikRw08Caj
	 bjs9FLq5DLL2MWk4O4uko6Hyee22sZNr2tZBOLfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shujath Mohd <shujath@outlook.in>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2015/3318] arm64: dts: qcom: sdm845-sony-xperia-tama: Fix Bluetooth UART pinctrl
Date: Wed, 18 Nov 2026 15:43:57 +0100
Message-ID: <20261118150422.488485045@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7ee61b20452e2..9f7c96be90d77 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-sony-xperia-tama.dtsi
@@ -667,6 +667,8 @@ int-pins {
 };
 
 &uart6 {
+	pinctrl-0 = <&qup_uart6_4pin>;
+
 	status = "okay";
 };
 
-- 
2.53.0



