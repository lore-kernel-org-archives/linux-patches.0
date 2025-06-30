Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6E41865FA;
	Mon, 30 Jun 2025 21:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317208; cv=none; b=CG9nA/rNfg2NwDnXnRFKZ7TtMH42UBc0h8cF8AGNwDnjTUNSRpLc9q8IQGcvwjDdSR2nDx81txWdfpfuXcc527XyJDzygIPWpBl2/Qsyc98Rr0PN2FGvdg3OvFA9Wr1GuUWJMRz+HX2Avmu/qjSgjZq7E82xgnE0C9lG7PRzzCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317208; c=relaxed/simple;
	bh=mXDjZlav0XZP/z7Ew8l/OLyjoAWWRlbVf9BXzQspdfM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IbedOMGrcR+BNja0YJS/k3pW28tryF5bnw7QNvIMvfOpRZfT+AMnHTkBQEepdniQC73C5seyNdS94nYMSUXG+9ac6adDbkuh8qIG0VbLsqRTHpp0vQIjoTPkzGQeeD8//lhoqMNc0wHRSi0JBfEARZNUY4fyNlbQ8kMRzWxjIQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SvOokl8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SvOokl8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86E8C4CEE3;
	Mon, 30 Jun 2025 21:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317207;
	bh=mXDjZlav0XZP/z7Ew8l/OLyjoAWWRlbVf9BXzQspdfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvOokl8eiprMvrsfi4VZ1ic/yvblaJWoVHoPgl2XrBBeQ1j4HsXTXHIDX0AGcATyG
	 YxPbjaeKwkxqBV4KHT8/sCAHeFN74PK0+DYbwtlpKyK3Zd0WNuLnzZ74FpPaqCHmXn
	 z+CC+T0oMhMJtPDfLDKXFHjOZMnu+Wd9onZs1jb/XEfyu4j5SuP/xSeIGSZdq+IOmE
	 4LM1iAne+W/1EO8GeXJkm4l14Fwboazq8bjfbgJSqVPP/JLbPZr3LlJkU1j7KVBHue
	 V2ghKSO3BwXqWnyuCIfGgeXuHpzcEm7dO61JyRAGD9q5B4qusnoa/GQrN9dmDR6JCM
	 ODx+vaBuBGAUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiaowei Li <xiaowei.li@simcom.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	netdev@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 11/21] net: usb: qmi_wwan: add SIMCom 8230C composition
Date: Mon, 30 Jun 2025 16:45:26 -0400
Message-Id: <20250630204536.1358327-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204536.1358327-1-sashal@kernel.org>
References: <20250630204536.1358327-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.35
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
index 944a33361dae5..7e0608f568353 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1426,6 +1426,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x22de, 0x9051, 2)}, /* Hucom Wireless HM-211S/K */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
 	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9001, 5)},	/* SIMCom 7100E, 7230E, 7600E ++ */
+	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9071, 3)},	/* SIMCom 8230C ++ */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0121, 4)},	/* Quectel EC21 Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0191, 4)},	/* Quectel EG91 */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0195, 4)},	/* Quectel EG95 */
-- 
2.39.5

