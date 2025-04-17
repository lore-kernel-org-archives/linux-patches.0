Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747DF25745A;
	Thu, 17 Apr 2025 18:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915244; cv=none; b=oQqm1w8ROqUbOq+j+DdV468dCD3FnOcjfYYAJ5DUX8EdzZUdVHMQxaT/rlPhIVZewN+1YSHMBWSu8YEmjb8JPcikMxoFgOSP0lcaPeFHq3O8eT+gdnJtfQkcK1WpaKIU3Ll55jhtwwWCFwAyYRokWafrVBRPLsokFpD3vn1u3ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915244; c=relaxed/simple;
	bh=PXl3xINe8xjlGwpBFwNkLz54yUrKUfpGKSCH8U5uoAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HlgTeCxwoxGA3KfeDQEYUf9gatl54iBNUhpoxo71ZYszl6+iF4FE3tC168nJUaGVsjJP1AranDBQ7xqrpfSRbavJRPYjP0nrR/xMwhOd6P2oCThxsG9iZnLW4zKhvwc5E6Oeu9eiNx/pLEAsXCbmgzPxLeFV8XgJZcT9PKrkBzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDOfzajf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDOfzajf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7823EC4CEE7;
	Thu, 17 Apr 2025 18:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915244;
	bh=PXl3xINe8xjlGwpBFwNkLz54yUrKUfpGKSCH8U5uoAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDOfzajfFbBAhyVjBmKjug+JNKU9vLKIsMhijNzJq7DwLFkwsDbtRLlDD06gUA6oT
	 BxsV97/BEv6/az34SJXokm92kEzED/RVo5ng9Ch6EnN1Jjra3pkWwrR46ENAT5b5by
	 daHPsbmwY4AJ0OFIVRElfJT6uE1Z7rqIakctcGpo=
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
Subject: [PATCH 6.12 065/393] HID: pidff: Add PERMISSIVE_CONTROL quirk
Date: Thu, 17 Apr 2025 19:47:54 +0200
Message-ID: <20250417175110.209391189@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 088c6688c3f98..cd3fedce48109 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1228,8 +1228,9 @@ int hid_pidff_init(struct hid_device *hid);
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



