Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA10B29A9;
	Fri, 15 Nov 2024 06:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653185; cv=none; b=NpJUZ9Uc7ns9zbqKEnvSOdYzn0QGW7uZ43sWZW8lCCMbIAu0UaSBMdj1Dp7sZs38P4Hful2JGa1wDT+tC/v6beBWN4/W9hNfAQ1VS21FQ5q4TYd3tVbqMsbrY+cJ+jaON3PRDVu0JjGC4fSKItPr7wh608P2BRMCWlJhKxN8T7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653185; c=relaxed/simple;
	bh=fMnUJaMLZFYhASe2iZbB/OWTGPJsXh/JE1AQkaevASM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enGvK78dUTzeMhu5jMsVEm/irmHU8l3rS0y/IHHKScDhm4tIfwEFxKEl2aEBYUU50cgAgRYlbD3X3ImyaELXWqP0Gc0xR3YRQXwXCuXBQoffwl3ihOCwNc3HLwnoITq7nUXGs0f7+tdKvH5ri18JK43yVcaAJK/X7usXDCZlg3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuakKEje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuakKEje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39019C4CECF;
	Fri, 15 Nov 2024 06:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653185;
	bh=fMnUJaMLZFYhASe2iZbB/OWTGPJsXh/JE1AQkaevASM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuakKEjexEzMHjxhnIZFGfQ0XJVQmjZZaa8WrZg7F5a+vEXfvevFqcqO8IWlWVG7j
	 HmXZVU4g+rmPVtOS0k24sWGbLuZiMH2DvkpzqvxHfFUQ29VHLpEj5kibjwuNTOZzw9
	 P0QT1K5L+KO+2zPRQA4Lh2w1r6oqKUCz/rKDPkj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Blum <stefan.blum@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 12/63] HID: multitouch: Add support for B2402FVA track point
Date: Fri, 15 Nov 2024 07:37:35 +0100
Message-ID: <20241115063726.339855052@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Blum <stefanblum2004@gmail.com>

[ Upstream commit 1a5cbb526ec4b885177d06a8bc04f38da7dbb1d9 ]

By default the track point does not work on the Asus Expertbook B2402FVA.

>From libinput record i got the ID of the track point device:
  evdev:
    # Name: ASUE1201:00 04F3:32AE
    # ID: bus 0x18 vendor 0x4f3 product 0x32ae version 0x100

I found that the track point is functional, when i set the
MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU class for the reported device.

Signed-off-by: Stefan Blum <stefan.blum@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 847462650549e..86ca25b637809 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2017,6 +2017,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_ELAN, 0x3148) },
 
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_ELAN, 0x32ae) },
+
 	/* Elitegroup panel */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ELITEGROUP,
-- 
2.43.0



