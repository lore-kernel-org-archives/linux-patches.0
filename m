Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591584;
	b=sZhUHHq6ogU1I8Id/9bgbByK8ypSEfwUoHMKndK0hXO7rEgtcBWooS9w5FrjptnmIOIY
	 JgS/b4AooUOvKeVP90QSdvHHQOEu5PdibzguF6vf9Qok+YZuP5VSRmP++SyV06Mk0lrH0
	 rlTODkDVoC52+rJnBjHMzqNLlpB5zE3TetW0JR3UOWOOlxFbMbtMP+4/LKS6Zd7b/+DSJ
	 VDjgs+/49R7eK6a2QNFpHaM+yF0qYAUcxhqb8HPJcIFFvr1enFf4GdawKeMnjW+2oFRBn
	 1Z9ROv0bFwqUGGSlA8eGYoziufCwx3IOScheAJgXBHcj9QsXng2UdhWv+zriLoysvvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gs6sUkF8KE00sLjN8gurrpWH/Am7k2e5LQD/hMUldHY=;
	b=vwXpqsNqhGptFEYd4s4BnLvCHEb/K9c3u1aQLKwrS2ez2LeWQAQLmqv7VClZbY5srGdh
	 Fr7+m/2tjUYPJ5mw1Hwf8Xfnlx2zyAa6ZPguv0qPMYHrAYRPnHw3l1APDom0mpRp/AvzX
	 mjRCZeWprg2hxXvby/wrzfkwfZB+/hlI8jyRZUnFhg6HDguYsQhbHp5fqW/xmEYsAJ3Iz
	 Sf9B/ggs0dRfgn334VNGcJpKszEuvynDycKBUSxBVqRX4pt0d3UAhgMszN0ZmdmzuRLKs
	 CXVr4k792cJcEk++HS4K3nsdJl6DLx934lv/PInX0ndR7CvlrRjswZjNHVagV/GzfTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k2Y3/M9Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7EF606E65A;
	Fri, 13 Nov 2026 17:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2Y3/M9Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CAC1F000C5;
	Fri, 13 Nov 2026 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591584;
	bh=Gs6sUkF8KE00sLjN8gurrpWH/Am7k2e5LQD/hMUldHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2Y3/M9ZKV6mMdIhZxMkHyWy/iRZeBOPG5J5pSzIkhxsHyk3E+xpV1JHoqzJBSduG
	 xMz1zO08/1C4vEIkI9Y9oL5wQbEb69U395nNNfL/ZMJQX2TLY0Fw57GQIv4HY3BJJ0
	 WisWBsflf2SAJOaV8nnKtcfv/K13DSo6Fo5EW3rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wahl <steve.wahl@hpe.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 631/670] watchdog/hpwdt: Refine hpwdt message for UV platform
Date: Fri, 13 Nov 2026 10:53:15 -0500
Message-ID: <20261113153833.172068959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wahl <steve.wahl@hpe.com>

[ Upstream commit d8207d1e9a36b1a8a461581b2d4073ea28335603 ]

The watchdog hardware the hpwdt driver uses was added to the UV
platform for UV_5, but the logging mentioned by this driver was not
added to the BIOS.  When the watchdog fires, the printed message had
the administrators and developers looking for non-existent log files,
and confused about whether a watchdog actually tripped.

Change the message that prints on UV platforms so it doesn't send the
user looking for non-existent logs.

To aid in any future debugging, include all 8 bits of the NMISTAT
register in the output, not just the two bits being used to determine
this was "mynmi".  And provide names to the bits in NMISTAT so the
code is easier to understand.

Signed-off-by: Steve Wahl <steve.wahl@hpe.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20260318155005.90271-1-steve.wahl@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: ed9e4c1ff15d ("panic: restore variable arguments to nmi_panic()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/hpwdt.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index ae30e394d176e..ba08189937ec6 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -22,6 +22,7 @@
 #include <linux/watchdog.h>
 #ifdef CONFIG_HPWDT_NMI_DECODING
 #include <asm/nmi.h>
+#include <asm/uv/uv.h>
 #endif
 #include <linux/crash_dump.h>
 
@@ -158,24 +159,31 @@ static int hpwdt_set_pretimeout(struct watchdog_device *wdd, unsigned int req)
 	return 0;
 }
 
-static int hpwdt_my_nmi(void)
-{
-	return ioread8(hpwdt_nmistat) & 0x6;
-}
+#define NMISTAT_EASR	BIT(0)
+#define NMISTAT_EWDOG	BIT(1)
+#define NMISTAT_RTRAP	BIT(2)
+#define NMISTAT_DBELL	BIT(3)
+#define NMISTAT_EMSWDG	BIT(4)
+#define NMISTAT_GPI	BIT(5)
+#define NMISTAT_NMIOUT	BIT(7)
 
 /*
  *	NMI Handler
  */
 static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs)
 {
-	unsigned int mynmi = hpwdt_my_nmi();
-	static char panic_msg[] =
+	u8 nmistat = ioread8(hpwdt_nmistat);
+	bool mynmi = (nmistat & (NMISTAT_EWDOG | NMISTAT_RTRAP)) != 0;
+	static char panic_msg_default[] =
 		"00: An NMI occurred. Depending on your system the reason "
 		"for the NMI is logged in any one of the following resources:\n"
 		"1. Integrated Management Log (IML)\n"
 		"2. OA Syslog\n"
 		"3. OA Forward Progress Log\n"
 		"4. iLO Event Log";
+	static char panic_msg_uv[] =
+		"00: A watchdog NMI occurred.";
+	char *panic_msg = is_uv_system() ? panic_msg_uv : panic_msg_default;
 
 	if (ulReason == NMI_UNKNOWN && !mynmi)
 		return NMI_DONE;
@@ -189,7 +197,7 @@ static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs)
 		hpwdt_ping_ticks(SECS_TO_TICKS(val));
 	}
 
-	hex_byte_pack(panic_msg, mynmi);
+	hex_byte_pack(panic_msg, nmistat);
 	nmi_panic(regs, panic_msg);
 
 	return NMI_HANDLED;
-- 
2.53.0



