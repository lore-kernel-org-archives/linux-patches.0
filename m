Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625180;
	b=qtBBCHRjrtwZwp30uapmVlQzLVtVY4+5R8N+Cld1fB4hZ5MmJh7rqWvoIfwhejIf0qws
	 6EwkoEauohf0jcXzuLc/967jY4uAqVlYpITd9PsR5Bf5E/wn61Zk9UdKfwH8Hcx4CGPSU
	 QlkSVdWoXKP5HO9FEKtwNhScU+mHx8gbsce9/ptFfE9k+MTSPP4oiskoOrsEOPq+vDNxx
	 HXPvPekbYbE570TCnfGp7Bfc54a29n9FEDnUHOE7PMApex73FjWfxsDtAx0cbQ5M/Yf+H
	 avRAsK/Ye/EuhLCtoKWMjD8WgDIdTHLAt/SjdCz7cRM8krgV9G3rulrcb4RNZOubrBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tPnSXCPM9ukV2sVALm0QSY217dYkxQICkiEAGIoCkQA=;
	b=dktFVhDZDZRGudD5kwgfL8BFNXSGO6urCVAMRSnEL6+CZ+Dr3+NCFnQqOgU7TgKeU+l5
	 l1BgDDKryZg2ky/1pFspoDRZHple7OZZpb5e3y2IpRi2upAdglB4GT5p50QGXgHLu+32y
	 8mnU1pFovcJ9WHx6GnK3oI+KRGIEd0U1SR3NguwiN/I8Zqz2HmvUkp7ka6B/HoJJUvlma
	 pjvdteopCUQwRyUtoaGhnoKT83xWF5Eb5/En+retbBxCQHYltc5Jh3uvzGOuGNOd031BH
	 ZGsfneY5n64r5cJwIgRy2sx8uG/n+eKyBUMPrxikL5UnA653UpYuf2JUAKgozJtBeHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WfL3qE/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907AC606A31E;
	Wed, 25 Nov 2026 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WfL3qE/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778611F000C0;
	Wed, 25 Nov 2026 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625180;
	bh=tPnSXCPM9ukV2sVALm0QSY217dYkxQICkiEAGIoCkQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfL3qE/CiOPCers5bMVmE97coQBwFm5HoAU3SOu857VFzCyLHFI4H3ZdJKSwb7tzy
	 BubfKTRfdRAi1MQaACn58wSdieIp7kprPm8khmqu1vnt+RowVIUbwwYSWubBx2Kc67
	 JWyyI37azdUxwYV0Se0dcvilR2SqnLAJP8cjRiE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 433/816] arm64: dts: qcom: x1-asus-vivobook-s15: Mark the EC reset gpio as reserved
Date: Wed, 25 Nov 2026 15:33:01 +0100
Message-ID: <20261125143859.215514122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 94a0d3a2595821878de98d495e89691f694a2083 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: d0e2f8f62dff ("arm64: dts: qcom: Add device tree for ASUS Vivobook S 15")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-9-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
[ sashal: Applied the one-line GPIO 65 reservation to the single x1e80100-asus-vivobook-s15.dts file, since the upstream split dtsi file doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
index ce3fa29de7b4a..62a36017616a6 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
@@ -506,6 +506,7 @@ &smb2360_1_eusb2_repeater {
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
 			       <44 4>, /* SPI (TPM) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	edp_reg_en: edp-reg-en-state {
-- 
2.53.0



