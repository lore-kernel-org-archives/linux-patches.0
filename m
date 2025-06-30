Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156E21865FA;
	Mon, 30 Jun 2025 21:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317256; cv=none; b=ICYNKtP+zVL4+5kxY+BuMuNXRe/fjwKnDMsHe13N3Ewwos7HBSwLlvXXVeWXCQOBzZVnXAXuDFZy5l5iCWJCmEQ2Qbd2uN56Ec4hwFzPngn357lw0X86cpqryKAEyfJfGXtOPO3wz5ZMb4ih8stYA3KqRBP0NePTK0T/IuVLLOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317256; c=relaxed/simple;
	bh=bgJMQE4amCsw0R8LqhB2mlYyLenEe+lgnpfI+NB2hLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kfsWDHUHnT9GpfEYa68e67DVjR3LJIhFuHg8Umev5Zl/tEIrqW4qgCpSmQdQ5MBouQCEbK05lkAzZyFl9YjyOdqqexIjq6DCpnWY/8Ql4Q90UWG+JRy3TFVvXZBDrHP1YX4C7BKNNrSshEAapLeRBm4qEgCkPwv6Dzb/j7ZrlcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=glMyIbnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="glMyIbnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF230C4CEE3;
	Mon, 30 Jun 2025 21:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317256;
	bh=bgJMQE4amCsw0R8LqhB2mlYyLenEe+lgnpfI+NB2hLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glMyIbnzKoQqYUS/Q2JPAaALgaROeHCEQjUvy58x44ISO0v+CKcI7NIynBplhlK6s
	 eXWuKJpV2SBGD1h5A4+rLFJoX9WQUbk+D4XyeSjAu8uy5YPXTwEeqNaY5JTrFt/4MR
	 7FZENH51OrHHkUlrOSCXBXuoTLpbQ1vd10o2E2LAAADsNdFqhOUXTEbKNZsA6/JW+P
	 6qtzLDWKjdrqxd5fItfFI+bD4ON1EPUBDVzetZF1P1dlFxz7ZwepCw7tx3iCab2SOd
	 nyGgq5D+S6CxWUIRh+PTiLQC5GyLiQbyIpEYzguHWNDFB9nukDLNcH7PGglECrnaxI
	 eSP1GP3HxslAg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiaowei Li <xiaowei.li@simcom.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	netdev@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 07/14] net: usb: qmi_wwan: add SIMCom 8230C composition
Date: Mon, 30 Jun 2025 16:46:32 -0400
Message-Id: <20250630204639.1358777-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204639.1358777-1-sashal@kernel.org>
References: <20250630204639.1358777-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.95
Content-Transfer-Encoding: 8bit

From: Xiaowei Li <xiaowei.li@simcom.com>

[ Upstream commit 0b39b055b5b48cbbdf5746a1ca6e3f6b0221e537 ]

Add support for SIMCom 8230C which is based on Qualcomm SDX35 chip.
0x9071: tty (DM) + tty (NMEA) + tty (AT) + rmnet
T:  Bus=01 Lev=01 Prnt=01 Port=05 Cnt=02 Dev#=  8 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1e0e ProdID=9071 Rev= 5.15
S:  Manufacturer=SIMCOM
S:  Product=SDXBAAGHA-IDP _SN:D744C4C5
S:  SerialNumber=0123456789ABCDEF
C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
E:  Ad=84(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
E:  Ad=86(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=none
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Signed-off-by: Xiaowei Li <xiaowei.li@simcom.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Link: https://patch.msgid.link/tencent_21D781FAA4969FEACA6ABB460362B52C9409@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

## Rationale for Backporting:

1. **Stable kernel rules explicitly allow device ID additions**:
   According to Documentation/process/stable-kernel-rules.rst line 15,
   patches must "either fix a real bug that bothers people or just add a
   device ID." This commit clearly falls into the "add a device ID"
   category.

2. **Simple, low-risk change**: The commit adds exactly one line:
  ```c
  {QMI_QUIRK_SET_DTR(0x1e0e, 0x9071, 3)}, /* SIMCom 8230C ++ */
  ```
  This is a minimal change that only affects users with this specific
  hardware (vendor ID 0x1e0e, product ID 0x9071).

3. **Enables hardware that would otherwise not work**: Without this
   device ID entry, users with the SIMCom 8230C modem cannot use their
   hardware with the qmi_wwan driver. This directly impacts
   functionality for those users.

4. **Follows established patterns**: The commit uses `QMI_QUIRK_SET_DTR`
   macro, consistent with the existing SIMCom entry at line 1428:
  ```c
  {QMI_QUIRK_SET_DTR(0x1e0e, 0x9001, 5)}, /* SIMCom 7100E, 7230E, 7600E
  ++ */
  ```
  This shows the vendor has a history of requiring the DTR quirk for
  their devices.

5. **Historical precedent supports backporting**: Of the 5 similar
   commits analyzed, 4 were backported to stable:
   - Fibocom FG132 (YES)
   - MeiG Smart SRM825L (YES)
   - Telit FN912 compositions (YES)
   - Telit FN920C04 compositions (YES)
   - Quectel RG255C (NO)

   The 80% backport rate for similar device ID additions suggests this
type of change is generally considered appropriate for stable.

6. **No risk to existing functionality**: The change only adds support
   for a new device ID (0x9071) and doesn't modify any existing device
   support or core driver functionality.

The commit meets all criteria for stable backporting: it's obviously
correct, tested (as evidenced by the detailed USB descriptor output in
the commit message), small (1 line), and enables hardware support that
users need.

 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index dc84d9029c2c7..3976bc4295dd1 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1432,6 +1432,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x22de, 0x9051, 2)}, /* Hucom Wireless HM-211S/K */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
 	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9001, 5)},	/* SIMCom 7100E, 7230E, 7600E ++ */
+	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9071, 3)},	/* SIMCom 8230C ++ */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0121, 4)},	/* Quectel EC21 Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0191, 4)},	/* Quectel EG91 */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0195, 4)},	/* Quectel EG95 */
-- 
2.39.5

