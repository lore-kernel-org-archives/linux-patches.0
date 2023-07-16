Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B818F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0F2C433C9;
	Sun, 16 Jul 2023 20:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540579;
	bh=GPJuPLSi8JaSXdEExjqkVoIylWyFv3lToAeFrYk8vNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwBAjqybzr4eEenU6R2LqKpujLtulfHDDbD/dXtTAg5I3UBI1GztkH+asKqsR4i2I
	 G41CrNknbsHzymdujUTaEP0GFPbk5QogFjHEe5Cef+6KQqoehujI7eForDUIDIhui3
	 808jZBbveigxSU7r4aKiLgu237vssJhVdJUIRpeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 414/591] usb: hide unused usbfs_notify_suspend/resume functions
Date: Sun, 16 Jul 2023 21:49:13 +0200
Message-ID: <20230716194934.624339052@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 984de3f5e8eb9..4184cd65a6aac 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -747,6 +747,7 @@ static int driver_resume(struct usb_interface *intf)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 /* The following routines apply to the entire device, not interfaces */
 void usbfs_notify_suspend(struct usb_device *udev)
 {
@@ -765,6 +766,7 @@ void usbfs_notify_resume(struct usb_device *udev)
 	}
 	mutex_unlock(&usbfs_mutex);
 }
+#endif
 
 struct usb_driver usbfs_driver = {
 	.name =		"usbfs",
-- 
2.39.2



