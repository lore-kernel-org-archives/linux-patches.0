Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7621C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E6AC433D2;
	Wed, 28 Dec 2022 16:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245310;
	bh=ZNqTtWOn2vMG1EH6bQnAzJfZfj7e79dr/PqWV1t5Vt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXSR82cCSJ0KCqS9LzkD6FscEjrGXO+HeKhuk/op3FCuj8Utso1/RPj/DvLFh8Y7U
	 CzNjqoEWzZbCS4XUOP+wpZL85/6cqawmIBhBDteQvkapW34fZhRi6SpwD40AmHIobb
	 IrhCbHoR+Soi4243d9fCoZvlSTludCfowuOh7oTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0837/1146] rtc: cmos: Rename ACPI-related functions
Date: Wed, 28 Dec 2022 15:39:36 +0100
Message-Id: <20221228144352.892158428@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit d13e9ad9f5146f066a5c5a1cc993d09e4fb21ead ]

The names of rtc_wake_setup() and cmos_wake_setup() don't indicate
that these functions are ACPI-related, which is the case, and the
former doesn't really reflect the role of the function.

Rename them to acpi_rtc_event_setup() and acpi_cmos_wake_setup(),
respectively, to address this shortcoming.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/3225614.44csPzL39Z@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 2a21d8281aa6..039486bfedf4 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -784,7 +784,7 @@ static u32 rtc_handler(void *context)
 	return ACPI_INTERRUPT_HANDLED;
 }
 
-static void rtc_wake_setup(struct device *dev)
+static void acpi_rtc_event_setup(struct device *dev)
 {
 	if (acpi_disabled)
 		return;
@@ -828,7 +828,7 @@ static void use_acpi_alarm_quirks(void)
 static inline void use_acpi_alarm_quirks(void) { }
 #endif
 
-static void cmos_wake_setup(struct device *dev)
+static void acpi_cmos_wake_setup(struct device *dev)
 {
 	if (acpi_disabled)
 		return;
@@ -880,11 +880,11 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 
 #else /* !CONFIG_ACPI */
 
-static inline void rtc_wake_setup(struct device *dev)
+static inline void acpi_rtc_event_setup(struct device *dev)
 {
 }
 
-static inline void cmos_wake_setup(struct device *dev)
+static inline void acpi_cmos_wake_setup(struct device *dev)
 {
 }
 
@@ -986,7 +986,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 			cmos_rtc.wake_off = info->wake_off;
 		}
 	} else {
-		cmos_wake_setup(dev);
+		acpi_cmos_wake_setup(dev);
 	}
 
 	if (cmos_rtc.day_alrm >= 128)
@@ -1091,7 +1091,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	 * the ACPI RTC fixed event.
 	 */
 	if (!info)
-		rtc_wake_setup(dev);
+		acpi_rtc_event_setup(dev);
 
 	dev_info(dev, "%s%s, %d bytes nvram%s\n",
 		 !is_valid_irq(rtc_irq) ? "no alarms" :
-- 
2.35.1



