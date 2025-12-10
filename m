Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76BF2264DC;
	Wed, 10 Dec 2025 07:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351949; cv=none; b=K/+feUT4iMmeTUGb5DwubO5sDmkR+xJNAjLEg9AlGa4080JdJugSSMF1CyLqi0nmNYF/DHAzPa/IpPXlmNVE7YrylAuDAp8mK+La6GDUZZVm3ohQFL/xa3JB52F5Lh+qQEUNCz9sT/5cBpmVDZSIWNuKwFJLgf0a8BNUzWFGx3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351949; c=relaxed/simple;
	bh=EMc4suf7g0VUPqpph1e7KDXz8uCR6yFbKPi6cM1a4qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7MI86Ij5h+LVm6ShSOe0fiwfmW+ufQNxxBgbnfJQ7Am0OaVC0tI9X3vm9+4aKvrdT7sTQZRBznA98P0mvKbb8rsmoDl0zRRnwOclKkfwRUOIMSZhpFq6SZRWAF5MkJvFmIOK58KEFV1/WSlPwJsMJFrnphFDVIhjmd1SgiAkI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKCn8EYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKCn8EYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA78FC4CEF1;
	Wed, 10 Dec 2025 07:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351949;
	bh=EMc4suf7g0VUPqpph1e7KDXz8uCR6yFbKPi6cM1a4qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKCn8EYAAQMfQ0sROm3pf1yOQJa8jOHBab57cIYNFNzmZykRl3Q7r/j4jdw/WNWaq
	 KXfyzvIDRx9r6g//rnJhr190CEhUX5yzRaB8tJWf1nAM8ML9CaZJ3NKmwYs2fK8eW7
	 HN8nQr92DdOrXHZbNhH6o16/HakDLS+yAL7ZPECw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.12 41/49] wifi: rtw88: Add USB ID 2001:3329 for D-Link AC13U rev. A1
Date: Wed, 10 Dec 2025 16:30:11 +0900
Message-ID: <20251210072949.184229292@linuxfoundation.org>
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


