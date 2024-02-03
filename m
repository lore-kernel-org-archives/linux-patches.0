Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EC210976;
	Sat,  3 Feb 2024 04:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933415; cv=none; b=eFyPd0vtcubo2uVz0cXwh4/0XRelmpmoLdlt3zsEbl0nNpb1KASNnEb9m+b7bDJJLIwcntgsEzitAVX47iUOxdnHS9VZNJmUALl8obiQSt3VyOiGLXxrSwzaRnGmZ3+AHpYfV1Y/chQLODYh71e8UrT+9GuNbkBCrmRTtcUVzCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933415; c=relaxed/simple;
	bh=s+BCnASocVNEIVmEy/r7oQRuhkwoaSxlt0iTxDtyjnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rheiHFh6cXPd65VENAsTxyeE6QX5hTodx2q2b94wiaZjmfeYpFAkXW1J73No9SfhrDgRIHTo7O+8nJxIlGvXjsUFZ/De6acEXWUb4yBKb1d3MDrSFeKHOpu3go3KW1Lr5tmrY+ko7x0LYUJasPZ52YupTGvjfVIyOmKsPyUugJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PM8VJXxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PM8VJXxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00248C433C7;
	Sat,  3 Feb 2024 04:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933415;
	bh=s+BCnASocVNEIVmEy/r7oQRuhkwoaSxlt0iTxDtyjnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PM8VJXxuQ0Q6A0vyTDYUG0sa3lgngYRzr6jcFy4qGVbqMyQwO4NjUnA7Ke9zfUgDA
	 i4tg2lIKlsDsAm9I8DNjRhIgKl8iAgFDxXMhj4QSL0pMM6E0IkN7cvx+DFXpvAICgh
	 JTTmgha+GoWm/xLG/VPmFcBeTkR5X6CrQCTfZZUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Fischer <devlists@wefi.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/219] watchdog: it87_wdt: Keep WDTCTRL bit 3 unmodified for IT8784/IT8786
Date: Fri,  2 Feb 2024 20:05:11 -0800
Message-ID: <20240203035336.849875852@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Werner Fischer <devlists@wefi.net>

[ Upstream commit d12971849d71781c1e4ffd1117d4878ce233d319 ]

WDTCTRL bit 3 sets the mode choice for the clock input of IT8784/IT8786.
Some motherboards require this bit to be set to 1 (= PCICLK mode),
otherwise the watchdog functionality gets broken. The BIOS of those
motherboards sets WDTCTRL bit 3 already to 1.

Instead of setting all bits of WDTCTRL to 0 by writing 0x00 to it, keep
bit 3 of it unchanged for IT8784/IT8786 chips. In this way, bit 3 keeps
the status as set by the BIOS of the motherboard.

Watchdog tests have been successful with this patch with the following
systems:
  IT8784: Thomas-Krenn LES plus v2 (YANLING YL-KBRL2 V2)
  IT8786: Thomas-Krenn LES plus v3 (YANLING YL-CLU L2)
  IT8786: Thomas-Krenn LES network 6L v2 (YANLING YL-CLU6L)

Link: https://lore.kernel.org/all/140b264d-341f-465b-8715-dacfe84b3f71@roeck-us.net/

Signed-off-by: Werner Fischer <devlists@wefi.net>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20231213094525.11849-4-devlists@wefi.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/it87_wdt.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index bb1122909396..843f9f8e3917 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -255,6 +255,7 @@ static struct watchdog_device wdt_dev = {
 static int __init it87_wdt_init(void)
 {
 	u8  chip_rev;
+	u8 ctrl;
 	int rc;
 
 	rc = superio_enter();
@@ -313,7 +314,18 @@ static int __init it87_wdt_init(void)
 
 	superio_select(GPIO);
 	superio_outb(WDT_TOV1, WDTCFG);
-	superio_outb(0x00, WDTCTRL);
+
+	switch (chip_type) {
+	case IT8784_ID:
+	case IT8786_ID:
+		ctrl = superio_inb(WDTCTRL);
+		ctrl &= 0x08;
+		superio_outb(ctrl, WDTCTRL);
+		break;
+	default:
+		superio_outb(0x00, WDTCTRL);
+	}
+
 	superio_exit();
 
 	if (timeout < 1 || timeout > max_units * 60) {
-- 
2.43.0



