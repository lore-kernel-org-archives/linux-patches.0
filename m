Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D509220FC
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 11:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F50FC433D2;
	Tue,  7 Feb 2023 11:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675768231;
	bh=OkRO0TmzgwU/D7fzKHxZGJ0808t2SLtMzoyYoyWjuXk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=q2inZrJyxJNUbn6/zSUtVFHM2v6U0059eoege5pYkr+lb4S/pf75nqEZ1arfQ8ocl
	 9e7fpO/A165+j8NaRmfe5d3uaApNEF98LkieP5uP7A6s69nHPYjuALymDcsFUWjrxP
	 Ij/HlOfR6/M/cOWI6GFgUFwjhwTrn2y+nOpORi5Q=
Subject: Patch "phy: qcom-qmp-combo: disable runtime PM on unbind" has been added to the 5.15-stable tree
To: dmitry.baryshkov@linaro.org,gregkh@linuxfoundation.org,johan+linaro@kernel.org,patches@lists.linux.dev,swboyd@chromium.org,vkoul@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 07 Feb 2023 12:10:28 +0100
In-Reply-To: <20230203222616.2935268-2-swboyd@chromium.org>
Message-ID: <167576822820142@kroah.com>
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

    phy: qcom-qmp-combo: disable runtime PM on unbind

to the 5.15-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     phy-qcom-qmp-combo-disable-runtime-pm-on-unbind.patch
and it can be found in the queue-5.15 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable-owner@vger.kernel.org Fri Feb  3 23:27:27 2023
From: Stephen Boyd <swboyd@chromium.org>
Date: Fri,  3 Feb 2023 14:26:12 -0800
Subject: phy: qcom-qmp-combo: disable runtime PM on unbind
To: stable@vger.kernel.org
Cc: Johan Hovold <johan+linaro@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Vinod Koul <vkoul@kernel.org>
Message-ID: <20230203222616.2935268-2-swboyd@chromium.org>

From: Johan Hovold <johan+linaro@kernel.org>

commit 4382d518d1887e62234560ea08a0203d11d28cc1 upstream.

Make sure to disable runtime PM also on driver unbind.

Fixes: ac0d239936bd ("phy: qcom-qmp: Add support for runtime PM").
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220907110728.19092-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5740,7 +5740,9 @@ static int qcom_qmp_phy_probe(struct pla
 		return -ENOMEM;
 
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 	/*
 	 * Prevent runtime pm from being ON by default. Users can enable
 	 * it using power/control in sysfs.
@@ -5790,13 +5792,10 @@ static int qcom_qmp_phy_probe(struct pla
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
 	if (!IS_ERR(phy_provider))
 		dev_info(dev, "Registered Qcom-QMP phy\n");
-	else
-		pm_runtime_disable(dev);
 
 	return PTR_ERR_OR_ZERO(phy_provider);
 
 err_node_put:
-	pm_runtime_disable(dev);
 	of_node_put(child);
 	return ret;
 }


Patches currently in stable-queue which might be from stable-owner@vger.kernel.org are

queue-5.15/phy-qcom-qmp-combo-fix-broken-power-on.patch
queue-5.15/phy-qcom-qmp-combo-fix-runtime-suspend.patch
queue-5.15/phy-qcom-qmp-combo-disable-runtime-pm-on-unbind.patch
queue-5.15/phy-qcom-qmp-usb-fix-memleak-on-probe-deferral.patch
queue-5.15/phy-qcom-qmp-combo-fix-memleak-on-probe-deferral.patch
