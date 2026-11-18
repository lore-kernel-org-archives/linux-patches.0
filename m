Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036159;
	b=L+oE5ilOZYCAYd7XB7vGJWj83eel3D8FMP/pqK+Yl6RpYtbVYHVkRWO5Mr5/T56zBZE5
	 FITvkhgQ/Mhf/it7ghlxJ0aqYLRcqms313+QYexZGElnj0EPjE5Z7l6B6DNvpFlm1oMk3
	 RMUDDKJjyZri3KqTRkVU3+vMFtLKIcab2mtrAN1rJvwUw+ymF7aRzRUersPHJOTlcX798
	 XHEFmjs/q3bF+P7i97iXePOtnzo2mzlSXbPSNbgeNKtZEo4CvLcMtl48sDLQsWLDEuVRf
	 tfAEwskAl5vFc9fBJF7RmZf4R8Jh99RzImwYo3/Z4gD4X13cxz1C3jkGBNxB2jaJZLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fczJCGN+Vo6XXVRPNDD9sxkAW8rouAiuPBL6L2hzSzk=;
	b=Q42AcCNRSCnX4iRKsv8WkvRdZ7WJiRphVfP5GSfpWq1d+TuEtjcLEHJoGF+LmsKZ/iQ+
	 SyDSDbKhTq0WDH0PIPkXJkAfeEAdF0Ydwd0BGdKDulQ0EGbQsoYValr9fZv87QHHZv0iK
	 XhNM8mZB74pU/kcrsgOkLiJ1tKWF5wsPIQO2P2kkIeJGIwoyzE2D5LW1mw80dNPnu36mU
	 QUOL0nMGV4qx2E2Dg59oJNh43yqNBHiXLftiry2f1a/KaITvqvMTfX+4fySpWDG3SHf0P
	 6j5Pi6o+083xNKv7JqT+vffCbX3DVL8B0fTVbQBATmt0XjIkvxVoonvpsjyplYrxYqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwg2AGqy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0F6606A320;
	Wed, 18 Nov 2026 21:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fwg2AGqy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C244E1F000C6;
	Wed, 18 Nov 2026 21:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036159;
	bh=fczJCGN+Vo6XXVRPNDD9sxkAW8rouAiuPBL6L2hzSzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwg2AGqyIYYGL4kVgxcOQ9m6T8CTf+6drSn9arqu2NIXa3uNPEzqa4NZIHWdT1AVM
	 3X4SuxfOVmRk5/v0KJI0Qoqzu4xWYDV35Q26TrVo1R72R1VBB+VHYAM5w/m/Irk16h
	 y7YV8V12+gv3yUPGq4QRUJ+2rEHNpP8Q+oxr7yck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0959/3318] cxl/acpi: Check ACPI companion before use
Date: Wed, 18 Nov 2026 15:26:21 +0100
Message-ID: <20261118150348.409711415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a881a764cf35..0b4ec78addaa6 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -661,12 +661,16 @@ static int pair_cxl_resource(struct device *dev, void *data)
 
 static int cxl_acpi_probe(struct platform_device *pdev)
 {
-	int rc;
+	struct cxl_cfmws_context ctx;
+	struct acpi_device *adev;
 	struct resource *cxl_res;
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



