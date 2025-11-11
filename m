Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D9821ABB9;
	Tue, 11 Nov 2025 01:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825085; cv=none; b=Ke1LGP9pjAOJF9Gc/ccH9o6GhjE/5sgxbuW8IBYsBaohhXC06OmYAXi7SmtSJGxfthDt7LZAoVtxJKyLmK86Zh6S/KTZVitS4/uswl/kuxlEuODGsfq6E/yisRzYjvRzuxmah9DJdKTPWAsh+z0Lgzb97zSbXdT9HLD8ESSsPzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825085; c=relaxed/simple;
	bh=lv356gCG0bc/RcSwuerMNjw3fsKwFb0GIp3Qy3M58iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iX9r1PyFB4XyjBeQE4hP80CDNYRUdKBp4vjRr8ELtYnWZwWfTfw+sgml3rE4g+1Gjd057VT49S96nR7LF1vK6cAdtcnNO/zI6SO584eogKpktzedwAb6YHEh39+eHl0Te7I8DcDEpqjFmEQpvAZti+s0y2fVV27CgKt87FplKhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeIGqYb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeIGqYb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D033C4CEFB;
	Tue, 11 Nov 2025 01:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825084;
	bh=lv356gCG0bc/RcSwuerMNjw3fsKwFb0GIp3Qy3M58iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeIGqYb8rOfEUQ5YnHSKwuCWjTHilykKR6rVHv3pIq58hWokOx6331AU7bVdFpoEg
	 lSXrFP8jaOt9BYVmBY1CWWbktGeQzgRzgStJd22176KjChOakM27M9e+XqVMuYAUYx
	 XHLiLvd4eL7p23mDBfNUoG8KJ57kP/wKJ1h/hee4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 653/849] platform/x86: x86-android-tablets: Stop using EPROBE_DEFER
Date: Tue, 11 Nov 2025 09:43:43 +0900
Message-ID: <20251111004552.215669736@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 01fd7cf3534aa107797d130f461ba7bcad30414d ]

Since the x86-android-tablets code uses platform_create_bundle() it cannot
use EPROBE_DEFER and the driver-core will translate EPROBE_DEFER to ENXIO.

Stop using EPROBE_DEFER instead log an error and return ENODEV, or for
non-fatal cases log a warning and return 0.

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20250920200713.20193-21-hansg@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/core.c  | 6 ++++--
 drivers/platform/x86/x86-android-tablets/other.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/platform/x86/x86-android-tablets/core.c
index 2a9c471785050..8c8f10983f289 100644
--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -277,8 +277,10 @@ get_serdev_controller_by_pci_parent(const struct x86_serdev_info *info)
 	struct pci_dev *pdev;
 
 	pdev = pci_get_domain_bus_and_slot(0, 0, info->ctrl.pci.devfn);
-	if (!pdev)
-		return ERR_PTR(-EPROBE_DEFER);
+	if (!pdev) {
+		pr_err("error could not get PCI serdev at devfn 0x%02x\n", info->ctrl.pci.devfn);
+		return ERR_PTR(-ENODEV);
+	}
 
 	/* This puts our reference on pdev and returns a ref on the ctrl */
 	return get_serdev_controller_from_parent(&pdev->dev, 0, info->ctrl_devname);
diff --git a/drivers/platform/x86/x86-android-tablets/other.c b/drivers/platform/x86/x86-android-tablets/other.c
index f7bd9f863c85e..aa4f8810974d5 100644
--- a/drivers/platform/x86/x86-android-tablets/other.c
+++ b/drivers/platform/x86/x86-android-tablets/other.c
@@ -809,8 +809,10 @@ static int __init vexia_edu_atla10_9v_init(struct device *dev)
 
 	/* Reprobe the SDIO controller to enumerate the now enabled Wifi module */
 	pdev = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x11, 0));
-	if (!pdev)
-		return -EPROBE_DEFER;
+	if (!pdev) {
+		pr_warn("Could not get PCI SDIO at devfn 0x%02x\n", PCI_DEVFN(0x11, 0));
+		return 0;
+	}
 
 	ret = device_reprobe(&pdev->dev);
 	if (ret)
-- 
2.51.0



