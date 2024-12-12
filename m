Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AA12054F8;
	Thu, 12 Dec 2024 15:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016602; cv=none; b=FVIJ7HdGRHTnS8WflivwPaYGjYppfRWA6kKIIgvlgsMTaj3aMEJf9PETMRfhANbRyr/adp0cYuJ3Zv6+0Qd78Hd7+gCXKadE9E5bO6yc0mPVwMXR4KgwrwaHu6pxNTBJflu37kKEDXE5muHOEIanGYIDIGWlaNlW8GywW4Oki4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016602; c=relaxed/simple;
	bh=Fidz5wYtwvBomorVxCCp+ayqvoKMEdwI4LI9umy2w3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqdibR7/R/3j/SuvqdY73vlxg9JUUVYSOezUx1nv5eK4Me2Xco3nDjUmec1gqvXaXSkCP2FASTVXRueuU2TQB9xSk8wbXh8Gjc01uj8+bzXFKCzNSoUdwatBxtQB4+PvvuksdLINZBu+IuvPqt0OrZxJff5i7sk1C/eSGuKeZkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NODnfPTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NODnfPTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCE8C4CECE;
	Thu, 12 Dec 2024 15:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016602;
	bh=Fidz5wYtwvBomorVxCCp+ayqvoKMEdwI4LI9umy2w3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NODnfPTH/93+Z/vhWXgxL+JMCzOAhX2T8fCeYt4k4N9QkHSApmiHpbeLLRKMkPWbd
	 hyq1Ashp2OKycXkurH5RE1oqL6NsFkXROzUmoEn/XofgzTGNSrLHpB8FTbzJXsKG2V
	 J6jutiBmXH9xToup+5fQ4+BdUzbCnP1AxpCWbH08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan Barar <rohan.barar@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/466] media: cx231xx: Add support for Dexatek USB Video Grabber 1d19:6108
Date: Thu, 12 Dec 2024 15:56:53 +0100
Message-ID: <20241212144316.427536600@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohan Barar <rohan.barar@gmail.com>

[ Upstream commit 61a830bc0ea69a05d8a4534f825c6aa618263649 ]

Add Dexatek Technology Ltd USB Video Grabber 1d19:6108 to the cx231xx
driver. This device is sold under the name "BAUHN DVD Maker (DK8723)" by
ALDI in Australia.

This device is similar to 1d19:6109, which is already included in cx231xx.

Both video and audio capture function correctly after installing the
patched cx231xx driver.

Patch Changelog
v1:
 - Initial submission.
v2:
 - Fix SoB + Improve subject.
v3:
 - Rephrase message to not exceed 75 characters per line.
 - Removed reference to external GitHub URL.

Signed-off-by: Rohan Barar <rohan.barar@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 92efe6c1f47ba..bda729b42d05f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -994,6 +994,8 @@ const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
 
 /* table of devices that work with this driver */
 struct usb_device_id cx231xx_id_table[] = {
+	{USB_DEVICE(0x1D19, 0x6108),
+	.driver_info = CX231XX_BOARD_PV_XCAPTURE_USB},
 	{USB_DEVICE(0x1D19, 0x6109),
 	.driver_info = CX231XX_BOARD_PV_XCAPTURE_USB},
 	{USB_DEVICE(0x0572, 0x5A3C),
-- 
2.43.0



