Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6F631E823;
	Sat, 12 Sep 2026 19:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241059; cv=none; b=lNP622OAc/GHEKt4gA2EE5t/vuNOfHHDV394m3/E4svI2d3dzMITqoEz+fdHV7Df1hrrkgpWRzVm6Fx4qd8/W7lqXrVg25jN3KGgYF4n7Bs6BQ8wedZ21wc8FdVzF11zB7OGXqGNjQX8yU+r1+4Vyg6TsZ/2vt2gapQYdqDuyn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241059; c=relaxed/simple;
	bh=tOCFoALZqt/ohpiKJH+TEe/GHXVFbDBnNyjgp+n2dxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvfQSLCIJF1MYrfggedgUH3kcXvr/Y+E3zx0FRkXor+AmBHzhXT9kFZX9oxOvkyKNT815K5/L9R9Y5PjgppzXtVlMigbvikKsAWZxxbd1xo0GE1uRtcTK980obcSDQsvllAS+CfTAG2ngsl0Al6zR7zAGqj2Ru9RnI3h7lEWc8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeCupA57; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeCupA57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0731F000FF;
	Sat, 12 Sep 2026 19:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241058;
	bh=0q4/EaF5jjdXV9s2ttWHnLuMNOIV2kfiJ/tnkqrVh4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VeCupA57iGtz2N16nBESCf2PSlwm3AQE9u/qF9y6MEdgirjDRYI4RU8/qZhZZ8RAs
	 Qj/yv8mzhJpsqgwJMq3zqDE0xOxHA5GbbNHA4o3XtHvArSgU9wuRNtKf80kAApEsgO
	 gh+uVnhj3Q71I7BWRAOTYtNCG7AMsgJoupPwKELI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 015/798] USB: phy: fsl-usb: fix missing static keywords
Date: Sat, 12 Sep 2026 08:54:03 +0200
Message-ID: <20260912065517.309776177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 80574c40598aedbc1751c528e414d7e224bc6313 upstream.

A recent change enabling compile testing of a Freescale dual-role
controller indirectly enabled a USB PHY driver to be built. That driver
in turn is missing a bunch of static keywords which results in warnings
like:

drivers/usb/phy/phy-fsl-usb.c:105:5: error: no previous prototype for 'write_ulpi' [-Werror=missing-prototypes]
  105 | int write_ulpi(u8 addr, u8 data)
        |     ^~~~~~~~~~

which consequently breaks -Werror builds.

Add the missing static keywords.

Fixes: 0807c500a1a6 ("USB: add Freescale USB OTG Transceiver driver")
Cc: stable@vger.kernel.org	# 3.0
Reported-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/4f9f5ff9-8eaa-4bd5-9331-37119f78e13f@sirena.org.uk
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260717154957.1853976-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-fsl-usb.c |   52 +++++++++++++++++++++---------------------
 drivers/usb/phy/phy-fsl-usb.h |    6 ++--
 2 files changed, 29 insertions(+), 29 deletions(-)

--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -45,7 +45,7 @@
 
 static const char driver_name[] = "fsl-usb2-otg";
 
