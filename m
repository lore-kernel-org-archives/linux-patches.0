Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACDB302CBA;
	Wed, 10 Dec 2025 07:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352104; cv=none; b=asZ6depoboTYoCxVREHfQTGcCqJzwiXaLeg0L27/HBW2Swh7zJDXi772ZsqDpI9T8ilERtJRNVdynTpfONJIoYwBGep3Tuqc3Lw55w9mdE6VEvGyOwLcSuE29n1wGXlrTBx40Pd30rH9k5C4OZtd/sDbfIH1qocwVTipgDU6Fx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352104; c=relaxed/simple;
	bh=G/4mZRCnM6+xPzFSIL7YXUwlr9hdThuOJic+w5K72VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9w8y+gHl3VYq+SYqIi+0UAA2AwpDf/ZMOHh7mQhvMD5SZ86RVSlCw/mrF/t4ohry0RfKruA2SE56g/UaKa8sMB8hDtrCt3AVWm5q/EJiP62PoDkQ7qnIztuuVjmuLQ4MeQ8skNZTnOvbg6K25DcDFSWjp2WNINfZJAUr6QJMKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTzTC4aX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTzTC4aX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41612C4CEF1;
	Wed, 10 Dec 2025 07:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352104;
	bh=G/4mZRCnM6+xPzFSIL7YXUwlr9hdThuOJic+w5K72VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTzTC4aX0RVlTaQxZwqrK4hBtTYUkfnKpB6PqidPWjG4rUYEziwM0HosXQ+eBC2cJ
	 rYby9VkCZlqK6NN6ZMEfExtzMPe4D5XZfM+zi1nZFtwZPkxtE/16860DLlRQZygVVZ
	 tqSF/GWmJ4pnjmaQFrR2sYID1h8F7HgUHY6eZXmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.17 52/60] wifi: rtl8xxxu: Add USB ID 2001:3328 for D-Link AN3U rev. A1
Date: Wed, 10 Dec 2025 16:30:22 +0900
Message-ID: <20251210072949.161397461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8113,6 +8113,9 @@ static const struct usb_device_id dev_ta
 /* TP-Link TL-WN823N V2 */
 {USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0135, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192fu_fops},
+/* D-Link AN3U rev. A1 */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3328, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192fu_fops},
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 /* Still supported by rtlwifi */
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8176, 0xff, 0xff, 0xff),


