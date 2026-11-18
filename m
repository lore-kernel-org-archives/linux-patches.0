Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024450;
	b=IjBY3pj/CLeXlPwsIQe3z4J6V05P6uJKNi4ZRvciBw1Do7vx7NSif2xl42YJi/zt9mXG
	 GgPy4/poEY2/iRn2CK37Oh8gzRvKMDwvo0NTXlyVy+Lhncjcoi1N/LbUV2Szdc0PcDe1Z
	 M8b6DhDAUitej7kA2pYA8Ve5itO1UCDzuq2VNtlR/3qhKviuKnoTM8I2s6x2Q1YYokS9Y
	 Xq3o5UWWQPuAjvZh3lofL8R9Ja7VTpNMidtY70Q3ChgT3eZJalSDYWmlv2NsTDF1k5xFs
	 k28Evc0d4nLy1kdQCeZEONuF+ixwT2k4jH7BOqfMpeVid9N34yJXqdCOjZZngOKvBqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=srYr0P+9Zibk/GHOxhh7q953nXGL7UiRi4tMs7MQRzQ=;
	b=n7UDxZiAEgrE00GKcKTH4o9/EXfMLxiPWxUcMKN2rwaEjvQf4U8JLQej6xr8pXN5luCj
	 WQ9U2evLaYWI8QJntiUe3KcaPWV8s56jkUIIeLrwgK04vGaOSWFjSVxzImnEPCfUR2VtB
	 St7KU07Exq6WXMk5mKiuL0rKqZ5GVhDnqNVvaGGYu1f6P/CQwtVZa1XzJO6NJscXbiwRC
	 HueIk/43iRVhhu+E83fbxWUadDfywWYywZXgHBWBHqtD/55NzgsbfOzRwvEZoaHfq9bLO
	 DYkddWepBufXT0ZU1yLvdKmiPNd60g8apeotmgnFbJbVx13BfiAIv+70Am5Qa+M1CQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AoXIdDx0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D5B606A31C;
	Wed, 18 Nov 2026 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AoXIdDx0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016791F000C4;
	Wed, 18 Nov 2026 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024450;
	bh=srYr0P+9Zibk/GHOxhh7q953nXGL7UiRi4tMs7MQRzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoXIdDx0GTplXIVGdVc69MwwjvNdObbZK/qzz3xROGNIz0IxCxRFuyYtpv7AligaJ
	 D1iEhbI8vvpu+75gSIir6zCnuTf813qlUvlhDHRVEOap32nxpNYUd1I2vSrd49cJZA
	 c27BAqpo7mYFzUczAkg1QWnR8JPretYmwbS42C1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0729/2151] arm64: dts: qcom: x1-asus-zenbook-a14: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:41:04 +0100
Message-ID: <20261118150148.585463483@linuxfoundation.org>
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

[ Upstream commit 48213677c9173680de328785768ea56315bfdd53 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 6516961352a1 ("arm64: dts: qcom: Add support for X1-based Asus Zenbook A14")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-10-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi b/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
index 8e5c5575a5320..6ad2cf5f5ed07 100644
--- a/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-asus-zenbook-a14.dtsi
@@ -1223,6 +1223,7 @@ wcd_tx: codec@0,3 {
 
 &tlmm {
 	gpio-reserved-ranges = <44 4>,  /* SPI11, TZ Protected */
+			       <65 1>,  /* EC reset */
 			       <90 1>;	/* Unknown, TZ Protected */
 
 	cam_indicator_en: cam-indicator-en-state {
-- 
2.53.0



