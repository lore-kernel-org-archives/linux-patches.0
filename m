Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2426F20FC
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 11:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DEEC433EF;
	Tue,  7 Feb 2023 11:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675768249;
	bh=tAK4ESoR+dXZ8wAVMiK8VyQzQAIo9gt6CXoAcTGhXqw=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=yiPgymADIEfwNbT/MRyFQacfwzpcvGppkHz5oTrK/jZWLEz93Y4fFwXdZ+MhpkrfI
	 I2v2f76MtdRWQjrOn6W4gFUGuGMqfFuoTUJd1LLXq9NB74Zlf6t9tV/DsHp47UP8zn
	 HpoxehZ3f8bbykWiFqH44zxBGBwjn3n+uf6/6bg0=
Subject: Patch "phy: qcom-qmp-combo: fix runtime suspend" has been added to the 5.15-stable tree
To: dmitry.baryshkov@linaro.org,gregkh@linuxfoundation.org,johan+linaro@kernel.org,patches@lists.linux.dev,swboyd@chromium.org,vkoul@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 07 Feb 2023 12:10:30 +0100
In-Reply-To: <20230203222616.2935268-6-swboyd@chromium.org>
Message-ID: <1675768230154218@kroah.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    phy: qcom-qmp-combo: fix runtime suspend

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     phy-qcom-qmp-combo-fix-runtime-suspend.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Fri Feb  3 23:27:28 2023
From: Stephen Boyd <swboyd@chromium.org>
Date: Fri,  3 Feb 2023 14:26:16 -0800
Subject: phy: qcom-qmp-combo: fix runtime suspend
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Vinod Koul <vkoul@kernel.org>
Message-ID: <20230203222616.2935268-6-swboyd@chromium.org>

From: Johan Hovold <johan+linaro@kernel.org>

commit c7b98de745cffdceefc077ad5cf9cda032ef8959 upstream.

Drop the confused runtime-suspend type check which effectively broke
runtime PM if the DP child node happens to be parsed before the USB
child node during probe (e.g. due to order of child nodes in the
devicetree).

Instead use the new driver data USB PHY pointer to access the USB
configuration and resources.

Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20221114081346.5116-6-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[swboyd@chromium.org: Backport to pre-split driver. Note that the
condition is kept so that ufs and pcie don't do anything as before]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -4985,7 +4985,7 @@ static void qcom_qmp_phy_disable_autonom
 static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 
 	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qphy->mode);
@@ -5010,7 +5010,7 @@ static int __maybe_unused qcom_qmp_phy_r
 static int __maybe_unused qcom_qmp_phy_runtime_resume(struct device *dev)
 {
 	struct qcom_qmp *qmp = dev_get_drvdata(dev);
-	struct qmp_phy *qphy = qmp->phys[0];
+	struct qmp_phy *qphy = qmp->usb_phy;
 	const struct qmp_phy_cfg *cfg = qphy->cfg;
 	int ret = 0;
 


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-5.15/phy-qcom-qmp-combo-fix-broken-power-on.patch
queue-5.15/phy-qcom-qmp-combo-fix-runtime-suspend.patch
queue-5.15/phy-qcom-qmp-combo-disable-runtime-pm-on-unbind.patch
queue-5.15/phy-qcom-qmp-usb-fix-memleak-on-probe-deferral.patch
queue-5.15/phy-qcom-qmp-combo-fix-memleak-on-probe-deferral.patch
