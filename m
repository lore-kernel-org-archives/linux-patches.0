Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015409;
	b=v1DZnsvOn3G0/Cw9axzLND1eEe15a0RtKYBpY3q5tuX3Hu1sAzW3hcFnbfxTUHEI+4IJ
	 XcY6YhO5oiC4NR7a+dg6DKIlK6i0/tUMI64NaC57m8nVdUV4osM+9Ley+EFXKRo2qVlMU
	 dnGAGBSb8QdROAMGQwNmywaXjUWBhgj9p89R9AyJElhGLULUlG9ThkPgM/JFG2i65fPR7
	 1Cu+BnhItQMhMPc21BqGR9TevSo18YugUdnSpuflBqUPFLcAzIwaBsk6M7NFnE+BtHA5L
	 YouRQuddji2vA7AwP8sVBlgbQ7ckDBmR9CLzcH9aJGnv5QJq0BmUT7yvckRrnDLjmCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GsjP3yo+liMZJy7YEWv2cBShBiIU2Q++lYqh/5OinIw=;
	b=ekiH2eyZZfNytPDhfqMoNXynuU1O9eyghb9xxAzfUa/G8ASFpBDRU8dbdZcYuFTdw7+2
	 aPW3AVUOL39Myn0+bOfl3WW06pkAsgLqFerW6XUyrG5ltolljk0H95dG4Ue/jucUQDBKx
	 n2gByBgGdlUbAwoyLbmMflOti0VCTwXIT/COYYxDbO5L1Y645jyuyZByYXoKOKWixhYc0
	 CQCcpE744A9vMAuzoJlMUvhQY4vcrgYDZQVqJk/ToHl3IJb512eTwgPeS71C4rcAHLyzj
	 /k8dfcfxTvCVkny2r3Efn8WZatwrWH8trep7JsGuye8necnwrdpn4+Pj7+1g8Ww4t3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZKI+5dQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC0D606A320;
	Wed, 18 Nov 2026 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZKI+5dQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B159A1F000C4;
	Wed, 18 Nov 2026 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015409;
	bh=GsjP3yo+liMZJy7YEWv2cBShBiIU2Q++lYqh/5OinIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZKI+5dQf5KwCu9QsidquSRwArSyR4K6GUeWh5x/C+tfgDg7dzjWeZfbBWHGhVYD5
	 aCDgzo/SBTlq/A8Gc+NFdEqfrlxI9O29u424LptURP1kqTgQP2HuBC1QPbL8TjZQrr
	 QW0WNW+MYIB/sQrlacteq+FlUSXaZMgV0TfSJtdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0122/2651] arm64: dts: qcom: glymur-crd: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:22:42 +0100
Message-ID: <20261118150252.260086946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 8ab228ebf968fe43afa55630fb98f1069828988e ]

GPIO 65 from TLMM is used by the Embedded Controller as its reset line.
Reserve it to prevent Linux from requesting or reconfiguring it.

Fixes: 9314c6ecace1 ("arm64: dts: qcom: glymur: Enable Glymur CRD board support")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260831-dts-qcom-glymur-crd-reserve-ec-reset-gpio-v1-1-4a9da88755d4@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur-crd.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
index e27c697e31702..4df3ccfee106a 100644
--- a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
@@ -963,7 +963,8 @@ &remoteproc_soccp {
 &tlmm {
 	gpio-reserved-ranges = <4 4>, /* EC TZ Secure I3C */
 			       <10 2>, /* OOB UART */
-			       <44 4>; /* Security SPI (TPM) */
+			       <44 4>, /* Security SPI (TPM) */
+			       <65 1>; /* EC reset */
 
 	edp_bl_en: edp-bl-en-state {
 		pins = "gpio18";
-- 
2.53.0



