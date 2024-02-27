Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9A913B79F;
	Tue, 27 Feb 2024 13:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040595; cv=none; b=LJU1j9YbXiXcGoQozddp9URNA/CB4fDLi7Tyr2gF1HrIreJpWKehy1eJX0miHVw8ztm7VUUzUbOyUt4KVgtaWX6HB6n7wx++tGA2l0tqWZtXg1IuD3zjxWqFiVXhc1HXtGiIY1pflIzjdGIviB3ARlFJTtEM3ckwt63i/bZe+yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040595; c=relaxed/simple;
	bh=4pbr+1xD1DUkfILtLwUrAUSu23Qin227K5/X9zBTg9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yo7Axe+echeDd3rBV4q6vhl9ZRfTCmmJ4LhfOVTNAIA6EZJALc4ouw99+ia4g6fsCaN3vK9Ya2ZPav6FIKfvkQ45qrjxPED4oD8kbVzhTKO/OA0k/yfdrBcopPZa+Vku6qMdN51TIUDcDU9O1UM2b6kZ8Cp4rpQZwDUtfH0UFr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f14DmgsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f14DmgsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A6CC433F1;
	Tue, 27 Feb 2024 13:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040594;
	bh=4pbr+1xD1DUkfILtLwUrAUSu23Qin227K5/X9zBTg9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f14DmgsJF0fd7QOE4peGwrfDfDdo9nVoBaTDXxAqhTeIyWH9MBIYNJbRqeOhihAxH
	 YsrBOpWJHhK5w3DLDVRLDCBd8oIhNnkczb/NJ3eY1GQrpzbmrwhwxYYL9+cw6HFPPn
	 boMy5tCJf9xBPmsSh529plK6pmcx4wJPjgeU68Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marcus=20R=C3=BCckert?= <darix@opensu.se>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 041/334] HID: logitech-hidpp: add support for Logitech G Pro X Superlight 2
Date: Tue, 27 Feb 2024 14:18:19 +0100
Message-ID: <20240227131631.912676505@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit afa6ac2690bb9904ff883c6e942281e1032a484d ]

Let logitech-hidpp driver claim Logitech G Pro X Superlight 2.

Reported-by: Marcus Rückert <darix@opensu.se>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index fd6d8f1d9b8f6..6ef0c88e3e60a 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4610,6 +4610,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC088) },
 	{ /* Logitech G Pro X Superlight Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC094) },
+	{ /* Logitech G Pro X Superlight 2 Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC09b) },
 
 	{ /* G935 Gaming Headset */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0x0a87),
-- 
2.43.0



