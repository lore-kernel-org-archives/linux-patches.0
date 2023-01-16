Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3223646B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FD9C433D2;
	Mon, 16 Jan 2023 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886217;
	bh=dTw+SZTi4pw+UwHad4CcK5Hl/QPhftsfPaluXvT5ie0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ePDGqfLo9Y0rbGu3j3uz2rJ5JfRaMQTAYYpL3+WpIjhMWv0I+uqtcU/02WPcUO2l
	 ArFSHhd3Gd6HdzZU1jj5nJ5/b5C1T/b/OYZSIlFlDIRfzfojuLlpuiDOuYxmDCnj9r
	 DNDxDeJMAPKladZJa5YhjxMKQx+UZY/hXZewtHbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 345/658] rtc: cmos: Rename ACPI-related functions
Date: Mon, 16 Jan 2023 16:47:13 +0100
Message-Id: <20230116154925.350087920@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index bc8f65014025..203f41afe8c1 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -738,7 +738,7 @@ static u32 rtc_handler(void *context)
 	return ACPI_INTERRUPT_HANDLED;
 }
 
-static void rtc_wake_setup(struct device *dev)
+static void acpi_rtc_event_setup(struct device *dev)
 {
 	if (acpi_disabled)
 		return;
@@ -782,7 +782,7 @@ static void use_acpi_alarm_quirks(void)
 static inline void use_acpi_alarm_quirks(void) { }
 #endif
 
-static void cmos_wake_setup(struct device *dev)
+static void acpi_cmos_wake_setup(struct device *dev)
 {
 	if (acpi_disabled)
 		return;
@@ -834,11 +834,11 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 
 #else /* !CONFIG_ACPI */
 
-static inline void rtc_wake_setup(struct device *dev)
+static inline void acpi_rtc_event_setup(struct device *dev)
 {
 }
 
-static inline void cmos_wake_setup(struct device *dev)
+static inline void acpi_cmos_wake_setup(struct device *dev)
 {
 }
 
@@ -940,7 +940,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 			cmos_rtc.wake_off = info->wake_off;
 		}
 	} else {
-		cmos_wake_setup(dev);
+		acpi_cmos_wake_setup(dev);
 	}
 
 	if (cmos_rtc.day_alrm >= 128)
@@ -1038,7 +1038,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	 * the ACPI RTC fixed event.
 	 */
 	if (!info)
-		rtc_wake_setup(dev);
+		acpi_rtc_event_setup(dev);
 
 	dev_info(dev, "%s%s, %d bytes nvram%s\n",
 		 !is_valid_irq(rtc_irq) ? "no alarms" :
-- 
2.35.1



