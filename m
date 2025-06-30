Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E48528C03B;
	Mon, 30 Jun 2025 21:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317344; cv=none; b=ZgbNBx0tFT33Z2Op+F+lCm/CnRAbVwFwUhNif8VpDOj8FA1vz7iVOquwRMNbD5MtgMW+Vss4z/4lY1xaCDdlKB5W7EN+XRh8ygOw8qYesbA9bGBWo57FZCFdONM8UJMAccJoVTt4/KzAkWox67oG/O37BU+2BZJ+kHBXs+rUlP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317344; c=relaxed/simple;
	bh=Ptole0ErNiP5cPa6065jKTFUwsyE8Iv0nXX+V8Mi/9U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t8r7UR8XnVzp2u4E8ODE8dzKMqgXBcJcggXNBaCY5/OUWmfM+P4Bm5IFNsbMP5bBkJ3Ycv9pLPAhhhV8tBb1SUIsqFHOAgiHuP2AcGRHDTFfXpTvefjw8O8tI5mS62js9hdn3p+9gbsySUcWL9u5aJgUSNwWA8zq9kZTvYJ5mbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QONO5yDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QONO5yDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56098C4CEEB;
	Mon, 30 Jun 2025 21:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317344;
	bh=Ptole0ErNiP5cPa6065jKTFUwsyE8Iv0nXX+V8Mi/9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QONO5yDM66KB4yqWeMjJqa5Tm7QcqOZYnPSYbztC8RF88Mx7NbM9DafR1csBjLNrR
	 Z17Z3zu15Uko1FYSe1OVy/2hMKXn4oiWdG996sF8+kqnww8adog8JNLXGsYI5biwOU
	 ZgpOMfjIFhC1rykyWP+cjoSdpTIFVVb6Hs+KD+Ytwowutcb3VPS1NaHiZHPX4VBQ6x
	 0Nifk9QnqkYlU1GyDJrsv4WhUL0y2wB8ktooCg9hPd6JVoJZRkYBN07+CbFcQsOfPA
	 iQIAPoy7mqZTv6JGtYkfU65Gq9kRErWdjBbch6v1K+k/yLLYrS6mMcvDlvj+nHPl2R
	 pS+/lx/ryekmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiaowei Li <xiaowei.li@simcom.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	netdev@vger.kernel.org,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/5] net: usb: qmi_wwan: add SIMCom 8230C composition
Date: Mon, 30 Jun 2025 17:02:16 -0400
Message-Id: <20250630210219.1359777-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630210219.1359777-1-sashal@kernel.org>
References: <20250630210219.1359777-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.295
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
index d0032db3e9f40..496cff5f3d0a3 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1382,6 +1382,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x03f0, 0x9d1d, 1)},	/* HP lt4120 Snapdragon X5 LTE */
 	{QMI_FIXED_INTF(0x22de, 0x9061, 3)},	/* WeTelecom WPD-600N */
 	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9001, 5)},	/* SIMCom 7100E, 7230E, 7600E ++ */
+	{QMI_QUIRK_SET_DTR(0x1e0e, 0x9071, 3)},	/* SIMCom 8230C ++ */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0121, 4)},	/* Quectel EC21 Mini PCIe */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0191, 4)},	/* Quectel EG91 */
 	{QMI_QUIRK_SET_DTR(0x2c7c, 0x0195, 4)},	/* Quectel EG95 */
-- 
2.39.5

