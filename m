Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D987C171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F214C433EF;
	Mon, 22 May 2023 19:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784451;
	bh=IjRiUvLYQP+9kc1hC+PvjP2DMMMkl/v+LroeMGs/n30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwtNfqTUu4Vi6R1kxrqAtWELYLQNWDq8WOkaISMqfSABjntW94IK/CG+29DX8GMgY
	 T+DG1ojqrG5HeIoFUq/RFedb6GDKtOu+XKTJLYLtGJu9YIqR0VQGuXzFefJGS4+NCK
	 BPtMU3WuUHlO2v2eqNdVbh2dygMkNkWQ2Jm+y3QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mezin <mezin.alexander@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 087/364] hwmon: (nzxt-smart2) add another USB ID
Date: Mon, 22 May 2023 20:06:32 +0100
Message-Id: <20230522190414.932960962@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aleksandr Mezin <mezin.alexander@gmail.com>

[ Upstream commit 4a148e9b1ee04e608263fa9536a96214d5561220 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nzxt-smart2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/nzxt-smart2.c b/drivers/hwmon/nzxt-smart2.c
index 2b93ba89610ae..a8e72d8fd0605 100644
--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -791,7 +791,8 @@ static const struct hid_device_id nzxt_smart2_hid_id_table[] = {
 	{ HID_USB_DEVICE(0x1e71, 0x2009) }, /* NZXT RGB & Fan Controller */
 	{ HID_USB_DEVICE(0x1e71, 0x200e) }, /* NZXT RGB & Fan Controller */
 	{ HID_USB_DEVICE(0x1e71, 0x2010) }, /* NZXT RGB & Fan Controller */
-	{ HID_USB_DEVICE(0x1e71, 0x2019) }, /* NZXT RGB & Fan Controller */
+	{ HID_USB_DEVICE(0x1e71, 0x2011) }, /* NZXT RGB & Fan Controller (6 RGB) */
+	{ HID_USB_DEVICE(0x1e71, 0x2019) }, /* NZXT RGB & Fan Controller (6 RGB) */
 	{},
 };
 
-- 
2.39.2



