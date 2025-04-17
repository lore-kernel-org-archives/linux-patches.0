Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB5C1A3178;
	Thu, 17 Apr 2025 18:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913977; cv=none; b=W5c3t1HxAcs1ehm1VlOTmkprTZVRkPyjCSciXwRlJkzEO78GiWeVOJ1VX+Imka8FPDT0imHdRtMxrmjhLnK/7k60FE1w3vYtJpByjBpe2Uh1hIvmoVqPhpVBDxqRLA6Q1B9HDDhDCnFbPDmLlEi1992glU1DatWVwXt1dz5XIYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913977; c=relaxed/simple;
	bh=PlOElnruYEOD3i4wCJXI5hgiFB5ATazn3IBk3MbuCvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jcakVz2cyNsRhjjiF0CySF+RAK4QHpS9Vtzj4+cQFnYF0RHUWxHvR7AjVwOhEdJPWlM8Q6iBruOXs6xVTNSFWEtS3v/8hXzpQo+kTX9DXtEYekco/eXOnJ2ySkG/aYgzU2FW6Gh4w+ir6a8INaZUZo0GDKBikE1S8nOl9yP73Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsYuLqkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsYuLqkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75959C4CEE4;
	Thu, 17 Apr 2025 18:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913976;
	bh=PlOElnruYEOD3i4wCJXI5hgiFB5ATazn3IBk3MbuCvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsYuLqkVFl8cNkr4lrNuWpG+6ZYuidZFU8/gqVDlM+tehzmR58plv8g4CSkVo0+TT
	 VDUKvZdxL0+smg5I1lee8LNJI3znKEz+WP7ERDkQSO2UGelCto5zRn6jAXW5e8z/GX
	 9aOaFh3CDXhid2dl2nw3dtp6pKNIcztxyqMPcOp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Makarenko Oleg <oleg@makarenk.ooo>,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 065/414] HID: pidff: Add PERMISSIVE_CONTROL quirk
Date: Thu, 17 Apr 2025 19:47:03 +0200
Message-ID: <20250417175114.028953604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit a4119108d2530747e61c7cbf52e2affd089cb1f6 ]

With this quirk, a PID device isn't required to have a strict
logical_minimum of 1 for the the PID_DEVICE_CONTROL usage page.

Some devices come with weird values in their device descriptors and
this quirk enables their initialization even if the logical minimum
of the DEVICE_CONTROL page is not 1.

Fixes initialization of VRS Direct Force Pro

Changes in v6:
- Change quirk name to better reflect it's intention

Co-developed-by: Makarenko Oleg <oleg@makarenk.ooo>
Signed-off-by: Makarenko Oleg <oleg@makarenk.ooo>
Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 3 ++-
 include/linux/hid.h            | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 503b22feacdbb..5a57ba0d7026a 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -969,7 +969,8 @@ static int pidff_find_special_fields(struct pidff_device *pidff)
 					 0x57, 0);
 	pidff->device_control =
 		pidff_find_special_field(pidff->reports[PID_DEVICE_CONTROL],
-					 0x96, 1);
+			0x96, !(pidff->quirks & HID_PIDFF_QUIRK_PERMISSIVE_CONTROL));
+
 	pidff->block_load_status =
 		pidff_find_special_field(pidff->reports[PID_BLOCK_LOAD],
 					 0x8b, 1);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index ea7ba8e4bfe49..89a4dee377292 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1229,8 +1229,9 @@ int hid_pidff_init(struct hid_device *hid);
 #endif
 
 /* HID PIDFF quirks */
-#define HID_PIDFF_QUIRK_MISSING_DELAY	BIT(0)
-#define HID_PIDFF_QUIRK_MISSING_PBO	BIT(1)
+#define HID_PIDFF_QUIRK_MISSING_DELAY		BIT(0)
+#define HID_PIDFF_QUIRK_MISSING_PBO		BIT(1)
+#define HID_PIDFF_QUIRK_PERMISSIVE_CONTROL	BIT(2)
 
 #define dbg_hid(fmt, ...) pr_debug("%s: " fmt, __FILE__, ##__VA_ARGS__)
 
-- 
2.39.5



