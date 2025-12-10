Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45BA2FF16C;
	Wed, 10 Dec 2025 07:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352106; cv=none; b=efpLfBfKue+7mKTTmahrfZaCOcaFcKIyx4/KB5uD33EQrD82YiUpG0QAGSsNORWKWLBXY1qENvtoxzp45s0QicAIUKRud7AHOYUmNxtDuvTq+emwVifdhH1djsmVtiIi/DJxr5w1ZdI9FPxM2rnGWSorFLajP5QKdPS802SkO6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352106; c=relaxed/simple;
	bh=cl+Fv2j3s9xPUMLOqNmNV6TI+n6vXwWDqwpBe1O4yu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDCPZo22dVEoFmZD7oR5hTcj0UlU2SnVwcJb3UuJPGLxbmHPp4ZKLMBhwjpWPZft5A5xO0sxT3h5MUojDG3FXs7V/t1e0OO1z7ShDvKzvVgeONHDCRc/Hvn5bxWnmkZpIj9TAmQnRSWtZG4tliE9skRLWpHEOquwuGYQXVTfiK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1TXzNOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1TXzNOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4A7C4CEF1;
	Wed, 10 Dec 2025 07:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352106;
	bh=cl+Fv2j3s9xPUMLOqNmNV6TI+n6vXwWDqwpBe1O4yu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1TXzNOw1mukqN0oz5OLOWMA3kogKOWDvsw4fbP6F8LYGa66IwNUyX3UdWNTNp87n
	 ty2MZtUj1H8ys9AOTUsYPZHwjQy9cXL20ZGhco4lQGbu3W9yEr8uUZ/hYlzC90pCks
	 QlfO8vH2l0O10teyvRIzUXbtEAXLEwBtLgYwHWhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.17 53/60] wifi: rtw88: Add USB ID 2001:3329 for D-Link AC13U rev. A1
Date: Wed, 10 Dec 2025 16:30:23 +0900
Message-ID: <20251210072949.186596774@linuxfoundation.org>
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

commit b377dcd9a286a6f81922ae442cd1c743bc4a2b35 upstream.

Add USB ID 2001:3329 for D-Link AC13U rev. A1 which is a RTL8812CU-based
Wi-Fi adapter.

Compile tested only.

Cc: stable@vger.kernel.org # 6.6.x
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250929035719.6172-2-zenmchen@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822cu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/realtek/rtw88/rtw8822cu.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822cu.c
@@ -21,6 +21,8 @@ static const struct usb_device_id rtw_88
 	  .driver_info = (kernel_ulong_t)&(rtw8822c_hw_spec) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x13b1, 0x0043, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&(rtw8822c_hw_spec) }, /* Alpha - Alpha */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3329, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822c_hw_spec) }, /* D-Link AC13U rev. A1 */
 	{},
 };
 MODULE_DEVICE_TABLE(usb, rtw_8822cu_id_table);


