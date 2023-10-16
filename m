Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7290F262A1
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTbprgUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AEDC433C8;
	Mon, 16 Oct 2023 14:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468084;
	bh=f+8Brc/rYBOMKjKTIkI4l4gv/oF1fmvYpueSqcoWjHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTbprgUbxK9/Ms0Ca08HWP6zKkI/paPNizWURgNwl4AzVPS7N27ydZtbrz5ljjiLs
	 fX0ZhiJDni+BHe3g1olQIwgcdueip8R0eNVAqzkYMhp3d+bTKPQWwWfGPoWVKhw0WD
	 gSjfFrqHPW5BDtH97zsNVndvHZYwJhbpXksI9yGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Toledanes <chris.toledanes@hp.com>,
	Carl Ng <carl.ng@hp.com>,
	Max Nguyen <maxwell.nguyen@hp.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.5 153/191] Input: xpad - add HyperX Clutch Gladiate Support
Date: Mon, 16 Oct 2023 10:42:18 +0200
Message-ID: <20231016084018.949398466@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -130,6 +130,7 @@ static const struct xpad_device {
 	{ 0x0079, 0x18d4, "GPD Win 2 X-Box Controller", 0, XTYPE_XBOX360 },
 	{ 0x03eb, 0xff01, "Wooting One (Legacy)", 0, XTYPE_XBOX360 },
 	{ 0x03eb, 0xff02, "Wooting Two (Legacy)", 0, XTYPE_XBOX360 },
+	{ 0x03f0, 0x0495, "HyperX Clutch Gladiate", 0, XTYPE_XBOXONE },
 	{ 0x044f, 0x0f00, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f03, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", 0, XTYPE_XBOX },
@@ -458,6 +459,7 @@ static const struct usb_device_id xpad_t
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* Xbox USB-IF not-approved class */
 	XPAD_XBOX360_VENDOR(0x0079),		/* GPD Win 2 controller */
 	XPAD_XBOX360_VENDOR(0x03eb),		/* Wooting Keyboards (Legacy) */
+	XPAD_XBOXONE_VENDOR(0x03f0),		/* HP HyperX Xbox One controllers */
 	XPAD_XBOX360_VENDOR(0x044f),		/* Thrustmaster Xbox 360 controllers */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft Xbox 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft Xbox One controllers */


