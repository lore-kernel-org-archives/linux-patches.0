Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024447;
	b=tH2ZnkhBiF3CWzajh0MSCVvhP5cAnZjroz8qFCJPVvwtdmTXvnnzPFHZbIVCZz498/B9
	 SgPP+TgJMnG5cvtqsFJhRWFVYhzht0vzgDamjUMUInW/vKs+Akbwx6yWu2PKwqCT+8Nwa
	 eWSZW+DIjkkxK2Sjyg07/mTTtMDng/xeOjCkFmB1pgnUIKU/x0mu1u2/S14Bp2NQJHKrt
	 ItOmFo7INu0q3+rYOCjBgdK1WWaemttff3oucGO3EamNB0DdrG3EgsviRQbhvlyscJNS9
	 9iEQRS49xVzdrO+NoklO9RjeFfMMidQDPanSUaXVVAiSO6xPUzO7Xo2A1xY57sEO8Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BT800vPZZ6bRV1+oylKCVnUkGGzAhDAxHZb9qmFo0i8=;
	b=jtiaJ3sEyYB1acmHR+F7sMe9vfevZDePAjWNvaAd67zH7/r83raZ51Phc6Wjfi6pVf5n
	 uR3raIez92hjoHQTjaEVXMZZQH9SGKj6oj33oMV8BWRIA9Hd5cQRs2l4WRPiF8/HeMY9f
	 KauW7cJepYGs1VxkjTVQ9FCPDARgXGt+1mZW0AN/lQcG18GkeuNNvKSxinOdyrpOjU7SR
	 VFty63Mkb1KlqNPlxkyJVMfQFogXShhejCAYpAJl0wf4gvs1pULl9oqE0McruIhuqdLUt
	 XAZfpZRD1gj/X81G9txD1uR0nt389z4bHcQYy/gFj7ZK4l6bNbgFKKU9lPG9aoiEBBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QS3byy5g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7981606A336;
	Wed, 18 Nov 2026 17:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QS3byy5g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386E81F000C4;
	Wed, 18 Nov 2026 17:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024447;
	bh=BT800vPZZ6bRV1+oylKCVnUkGGzAhDAxHZb9qmFo0i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QS3byy5gGzrqgi8dJyQDKXP+PKNHv5z1r4SCG/3R64SsTMpPVGXeJf6Yc3oAkpkgm
	 yO97pD8Eh7ykgPIJ4A5Qvp6pbrHWEO6q7WWim4KtuJhhoTfC2Hqs3lB9b04KcNNkSi
	 ZZ6Qye3gR/oUwvSDPl/EGPaI4NLKJlfS/HIKEKUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0728/2151] arm64: dts: qcom: x1e80100-qcp: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:41:03 +0100
Message-ID: <20261118150148.551221095@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit fd7d7b5d307f3a475e9555dfd89ff80cfae46b3c ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-8-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
index 5a121fc449401..fb2d90ee7d5a6 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -1177,6 +1177,7 @@ wcd_tx: codec@0,3 {
 &tlmm {
 	gpio-reserved-ranges = <33 3>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



