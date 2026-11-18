Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024442;
	b=PNOsYmI516dC67Yzx6HH83IvPXxUZxUMJI0VlVaAHqj+37bxwJPXLMdnZqj1VUC2utTf
	 r28TNWjY6ZzjWhsln2ake9DXV1/n2JA/IdJrL2wtk2C8LoOFFj1cBLSwo6TJOPAO9pzTt
	 HqfeTzxyKbMhXM6m4d3FNWLLODcC+kzQSlvMOEgOg62MVMGloApMaLHcIpcge0jcQRtWM
	 8oUsyjw0LB3NSIKxdoxX5F/u0KMKRdeeA6/p1YOQTcWUjiUwy1rBIKSBblOEoA8Kl21J5
	 SD//8q5SZpHqnzcnELkSZTOefshDxl29Ih3d5UnltB+6hZo+dMONJK3PIqmIQlksPjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZXRARhRYYLAbJnRN8Zk9WLm45yXUV6lyW1qFilJzpTI=;
	b=hRfJPd2DY/igfqispGOBbMv7/6ebxvFP6BYK10SRWjPNLLH/Uo6EA7wfSHOl2G1ONNBV
	 Me4LZejypoEmGAQmyimlgZ8rTT7v1cuHPRP6tGmsi+SQlHRTw4277Srosm8s+9QkWnjds
	 m7KTv2xZxFU5iuXalcQ+qR2N1XLq0zb1RtDuSyYOLe1dWrSB/PX+kxLa0XCIrf3U/Tvfr
	 DSpVFaVzONnTSgc5ih/eyk1TFhgA89yjmVFPSM2y0y4kN1bwlNBhEbKbdeakxWcFQIBz7
	 gjaxVtWWgidK2pxQTjvKvcjhRlSyglWTK9/hMWIGy3OPTc7bo031b43Lpd0KiRKHDkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfBEKIeM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AED606A31C;
	Wed, 18 Nov 2026 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfBEKIeM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54D01F000C4;
	Wed, 18 Nov 2026 17:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024442;
	bh=ZXRARhRYYLAbJnRN8Zk9WLm45yXUV6lyW1qFilJzpTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfBEKIeMLW7FG1TWr9pPcraokQ7zBh1xOdxgxJUINgn8a5ItzdvAoLkPiEcZeDz4r
	 f01pVpXIGM3A3lR+kqZK0rtEoE3wq+UPWJVDXrS+ESipyBhVRUzk/Gk+qHEL6ErZr+
	 6NKHAyCcGtMmUgR3E3NeWZhdxSrxTMyIuBwz6sMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0726/2151] arm64: dts: qcom: x1e80100-dell-xps13-9345: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:41:01 +0100
Message-ID: <20261118150148.483297856@linuxfoundation.org>
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

[ Upstream commit 5630150c90db33df906d26cc4b6ff56315471352 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: f5b788d0e8cd ("arm64: dts: qcom: Add support for X1-based Dell XPS 13 9345")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-4-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts b/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
index c1f49cba61fc4..373aec773d732 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
@@ -1070,6 +1070,7 @@ &smb2360_1_eusb2_repeater {
 &tlmm {
 	gpio-reserved-ranges = <44 4>,  /* SPI11 (TPM) */
 			       <76 4>,  /* SPI19 (TZ Protected) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	cam_indicator_en: cam-indicator-en-state {
-- 
2.53.0



