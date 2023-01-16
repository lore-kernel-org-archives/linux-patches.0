Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C20F6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78E7C433D2;
	Mon, 16 Jan 2023 16:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887763;
	bh=TBbyprcp1iJeN3eqoH5p2XjwuTH/gejq73IdvlNpDA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYjygsI2t8l0hp6qKNZYKFbGvC2LHYTN81o6dXVCBNa1J6+/dFSo5LaY8h8wA9Uvh
	 nlJQT7xO/Ddb4uIpJZ8eck2Sg4Eboa1sLCb2KXHti26fvAcI0Ye61nPBNCgwXP51Yw
	 uj36Doj5M57Aa2jlA4rOFmt2AnH/3bslv3KnhrRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 273/521] rtc: cmos: Rename ACPI-related functions
Date: Mon, 16 Jan 2023 16:48:55 +0100
Message-Id: <20230116154859.363293632@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 909cb1d4a4d5..0c035c5a5ae6 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -742,7 +742,7 @@ static u32 rtc_handler(void *context)
 	return ACPI_INTERRUPT_HANDLED;
 }
 
-static void rtc_wake_setup(struct device *dev)
+static void acpi_rtc_event_setup(struct device *dev)
 {
 	if (acpi_disabled)
 		return;
@@ -786,7 +786,7 @@ static void use_acpi_alarm_quirks(void)
 static inline void use_acpi_alarm_quirks(void) { }
 #endif
 
-static void cmos_wake_setup(struct device *dev)
+static void acpi_cmos_wake_setup(struct device *dev)
 {
 	if (acpi_disabled)
 		return;
@@ -838,11 +838,11 @@ static void cmos_check_acpi_rtc_status(struct device *dev,
 
 #else /* !CONFIG_ACPI */
 
-static inline void rtc_wake_setup(struct device *dev)
+static inline void acpi_rtc_event_setup(struct device *dev)
 {
 }
 
-static inline void cmos_wake_setup(struct device *dev)
+static inline void acpi_cmos_wake_setup(struct device *dev)
 {
 }
 
@@ -944,7 +944,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 			cmos_rtc.wake_off = info->wake_off;
 		}
 	} else {
-		cmos_wake_setup(dev);
+		acpi_cmos_wake_setup(dev);
 	}
 
 	if (cmos_rtc.day_alrm >= 128)
@@ -1042,7 +1042,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	 * the ACPI RTC fixed event.
 	 */
 	if (!info)
-		rtc_wake_setup(dev);
+		acpi_rtc_event_setup(dev);
 
 	dev_info(dev, "%s%s, %d bytes nvram%s\n",
 		 !is_valid_irq(rtc_irq) ? "no alarms" :
-- 
2.35.1



