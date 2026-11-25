Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622769;
	b=pJZ+cyEJyeBAafj6ie9v5bD+IDRh6Q0iY3ry2/AiiuyD0gWY7oKYBeqSGphQq8OavSka
	 dIoPlhqXTtKyuyqx/ORXDVAVRZxjVdLYs9CDvy/uKOzbe3zpSEMoOecrnpdsyXdpE4Hj0
	 fDTF37MWqbNIIIawgXilURAouoUEm0m/jSsoMsnX/nEyIaV/znwxdWYDdZiWzqW19oVlA
	 WFt2AUioiJvfNjOSc42e6d9E5jH8833cnnhm70DNcfP4Tihv1p3lqJvtntDO4rS6W077v
	 YzO3jft7DQ2z9Ei37CO88VUVhkkgUk5Lm5XJztVngCiOgTXZrbiWMt7TsCrhF6hWKtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Eg8L3h/xE9fJA49tLF3YCw87nEzG70wRQBbUriFPy3k=;
	b=UMc44YJpMejgt9qthi1E5VwsPGLey5xu/L1TQeCCiP1M0Nw6KWJcoBQsK+kyyxMMUghS
	 7pZVL53Ma8zGCYgjVo60NZ6+FwwJ8bSkQLKkLJnK7H1DRuxE52ixnWHLd1BgAR9lOkpzt
	 Ap18pFuTYjv5Co94hULjNOhvlWr5sKDke/K02d80bqy5Xi5H82ggDPQm7k1j3k36L5ITT
	 Iho6Do2l/Agi5KM5Nz/iP15jmYnRRZwdFg8eqfK9aYkgxemX1BXd4hdHyrQR3yYmWI3vg
	 A9cnO9yZ30ub0LngJ4OV3hcs1yqr/Y5wMbI5Stt4tTK38g/PFpQ8Nzfk+Uiw6BaVHwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F5zNcUWy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EE9606A31E;
	Wed, 25 Nov 2026 16:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F5zNcUWy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E801F000C4;
	Wed, 25 Nov 2026 16:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622769;
	bh=Eg8L3h/xE9fJA49tLF3YCw87nEzG70wRQBbUriFPy3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5zNcUWyZFx22LTAYOk07fNF7sWWd4Qf2Zzmwe+IuPC4b8GMaZ3lzuguhOvzYbisd
	 QTHExwvydWaHt0CmHIgTolrFpBe44tNOfxdHejQTsE5dvNWNPpwC1LzJKNWpQsiuMY
	 ENNe3lVSivwiyrAUSvXb6HSGIKBxpvPw9bK7na68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra <ravindra@intel.com>,
	Sergey Lebedev <lsa.uz@pm.me>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 596/990] Bluetooth: btintel_pcie: fix PM flow for S0ix, S3 and S4
Date: Wed, 25 Nov 2026 15:32:43 +0100
Message-ID: <20261125143836.051504128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ravindra <ravindra@intel.com>

[ Upstream commit 2926eb396711f1f843a0aafee6778822f50e9021 ]

Fix two issues in the PM suspend/resume path:

1. S3 was handled the same as S0ix, keeping the controller on the
   D3hot-style path. That caused resume instability because S3 can
   remove power from the controller, unlike s2idle/S0ix. Use
   pm_suspend_target_state to distinguish them: D3_HOT for S0ix and
   D3_COLD for S3/S4. Add .restore to force FLR-based firmware recovery
   after S4 and S3 (PM_SUSPEND_MEM), as power is lost. S0ix resumes via
   a normal D0 transition.

2. During hibernation, .freeze() puts the controller into the D3cold
   state without any loss of power, and the flow normally continues to
   .poweroff(). If hibernation instead fails, .thaw() is called to bring
   the controller back up, and the old code routed it through
   btintel_pcie_resume(), which forced FLR-based firmware recovery
   whenever data->pm_sx_event was PM_EVENT_FREEZE. That check was
   incorrect: since the controller's power was never actually removed on
   this failed-hibernation path, FLR-based recovery is unnecessary. Remove
   pm_sx_event and route .thaw through a normal D0 transition instead;
   FLR-based recovery is retained only in .restore, where genuine S4
   power loss requires it.

Tested with:
  S0ix: sudo sh -c 'echo "+40" > /sys/class/rtc/rtc0/wakealarm' && \
        echo freeze | sudo tee /sys/power/state
  S3:   sudo rtcwake -m mem  -s 60
  S4:   sudo rtcwake -m disk -s 60

Fixes: e57362f4911b ("Bluetooth: btintel_pcie: Add support for _suspend() / _resume()")
Assisted-by: GitHub-Copilot:GPT5
Signed-off-by: Ravindra <ravindra@intel.com>
Tested-by: Sergey Lebedev <lsa.uz@pm.me>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ sashal: Replaced the btintel_pcie_request_reset(data, FLR) call with btintel_pcie_reset() and kept the gp0_received = false resets, because the set_dxstate retry rework is missing here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 45 +++++++++++++++++++++-----------
 drivers/bluetooth/btintel_pcie.h |  2 --
 2 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 75bbb2bb6be55..3799e5b20d5f7 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -13,6 +13,7 @@
 #include <linux/wait.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/suspend.h>
 
 #include <linux/unaligned.h>
 #include <linux/devcoredump.h>
