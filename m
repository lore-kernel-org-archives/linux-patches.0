Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024439;
	b=MOBup7KBKv0dKIEQmWa2ST+lD8da+DQUsH32NExVUH8isr50OAYfJbv6RjCXhjhxxrP5
	 Vuii/MA+qZxir5s8VTAdeNdRZi16LDAd8DrTzxJ/2pKKjr+iqssG3wJDNFnMkLxbigAID
	 91BHIJKJEX7f7V6pQL4yr7mj+3rGUjFl4f/OyKbKUamqZ27vuKnGy3YZDI06alne2q2Hr
	 tnvkEPgvy8jm7HjK6KFcFi8E9mUBA8nUxhynT3rlCtsktb+OOnCZrqlVR2xmpSU9cE97X
	 QZVZ4bPbzCSz63zgl0V1caAJ/6yEoDXA1fRpol1Q0bJRaf0gE+XicOg88FqAmSb1+Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HzDffjiUfrntb0W7WfrDFwlbFdv2r6POcplesfmCgQw=;
	b=W6dIT27fIoSAJglSSC6ILTvGHunz3ie/sRlwJhdKn4u9DxFt+MMyuAJbQW//zFse/v6s
	 cHZkfYIfW6jRaR/3csqDS3ITCOHi8iftFaqLiMOcZyYZmH4zuKFOexqd1mG+1KtvVqN1S
	 GrPvQZyPpp0XvYdqWx7QQZb6un3eiDC9vZtodnEpGl6j+6f6nlV+tTJTnCYY9Y2LXmYbf
	 mIo7tb5l+Eg8Y24+TpfDPqAEfbCak1NoFJymuMe//0Ap4WKy6URfVNwxpNXUL0CcMPj3L
	 qL7Wu58S6bAtA5VErdUdOqbitlBmmTKpqw8dTehUT6KqCS55MWnwasrliEEBm2m0Www==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GkHC6nwv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88231606A320;
	Wed, 18 Nov 2026 17:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GkHC6nwv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0901F000C4;
	Wed, 18 Nov 2026 17:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024439;
	bh=HzDffjiUfrntb0W7WfrDFwlbFdv2r6POcplesfmCgQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkHC6nwvG3w+okIPHFGYCzQHoWoTO1Uha5tdVgYIqR6Ltv5v1jD2kc6sv1cb7YTlR
	 +NLzsM/pISoDfXrXulbcfXz4OZVx2VH/a8bxZBsE6UFNn28TY01gKyLDswbygXMDwV
	 r8WCGOTEZ7GI9EccQjaHGufg50ER5axmjt/pTaaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0725/2151] arm64: dts: qcom: x1e78100-t14s: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:41:00 +0100
Message-ID: <20261118150148.447464667@linuxfoundation.org>
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
index 169726984d3b0..8179f571ceba8 100644
--- a/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e78100-lenovo-thinkpad-t14s.dtsi
@@ -1284,6 +1284,7 @@ wcd_tx: codec@0,3 {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <72 2>, /* Secure EC I2C connection (?) */
 			       <238 1>; /* UFS Reset */
 
-- 
2.53.0



