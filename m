Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C90223C69;
	Thu, 12 Dec 2024 17:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024793; cv=none; b=J4aXrska2GtMMjsKdE9kXoI71vzRcsGEHo7Ns3vqLUt6zCpcataxoDAZXW5bre44JIwPazjZRJekjPjjG0JFSBDj01q2JNjvHyHX0rOUFCUKrV077/0qg1Q2OzowdLJDJ8qMVDZCOizTTwW6L/+TI7CJL7wRN/nTeSng6XvTp50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024793; c=relaxed/simple;
	bh=x9W09Njft8U8zNYr+rxnwk7ugUHzbrd29XTr/vfVkY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TL+lxH0JQpqmuycX2noVj8QO6wu3Cbt0Qw5G2kcr+eD8zk2ifVZ0UC5tba8tZV+6f67YDB4kwRXTN1XFPfFsn34ny5RcUfUe/9fxdgEvodbQcgPOm54ZEfG1QHeYGAQ3UV8dqkI1QSDnB+siRNyMmWVR2eDz/LaxPglHfurAqQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyIh9Vac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyIh9Vac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E3DC4CECE;
	Thu, 12 Dec 2024 17:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024793;
	bh=x9W09Njft8U8zNYr+rxnwk7ugUHzbrd29XTr/vfVkY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyIh9VacfsRNFRFCcrZXm43pnLDMrZNmuEiBaZPqFrhl+Jqr3GpIE9ofkdgrM8mHi
	 xLyGZvr6FzKekkzPv9H9jj2X2Lpk3ur9OGpahi/RuE9uUyQZ7GMnUOjUcM8En4U6BT
	 7aSoDrBe9sLuQjmUqbr2SZSg6MDKyToOWOzUmKco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan Barar <rohan.barar@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 384/459] media: cx231xx: Add support for Dexatek USB Video Grabber 1d19:6108
Date: Thu, 12 Dec 2024 16:02:02 +0100
Message-ID: <20241212144308.940001129@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



