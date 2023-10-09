Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C420D1A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRHK7w2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFD7C433C8;
	Mon,  9 Oct 2023 13:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857537;
	bh=aDxcey5qiL4Vbxx1HJEEg3DCEl93r4q47hwE9JDsRgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRHK7w2acexVwOeIULFwOv30nNDq2bDI3l0qnuBHQjy5SdhUyUKPQFXm8+yySeja1
	 om+cK3a3k1AqWwpBMINnfaDeC93huBrBjPSE5jfKaZiTbK0KlamOtLXiiW1I/NNdSl
	 9NNoJ4aovqTTwbnezZclddxojO9h+2ThXszfLJmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman Fries <baracoder@googlemail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 051/162] hwmon: (nzxt-smart2) Add device id
Date: Mon,  9 Oct 2023 15:00:32 +0200
Message-ID: <20231009130124.346439519@linuxfoundation.org>
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

From: Herman Fries <baracoder@googlemail.com>

commit e247510e1baad04e9b7b8ed7190dbb00989387b9 upstream.

Adding support for new device id
1e71:2019 NZXT NZXT RGB & Fan Controller

Signed-off-by: Herman Fries <baracoder@googlemail.com>
Link: https://lore.kernel.org/r/20221214194627.135692-1-baracoder@googlemail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/nzxt-smart2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -791,6 +791,7 @@ static const struct hid_device_id nzxt_s
 	{ HID_USB_DEVICE(0x1e71, 0x2009) }, /* NZXT RGB & Fan Controller */
 	{ HID_USB_DEVICE(0x1e71, 0x200e) }, /* NZXT RGB & Fan Controller */
 	{ HID_USB_DEVICE(0x1e71, 0x2010) }, /* NZXT RGB & Fan Controller */
+	{ HID_USB_DEVICE(0x1e71, 0x2019) }, /* NZXT RGB & Fan Controller */
 	{},
 };
 


