Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017400;
	b=YBGoVdewBffLFxKxvH8AgN7WeOhihYkrmRJVBEamNt9e8FuPxf1ZzyRXqYVmV+I7rB5h
	 Eq9a6ItJ4JNr7QT+2ygfDgYO+VeYuvwczQEQMKuOpC8uy422TH2Gpmf2bFHCb7QxP7NgG
	 2CxehsR1pqWjU8v8ayA5I0fM88znDL0Q8IiWG3JnuFqinwU4sgkeEpAp/d/p7LoQZ09ix
	 riF2+k0MlBETxxeppPO3edS2TMn7p91nz5AHDyflQBLW49mj9I3LdGvIzYrsDSGoZ4hB2
	 IeNPS+4iaFaMDRWpkJysB/QzpXSvhBVob5tFUIZc2LfQ91vCz5vwtyYCILoZu2VkNWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pMuITxPD+kbXrBj3tKRYEfM4TpCSZExCa9ETj0QM/cc=;
	b=gD2Bqy+vY0IRl8JKYm7/PzMtNUjRbWW+kCsTuVxhFifhYqSpI4zazDGpcZvsQejWSN2r
	 j3KZhcpX2yVEdluySGGULlHOCX8jZeVwBc6ZVc5t4UFsZuVxQvtSY+XtctmcEP1CDskNx
	 PShKnEfkwe3m+9pZbLyNdXN5lUiqYPW7ek+k89HMJ92U3YS1sty0lR5Y8na88TF6z4Rha
	 joJQDRajwzYRcPlPPZadW7wMq1rg5QRi077LOrW35q6V50ZZQIpT7d+NEBrN5a8TEcxk4
	 Nc1drp0/Tm1iaPUsrbbXkduVFWusnxd0uEGa2vl9Ipo7KhZ1fhkv3nEKYj9xBpAPGzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=myePdna0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3463B606A32C;
	Wed, 18 Nov 2026 15:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=myePdna0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D581F000C4;
	Wed, 18 Nov 2026 15:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017400;
	bh=pMuITxPD+kbXrBj3tKRYEfM4TpCSZExCa9ETj0QM/cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myePdna0H9Ck79xXn1XTzC5F38tMfRwdSpEtSdoAMsKKcL0JhC5iwMXB7y4VcjQD5
	 pPEVmxWhp0hplXYSi8RQ6KZU7op/N060mb6DXFrQyso+xDftC9JRWa9SrxK6H8kvMp
	 RGfwpoOm6FDyG3iLFbXuNr7iAK5UPyPy0AQLC6us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Garner <charlie@akao.au>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0831/2651] arm64: dts: qcom: x1e80100-dell-inspiron-14-plus-7441: fix touchscreen i2c address
Date: Wed, 18 Nov 2026 15:34:31 +0100
Message-ID: <20261118150317.802196577@linuxfoundation.org>
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



