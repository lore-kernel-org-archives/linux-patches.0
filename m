Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024462;
	b=z5F58NShAZ9pLYz+kxEaN08VOfZpki0cxoeboVc9rPR/eXSaCq58Bc4tTkXJ9HWLgYba
	 wQJ181LNkeF5GLAFagjVW0LvOduSvT6czWJ4AtN9eAJRNpQuj1C1MKSV5se8tJ640gIa/
	 NS3zshxbWdSdSTdm10X5R3MKW0sVLKxo6dWF1ZZpJl7qOdPUsjTs0G5uY2oCKBIGteBZI
	 qEKzjdfMoERj1Tg17PkffN2fW7un6+b04BmAoLVDaHi1p0v9dkEXorFS/ZXMLt5OUes1H
	 5z1lL/AqXKilMW7iHlPMyPwPXCc+O+pd7QZglGFgy/OvLtGCa4U4XbOuedmuVu5ra8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UAAohKH92SxHRvG/sCRdQpuHwgkqtwM8aqQjDIOxOLs=;
	b=o3MiL8+9Rme50wOF0qoSAbjRypDdhYeo3YOjFjRlT1dgsxGyiRiCLQJW22/2f/YItavs
	 uKsjOOh2hGkY4V07x8KTz67MJ/tRGbfK5ielaDFP7ohmr9hn/aDFrWDGeSthSWybT3LUU
	 t92N5ukvhfyI1ZTSRuYAGkpuruyIMMy33kNP86+ajwg4Tv9yIRoDdFcKE+BFKy1XdnS62
	 E6fRiTM91rWpbT1anquYn5EuXJOjRnMsvq4twiLlEGEGUEQHQfLA1nIjmcRRHMwBICrQw
	 ltDt5UDCoT+O3M6pV32MzWnebwNlC81lSCQhBm9d1guFZr01KrFhv3V9dxzIb130Vvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bqkZD3Kd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E836606A320;
	Wed, 18 Nov 2026 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bqkZD3Kd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DC61F000C4;
	Wed, 18 Nov 2026 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024461;
	bh=UAAohKH92SxHRvG/sCRdQpuHwgkqtwM8aqQjDIOxOLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqkZD3KdHzN4ezVlStG0I18AucOSB+tcCeGNA50ywfstVCS8eTy1XJwfSTuU0gnnj
	 WUMz0LMrNzLSu4J+bODFH6Gjf0omrV9dCvmRx5DjGEa8ygFlw4cPryfYVz/R144ZaS
	 mtbVC1/Fedq3chBaFrIbye5OIUcoBOxoMpsnqMug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0732/2151] arm64: dts: qcom: x1p42100-thinkbook-16: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:41:07 +0100
Message-ID: <20261118150148.685953959@linuxfoundation.org>
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

[ Upstream commit d15d83967b113e43a4811164ada19909d99c93a7 ]

GPIO 65 from TLMM is used by the embedded controller as its reset line.

On some devices, toggling the embedded controller reset line makes the
device not power up at all, unless the battery is unplugged.

So reserve it in order to prevent Linux from requesting or
reconfiguring it.

Fixes: d3f600dc452d ("arm64: dts: qcom: Add Lenovo ThinkBook 16 G7 QOY device tree")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260922-dts-qcom-hamoa-reserve-ec-reset-gpio-v3-13-fde7f8a53382@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts b/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
index 3186e79e862de..af0bebb1711b0 100644
--- a/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
+++ b/arch/arm64/boot/dts/qcom/x1p42100-lenovo-thinkbook-16.dts
@@ -1275,6 +1275,7 @@ wcd_tx: codec@0,3 {
 
 &tlmm {
 	gpio-reserved-ranges = <34 2>, /* Unused */
+			       <65 1>, /* EC reset */
 			       <72 2>; /* Secure EC I2C connection (?) */
 
 	edp_hpd_default: edp-hpd-default-state {
-- 
2.53.0



