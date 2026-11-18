Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024456;
	b=uBo9aELKzd9HAaw8WLmvD9/dSQDmBBJRMovYfG9lwaRLcIS52TGi/pYv+x1b8AvgUzEQ
	 Lvkc6J87HBW9Lb6cznuTgE0dJeqPBGBFAcOyPEAIQaTHlJjXMGMEaQajyIcAbplbq0Fck
	 aa1lZ3PuHtkqf7cmDfEdHiixpimvH0wmdl3ZboWnM1yUSRdoDn9Rlh7MPEvRpHuWRv3oZ
	 b7MTAh8kG2BFrhMqkPPKyn/ACE/Gr08FhxtTLNdLuE88YPwUzY1Q8YRma07nkYgILaKcS
	 2xUGHeCSS+UQyng9aGh0DxLfy61CwIcFFppDfhxR0fnBGwSbtyc5MHizKyRvnCWYfhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BY4FhN3Z9edNAN71mklrpaunygZCS0WWpF8IS7Ar8Fs=;
	b=RfhBytsYHO++yLUMKuYQHaAxHdMlbYUi0NW4IYivzr4g3fG2sd99Qq5CFOTX2JrpWOsa
	 v9G/9H6qzZcKieyCummpt8U2C1747sKE73BLZxGHhxHfKAWrbiA81SypUls0QXBXfCq2W
	 nHPM3KNOnChHaFG3sqldccuEGf1kDTzofFH+gqff9WullRy7EExHMR3vcyDsfkS+g6FgB
	 WCqMZygHhQx3htPiLKrZj4eCdbltW5VR56k9RAl/qukFbOg2Wv3yn8q4rNwkjLTooK8zv
	 HbJ7HTZv6mHFSVmYuZL7uGo4+OLa4/2gn3QKoNs7Mrb1geJAMD4YI0m6Bfi3eKM4Tqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2dZ+8I9g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E629606A31C;
	Wed, 18 Nov 2026 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2dZ+8I9g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879FA1F000C4;
	Wed, 18 Nov 2026 17:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024456;
	bh=BY4FhN3Z9edNAN71mklrpaunygZCS0WWpF8IS7Ar8Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2dZ+8I9gTtvqpesv3h8ccmjg9Jepu6vN8wo86M3NTWsWXjdew4oRCYt2SIT2nXfxY
	 HV753Ws5qYEmHOyFj5ZpDtWbl3CFAQSoC9444vg0aePYMjMxPVMAHX2QiGNLkS6SIB
	 zzGhPxlX/zj8GOI5ohDINTHhufE0Ua6pJ96SP8+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0730/2151] arm64: dts: qcom: x1-dell-thena: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:41:05 +0100
Message-ID: <20261118150148.623616855@linuxfoundation.org>
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

[ Upstream commit 2c376a1b675075018c77d040ba1595db896a75f6 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: e7733b42111c ("arm64: dts: qcom: Add support for Dell Inspiron 7441 / Latitude 7455")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-11-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
index 58a5fe65ae38b..3bfc152793833 100644
--- a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
@@ -1301,6 +1301,7 @@ right_tweeter: speaker@0,1 {
 
 &tlmm {
 	gpio-reserved-ranges = <44 4>,  /* SPI11 (TPM) */
+			       <65 1>,  /* EC reset */
 			       <76 4>,  /* SPI19 (TZ Protected) */
 			       <80 2>,  /* I2C20 (Battery SMBus) */
 			       <238 1>; /* UFS Reset */
-- 
2.53.0



