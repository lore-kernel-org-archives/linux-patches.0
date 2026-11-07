Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065030;
	b=O1RcErj8XVFAVRbAVbQqvcGI4ga6pNfPWoeXinYB7+wvdMeUVGhzcd8z9z3pIo0wKujN
	 fiAJxB7OzOauWJwWqWEzsQ9zo0Ay+38dC2bAxZgObUpTtk5DBD/2qMwSxF5g3vTvFMc+N
	 w86d4GhfA9mLHDkZOYYdCSIJBhirIEKvjtz/426e7PUy2DVjY9o1jz+FvnE+7qlabYWTe
	 /8NYyqb8QMeRYb5bjf9Zd4EDF24mFNuLSaQIP8Mllc/mbKFsaoeikxUSjGdrLbA56CGSG
	 9jW/18I9ey/ypg8hfMscTs0A4Gf/UB9jdfxjmmyJG6xcFEmx/W070amWoAAeS7LLdlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86KUR+e4va9HRSE76Q8Jz7GexygHAD71PXEVJ5j1ycE=;
	b=QuL3JO4Alirb2HjcfOZjh+YJbItscjrI9hGbsDX6ssarJf7tOnoozqAHUk4QG3VOmI54
	 qdJlDVBC8qNpLrLxoTtUDjIdFhGKgMTCnY2F1RL+d3KkAsCnwH1Li8H69wWMKgnAO715H
	 Hh3OchiSKqHdAJOzXsPVSzyq8KjtnSVX+4zsDpVLQ9FbaEoOMERI45qx5u1sXT5HSFINn
	 4p3XkZe5Hn5Wo69FzpzbgH/2Gm9yNxHYFb/DLxEVnPD7jXHS+rzye6B+FeVgeGcwaPytr
	 te8a9jtbulSn6hICRLXo1VUB7J0VlYjCjULIjE7EAIo8Jx8fbGjbAKLuRGZbF/ochQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CaGT6U2B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD66A606A336;
	Sat,  7 Nov 2026 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CaGT6U2B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B881F0089F;
	Sat,  7 Nov 2026 15:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065029;
	bh=86KUR+e4va9HRSE76Q8Jz7GexygHAD71PXEVJ5j1ycE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CaGT6U2Br5tG7ZseVXKgy13Qzfj1j8kUZrLJoRvCKhoTkjTzjlM6M8OavRu+FuZCM
	 YIVqME/mX5bY4Cc6sYE1/LLSt28BXlLmW96uwCHrgwTYwQ40mGSc1e+lScYnYzWEAw
	 z9pcPIhIsuroyqOYCMULz/+kYMEwvheJVW7f8RRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0888/1257] platform/x86/amd/pmc: Fix RTC reference leak in amd_pmc_verify_czn_rtc()
Date: Sat,  7 Nov 2026 08:53:04 -0500
Message-ID: <20261107135003.846111241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/amd/pmc/pmc.c | 5 +++--
 include/linux/rtc.h                | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index e384b56d67559..f93c35efeaa00 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -14,6 +14,7 @@
 #include <linux/array_size.h>
 #include <linux/bitfield.h>
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
@@ -648,7 +649,6 @@ static int amd_pmc_wa_irq1(struct amd_pmc_dev *pdev)
 
 static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 {
-	struct rtc_device *rtc_device;
 	time64_t then, now, duration;
 	struct rtc_wkalrm alarm;
 	struct rtc_time tm;
@@ -664,7 +664,8 @@ static int amd_pmc_verify_czn_rtc(struct amd_pmc_dev *pdev, u32 *arg)
 	if (pdev->major < 64 || (pdev->major == 64 && pdev->minor < 53))
 		return 0;
 
-	rtc_device = rtc_class_open("rtc0");
+	struct rtc_device *rtc_device __free(rtc_class_close) =
+		rtc_class_open("rtc0");
 	if (!rtc_device)
 		return 0;
 	rc = rtc_read_next_alarm(rtc_device, &alarm);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c09fc22819d0c..0f43b50272354 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -13,6 +13,7 @@
 #define _LINUX_RTC_H_
 
 
+#include <linux/cleanup.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/nvmem-provider.h>
@@ -201,6 +202,7 @@ extern void rtc_update_irq(struct rtc_device *rtc,
 
 extern struct rtc_device *rtc_class_open(const char *name);
 extern void rtc_class_close(struct rtc_device *rtc);
+DEFINE_FREE(rtc_class_close, struct rtc_device *, if (_T) rtc_class_close(_T));
 
 extern int rtc_irq_set_state(struct rtc_device *rtc, int enabled);
 extern int rtc_irq_set_freq(struct rtc_device *rtc, int freq);
-- 
2.53.0



