Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030129;
	b=n+ZktX4xYHE/+2BvQnYY8B5KELEuOPRXCFNPocvy9DbEtaowSFjmN2SGnsxQyRuKxwJ0
	 BznD/B232tiUndJ00ha61KZ61atzU+kVaeXH9xAUcSd2SqYuKgdbewcSqVmPgXvOaSr3r
	 59QZnHOB+k1rpFvxcjpz33a0fj4w2UK7CVPqNhJeq5ZRU1Nqq5IZrv2MlGP2Obs0d9dxl
	 CBKwZpw2yvnzvSQqcbyn+t4jxypScNnfTgGJyu9O2sE2onCGGmhWosjK9ydMqxH7Ygdya
	 CmZhITgpydDdTSrRHHzCfD8Cpnm7+CbUlur/CIC+5yvgTdlM+IxFP/nWwfiSNBGuUNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KazD1h+GDr5p/mEmiWjfhAEN6jYVOTfQ8FdtPLTbTKw=;
	b=XLBzQXlRDGfV9ZgfF19MtUyLEzTrNInDs1uGOzgxSKBkB/CSiMp/1mUWbtonv+2MSrFu
	 pBdD9Z/d4/yp21al+p3wDvltKwGd5P/uiTaX8BLir+7uwMbGl3bsTQqMnoKpdmIqDWdyM
	 vhgClQerhpc1rH6/V53Fp4OtImzmbDYH9Zz3ZoPRJFKuW2DRCX5MUcq1yKSdKo1egwLFK
	 8dsjzfD7FNSGOLpV+h1w3nRp780uUGTXb8n758XVOCfKP9/qoi8CbjO4b6lz7KJ+92rMx
	 giCLX1M1ryJXjt5dbXwpAYchefVrV7OPIsSg/e1QBptGJyWaPEdu9DkrgGeAHrjWl4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kJcLMTTR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7567D606B114;
	Wed, 18 Nov 2026 19:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kJcLMTTR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D7D1F000C5;
	Wed, 18 Nov 2026 19:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030129;
	bh=KazD1h+GDr5p/mEmiWjfhAEN6jYVOTfQ8FdtPLTbTKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJcLMTTRsA3COCdJefGwTkAVs4Sf1bE0E+ZiYPS/BMq3w1UIQ+j+2+0LEs60LgT6D
	 sEFJsYH5K+xIrJArXcgytOO7owvptJD4WrfyJ3nTST3k3HoXbII1mb/pecSrlyPFUi
	 qSbfA4V9q/B6KeyJYv6C+pOYRWaYzzrhqYSMwdos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0594/1756] ACPI: PCC: Simplify PCC shared memory region handling
Date: Wed, 18 Nov 2026 15:45:21 +0100
Message-ID: <20261118150032.636825324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 8960c45a0f41399770d408921180231395604e2f ]

The PCC driver now handles mapping and unmapping of shared memory
areas as part of pcc_mbox_{request,free}_channel(). Without these before,
this ACPI PCC opregion driver did handling of those mappings like several
other PCC mailbox client drivers.

There were redundant operations, leading to unnecessary code. Maintaining
the consistency across these driver was harder due to scattered handling
of shmem.

Just use the mapped shmem and remove all redundant operations from this
driver.

Tested-by: Adam Young <admiyo@os.amperecomputing.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://patch.msgid.link/20250411113144.1151094-1-sudeep.holla@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 46c263c21387 ("ACPI: PCC: Preserve shared memory signature in OpRegion handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pcc.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/acpi_pcc.c b/drivers/acpi/acpi_pcc.c
index 59d2308259cb2..e3f302b9dee5f 100644
--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -31,7 +31,6 @@
 
 struct pcc_data {
 	struct pcc_mbox_chan *pcc_chan;
-	void __iomem *pcc_comm_addr;
 	struct completion done;
 	struct mbox_client cl;
 	struct acpi_pcc_info ctx;
@@ -81,14 +80,6 @@ acpi_pcc_address_space_setup(acpi_handle region_handle, u32 function,
 		ret = AE_SUPPORT;
 		goto err_free_channel;
 	}
-	data->pcc_comm_addr = acpi_os_ioremap(pcc_chan->shmem_base_addr,
-					      pcc_chan->shmem_size);
-	if (!data->pcc_comm_addr) {
-		pr_err("Failed to ioremap PCC comm region mem for %d\n",
-		       ctx->subspace_id);
-		ret = AE_NO_MEMORY;
-		goto err_free_channel;
-	}
 
 	*region_context = data;
 	return AE_OK;
@@ -113,7 +104,7 @@ acpi_pcc_address_space_handler(u32 function, acpi_physical_address addr,
 	reinit_completion(&data->done);
 
 	/* Write to Shared Memory */
-	memcpy_toio(data->pcc_comm_addr, (void *)value, data->ctx.length);
+	memcpy_toio(data->pcc_chan->shmem, (void *)value, data->ctx.length);
 
 	ret = mbox_send_message(data->pcc_chan->mchan, NULL);
 	if (ret < 0)
@@ -134,7 +125,7 @@ acpi_pcc_address_space_handler(u32 function, acpi_physical_address addr,
 
 	mbox_chan_txdone(data->pcc_chan->mchan, ret);
 
-	memcpy_fromio(value, data->pcc_comm_addr, data->ctx.length);
+	memcpy_fromio(value, data->pcc_chan->shmem, data->ctx.length);
 
 	return AE_OK;
 }
-- 
2.53.0



