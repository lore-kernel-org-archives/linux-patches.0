Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214816;
	b=fwPRbOehPLKYpXOrFOr9J5dYQDIAQO1HJGTkCDdUY7DDftrigkLcwIDXV/+kuTIzBkqx
	 B4ZTsWa7QOcbkebzYUGGJMORRvHLjpQCVxCWo0rcfJkTHGwjmZtAUo+sJxJzWFbpL4pGG
	 ohRZk2DBRAFCVGZ8zxvV4UY7ggMDCCGx5gRwewXSO34rEPkzLKxvfJ0OqdG8mscXJPjbP
	 ugsxsJX2hE7jUwFuFaR3Z5hqMBty2vJ9ng0Ahbo797WwYZEsy/VvxlwO2loABMV5xXizY
	 dPjLSov+Wlxy+Niby3RcZ0+r/3ZKNegSV3kXQn3/V4Ns5SA6i8BdDDShW+epkiinrTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+l8tS5NVVHmiZ31dbDWl4il6ZnmKoky0QnhKBbhB5Rc=;
	b=PA5uvo1VhdvVWecFQN3LyvJHOs2XlJXDD9YCtLdn2Ba5IonAU97aiUR7weDrCZpQJ+ol
	 3g3TBLJwOtOlZCSWXDxB++K0wbt62OXFIPJUvq6ewDou41XeND3EPz+gGa/YaY8qha5X0
	 8Db1picUrfDWDr50xik78O5f2XU5h6L5jBq9sbqr4e5cSZkFJD2109ymybiZHGdyJ8MGv
	 HcfwMour/JC+oRXos5mit0Pwh5BGmvml8/ZEwLJX/U9Sjtk2H4XyyeFzQr41iHvGxagyA
	 KrzLS0bTgs85BqQcTU4OJBxBD2845q55F0blGm4RoAp/dcbsng6ReOq/Jk1swcBID0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UR5glfUg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BC8606A33B;
	Wed, 28 Oct 2026 19:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UR5glfUg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E261F01825;
	Wed, 28 Oct 2026 19:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214816;
	bh=+l8tS5NVVHmiZ31dbDWl4il6ZnmKoky0QnhKBbhB5Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UR5glfUgygbRAiaZufkL0wi6HYymKyqPOOIxsL1/4iDCkxHVTcKyx2Y2t/fy2WeI1
	 nVF3XnHCJg5HkiuJHoc0vsv0eHs+xWdifFQ4gCvF6lSZEHj3ff2MDMLS7sZU3VKoVC
	 fI0xlWt2pAcDjglzjClI4f5K+1ChdzBe8XHHWFs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Samuel Wu <wusamuel@google.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0990/1887] usb: dwc3: gadget: Move vbus draw to workqueue context
Date: Wed, 28 Oct 2026 17:51:26 +0100
Message-ID: <20261028170521.939881291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Prashanth K <prashanth.k@oss.qualcomm.com>

[ Upstream commit 54aaa3b387c2f580a99dc86a9cc2eb6dfaf599a7 ]

Currently dwc3_gadget_vbus_draw() can be called from atomic
context, which in turn invokes power-supply-core APIs. And
some these PMIC APIs have operations that may sleep, leading
to kernel panic.

Fix this by moving the vbus_draw into a workqueue context.

Fixes: 99288de36020 ("usb: dwc3: add an alternate path in vbus_draw callback")
Cc: stable <stable@kernel.org>
Tested-by: Samuel Wu <wusamuel@google.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://patch.msgid.link/20260204054155.3063825-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c   | 19 ++++++++++++++++++-
 drivers/usb/dwc3/core.h   |  4 ++++
 drivers/usb/dwc3/gadget.c |  8 +++-----
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 7793936757ac3..dbddc1d45fdcc 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1855,6 +1855,20 @@ static struct extcon_dev *dwc3_get_extcon(struct dwc3 *dwc)
 	return edev;
 }
 
+static void dwc3_vbus_draw_work(struct work_struct *work)
+{
+	struct dwc3 *dwc = container_of(work, struct dwc3, vbus_draw_work);
+	union power_supply_propval val = {0};
+	int ret;
+
+	val.intval = 1000 * (dwc->current_limit);
+	ret = power_supply_set_property(dwc->usb_psy, POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT, &val);
+
+	if (ret < 0)
+		dev_dbg(dwc->dev, "Error (%d) setting vbus draw (%d mA)\n",
+			ret, dwc->current_limit);
+}
+
 static struct power_supply *dwc3_get_usb_power_supply(struct dwc3 *dwc)
 {
 	struct power_supply *usb_psy;
@@ -1869,6 +1883,7 @@ static struct power_supply *dwc3_get_usb_power_supply(struct dwc3 *dwc)
 	if (!usb_psy)
 		return ERR_PTR(-EPROBE_DEFER);
 
+	INIT_WORK(&dwc->vbus_draw_work, dwc3_vbus_draw_work);
 	return usb_psy;
 }
 
@@ -2120,8 +2135,10 @@ static int dwc3_remove(struct platform_device *pdev)
 	dwc3_free_event_buffers(dwc);
 	dwc3_free_scratch_buffers(dwc);
 
-	if (dwc->usb_psy)
+	if (dwc->usb_psy) {
+		cancel_work_sync(&dwc->vbus_draw_work);
 		power_supply_put(dwc->usb_psy);
+	}
 
 	return 0;
 }
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index e4e0c40dc51d3..0119a8940c8d5 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1035,6 +1035,8 @@ struct dwc3_scratchpad_array {
  * @role_switch_default_mode: default operation mode of controller while
  *			usb role is USB_ROLE_NONE.
  * @usb_psy: pointer to power supply interface.
+ * @vbus_draw_work: Work to set the vbus drawing limit
+ * @current_limit: How much current to draw from vbus, in milliAmperes.
  * @usb2_phy: pointer to USB2 PHY
  * @usb3_phy: pointer to USB3 PHY
  * @usb2_generic_phy: pointer to USB2 PHY
@@ -1207,6 +1209,8 @@ struct dwc3 {
 	enum usb_dr_mode	role_switch_default_mode;
 
 	struct power_supply	*usb_psy;
+	struct work_struct	vbus_draw_work;
+	unsigned int		current_limit;
 
 	u32			fladj;
 	u32			ref_clk_per;
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index cd0532158ba0b..18fab84af369e 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3019,8 +3019,6 @@ static void dwc3_gadget_set_ssp_rate(struct usb_gadget *g,
 static int dwc3_gadget_vbus_draw(struct usb_gadget *g, unsigned int mA)
 {
 	struct dwc3		*dwc = gadget_to_dwc(g);
-	union power_supply_propval	val = {0};
-	int				ret;
 
 	if (dwc->usb2_phy)
 		return usb_phy_set_power(dwc->usb2_phy, mA);
@@ -3028,10 +3026,10 @@ static int dwc3_gadget_vbus_draw(struct usb_gadget *g, unsigned int mA)
 	if (!dwc->usb_psy)
 		return -EOPNOTSUPP;
 
-	val.intval = 1000 * mA;
-	ret = power_supply_set_property(dwc->usb_psy, POWER_SUPPLY_PROP_INPUT_CURRENT_LIMIT, &val);
+	dwc->current_limit = mA;
+	schedule_work(&dwc->vbus_draw_work);
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.53.0



