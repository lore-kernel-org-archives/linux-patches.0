Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4B379E3;
	Tue,  5 Dec 2023 03:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaE4rzg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC74C433C8;
	Tue,  5 Dec 2023 03:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747667;
	bh=zQQjns+iyEp2+vEgLtqaL6tlkK1S4lmu16uJvYEyJeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaE4rzg8B2sXWXd5VvsO8pCXpk8LLqTDwcSMGLNfgAcTnc0iMtU3CNG5zYhTK9ImD
	 5UJPXQvgptruAEaU1+SXVpK10/25ncR/PQYK/Nfz4x2DUkZpRkpSBElttdt0z+wpq+
	 mgxWDhSsHVxYi5FsLT27bhe7OPhMn7Jfgo3OvgRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Toledanes <chris.toledanes@hp.com>,
	Carl Ng <carl.ng@hp.com>,
	Max Nguyen <maxwell.nguyen@hp.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 24/67] Input: xpad - add HyperX Clutch Gladiate Support
Date: Tue,  5 Dec 2023 12:17:09 +0900
Message-ID: <20231205031521.184727844@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Nguyen <maxwell.nguyen@hp.com>

commit e28a0974d749e5105d77233c0a84d35c37da047e upstream.

Add HyperX controller support to xpad_device and xpad_table.

Suggested-by: Chris Toledanes <chris.toledanes@hp.com>
Reviewed-by: Carl Ng <carl.ng@hp.com>
Signed-off-by: Max Nguyen <maxwell.nguyen@hp.com>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Link: https://lore.kernel.org/r/20230906231514.4291-1-hphyperxdev@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -120,6 +120,7 @@ static const struct xpad_device {
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f10, "Thrustmaster Modena GT Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0xb326, "Thrustmaster Gamepad GP XID", 0, XTYPE_XBOX360 },
+	{ 0x03f0, 0x0495, "HyperX Clutch Gladiate", 0, XTYPE_XBOXONE },
 	{ 0x045e, 0x0202, "Microsoft X-Box pad v1 (US)", 0, XTYPE_XBOX },
 	{ 0x045e, 0x0285, "Microsoft X-Box pad (Japan)", 0, XTYPE_XBOX },
 	{ 0x045e, 0x0287, "Microsoft Xbox Controller S", 0, XTYPE_XBOX },
@@ -434,6 +435,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x0079),		/* GPD Win 2 Controller */
 	XPAD_XBOX360_VENDOR(0x03eb),		/* Wooting Keyboards (Legacy) */
 	XPAD_XBOX360_VENDOR(0x044f),		/* Thrustmaster X-Box 360 controllers */
+	XPAD_XBOXONE_VENDOR(0x03f0),		/* HP HyperX Xbox One Controllers */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft X-Box One controllers */
 	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */


