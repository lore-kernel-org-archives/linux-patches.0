Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017308;
	b=nhEtPYM8+3SkJXoKDVCx0MpooI2SyAtmW3dOgJQDCH1SjmuySV6U4TiX0oyaUqSYsF+t
	 eRJW9iCQ43bXstmHF6Ao9Q1KIF9/IOxZIXKuW2X+jIG5WXHdrr5V0uwuh7q7LWWb+zj9C
	 5h/6E2tr3VunKlR5GCr6PapmumBcvzQ+9FCWZ9XMbXN1e+nU09ny+3PbLHWdzh453kMTP
	 +OjeoCKtNrJcAkZRYL08hkvYkATxvqT3yNoAlQ7Ib5BI2c/vSatuLtSxVpf+b4feqYABM
	 hneZg2Ifon2Iv0SG61wgEbd0/QDQk5iUe6Br4UA0M2HRpO0SbOYvXqsof23ojxIxmjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fEzTKGtP61pbPk9VatIddgh+18ebdvWWOa5o5l96MUQ=;
	b=vkuKLMxweyqJatf0WDLPz8pTsq0OajQJVPDtEAY0Cb7STiBYS2mUtnnJewEnYEfEwPd4
	 txcgQ0EwOHjTgMK1fOgcxU9VVOuDQhrbPqDWWtEzNOok5puWBJdJAU/vXtew+O8I+32Hr
	 HYQF5nMF9H5Z75zMrbMUlJeWR5ZE13aK7ORKJcRDKw3PypqvUMSJ7vO5GT5dty2+t4x5v
	 VlRhCeA60mWHEjt1oZYPL/sFky/zKNRp2sKR8dhDVRODmkYquw5P9pCYiyRqCHyU2/jao
	 ZZzZFwIX0g6uuZXI9UYCBrwBDhr0eAoNHhrOgrZV2zttwENLmeUmoG0qlk3KCq7IGNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Umb1yfO7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85010606A320;
	Wed, 18 Nov 2026 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Umb1yfO7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79BF1F000C4;
	Wed, 18 Nov 2026 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017308;
	bh=fEzTKGtP61pbPk9VatIddgh+18ebdvWWOa5o5l96MUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Umb1yfO72P4vxSgnQ1GO8+w+KNwKgh2b5jyj/3swgjpnN0EDD7aClJdXH2q6JgMCQ
	 BiXrrviiNCFaEC3D4f+95bYq7uEPMTV0rUglxvw3D3KK9pxqTvefN8+JoMVkDIjYaJ
	 //ARfaVF4Ky+R+9lLpqmAUJ2EOQKnmt9suzR7FVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0839/2651] arm64: dts: qcom: x1e80100-qcp: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:39 +0100
Message-ID: <20261118150318.082638198@linuxfoundation.org>
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
index 78380fec8839e..19ea1add016c9 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -1180,6 +1180,7 @@ wcd_tx: codec@0,3 {
 &tlmm {
 	gpio-reserved-ranges = <33 3>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



