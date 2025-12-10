Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EF33054E6;
	Wed, 10 Dec 2025 07:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352180; cv=none; b=tRqknOCITJ5HNZxmFf6kx1bi2b4/WwV0C9hI1Ik4J5hOv8N3mPStUfvP8wKflguw/RUL+zrdzWFSZ9Gg8nrlCGml+C3s8i7hdzevggt4tGBq+oFiDAIoZaAAaLYGJKUdxG1WzVR0GL2njP1ueE0VJe1ebJgUZ+IenLjZYu2bhqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352180; c=relaxed/simple;
	bh=V4/tnwVeesWSTSJixyZVIlwjOmMgIPupSnzW7HIu6Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMKNNL/xoLUoAMjkSC/MlrlWmOWrg8Vso7MetNdEQnWoAPRotfc1PLbWu9AemY+Y0ELXwzQv0w7gtHmxVQa5R3gBIy7Yo1m7jUjHErbJAufd8XiZIQOaUOQutqkF+SaXhpp7pDiMQfhEVig71wB++weqOF400JK26dKHdUBsYFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sk17dfke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sk17dfke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792E8C4CEF1;
	Wed, 10 Dec 2025 07:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352180;
	bh=V4/tnwVeesWSTSJixyZVIlwjOmMgIPupSnzW7HIu6Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sk17dfkePN1GFwyXSq1xICMcrBPY8k4nejiDEKsaE4/qYlsQAfgjHh3SB7JwR/B8u
	 8t4A9TbuKdUjYsLWwjQsP+TkwLuIOR1b5YOWgQYUK19HLn3mMx7zy0+Fy4922aCVDh
	 NfnhPVpPvhFoGB8uunDPo9wk1ObqBbjP15J8d2ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.18 21/29] wifi: rtl8xxxu: Add USB ID 2001:3328 for D-Link AN3U rev. A1
Date: Wed, 10 Dec 2025 16:30:31 +0900
Message-ID: <20251210072944.938449006@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenm Chen <zenmchen@gmail.com>

commit 3f9553f65d0b77b724565bbe42c4daa3fab57d5c upstream.

Add USB ID 2001:3328 for D-Link AN3U rev. A1 which is a RTL8192FU-based
Wi-Fi adapter.

Compile tested only.

Cc: stable@vger.kernel.org # 6.6.x
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250929035719.6172-1-zenmchen@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -8136,6 +8136,9 @@ static const struct usb_device_id dev_ta
 /* TP-Link TL-WN823N V2 */
 {USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0135, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192fu_fops},
+/* D-Link AN3U rev. A1 */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3328, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192fu_fops},
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 /* Still supported by rtlwifi */
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8176, 0xff, 0xff, 0xff),


