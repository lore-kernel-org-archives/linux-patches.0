Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D934E1A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjJddS9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57359C433C8;
	Mon,  9 Oct 2023 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857540;
	bh=Lb9fu2kQuj+nSQC8IhJi5WfXn/CZCsTDhxhHhSgBrBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjJddS9Jbpmlk+9S4AJQgG4iQ31Ty8XE34FfdvmCeo86XpQFzcImRItbkTNkP6Hx/
	 XvnuFQpT86tHPZTejNE4Qrrd/XtqJcVw5s1gYjdHJEYZOn5CHT8fVA8lSNTSbzMuNC
	 aqIVAuN2658wU6SEVr0Dxj4o2G9qa5gsCVvVmEe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mezin <mezin.alexander@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 052/162] hwmon: (nzxt-smart2) add another USB ID
Date: Mon,  9 Oct 2023 15:00:33 +0200
Message-ID: <20231009130124.372016580@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mezin <mezin.alexander@gmail.com>

commit 4a148e9b1ee04e608263fa9536a96214d5561220 upstream.

This seems to be a new revision of the device. RGB controls have changed,
but this driver doesn't touch them anyway.

Fan speed control reported to be working with existing userspace (hidraw)
software, so I assume it's compatible. Fan channel count is the same.

Recently added (0x1e71, 0x2019) seems to be the same device.

Discovered in liquidctl project:

https://github.com/liquidctl/liquidctl/issues/541

Signed-off-by: Aleksandr Mezin <mezin.alexander@gmail.com>
Link: https://lore.kernel.org/r/20230219105924.333007-1-mezin.alexander@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/nzxt-smart2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -791,7 +791,8 @@ static const struct hid_device_id nzxt_s
 	{ HID_USB_DEVICE(0x1e71, 0x2009) }, /* NZXT RGB & Fan Controller */
 	{ HID_USB_DEVICE(0x1e71, 0x200e) }, /* NZXT RGB & Fan Controller */
 	{ HID_USB_DEVICE(0x1e71, 0x2010) }, /* NZXT RGB & Fan Controller */
-	{ HID_USB_DEVICE(0x1e71, 0x2019) }, /* NZXT RGB & Fan Controller */
+	{ HID_USB_DEVICE(0x1e71, 0x2011) }, /* NZXT RGB & Fan Controller (6 RGB) */
+	{ HID_USB_DEVICE(0x1e71, 0x2019) }, /* NZXT RGB & Fan Controller (6 RGB) */
 	{},
 };
 


