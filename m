Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3B52264DC;
	Wed, 10 Dec 2025 07:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351946; cv=none; b=Y/FGWpfAetA41odgnbKWTSnT1X5uaahC9VblLGsomFqAriW7AwegKWpkzO/gimqshb/BPZjgGNLtW33T8Vwo8uwo8SglqoKDZhGZqkijuQ8MYcZfUolX2WXR/lOmkhY+SNyqxxJBvWAAJP3MsfMWot/4AKvac9ATUtcHxYyKGkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351946; c=relaxed/simple;
	bh=zkcYrcdjYBbgFbvRARtPWp3wti0KMjlHvstpuxqfEkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikCc9k3G53/zJGBjGkE4EBGWtA2RPj7XdlWu6R4Zz/cPjU/JCyZWz8qj1qxsbbzMtcIkrc00PL5clcnN2eAzaFhoFyaenLOaNP9RVK/kgysWEJcvQi3hB02TUmlk6pyWl3Z0qfuI2Eyy0hP7jjcBpwlPZ+Pyt2RBb+LEUpg5g9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1I8L0BxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1I8L0BxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CB8C4CEF1;
	Wed, 10 Dec 2025 07:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351946;
	bh=zkcYrcdjYBbgFbvRARtPWp3wti0KMjlHvstpuxqfEkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1I8L0BxSuq61WGtnqfxjBiAKn1aeDYOjUMMQCJ1WjkJH9hn3WM579P+HiZs2oypDz
	 yA1ewcAfaYXfQt8DaLgXvU3Z/FryirVc2wsIM68nzdDuSyoN7rEuOuxXBjOENZqdX3
	 oCtNBXnq9/vZ/X1lJbwd3JRVVfhLNgxgJi3PHxzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.12 40/49] wifi: rtl8xxxu: Add USB ID 2001:3328 for D-Link AN3U rev. A1
Date: Wed, 10 Dec 2025 16:30:10 +0900
Message-ID: <20251210072949.160878610@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8111,6 +8111,9 @@ static const struct usb_device_id dev_ta
 /* TP-Link TL-WN823N V2 */
 {USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0135, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192fu_fops},
+/* D-Link AN3U rev. A1 */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3328, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192fu_fops},
 #ifdef CONFIG_RTL8XXXU_UNTESTED
 /* Still supported by rtlwifi */
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8176, 0xff, 0xff, 0xff),


