Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024459;
	b=pWv4kzdlwyG1D0j3j22hIOgbOh5bqFaMFk/dYZTKs2poDwSrMVcDKC5uUFBhojaOZF/T
	 c+ZSCi3xtr9iDHsQH5z1RumoiaENpKzcubMG4l8wob/Bt3Lc7MSXph2w22+w886vN3EdV
	 iWzBJYWAsqPyOwVd5KVCttVThDeGYK79+3uaR0158d7FRxr3PUUqcgBR8QpRaJwIxocBD
	 LpF0f3/AADf5YjlJpRFy5HJwrsv4eN46lyiLwhZHB2kbiik9AFFueQ1uvBojUWy1+u1mI
	 MQXrWsI464XsrYZJtbm2oD9wuIAHqLsn3a18HXvnHXpTEilT6783+8ISaeEsUUUKi8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nKjANcTdAqQ8XUy8Zo8rMrJA2mjAOwNgZdUc7J+/6yI=;
	b=WQ4sI1u7fSSFMvPFeMVdv3cgA9EbMh+a8BQou+xJXOmHDJBV1dEx3L4CAMwv66LsUznu
	 s8KOz0iLHpKFMVmPBsYnCmwIdL+eIaFVRn8UpH1wPV37bXvJio95IZ2yiUP8vDC/2GX0D
	 /zlyox0sJVyinoUqm8rwtXIyYkPtS13BMfgoRoA5vufW//4ieLrJ7ceOeoipVjGuGIBA7
	 xF4BspvvwSDqgp/sQB/XHMV1CD/xjue0BAvOMQLULnD/zE9l2XIpKMyXPX0LHTdE2w4jV
	 rKHne5LSQIETp2DCkkre3iY5vWG3lGhpB3Z5G4A2n19V2U1qzgO3CdlKJ0MvsYSrj4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KK/0+Cqz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02041606A320;
	Wed, 18 Nov 2026 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KK/0+Cqz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538BF1F000C4;
	Wed, 18 Nov 2026 17:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024458;
	bh=nKjANcTdAqQ8XUy8Zo8rMrJA2mjAOwNgZdUc7J+/6yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KK/0+CqzQK0v74kMJSKsgEQ0r0ihoVBoXZWD21epoot81k2AUryZNRGXNRQ3S2nM8
	 u4Y0q+lV8r3FjD3+y+yXYs1loJ7zqZ6AZFOXGTw0vKcY5BEnu3GkCB+M0shAXJCfKU
	 ua0BRGQcGNbfEGjh/+52c04S+YjkGebRqu4wHEew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0731/2151] arm64: dts: qcom: x1-hp-omnibook-x14: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:41:06 +0100
Message-ID: <20261118150148.654679102@linuxfoundation.org>
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

[ Upstream commit 4ea8c5b790dd884bb5118336dfcb2c648cb40b2d ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: 6f18b8d4142c ("arm64: dts: qcom: x1e80100-hp-x14: dt for HP Omnibook X Laptop 14")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-12-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi b/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi
index a4075434162aa..88810fb07ff2c 100644
--- a/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-hp-omnibook-x14.dtsi
@@ -1285,6 +1285,7 @@ wcd_tx: codec@0,3 {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <72 2>, /* Secure EC I2C connection (?) */
 			       <238 1>; /* UFS Reset */
 
-- 
2.53.0



