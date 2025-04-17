Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F375256C79;
	Thu, 17 Apr 2025 17:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912769; cv=none; b=bxQIkx9+yJJ5vYslV1IR9cxf2LiV2aAUXbCwGCeOXvlqs6rCR8AOf1d3enCgbTZ80KJIo8wgfz9h6+jaXYuA32YHrVuWpkw9+3EFFY8rC/9cjQriArUAkyVubid63xoC06F/8+MV1kYArRERQI7DbxuJbekoLqhb+4kOBVIjMbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912769; c=relaxed/simple;
	bh=CSyfXDBMaODdWhPXyU5vU2HO6DnLT1E8e5+8D48mhpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADzYMYIIAmgFifLwbzVpHX27Q7LUbRiu8btky+oNuTbNJH+4Qm/rPJr0Q4XhSlWufgn25z/qtFBD5vlt7a7UMnR602caR27pQbNBgxk1HcurUkd3rq0rPwrB3P026l7niycy/mMshw5ZXGmm7234/taTZ3htyMzb7tJgh2cgRSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxrfytsL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxrfytsL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33DDC4CEE4;
	Thu, 17 Apr 2025 17:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912769;
	bh=CSyfXDBMaODdWhPXyU5vU2HO6DnLT1E8e5+8D48mhpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxrfytsL/BVR28ixgN5YUptrzY9Fm+YuMjUF8ifZtC7gv3pLAFt0sVmf4M+FXjzzf
	 eVP5iFwYhaWY8LxDo1+A+IP4EtNUN8ayau8YvZ0Iu0dZckgrUB7+0mcWA3ECjz1Hk1
	 DnNB7m/eLv8rPeRq2C3Z0dhxhXsU7/WxktK6L+Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 118/449] wifi: rtw88: Add support for Mercusys MA30N and D-Link DWA-T185 rev. A1
Date: Thu, 17 Apr 2025 19:46:46 +0200
Message-ID: <20250417175122.717469697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenm Chen <zenmchen@gmail.com>

[ Upstream commit 80c4668d024ff7b5427d90b5fad655ce9461c7b1 ]

Add two more USB IDs found in
https://github.com/RinCat/RTL88x2BU-Linux-Driver
to support Mercusys MA30N and D-Link DWA-T185 rev. A1.

Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250210073610.4174-1-zenmchen@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822bu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822bu.c b/drivers/net/wireless/realtek/rtw88/rtw8822bu.c
index 8883300fc6adb..572d1f31832ee 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822bu.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822bu.c
@@ -73,6 +73,10 @@ static const struct usb_device_id rtw_8822bu_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* ELECOM WDB-867DU3S */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2c4e, 0x0107, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Mercusys MA30H */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2c4e, 0x010a, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* Mercusys MA30N */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3322, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) }, /* D-Link DWA-T185 rev. A1 */
 	{},
 };
 MODULE_DEVICE_TABLE(usb, rtw_8822bu_id_table);
-- 
2.39.5



