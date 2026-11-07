Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062130;
	b=QqLg2PSUHYu/v+AacuT1a887MG9JAcvALMupZw2Fqb40FL9yi7AomzOJogTy2mhTT/1F
	 DNIDtAD38Zq4NIPiuj2ZnJ2+KpeSY7Ujy/+pmKHjxLEhX4z10TRxuxv9YODEmcKFVJ6Ks
	 tjKgve823+sSuL/lDdYl9SKEPrXPMmSMmR/ApBBGx2cv1WEeNVIDINhKI53qDp8xD21j/
	 EkQFcFLP2cg531BIWY0piXlPcbw+83XRmNCv5lAW8HrBR/vhjcXXzublwVFDAWgRXVtYL
	 P7P7G2iahvYTti1OsvTJZVvzbd9+13eW2Y4UNJe9IFb48cCDcqofu1sNa69fB4978VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V/Hg4DmckUAsNiXiCbMyApaCspvSB6ufzoPtottqHd8=;
	b=BaCPEmlspx1PcH3C9CJoJBq61OamFRa7O89Tybu2SO+UVr1P5bXcBi7V7t2sabbL2DSA
	 Xca4LZCt5LQ3LvltxQUBDEspmyNvrsIG8HOPaAJ6+0ZIvTiE76Lom44XIbYk8SFacG6nP
	 f6ROB7eNScD9kcq/tlfrE1IZK5de68U/uuc4VyFCCEqISpq2hMde7jZGwFMxmh6msIQpt
	 8HFM9Be2NNaUMdwXzavkrn/a82n70+FRBHkail4nIBpO18ESXfpPhk7oq+REq/xzPZTnn
	 5G5zXtHmdCk0RbfBpNb2FJaU7kyt+iOLgcZ+ynRT/gzTE+l+0g19zew25vAds8WOXeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EsivOYAw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F7E606EE99;
	Sat,  7 Nov 2026 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EsivOYAw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A1B1F008A4;
	Sat,  7 Nov 2026 14:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062130;
	bh=V/Hg4DmckUAsNiXiCbMyApaCspvSB6ufzoPtottqHd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EsivOYAwBwd+JsylBZfRoyOFUZzpUTvRRG3ptuPCK02cQH7wbXbe6pA4VQjZLeEx4
	 8GhNo2N6v75gdt9G4uqWWneWjI4LOkYxq/Rt0jl1EIqAYf4Dr7MNVl3rbw6rtBadS6
	 XuvY6m4yYEjXCGtffyfrWxqV5956bKFV1gSv7Lzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1098/1536] cxl/acpi: Check ACPI companion before use
Date: Sat,  7 Nov 2026 08:51:54 -0500
Message-ID: <20261107135028.539298244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 432b7cfd12a8e..0b0937c09f2be 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -815,13 +815,17 @@ static int pair_cxl_resource(struct device *dev, void *data)
 
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



