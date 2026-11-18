Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017408;
	b=GnXFZ9qttKT/kvrIkugKDeVAXtqcmff8Wg6FAB6xzEoQC49VWFKvYfxBzdzK9f2C2qVY
	 jhJ+qLFkf0g//v8pLOa634oYt7ph2lVhZf1BCql2VZCITesLBGHmfSWsvyKm1K0L6ASrB
	 6rbWB1wWKQ2bkL8a15W6XQa4chJCOcoq7INHKTYQqiaUZAGDhVIPyJPSdJ9zJv0p2WKel
	 VYZeN4KMsZWCSAPureS8uIWFgqiglcq9/QCqzDSE7RdQL8dacptmCbTjp8BUKpmo+fmWI
	 qmqhOFSxkWx247xXNVbFTWc1tudjLV0Mqg9v9cBdiG3g7iukSm+3BnR8LvgQN0oxBnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YVctWswJRC1CkKQnP3MbLb2ZVzikFjGsUybzSBXtMpY=;
	b=vCMYBls5c0cThd3m/Wpo+L1HfRJiZzYsI+ZAtcCJNKmSTCjY1Cy0D0bSp1fJlrzBfA2X
	 /Lk2k6HysKArdyAnUPicle0XX1AwZ2PiY52SdHLNBIHA0Mj8X8k60xba1lyIw1THPSYCl
	 W9S0gdNa8AUlCBw56zrl4J6SgJR95OJK2TGivgDjG7xhQ4H5dZMeA0mmkvuyYW75MZ/mM
	 Di3OqdFbeKQU8zk1CQpdItTjI0SCrh4x0xWWpJ5lCu/wYtnrWBooWk3fMRpVP795ioQSE
	 iIR0oOPLcPF587w5JtcfZAIr2wy6kkcK+4tPYYlYMyjg6XvHuKPYk6hExUUEoN2EbgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAKU561l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A63606A31C;
	Wed, 18 Nov 2026 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAKU561l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F371F000C5;
	Wed, 18 Nov 2026 15:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017408;
	bh=YVctWswJRC1CkKQnP3MbLb2ZVzikFjGsUybzSBXtMpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAKU561l5GJiVCoBuHiuhQ9Iz4kHfkgeaSzYvgfpnrSFlzLKl9WJ+TusjqyDUop33
	 FIwj8FhvgBrBDu8GEylqhvdxGRCvZVBj//xDIdyn/M8ALPMSI1jZkTZhjNipoD/sO9
	 XsQkI2LJ6aAZ1RAFqVSwL1/WKzSKWex98sVIJDFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0867/2651] ACPI: PCC: Free channel on OpRegion deactivation
Date: Wed, 18 Nov 2026 15:35:07 +0100
Message-ID: <20261118150319.069686292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit fa9c7ee692988edddc1da74bc5257d53dd3c7130 ]

ACPICA calls the address space setup callback with
ACPI_REGION_DEACTIVATE when a PCC OperationRegion is torn down.

The PCC setup callback currently allocates a fresh pcc_data and requests
the mailbox channel before looking at the function argument. If ACPICA
deactivates a region, this can leave the existing region context and
mailbox channel unreleased, and may also request a channel during
teardown.

Handle ACPI_REGION_DEACTIVATE before allocation. Free the PCC mailbox
channel, release the region context and clear the context pointer.

Fixes: 77e2a04745ff ("ACPI: PCC: Implement OperationRegion handler for the PCC Type 3 subtype")
Reviewed-by: Huisong Li <lihuisong@huawei.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Link: https://patch.msgid.link/20260922144302.3847593-4-sudeep.holla@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pcc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/acpi_pcc.c b/drivers/acpi/acpi_pcc.c
index 9881c9ee293d1..57d13b25c1d6b 100644
--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -55,6 +55,19 @@ acpi_pcc_address_space_setup(acpi_handle region_handle, u32 function,
 	struct pcc_mbox_chan *pcc_chan;
 	acpi_status ret;
 
+	if (function == ACPI_REGION_DEACTIVATE) {
+		data = *region_context;
+		if (data) {
+			pcc_mbox_free_channel(data->pcc_chan);
+			kfree(data);
+			*region_context = NULL;
+		}
+		return AE_OK;
+	}
+
+	if (function != ACPI_REGION_ACTIVATE)
+		return AE_BAD_PARAMETER;
+
 	data = kzalloc_obj(*data);
 	if (!data)
 		return AE_NO_MEMORY;
-- 
2.53.0



