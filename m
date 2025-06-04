Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C1778F2B;
	Wed,  4 Jun 2025 00:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998268; cv=none; b=Ufwr92EswkKSLE3W3rOMR9S84hAKi8QPo8cyStaMGRMl4NHPVXP0IvE8zCU++M45yX2IxBBSM2j3soWXRO09zNiroBDp8y9s5Q1B+XM6HS/nLYb3F9feH9nfAUXJl30BvSa5vFbLfwPJvGsTXBs+CAJfXAR3VxG9AepU8K81UcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998268; c=relaxed/simple;
	bh=ShxFGcdclnmjcr5cRrjXWvRJD7GwuxdAv84zWLQHOEs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hDOL+U1aogX4XDZzoqgRhotH71DinBb5Nxv1bLaVLo173URQ048zjvLjUlYU+UvpCDLZj+Q+lcIBBT5HyyYfXLSvlFhJp3DIZC2bmzdt7wRbeTsNcHe+UETinkcQwCiF8JNEIdlGD+GfHD7VqFkxwag9RCkLGDlVGIJQZeUfgIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDWceiAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDWceiAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEEAC4CEF1;
	Wed,  4 Jun 2025 00:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998268;
	bh=ShxFGcdclnmjcr5cRrjXWvRJD7GwuxdAv84zWLQHOEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDWceiADBK2JnrpehRSb+UWewppbpBB3UV6RlkwYyvq1tTN/9ffjgzVuC7ImBqhGY
	 nHVoxENmvcrH8PPawWw4BDT64MvGGNTkylAsU8j9NhtBh/7zGuqmWgfm9xmoLx9ukH
	 2CxyN43M60fgj7XFLWaGfhxHcqgvzcYzu9lhL0fiNYp1I6v+g/DK2Ly9Kx7BJL6jpp
	 ClntzHglUtEymvgQqc4R0z6t2r03Qz0sjf8pdo8obwezjrWITBV0/ORAjtFAE5WL+8
	 ajqYcwRtjpd1zcaM0bk9i3V8mTN4tIv+FyprvrFDvPsWtbv3U02VJnd/W7+ZSMk1vv
	 KyMeOdgILKCYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: WangYuli <wangyuli@uniontech.com>,
	Hao Li <lihao1@uniontech.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 011/118] Bluetooth: btusb: Add RTL8851BE device 0x0bda:0xb850
Date: Tue,  3 Jun 2025 20:49:02 -0400
Message-Id: <20250604005049.4147522-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit c4dbb1bdada90168dd5fa2f7e4553cb0e1dad3c8 ]

The information in /sys/kernel/debug/usb/devices about the Bluetooth
device is listed as the below:

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  3 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=b850 Rev= 0.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
S:  SerialNumber=00e04c000001
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
I:  If#= 1 Alt= 6 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  63 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  63 Ivl=1ms

Co-developed-by: Hao Li <lihao1@uniontech.com>
Signed-off-by: Hao Li <lihao1@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now let me analyze this commit thoroughly based on the criteria and
compare it with the similar historical commits. **YES** This commit
should be backported to stable kernel trees. **Extensive Analysis:**
**1. Nature of the Change:** The commit adds USB device ID support for a
new Realtek RTL8851BE Bluetooth device (0x0bda:0xb850) to the
`quirks_table` in `drivers/bluetooth/btusb.c`. This is a minimal,
contained change that adds exactly one line: ```c { USB_DEVICE(0x0bda,
0xb850), .driver_info = BTUSB_REALTEK }, ``` **2. Comparison with
Historical Similar Commits:** All provided historical similar commits
(commits #2-#5) that add Realtek Bluetooth device IDs have "Backport
Status: YES". These commits follow the exact same pattern: - Adding USB
device IDs for Realtek Bluetooth chips - Minimal code changes (single
line additions to the device table) - Similar commit message structure
with device information from `/sys/kernel/debug/usb/devices` - Same
driver_info flags (BTUSB_REALTEK and sometimes BTUSB_WIDEBAND_SPEECH)
The only commit marked with "Backport Status: NO" (commit #1) was for
RTL8851BE device 13d3:3600, but this appears to be an inconsistent
marking since it's functionally identical to the others. **3. Bug Fix
Criteria:** This commit fixes a real user issue - users with this
specific RTL8851BE device variant would not have working Bluetooth
functionality without this device ID entry. The fix enables hardware
that was previously non-functional. **4. Risk Assessment:** The risk is
extremely minimal because: - It only adds a device ID to an existing,
well-tested code path - The BTUSB_REALTEK flag directs the device to
established Realtek-specific handling code - No existing functionality
is modified - The change is confined to the device recognition table
**5. Code Context Analysis:** Examining the actual kernel code at
`/home/sasha/linux/drivers/bluetooth/btusb.c:516`, I can confirm the
commit has been applied and fits perfectly within the existing RTL8851BE
device section. The device is grouped appropriately with other RTL8851BE
devices and uses the same driver_info flags as the existing RTL8851BE
entry (0x13d3:0x3600). **6. Stable Tree Compatibility:** Device ID
additions like this are ideal for stable tree backporting because they:
- Fix hardware compatibility issues for specific devices - Don't
introduce new features or architectural changes - Follow the stable
kernel rule of "important fixes with minimal risk" - Are self-contained
and don't depend on other changes **7. User Impact:** Without this
change, users with RTL8851BE devices using vendor ID 0x0bda and product
ID 0xb850 would have non-functional Bluetooth, which significantly
impacts user experience. The commit perfectly matches the pattern of
previously approved similar commits and meets all stable tree criteria
for backporting.

 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index c7c3cd0dcd49e..ef9689f877691 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -513,6 +513,7 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek 8851BE Bluetooth devices */
+	{ USB_DEVICE(0x0bda, 0xb850), .driver_info = BTUSB_REALTEK },
 	{ USB_DEVICE(0x13d3, 0x3600), .driver_info = BTUSB_REALTEK },
 
 	/* Realtek 8852AE Bluetooth devices */
-- 
2.39.5

