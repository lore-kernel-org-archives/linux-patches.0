Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C69330595A;
	Wed, 10 Dec 2025 07:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352183; cv=none; b=EtHTS7o3tzFOzQ/c7L/uhYoi52XIH6DVt7hdd+qLF5smq70fn/Y1YsSDHgfhnXw2L6r2pTIbU2HzGUYRpngTD0u47JhlsvzD3rr/bnQTHzkywYnOiFpoSDvM55hJWVLkXyj2MXlZaAETUhjtMHt6cpSH3BiP5Jst9UDIgQSdu/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352183; c=relaxed/simple;
	bh=gbp4msZhDFYoa5xb9shzt+xKI1E6A5pbodL8urVCl+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTtpELFfQuHhofnXMVggHL+Tig+y9fki7tNX+Nn+X9ARaLurFcEQXKHMP5bnao+y71uXW9m4sLV1JFyFBSOfHd9kjceYC8W0+CFalnxal+dsfga4tzj1K84k1BK75koRtOl/lF5dlXXng/AbatQ56GFn16bAamHf+8Nqtaqk66I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bkswdz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bkswdz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0666C116B1;
	Wed, 10 Dec 2025 07:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352182;
	bh=gbp4msZhDFYoa5xb9shzt+xKI1E6A5pbodL8urVCl+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bkswdz9g9kmofv8vhsyk3xxfWEvNsux3gm2pDEznW8DhSU7t+ShutUvhSS4Ln6mg
	 IDhuPbezv5AAt8hW/xNRdbKipYBOOuinPSHTHsLqECNQoQdzpo8VllOAVGf2mBL9y8
	 cnAGpzEqSNmMiGGHCaEbgDaMPWcsvqB/ieiQnEV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.18 22/29] wifi: rtw88: Add USB ID 2001:3329 for D-Link AC13U rev. A1
Date: Wed, 10 Dec 2025 16:30:32 +0900
Message-ID: <20251210072944.965460143@linuxfoundation.org>
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


