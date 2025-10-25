Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C2031D39A;
	Sat, 25 Oct 2025 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409700; cv=none; b=I9aF82a8LYYJEb7cDgEMgMH96BtQnTIoRPOWdCZ3Qx/I8ZGvyAs9xNxFzluBoo+/Xqt42NwqdgyH7KFbdxH+8nPkUfzAdVByHG325L7elcX70FMKAkOdXeq8++lXSqCtZVTvags2Dth61TzWkLeBjWgZW42FES+td9nj/IQGLWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409700; c=relaxed/simple;
	bh=hhVmO8Q3TJXMPMBlG9yOr4wrre1e8Mf+8pKaavnKWGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q9+HG1SxlEizvlK0q/L2BUev6K5/eiKMp36zXeTImivrstwh6vXv7C+2zSpRrxabnvQc8ZZmwH2ySwdmrrCSUoXWq0hoGg2LN/aWGS/BUaaoqmacMry3B7zNhbqAY5oKiI7Y7o5dDEy1gW2Y2zFEhWk5meozvUAAGyDxg1RgojI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B6sEz8x8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B6sEz8x8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFFF1C4CEFB;
	Sat, 25 Oct 2025 16:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409700;
	bh=hhVmO8Q3TJXMPMBlG9yOr4wrre1e8Mf+8pKaavnKWGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6sEz8x8nVe1gy7Cg2Xzdx0vjDROwXi7PN8vh7dJwgjb/JPwpDXwNIFiOqTxeBpGY
	 WtKk0UbE9y0VdH38SewDOXuLTCO8k8HyNRx+mBf9LhKEItIbRwTSD5pz5yIRxM3PGy
	 1dlMpzVSytZhei5WWsb86aNfjmWHwXlW7k5cWVCBZamXC1ZUzVkGLFeBpdfVagCahq
	 7N5z8Yl8SinNLhN5dqVzwvPlG96iJfZVBQ9TLr/9FqsQ/sJO3oiAavvmxDYDWk4UQg
	 xA0SQ+FufAxJ7jdzkAhl8ZmajV6ukW2p7TvpyuzAPDB9v3F37RTlhd9Halnpag8xdv
	 +/eVu2t8P6qmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hans de Goede <hansg@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] platform/x86: x86-android-tablets: Stop using EPROBE_DEFER
Date: Sat, 25 Oct 2025 12:00:57 -0400
Message-ID: <20251025160905.3857885-426-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- `__platform_driver_probe()` sets `drv->prevent_deferred_probe = true`
  and `platform_probe()` converts any `-EPROBE_DEFER` into `-ENXIO` with
  only a warning (drivers/base/platform.c:935,1408-1410). The
  x86-android-tablets driver is created through
  `platform_create_bundle()` (core.c:523-530), so any deferral request
  from this code path is doomed to a permanent failure of the bundle.
- Before this commit `get_serdev_controller_by_pci_parent()` returned
  `ERR_PTR(-EPROBE_DEFER)` when the PCI parent was missing, which
  immediately tripped the `prevent_deferred_probe` guard and killed the
  whole probe with an opaque `-ENXIO`. The patch replaces that with an
  explicit error message and `-ENODEV` (core.c:276-282), aligning the
  driver with the documented restriction in `x86_android_tablet_probe()`
  that “it cannot use -EPROBE_DEFER” (core.c:411-416). This removes the
  bogus deferral while keeping the failure visible to users and
  diagnostic logs intact.
- The more severe issue was in `vexia_edu_atla10_9v_init()`: if the
  expected SDIO PCI function was absent, the code returned
  `-EPROBE_DEFER`, which, once translated to `-ENXIO`, caused
  `x86_android_tablet_probe()` to unwind and prevented every board quirk
  (touchscreen, sensors, etc.) from being instantiated. The fix
  downgrades this path to a warning and success return
  (other.c:701-716), allowing the tablet support driver to finish
  probing even when that optional Wi-Fi controller is missing or late to
  appear.
- No behaviour changes occur on the success paths; only error-handling
  logic is touched, so the regression risk is very low. The change is
  self-contained, affects just two helper functions, and has no
  dependency on the rest of the series. Given that the preexisting code
  can leave entire tablet models without platform devices because of an
  impossible deferral, this is an important bugfix that fits stable
  backport criteria.

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

