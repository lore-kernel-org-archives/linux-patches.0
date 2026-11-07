Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064255;
	b=nZa8/r3jYkDAFFRaTfxRL60Ts0Zf03NGAUSo3guQ4ncKG7stoLuVZm20upXNWgJ8IZn2
	 IPxbrgV7EgNHneEtJozd4NefdQsXvJQgd8ryECIIrIhfVoeqv5hUrkIFbNK7zGCB5psSm
	 koaqTUtaROW662GpoxayquKXJT+hHWlVaie+H6vrHd2daa3oppPBt3myTn1CIkHNQ4dK4
	 Kw4ga5dkmp4gxh6VbFf0mywBFVAWB6ou7roRlHjIMg5Ifs8ZmuRPFviSMfvZvfOCZVZDu
	 XPsFi191pGeT+rufVqkSNW3qOqmRazFexyjtRJmpcsqEWOIetQWFS1SzGedgCjOY2xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q3IMSfpXeGEboWDI7G065l7ogLmmrMCyN6DmafZorlU=;
	b=Ldz3jTjdAVm41EvxcOp0oYXWcHWgqD5bX3hEHk63t4bVeW5PeK7yyWMG+jh4sdLwXWzP
	 0Vbxx5+neeSHyMR27rU+DgDs1R3FiI980suQ+Jb4shQeSmeACcf4BDZ05TZxvgdB7J7D7
	 nQ5KJUfrm+JWpZYyrM0zpI50B/QY0qRKWmpRltH4/x5Fa1K63qD4vK1zqFCkfC0MBLUiq
	 iVUvjYEQppV8Ghj5lxLEFq5F2Fl+Adxip6l7SuHgOPeoE2yH4A+HMbOnavAzqjGMyn2DE
	 Rj/qM5QzlqUseSfGZEU3xApkXHKVIbAY4Cpbk2c5iinbJ8wEIiwSSb+QHeNnR87u2Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2TqeKFn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9752B606A9C6;
	Sat,  7 Nov 2026 15:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2TqeKFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AE71F0089F;
	Sat,  7 Nov 2026 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064255;
	bh=q3IMSfpXeGEboWDI7G065l7ogLmmrMCyN6DmafZorlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2TqeKFnFYaHm8E9pxr4yqaiTYTbD7aJqBNsnbgDmMqm4lw/jGN113kaapLABQRXH
	 Wc1U9ydwjFeMvSN7okR3aKCrSrAaVSs38ak75hPPKokmZsIoLGM65YDkLr3VJT6g7L
	 5on3uSliZj9YjOL84m4S/S9ujaLnhOzW/6KBmqp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0356/1257] cxl/acpi: Check ACPI companion before use
Date: Sat,  7 Nov 2026 08:44:12 -0500
Message-ID: <20261107134949.217334162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 371c2ad1624283b6c7a62a28199f5161d388a738 ]

Platform drivers can be forced to match devices outside their ID tables
through driver_override.  cxl_acpi_probe() assumes that every bound device
has an ACPI companion and dereferences adev->dev.bus without checking the
result of ACPI_COMPANION().  Force-binding cxl_acpi to a platform device
without a companion therefore causes a NULL pointer dereference.

This was reproduced by setting the driver override for the pcspkr platform
device to cxl_acpi and binding it through sysfs:

  BUG: kernel NULL pointer dereference, address: 0000000000000280
  #PF: supervisor read access in kernel mode
  RIP: cxl_acpi_probe+0xf4/0x220
  Call Trace:
   platform_probe+0x4d/0x80
   really_probe+0x106/0x370
   device_driver_attach+0x4c/0xa0
   bind_store+0xd0/0x100

Commit 2b3a5dabe89e ("platform/surface: acpi-notify: Check ACPI
companion before use") fixed the same force-binding issue in another
platform driver.  Check the companion before setting up the CXL root and
return -ENODEV when it is absent.

Fixes: 7d4b5ca2e2cb ("cxl/acpi: Add downstream port data to cxl_port instances")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Link: https://patch.msgid.link/20260926071605.3013893-1-yaojiale02@163.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/acpi.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 3b818adbd38b5..fb09a5ff48c16 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -885,13 +885,17 @@ static int pair_cxl_resource(struct device *dev, void *data)
 
 static int cxl_acpi_probe(struct platform_device *pdev)
 {
-	int rc;
+	struct cxl_cfmws_context ctx;
+	struct acpi_device *adev;
 	struct resource *cxl_res;
 	struct cxl_root *cxl_root;
 	struct cxl_port *root_port;
 	struct device *host = &pdev->dev;
-	struct acpi_device *adev = ACPI_COMPANION(host);
-	struct cxl_cfmws_context ctx;
+	int rc;
+
+	adev = ACPI_COMPANION(host);
+	if (!adev)
+		return -ENODEV;
 
 	device_lock_set_class(&pdev->dev, &cxl_root_key);
 	rc = devm_add_action_or_reset(&pdev->dev, cxl_acpi_lock_reset_class,
-- 
2.53.0



