Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299D1145345;
	Tue, 27 Feb 2024 13:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041701; cv=none; b=LUG4KkBTeMRtLNZHMP4eooenTzW5BFEQKKzoTDxRQPrBxCnB+q32QmORccjlxE57ZSQRdu+OMg/hXShObgQw//OfYmOwXI5WM33IG4eV1RHyIwP5j/Df3xagfjv9umI7QlrORv/uBwaA6fZDlGW0o8zZo6rvzlwpkwZKs6iKz5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041701; c=relaxed/simple;
	bh=dICsfInweW4kLAcI8ADbNjur7dVPUjliZ0d/eQjZIGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VqXxN8BKRerQ0C3WIjW2iGw9Ud4iOyd8hP9S+g9dNjiSrKPes3szkvOVbGWCX9A/TPs1jdqMs9zRzFkLjPR960qu6DFpvRdnMVPHawdW6qxD4PGqNCcHZtFnVK63lipvcDbus2Utf0LD2WR3hsQ2w723YgfywczeZO9RE3xT+QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuHSU1uV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuHSU1uV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5F3C433F1;
	Tue, 27 Feb 2024 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041701;
	bh=dICsfInweW4kLAcI8ADbNjur7dVPUjliZ0d/eQjZIGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuHSU1uVkpZO2+Vy7LzEaHVn3Q/pCtFkQxUeKmtOMEFOpSE5M4YwH51K99uOont+J
	 SxdR3C+fVbSdCJSyS4uSjklBSozOixMKlGVrBRbTiq3OpH4ljelCDcTPJZZ8CF1fpr
	 JDQba1u3iI97QmPjBSOCWG/pu4Nyo4jHfhOXS3pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marcus=20R=C3=BCckert?= <darix@opensu.se>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/299] HID: logitech-hidpp: add support for Logitech G Pro X Superlight 2
Date: Tue, 27 Feb 2024 14:22:31 +0100
Message-ID: <20240227131627.277270901@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7bf12ca0eb4a9..4519ee377aa76 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4650,6 +4650,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC088) },
 	{ /* Logitech G Pro X Superlight Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC094) },
+	{ /* Logitech G Pro X Superlight 2 Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC09b) },
 
 	{ /* G935 Gaming Headset */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0x0a87),
-- 
2.43.0



