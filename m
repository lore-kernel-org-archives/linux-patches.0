Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EFC15198D;
	Wed,  5 Feb 2025 14:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764724; cv=none; b=C0BbDTUWlzNe4fgKIvOIE6YE0/6Z/xP2mYRmmP2r/ICz3Bnhq0UdVykh4GrPOFcc1AXhMNgPxPDlJrvNke8lTjo/ZjeQXvFvoWeapmDKGwjNiiOUtXqU4I/AUxrXOS9rUFvFTkFY9og0Pe28XHMaNn3uopeQ/2D8X3qzSYzLgtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764724; c=relaxed/simple;
	bh=+K/htZCvU1bp/UYuL+8pSXL0GOB0Lyn9hAQ9nQC0ZaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TdGNJoMg/63WBf9NTjV3VlSa8TunnBtIsXLsasSiHmmuQV36xESwc2Y0IfHoFeVjyjbDd2gbV21C9iHI1hCsL1QBiVabUlgoCZgeoXQajK3zXdBzciEtjaJt244EnRcINNpLXoHVN24/2ohqfXdPibzaLLOKUpshcgGVsvMAkCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuJVNzfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuJVNzfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D93C4CED1;
	Wed,  5 Feb 2025 14:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764724;
	bh=+K/htZCvU1bp/UYuL+8pSXL0GOB0Lyn9hAQ9nQC0ZaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuJVNzfvnlqCqvqhupDKOgRdW7lQQ0u4XQ6kd4NdNIag3nKV0fF/7LVieLDUcgp0c
	 OQd5JY3rIJV5cOgZMRre+cfYCPFu8wueHa94Ol1Lyz29wCBatC/aM0U7E1KxqboxRw
	 oybzbs4xu2kB+mDHvLgSXL0UbYfwCILBDbZ862hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Lugang <helugang@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	=?UTF-8?q?Ulrich=20M=C3=BCller?= <ulm@gentoo.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 108/623] HID: multitouch: fix support for Goodix PID 0x01e9
Date: Wed,  5 Feb 2025 14:37:30 +0100
Message-ID: <20250205134500.347960388@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 8ade5e05bd094485ce370fad66a6a3fb6f50bfbc ]

Commit c8000deb68365b ("HID: multitouch: Add support for GT7868Q") added
support for 0x01e8 and 0x01e9, but the mt_device[] entries were added
twice for 0x01e8 and there was none added for 0x01e9. Fix that.

Fixes: c8000deb68365b ("HID: multitouch: Add support for GT7868Q")
Reported-by: He Lugang <helugang@uniontech.com>
Reported-by: WangYuli <wangyuli@uniontech.com>
Reported-by: Ulrich Müller <ulm@gentoo.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 65023bfe30ed2..42c0bd9d2f31e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2084,7 +2084,7 @@ static const struct hid_device_id mt_devices[] = {
 		     I2C_DEVICE_ID_GOODIX_01E8) },
 	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
 	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
-		     I2C_DEVICE_ID_GOODIX_01E8) },
+		     I2C_DEVICE_ID_GOODIX_01E9) },
 
 	/* GoodTouch panels */
 	{ .driver_data = MT_CLS_NSMU,
-- 
2.39.5



