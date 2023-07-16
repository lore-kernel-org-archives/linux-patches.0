Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFDB8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C767BC433C7;
	Sun, 16 Jul 2023 20:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538884;
	bh=8P7yzFL1ajF5GBdrCzn17c4qHZZ34u3r6LBKCbsff08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vPuuyzbCRp9G4y2siXuhtv9+I+CsrYzhQRdtLu1N6OYIPE0ZA4PF+g4mlws12B8Fd
	 i8944HIV/DWOaFhSqy3u2k3jpsxFBliv7uZfaJriWU/aqklPw77NxoiwjU6D2IeQxY
	 pA3CSe893uJfetvCWaOu6E70N1Alw1BtVVydy6vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 593/800] usb: hide unused usbfs_notify_suspend/resume functions
Date: Sun, 16 Jul 2023 21:47:26 +0200
Message-ID: <20230716195002.874837268@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8e6bd945e6dde64fbc60ec3fe252164493a8d3a2 ]

The declaration is in an #ifdef, which causes warnings when building
with 'make W=1' and without CONFIG_PM:

drivers/usb/core/devio.c:742:6: error: no previous prototype for 'usbfs_notify_suspend'
drivers/usb/core/devio.c:747:6: error: no previous prototype for 'usbfs_notify_resume'

Use the same #ifdef check around the function definitions to avoid
the warnings and slightly shrink the USB core.

Fixes: 7794f486ed0b ("usbfs: Add ioctls for runtime power management")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20230516202103.558301-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/devio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index fcf68818e9992..cbad2af5fd882 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -746,6 +746,7 @@ static int driver_resume(struct usb_interface *intf)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 /* The following routines apply to the entire device, not interfaces */
 void usbfs_notify_suspend(struct usb_device *udev)
 {
@@ -764,6 +765,7 @@ void usbfs_notify_resume(struct usb_device *udev)
 	}
 	mutex_unlock(&usbfs_mutex);
 }
+#endif
 
 struct usb_driver usbfs_driver = {
 	.name =		"usbfs",
-- 
2.39.2



