Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045738;
	b=5JVAbep4eHTi5IYNJ7uHTxfv9ISRquH5SPRkGBogCQhe6cFQX9BBJFnlMR4gwQOji0eJ
	 MYjht6QSHSKmKztv15bWz/SVFwphVWzCM8xQShi9o8uCKWJg/W5vUnVPfLmaWOTCIm75T
	 hwcEkdXQnTyTM6Y4+RGWGpfzjGpPSxsE5XBNNqDh98irbi97Re8qKkKCM/rBK2c320GMq
	 Bo+OTB+vk9sP89tWmhnyV3OwtuGfMuwkvPpxSd+ycgw5nlHhZXRwnavAKn2bJBSFBbswy
	 BIMVB4Y8cGMq/UIA718kB7j5pK08gvsgVaSGqngITYGerRBfwa0ScCFIaBULfx1sxPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DFl7toTxwSctrNYRUj+gJUQHOtZlIBcSJg0h1UcLZTg=;
	b=x0IP55kwdmj7NFjNRK7hTBmd75X1qf/JGBXsj+g3wAHCAlxfIcfeVheDEdTjYBEpGGQP
	 wACLKEUZBfF+fzhH92cBmykoaGRsaG1SAEYAT2VLprY4Gwg8rjxk1/NR+EAEdEqaqsOlv
	 evQy8vFUkN/3hx+AccF7hJNQd6Ia4XbwUaCd2OVkxLPSOIdHpu4hfguEgG9hmnpMU5Jbc
	 2jssX4GQr9JGyP1/8SM888Qge/7jKVmEU04Cspa+oCqhaYyJPtZDEjJ50/8IJHbZbT8DT
	 JbSChZbUaJazYYJOmiATAbdXCfMuXXxQbucIQUkbdGR3Bmi1Z+GIIKkxrLPhqa2Vbzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvQ8O1TZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22D9606A320;
	Wed, 18 Nov 2026 23:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvQ8O1TZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337F41F000C4;
	Wed, 18 Nov 2026 23:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045738;
	bh=DFl7toTxwSctrNYRUj+gJUQHOtZlIBcSJg0h1UcLZTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvQ8O1TZ4TBoKhPSoitWF7N79LprdV42qw6eLbXsBoTt4u/uAJ8YT3dDFeovzKMTt
	 reO9WTVmuAElo0naExnFSw6IYBebtBkQZ7Uuxbe9+VMOTzYOOxCFEh6UEXmP2lcvRe
	 sHSLfpqqw3jV8HXhE1Dfy2MqBRjiLmrLcYNjssvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0990/2857] platform/x86/amd/pmc: Fix RTC reference leak in amd_pmc_verify_czn_rtc()
Date: Wed, 18 Nov 2026 15:33:44 +0100
Message-ID: <20261118150237.246463716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit 22b9306f1fcf86f80b55f05f08d10a9951ba970a ]

amd_pmc_verify_czn_rtc() opens the RTC with rtc_class_open(), which
takes both a device reference and a module reference on the RTC
driver. The matching release is rtc_class_close(), and it is never
called. Every return path after the device has been opened, the ones
that return 0 as well as the ones that report an error, leaves both
references behind, so each S0i3 suspend leaks them.

Release the reference with a __free() cleanup on the declaration,
which covers every return path without adding labels.

rtc_class_close() does not accept a NULL argument, so the cleanup
helper has to guard against one: rtc_class_open() may fail and the
declaration still has to be cleaned up.

Found by code review.

Fixes: 59348401ebed ("platform/x86: amd-pmc: Add special handling for timer based S0i3 wakeup")
Cc: stable@vger.kernel.org
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20261011121759.3267678-1-make_ruc2021@163.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc.c | 5 +++--
 include/linux/rtc.h            | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 8eb5ddeca0d46..ca3b874058ff0 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -14,6 +14,7 @@
 #include <linux/acpi.h>
 #include <linux/bitfield.h>
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -694,7 +695,6 @@ static int amd_pmc_czn_wa_irq1(struct amd_pmc_dev *pdev)
 
 static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 {
-	struct rtc_device *rtc_device;
 	time64_t then, now, duration;
 	struct rtc_wkalrm alarm;
 	struct rtc_time tm;
@@ -710,7 +710,8 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 	if (pdev->major < 64 || (pdev->major == 64 && pdev->minor < 53))
 		return 0;
 
-	rtc_device = rtc_class_open("rtc0");
+	struct rtc_device *rtc_device __free(rtc_class_close) =
+		rtc_class_open("rtc0");
 	if (!rtc_device)
 		return 0;
 	rc = rtc_read_alarm(rtc_device, &alarm);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 1fd9c6a21ebe8..447bdba3497b5 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -13,6 +13,7 @@
 #define _LINUX_RTC_H_
 
 
+#include <linux/cleanup.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/nvmem-provider.h>
@@ -197,6 +198,7 @@ extern void rtc_update_irq(struct rtc_device *rtc,
 
 extern struct rtc_device *rtc_class_open(const char *name);
 extern void rtc_class_close(struct rtc_device *rtc);
+DEFINE_FREE(rtc_class_close, struct rtc_device *, if (_T) rtc_class_close(_T));
 
 extern int rtc_irq_set_state(struct rtc_device *rtc, int enabled);
 extern int rtc_irq_set_freq(struct rtc_device *rtc, int freq);
-- 
2.53.0



