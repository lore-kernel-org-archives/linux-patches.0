Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048633;
	b=SDdR7xdLKx1V5oTD2TpQzLNdfDfn+cMuZ+7kZpvUuJJ9bjBrW2mX/kKHEBGx3CsIhmfj
	 Oo/vA5iovBQF1XMCY085ADYFS21kW2dlUsWl4WSBb3aZ8hE7+/B8zPSq+YBno1EuQFzP6
	 MqGqy7zM6oXtLv//43TQ8EqGAjicE1/mrqtpU6S0JcyYpXSdww7qWxesXjr3DbcX8ZWkn
	 c9pb102p+FhAJmfK/QQOoPi+pe+L5zXS3klyNk9DJtPo5cmkhdqOXRc7KqqIBPaYumc2e
	 Xg+sBr0FN9/RP8pAO2waQRDPRqILFi4+gdDP9Nlo41O+tuqI/jN7dZ+Mdd01R9vJZ5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ys6/cWWNlbf9HnRNP1lEgBcI6UXXBTZM5CnoQfkj8VA=;
	b=aAadTWM+lK8fJGzpQqMfsyyqIHqIHv0tk7lAqUqZb68MGNntXGRnZwR6/kuMcyvSOnPH
	 hHfmA9JVcYFBXR/y1lyZJGUvbSJXk2my0ISpUUbyLr8/ET9ZyONsOconnfX4whkMF+0OP
	 zw48gSA2Vf90ZNrsEMo5prvrnwNA5/K16+auGeia1PRSoO4EeElChgED4jIL1DPZjcZ+1
	 AcaR1hQcrGJik/OKL0qnyt5KmrysRUFbNzZYVbkUh1qLAK7rfzJvW4KEUBfgPGfh9DIaP
	 HBK+0j54MQRtO30M75uzx1DOUJ5vxLww8X2GMkX4r2yrLDnE52Q0sVtFRSo5PDzDpGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lGoCFRU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6A2606A334;
	Thu, 19 Nov 2026 00:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lGoCFRU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710221F000C4;
	Thu, 19 Nov 2026 00:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048633;
	bh=Ys6/cWWNlbf9HnRNP1lEgBcI6UXXBTZM5CnoQfkj8VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lGoCFRUWBqkVDWSKs7SihXDDKLiWgjzI0Zz81LkTSCG9ptUY+4XD6NHWXU/L4FcB
	 FA51mZU45wfoi4PQCSt9M1rQp+/Mgrv+PDOfRBeJJnk/N8kyRY3ZrA7vYyKCTYVXfB
	 g8EuTQQ6RQ6sH0hGmQZ8zGpEvZD0eSVZporZuYxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2063/2857] ACPI: PCC: Simplify PCC shared memory region handling
Date: Wed, 18 Nov 2026 15:51:37 +0100
Message-ID: <20261118150315.694233806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 07a034a53acac..97064e943768a 100644
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