-const pm_message_t otg_suspend_state = {
+static const pm_message_t otg_suspend_state = {
 	.event = 1,
 };
 
@@ -56,11 +56,11 @@ static struct fsl_otg *fsl_otg_dev;
 static int srp_wait_done;
 
 /* FSM timers */
-struct fsl_otg_timer *a_wait_vrise_tmr, *a_wait_bcon_tmr, *a_aidl_bdis_tmr,
+static struct fsl_otg_timer *a_wait_vrise_tmr, *a_wait_bcon_tmr, *a_aidl_bdis_tmr,
 	*b_ase0_brst_tmr, *b_se0_srp_tmr;
 
 /* Driver specific timers */
-struct fsl_otg_timer *b_data_pulse_tmr, *b_vbus_pulse_tmr, *b_srp_fail_tmr,
+static struct fsl_otg_timer *b_data_pulse_tmr, *b_vbus_pulse_tmr, *b_srp_fail_tmr,
 	*b_srp_wait_tmr, *a_wait_enum_tmr;
 
 static struct list_head active_timers;
@@ -101,7 +101,7 @@ static void (*_fsl_writel)(u32 v, unsign
 #define fsl_writel(val, addr)	writel(val, addr)
 #endif /* CONFIG_PPC32 */
 
-int write_ulpi(u8 addr, u8 data)
+static int write_ulpi(u8 addr, u8 data)
 {
 	u32 temp;
 
@@ -114,7 +114,7 @@ int write_ulpi(u8 addr, u8 data)
 /* Operations that will be called from OTG Finite State Machine */
 
 /* Charge vbus for vbus pulsing in SRP */
-void fsl_otg_chrg_vbus(struct otg_fsm *fsm, int on)
+static void fsl_otg_chrg_vbus(struct otg_fsm *fsm, int on)
 {
 	u32 tmp;
 
@@ -132,7 +132,7 @@ void fsl_otg_chrg_vbus(struct otg_fsm *f
 }
 
 /* Discharge vbus through a resistor to ground */
-void fsl_otg_dischrg_vbus(int on)
+static void fsl_otg_dischrg_vbus(int on)
 {
 	u32 tmp;
 
@@ -150,7 +150,7 @@ void fsl_otg_dischrg_vbus(int on)
 }
 
 /* A-device driver vbus, controlled through PP bit in PORTSC */
-void fsl_otg_drv_vbus(struct otg_fsm *fsm, int on)
+static void fsl_otg_drv_vbus(struct otg_fsm *fsm, int on)
 {
 	u32 tmp;
 
@@ -168,7 +168,7 @@ void fsl_otg_drv_vbus(struct otg_fsm *fs
  * Pull-up D+, signalling connect by periperal. Also used in
  * data-line pulsing in SRP
  */
-void fsl_otg_loc_conn(struct otg_fsm *fsm, int on)
+static void fsl_otg_loc_conn(struct otg_fsm *fsm, int on)
 {
 	u32 tmp;
 
@@ -187,7 +187,7 @@ void fsl_otg_loc_conn(struct otg_fsm *fs
  * port.  In host mode, controller will automatically send SOF.
  * Suspend will block the data on the port.
  */
-void fsl_otg_loc_sof(struct otg_fsm *fsm, int on)
+static void fsl_otg_loc_sof(struct otg_fsm *fsm, int on)
 {
 	u32 tmp;
 
@@ -202,7 +202,7 @@ void fsl_otg_loc_sof(struct otg_fsm *fsm
 }
 
 /* Start SRP pulsing by data-line pulsing, followed with v-bus pulsing. */
-void fsl_otg_start_pulse(struct otg_fsm *fsm)
+static void fsl_otg_start_pulse(struct otg_fsm *fsm)
 {
 	u32 tmp;
 
@@ -218,7 +218,7 @@ void fsl_otg_start_pulse(struct otg_fsm
 	fsl_otg_add_timer(fsm, b_data_pulse_tmr);
 }
 
-void b_data_pulse_end(unsigned long foo)
+static void b_data_pulse_end(unsigned long foo)
 {
 #ifdef HA_DATA_PULSE
 #else
@@ -229,7 +229,7 @@ void b_data_pulse_end(unsigned long foo)
 	fsl_otg_pulse_vbus();
 }
 
-void fsl_otg_pulse_vbus(void)
+static void fsl_otg_pulse_vbus(void)
 {
 	srp_wait_done = 0;
 	fsl_otg_chrg_vbus(&fsl_otg_dev->fsm, 1);
@@ -237,7 +237,7 @@ void fsl_otg_pulse_vbus(void)
 	fsl_otg_add_timer(&fsl_otg_dev->fsm, b_vbus_pulse_tmr);
 }
 
-void b_vbus_pulse_end(unsigned long foo)
+static void b_vbus_pulse_end(unsigned long foo)
 {
 	fsl_otg_chrg_vbus(&fsl_otg_dev->fsm, 0);
 
@@ -250,7 +250,7 @@ void b_vbus_pulse_end(unsigned long foo)
 	fsl_otg_add_timer(&fsl_otg_dev->fsm, b_srp_wait_tmr);
 }
 
-void b_srp_end(unsigned long foo)
+static void b_srp_end(unsigned long foo)
 {
 	fsl_otg_dischrg_vbus(0);
 	srp_wait_done = 1;
@@ -265,7 +265,7 @@ void b_srp_end(unsigned long foo)
  * a_host will start by SRP.  It needs to set b_hnp_enable before
  * actually suspending to start HNP
  */
-void a_wait_enum(unsigned long foo)
+static void a_wait_enum(unsigned long foo)
 {
 	VDBG("a_wait_enum timeout\n");
 	if (!fsl_otg_dev->phy.otg->host->b_hnp_enable)
@@ -275,13 +275,13 @@ void a_wait_enum(unsigned long foo)
 }
 
 /* The timeout callback function to set time out bit */
-void set_tmout(unsigned long indicator)
+static void set_tmout(unsigned long indicator)
 {
 	*(int *)indicator = 1;
 }
 
 /* Initialize timers */
-int fsl_otg_init_timers(struct otg_fsm *fsm)
+static int fsl_otg_init_timers(struct otg_fsm *fsm)
 {
 	/* FSM used timers */
 	a_wait_vrise_tmr = otg_timer_initializer(&set_tmout, TA_WAIT_VRISE,
@@ -338,7 +338,7 @@ int fsl_otg_init_timers(struct otg_fsm *
 }
 
 /* Uninitialize timers */
-void fsl_otg_uninit_timers(void)
+static void fsl_otg_uninit_timers(void)
 {
 	/* FSM used timers */
 	kfree(a_wait_vrise_tmr);
@@ -390,7 +390,7 @@ static struct fsl_otg_timer *fsl_otg_get
 }
 
 /* Add timer to timer list */
-void fsl_otg_add_timer(struct otg_fsm *fsm, void *gtimer)
+static void fsl_otg_add_timer(struct otg_fsm *fsm, void *gtimer)
 {
 	struct fsl_otg_timer *timer = gtimer;
 	struct fsl_otg_timer *tmp_timer;
@@ -420,7 +420,7 @@ static void fsl_otg_fsm_add_timer(struct
 }
 
 /* Remove timer from the timer list; clear timeout status */
-void fsl_otg_del_timer(struct otg_fsm *fsm, void *gtimer)
+static void fsl_otg_del_timer(struct otg_fsm *fsm, void *gtimer)
 {
 	struct fsl_otg_timer *timer = gtimer;
 	struct fsl_otg_timer *tmp_timer, *del_tmp;
@@ -442,7 +442,7 @@ static void fsl_otg_fsm_del_timer(struct
 }
 
 /* Reset controller, not reset the bus */
-void otg_reset_controller(void)
+static void otg_reset_controller(void)
 {
 	u32 command;
 
@@ -454,7 +454,7 @@ void otg_reset_controller(void)
 }
 
 /* Call suspend/resume routines in host driver */
-int fsl_otg_start_host(struct otg_fsm *fsm, int on)
+static int fsl_otg_start_host(struct otg_fsm *fsm, int on)
 {
 	struct usb_otg *otg = fsm->otg;
 	struct device *dev;
@@ -521,7 +521,7 @@ end:
  * Call suspend and resume function in udc driver
  * to stop and start udc driver.
  */
-int fsl_otg_start_gadget(struct otg_fsm *fsm, int on)
+static int fsl_otg_start_gadget(struct otg_fsm *fsm, int on)
 {
 	struct usb_otg *otg = fsm->otg;
 	struct device *dev;
@@ -703,7 +703,7 @@ static int fsl_otg_start_hnp(struct usb_
  * intact.  It needs to have knowledge of some USB interrupts
  * such as port change.
  */
-irqreturn_t fsl_otg_isr(int irq, void *dev_id)
+static irqreturn_t fsl_otg_isr(int irq, void *dev_id)
 {
 	struct otg_fsm *fsm = &((struct fsl_otg *)dev_id)->fsm;
 	struct usb_otg *otg = ((struct fsl_otg *)dev_id)->phy.otg;
@@ -829,7 +829,7 @@ err:
 }
 
 /* OTG Initialization */
-int usb_otg_start(struct platform_device *pdev)
+static int usb_otg_start(struct platform_device *pdev)
 {
 	struct fsl_otg *p_otg;
 	struct usb_phy *otg_trans = usb_get_phy(USB_PHY_TYPE_USB2);
@@ -1002,7 +1002,7 @@ static int fsl_otg_remove(struct platfor
 	return 0;
 }
 
-struct platform_driver fsl_otg_driver = {
+static struct platform_driver fsl_otg_driver = {
 	.probe = fsl_otg_probe,
 	.remove = fsl_otg_remove,
 	.driver = {
--- a/drivers/usb/phy/phy-fsl-usb.h
+++ b/drivers/usb/phy/phy-fsl-usb.h
@@ -373,6 +373,6 @@ struct fsl_otg_config {
 
 #define FSL_OTG_NAME		"fsl-usb2-otg"
 
-void fsl_otg_add_timer(struct otg_fsm *fsm, void *timer);
-void fsl_otg_del_timer(struct otg_fsm *fsm, void *timer);
-void fsl_otg_pulse_vbus(void);
+static void fsl_otg_add_timer(struct otg_fsm *fsm, void *timer);
+static void fsl_otg_del_timer(struct otg_fsm *fsm, void *timer);
+static void fsl_otg_pulse_vbus(void);


