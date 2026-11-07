Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063031;
	b=0yu5+ULhWI1Gyy6LMl1rfEELHg+fPKLxQLYVzrOqAqKy2oxeVwEn3WjwSL0gFOamgFqg
	 89glFW5jJevwkyg5z7qvVhPfO4jALZcl7LIW1PPb1dRBrM8OuM5YUDi0BkNc4elcR8od1
	 WHhw5+tykTE9pY9OZ/KbyjkuXCtuwOL8xYyMLD/mNtXlTCPldWLiTObWIKjaWV45Xhd6G
	 peX3Jfm8kgXgjNiZYn2ge71LDBfIDw6NVmkb7Sya39PIVPnbyjssBXNRVyaAoEMWuNpwk
	 FXPJU3ul2Xi/XnGPlQmlKaBIPfq0X47wtE57sqQQNuyECGzeAUQHJeCOgy2C7zrwj8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D3dP83B9qfnS2EH3XcmkBK3xgGpCbu8OiB4W0cfYNEY=;
	b=q1K+Nac6N6/Av4E1+L/BuXgRLhRWSVUYKy22oG1RkhFIPYsTyKA30ttwD3vMdKT/qjnp
	 Q6BV02HBvE34t+t+dIjPAYX5Rv0CJoTP5B55H8Mqlm7LjwpQALnToBUv1Kourg4TaPkmf
	 8QEbu+fcXiSxALtsxwiPuWc1AhmRSltF7fNEQvcaei5L2t07fjDXDjPY6lTnvWI99Ndym
	 cE3TONh6v+0pMea5IVriUC49k1xoNNqGVJ2rOWX7oxhr+19Z8tkdmWqs9ee1ysaUDR0Xw
	 H0+o5EX+B//DijbKUAtciaci6qyIkqy1g9e0H5LMgU+NIIDvJ2IVEM9QT4xR8KV2cbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bO0TBrS8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E11606D802;
	Sat,  7 Nov 2026 14:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bO0TBrS8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BF91F0089F;
	Sat,  7 Nov 2026 14:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063031;
	bh=D3dP83B9qfnS2EH3XcmkBK3xgGpCbu8OiB4W0cfYNEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bO0TBrS8dLnmPVPc59mhtJGKXr0S+XxfvPWSJKnv8ExnCKbKuSaoPDJfqYIAr+5Rf
	 FQp+WwrcV10wdqbfXynaY8JYfhdj4zBu/3OCckwOeqfeSa67wYQ2Z91SXxymyfqMhD
	 ac2mKDYWZ0kceASIesqvBlXaIWeKvgMi63A9+HeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 281/869] cxl/acpi: Check ACPI companion before use
Date: Sat,  7 Nov 2026 08:49:23 -0500
Message-ID: <20261107134901.243272208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index bd2e282ca93a0..5e9bb0df46dd8 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -892,13 +892,17 @@ static int pair_cxl_resource(struct device *dev, void *data)
 
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