@@ -2580,10 +2581,12 @@ static int btintel_pcie_suspend_late(struct device *dev, pm_message_t mesg)
 
 	data = pci_get_drvdata(pdev);
 
-	dxstate = (mesg.event == PM_EVENT_SUSPEND ?
-		   BTINTEL_PCIE_STATE_D3_HOT : BTINTEL_PCIE_STATE_D3_COLD);
-
-	data->pm_sx_event = mesg.event;
+	/* S0ix (s2idle) uses D3_HOT; S3, freeze and hibernate use D3_COLD. */
+	if (mesg.event == PM_EVENT_SUSPEND &&
+	    pm_suspend_target_state == PM_SUSPEND_TO_IDLE)
+		dxstate = BTINTEL_PCIE_STATE_D3_HOT;
+	else
+		dxstate = BTINTEL_PCIE_STATE_D3_COLD;
 
 	data->gp0_received = false;
 
@@ -2622,7 +2625,7 @@ static int btintel_pcie_freeze(struct device *dev)
 	return btintel_pcie_suspend_late(dev, PMSG_FREEZE);
 }
 
-static int btintel_pcie_resume(struct device *dev)
+static int btintel_pcie_resume_event(struct device *dev, pm_message_t mesg)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct btintel_pcie_data *data;
@@ -2634,15 +2637,12 @@ static int btintel_pcie_resume(struct device *dev)
 
 	start = ktime_get();
 
-	/* When the system enters S4 (hibernate) mode, bluetooth device loses
-	 * power, which results in the erasure of its loaded firmware.
-	 * Consequently, function level reset (flr) is required on system
-	 * resume to bring the controller back into an operational state by
-	 * initiating a new firmware download.
+	/* S3 and S4 may cut power, erasing the firmware. Force FLR to recover
+	 * instead of a normal D0 transition.
 	 */
-
-	if (data->pm_sx_event == PM_EVENT_FREEZE ||
-	    data->pm_sx_event == PM_EVENT_HIBERNATE) {
+	if (mesg.event == PM_EVENT_RESTORE ||
+	    (mesg.event == PM_EVENT_RESUME &&
+	     pm_suspend_target_state == PM_SUSPEND_MEM)) {
 		set_bit(BTINTEL_PCIE_CORE_HALTED, &data->flags);
 		btintel_pcie_reset(data->hdev);
 		return 0;
@@ -2685,13 +2685,28 @@ static int btintel_pcie_resume(struct device *dev)
 	return 0;
 }
 
+static int btintel_pcie_resume(struct device *dev)
+{
+	return btintel_pcie_resume_event(dev, PMSG_RESUME);
+}
+
+static int btintel_pcie_restore(struct device *dev)
+{
+	return btintel_pcie_resume_event(dev, PMSG_RESTORE);
+}
+
+static int btintel_pcie_thaw(struct device *dev)
+{
+	return btintel_pcie_resume_event(dev, PMSG_THAW);
+}
+
 static const struct dev_pm_ops btintel_pcie_pm_ops = {
 	.suspend = btintel_pcie_suspend,
 	.resume = btintel_pcie_resume,
 	.freeze = btintel_pcie_freeze,
-	.thaw = btintel_pcie_resume,
+	.thaw = btintel_pcie_thaw,
 	.poweroff = btintel_pcie_hibernate,
-	.restore = btintel_pcie_resume,
+	.restore = btintel_pcie_restore,
 };
 
 static struct pci_driver btintel_pcie_driver = {
diff --git a/drivers/bluetooth/btintel_pcie.h b/drivers/bluetooth/btintel_pcie.h
index 481de85456e2b..43be595d20b65 100644
--- a/drivers/bluetooth/btintel_pcie.h
+++ b/drivers/bluetooth/btintel_pcie.h
@@ -461,7 +461,6 @@ struct btintel_pcie_dump_header {
  * @txq: TX Queue struct
  * @rxq: RX Queue struct
  * @alive_intr_ctxt: Alive interrupt context
- * @pm_sx_event: PM event on which system got suspended
  */
 struct btintel_pcie_data {
 	struct pci_dev	*pdev;
@@ -511,7 +510,6 @@ struct btintel_pcie_data {
 	u32	alive_intr_ctxt;
 	struct btintel_pcie_dbgc	dbgc;
 	struct btintel_pcie_dump_header dmp_hdr;
-	u8	pm_sx_event;
 };
 
 static inline u32 btintel_pcie_rd_reg32(struct btintel_pcie_data *data,
-- 
2.53.0



