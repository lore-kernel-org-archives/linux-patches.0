Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017295;
	b=d4xGfx8WCz+lITTlcUsbVxkIv7iZuZFbgAgDQ0uIzWgVUI5vsB1W/4p7b5PeJh+G/HfS
	 VRAi4uUCV1sbaG6B2FU1k/FgPT8gDr2Z0wOii6NN0mnZT9ntw435TKVPKzSpnJjdCJM1M
	 +5ccoqz0i4mu493O4z5qUZuulQ8KphaET/whRunW45YFiYb34GYGr2gTIZ9qiliRsYagu
	 4Mc533Bnt2RdDLepG3XFiHOp52iU6XWTAoVAl4+7yzUZicJ0sSM0jdpASG0TXi4eBIcPJ
	 yrYCW2pzJbU3pbZoa4Gb6Y3ysvLrZgRjUh053wJJj2ue2B0JpaqEXnlv92u5a0X6ENA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LMG93Ll1A6YctrspylNnwSnKnSWRBe6ONXJ7IYbiQtA=;
	b=YAm7Go0DZKmTW1wsgIY352hsV5+8v7oOqB1RSZE/1PSgSHSs2arLxfXyKQvw2eSsvOnn
	 yvT3f7WFtqR6/Pf6PlMFpdXBix8cjad/2RHZm8ty6fXFryBpaF7zaJeNKnzXShbORTegY
	 dW4aDpYQ4jEetQUlIaMGtu4Ul+WbvmpqfCN3Zy/xWwcA5s89WjUW9rNLjep2WiAxCltBG
	 WuDRl7apCPUGvGwgZqUklWbKE08gpm21dIZMoee3tx2+hTrMBNJ0ZoTk4+H9YgGrDZRle
	 18jCid9cawnUh6tTCwNMSzaL9uIrOzUW9k7X2Tlv1ufaTPw1LiCkRS49f3XLQUq24mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jO2Zw3Br;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BADD606A320;
	Wed, 18 Nov 2026 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jO2Zw3Br
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165C51F000C6;
	Wed, 18 Nov 2026 15:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017294;
	bh=LMG93Ll1A6YctrspylNnwSnKnSWRBe6ONXJ7IYbiQtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jO2Zw3Br3+8TW4TdGA+G3w/uKVsbKM4DbLE5EdCmnZYtSIN651iPsMnVr9pImgLds
	 TxLvp3MPoxO1deBAWo7xcj8S1IDmTXSMs5Sx1HzoAHbcN9SjZOn0K5jeiAuJWLG4da
	 TlG1Jjqktnv8+xBOLaC8eUWoKOvNantY7BogfaVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0834/2651] arm64: dts: qcom: x1e78100-t14s: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:34 +0100
Message-ID: <20261118150317.906800676@linuxfoundation.org>
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

[ Upstream commit 07321595ce693eea5854120869a8b1560d7b14d6 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 7d1cbe2f4985 ("arm64: dts: qcom: Add X1E78100 ThinkPad T14s Gen 6")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-3-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi
index 0bee2a3d6e7a9..8f7b016174618 100644
--- a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi
@@ -1385,6 +1385,7 @@ wcd_tx: codec@0,3 {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <72 2>, /* Secure EC I2C connection (?) */
 			       <238 1>; /* UFS Reset */
 
-- 
2.53.0



