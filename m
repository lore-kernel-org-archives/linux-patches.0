Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053833;
	b=NZ78lKzD/jzqeiy16/faUg856gEChKSoPkfILSSiRcJmJOAIbkJ6aJDL9j81XnLiHwCj
	 LGTQ1/04Fye87M98AoZ2PuaxxQ4RxJRqj5kvk9oDm8LcEpOlLd9Wjj7GHfsWOAUji26K6
	 79p0GzjjqgbAgqeR+u/4sw4qP/0DWAwQSa5hIg+t6CoowKl5NzdEyOeGBEBQYt45DM94R
	 e0MuEicaB6YJMj3ssSXFL+WvJcM52Q0y0vJpZNmInZReAAuocMhq/mty/BQWLkkA2ljFH
	 GrYY5y28lIsTDQzKXT+ZkF5VQuyCL7bAtbwa3v/1nEPJ+0ZPXL3Ai6HMjQVd67tWIWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Pk+sb8qflD45+wr0Jr/G8RtwA8qhFVhMLaRPISJdns=;
	b=3Zh71QdulP0whdX08aAfcE1EBaO69z+LcROu5U1pFHWFRk0hRrRa4eZKM7fZUn9tIq8f
	 yZaUgVCyxWIKpW8d4212TVg4Dm3SnLB2M+LdPC3eRv+Q+Io09W+uyoz0XuUP/TjB9Q6uW
	 DhJpsEOYsDXv/vymSUI7TSWW3SP2UioK4eXpZ9Cwmdj9YgMuXqdb6apU1pN0Xwe6IBt7a
	 fhDeDKResyp4bXRUE2FYv0V1byI1xWcLbtNhmTyiINhxYBr4c33vDy5Ns9BRgUj5ZW+eg
	 uQUVZoBrNeCe62tIX7diS/2qEzJ180a8SmxKKPUBMDd8j6poPKr2dOUifc8bYWB2Iew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9ollYiO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88F0606A31C;
	Thu, 19 Nov 2026 02:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9ollYiO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280E21F000C4;
	Thu, 19 Nov 2026 02:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053833;
	bh=/Pk+sb8qflD45+wr0Jr/G8RtwA8qhFVhMLaRPISJdns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x9ollYiOXA+z99oHFTNM9JC9PBWZBDtNzQsMok2hkquqpoiDInXzxtM8XAMyRhQoc
	 vqT+K9lmGJ+NTX4dxvEvCtYmVILofHSFBGKE5WppBek23YO91g3XBbP9WiCKO86HRF
	 +kbR9b35Rx8yccAv5l2NpxdW947TgjadaYonww6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1058/2214] cxl/acpi: Check ACPI companion before use
Date: Wed, 18 Nov 2026 15:45:34 +0100
Message-ID: <20261118150054.633499026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted cxl_acpi_probe() declaration context to preserve the required acpi_status status variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/acpi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 54e9d4d2cf5f5..f2203f14af2cd 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -377,11 +377,15 @@ static int add_root_nvdimm_bridge(struct device *match, void *data)
 
 static int cxl_acpi_probe(struct platform_device *pdev)
 {
-	int rc;
 	acpi_status status;
+	struct acpi_device *adev;
 	struct cxl_port *root_port;
 	struct device *host = &pdev->dev;
-	struct acpi_device *adev = ACPI_COMPANION(host);
+	int rc;
+
+	adev = ACPI_COMPANION(host);
+	if (!adev)
+		return -ENODEV;
 
 	root_port = devm_cxl_add_port(host, host, CXL_RESOURCE_NONE, NULL);
 	if (IS_ERR(root_port))
-- 
2.53.0



