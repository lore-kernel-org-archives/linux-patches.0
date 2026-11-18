Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017297;
	b=kuoEKJyzTsmwtHdD3KUYw1FV6xCEhTH7awUL+iVW16b5lVZXLThKWvo/3PlxNkgxcFKr
	 r+yedaNJE5Nl5GzqJwonuwttO3ZY3x9xkaBl798LoKRI4qeAqYhoHjpyaGGhmYE3vexmL
	 c3IXDIXO9siac8/YYz+LW/u8ZY7cz2CtpibmPt6uNen9Md5CLhXZJPeEXTaT9V+GWCXK5
	 kAbHUuKLOcaIB6Tw+p6BhaJAadASBAf0kvD4ECJgwPS2EWWSM3nG5OnDdrv+AI8EP+iir
	 4vZjtl6/hurn9Mo1jTxJb9rGce6QG/53VJCwYFdD32Y4HxxSjAvqouDPKshQKO3Ne+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dl8GdeO+qi3itIRMkB2jwm6meLQL/aQ68Au2EHbZteU=;
	b=DSRk5ctpSi96LusijN7dhVnmS4trOuSFSeyhzN7eSl2te4h43UrBbojWbhyWBsrDzBNI
	 FQXsHgaJa+AH7xocOimHYgku7Lpu/Ps+OBdyXoHxmkXyT9UToymibPfpt0E5yRCKBHfsW
	 HI4RBNjXvgdkfQVWA3VDYd4wwCDAhr+ImFWwYPHEgQJjHmLGwwT1HPLrxj6InZfdZCiad
	 b7Ay92npGA8Uz97hZdYuo9PWKEHPW5j7Ue7iAmoD96kHIUCj8Sf0pDluKUB77UqEXtv1z
	 03DKgchY3jGWZv+vcIbxdQ8+SQZ9NJ4y5dZAy8tat4hNTsBPA9AjMMN6FRZkQOEykJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fUTKKBRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD3B606A31C;
	Wed, 18 Nov 2026 15:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fUTKKBRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23F91F000C6;
	Wed, 18 Nov 2026 15:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017297;
	bh=dl8GdeO+qi3itIRMkB2jwm6meLQL/aQ68Au2EHbZteU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUTKKBRZot+2J/WoE8nSy2YMsdtGDx1e/dwjHpJbY4JW3evOn9w2i6ree1aOEmlC2
	 Wg+4bA1Blo8x27KrFtfjm/d2Yn5WESWLI5Mz0C8sq1OBYs6PJC8PXIZjUtmfk1OARo
	 nII66Rj3yEfa8XomLGZ0H+RS4VG8z39E7+ZCYZyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0835/2651] arm64: dts: qcom: x1e80100-dell-xps13-9345: Mark the EC reset gpio as reserved
Date: Wed, 18 Nov 2026 15:34:35 +0100
Message-ID: <20261118150317.942474895@linuxfoundation.org>
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
index 2be5a37c00ccc..b795b65d604ef 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-dell-xps13-9345.dts
@@ -1072,6 +1072,7 @@ &smb2360_1_eusb2_repeater {
 &tlmm {
 	gpio-reserved-ranges = <44 4>,  /* SPI11 (TPM) */
 			       <76 4>,  /* SPI19 (TZ Protected) */
+			       <65 1>, /* EC reset */
 			       <238 1>; /* UFS Reset */
 
 	cam_indicator_en: cam-indicator-en-state {
-- 
2.53.0



