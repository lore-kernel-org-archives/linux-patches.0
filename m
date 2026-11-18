Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024431;
	b=A88jD2J3kIl3Qlt2tOFAsFnxA/ZXzE9DHXhvb/4oUJMNooryyx6ZNxVqKn06QTOghIa4
	 fYnSLfROAIGAfjLvZ1ShjmDCeXPrD6nZaPiG7fM7Ailex0zY2czHQa/HnKMErvzhWnlH8
	 6FzMmBczOtRR5hw9a9PhLNx5EzsA2Ovq3gJd9B+ZNW/mj2MLc/mo3isRpmJPKGSTE3ohw
	 C4hYnTpiMzxBx5KYtebvwU/hR3uelQZnA8du8gBq+5srrchEAllbDLULkCkcaHstYfTxR
	 Ge0NJwNpn1s/cDv2c9AbZWYajy1n0pAiGmVgGdAQjkroqHRIVytEEL7a0+FPNlYJazA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tUpRS4sPy9DrlR/nsAO1j5qrEWQ0upS2SLL737AqJto=;
	b=o75NT6kaLMtwJY6+BWn+uP/cVuQB5eMuBcGJl+WOmCVW1/b37hAyVjgt7rtZBpEZZBIQ
	 mtFtP60BaFIXrDso70qJpXgnMp6jRAIGdeh5QlmcMOB7u8H99fp7B1GM9Ed5xtH6PO9jo
	 ST7UgI5MSkW+uXqmt8D/D8JOYMx5IjkZWKC6NRGxZ7Zuhjw/QxpuB1Z8I3c7NH40ZnKdl
	 n6EsD4BBOb9Vuo+c1w7bsAn6zRRE05/R+96VBgjw0VEIBYAZ6IHobahj9P6l71/I5NLfn
	 f3LFacjpUrrvPtpRKlf26P3YcHRNZvOCSnGHWSkxskh3djhxz3aNU2NfWvDHt6Yl6Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ovQ5BVnj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2C4606A31C;
	Wed, 18 Nov 2026 17:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ovQ5BVnj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF9B1F000C4;
	Wed, 18 Nov 2026 17:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024431;
	bh=tUpRS4sPy9DrlR/nsAO1j5qrEWQ0upS2SLL737AqJto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ovQ5BVnjqlvEKEycF3ofWrrHVz3mc4+9Iq5/MKDJ6A6UIYcGzoOW4y9WTDhfb6EsE
	 QNCuWaczCwpSmKVBmlPv3SmRaFBFBK89XxwhZKhkXowIEX8I1g6KoWe2N6F34XbKn0
	 kpsLDMl/QNyc3FhCU95qNHda2OR8jIsIV3aAkS08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Garner <charlie@akao.au>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0722/2151] arm64: dts: qcom: x1e80100-dell-inspiron-14-plus-7441: fix touchscreen i2c address
Date: Wed, 18 Nov 2026 15:40:57 +0100
Message-ID: <20261118150148.329724160@linuxfoundation.org>
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

From: Charlie Garner <charlie@akao.au>

[ Upstream commit 52c679ecfd03312c585bfbfe1c7a0d3a9c25cf0e ]

The touchscreen is at i2c address 0x09, not 0x10. Nothing responds at 0x10,
so i2c_hid_of never probes and the panel does not work. tlmm pin 51, the
touchscreen interrupt, is left unclaimed as a result.

Scanning the bus shows only 0x09 responding (0x28 also ACKs but returns
zeros, presumably an alternate address on the same controller). Linux bus
0 here is the GENI I2C controller at 0xa80000, which is i2c8 in the DT:

	# i2cdetect -y -r 0
	00:          -- 09 -- -- -- -- -- --
	...

and 0x09 returns a valid HID-over-I2C descriptor:

	1e 00  descriptor length 30
	00 01  bcdVersion 1.00
	6b 03  report descriptor length 875
	...
	bd 29  vendor 0x29bd
	03 11  product 0x1103

whose report descriptor opens as a Windows Precision touchscreen:

	05 0d  Usage Page (Digitizer)
	09 04  Usage (Touch Screen)
	a1 01  Collection (Application)
	85 10  Report ID (0x10)
	05 0d  Usage Page (Digitizer)
	09 22  Usage (Finger)
	a1 02  Collection (Logical)
	09 42  Usage (Tip Switch)
	...    Contact Id, 16-bit X/Y, unit exponent -3

The firmware agrees. The DSDT describes one touchscreen, \_SB.TSC1, on
I2C9 (QUP_1_SE_0 at 0xa80000, i2c8 here) with its interrupt on GPIO 51.
Its _HID, slave address and HID descriptor address are placeholders that
UEFI fills in at boot, and on this machine they read LXST2021, 0x09 and
0x0001. Nothing at 0x28 is described. The Latitude 7455 DT already has the
same LXST2021 touchscreen at 0x09.

The original touchscreen@10 node is identical to the ones in
x1-crd.dtsi, x1e80100-dell-xps13-9345.dts and
x1e78100-lenovo-thinkpad-t14s.dtsi, which the Inspiron DT was based on.

Rename the node to match the corrected unit address.

Fixes: e7733b42111c ("arm64: dts: qcom: Add support for Dell Inspiron 7441 / Latitude 7455")
Signed-off-by: Charlie Garner <charlie@akao.au>
Link: https://lore.kernel.org/r/20260923152506.44989-3-charlie@akao.au
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/x1e80100-dell-inspiron-14-plus-7441.dts     | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-dell-inspiron-14-plus-7441.dts b/arch/arm64/boot/dts/qcom/x1e80100-dell-inspiron-14-plus-7441.dts
index 75e10d97c3867..d10ce9f381eaa 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-dell-inspiron-14-plus-7441.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-dell-inspiron-14-plus-7441.dts
@@ -25,9 +25,9 @@ &gpu_zap_shader {
 };
 
 &i2c8 {
-	touchscreen@10 {
+	touchscreen@9 {
 		compatible = "hid-over-i2c";
-		reg = <0x10>;
+		reg = <0x9>;
 
 		hid-descr-addr = <0x1>;
 		interrupts-extended = <&tlmm 51 IRQ_TYPE_LEVEL_LOW>;
-- 
2.53.0



