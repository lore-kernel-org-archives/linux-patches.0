Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625183;
	b=b7p0I1x+71UDfaAqx/HKVfk+FQ1Bny1N/IYuJTf7Z3djbz1WJ84NVZPbRknz8Gn/6iXv
	 yfdNriT1DP1YBoyfa7arDYhdadLmcbjB9Idm0BpjD927eqZnzPGQYDrQPtx/eYwxkHqId
	 S5G1DMlmyJUyNurROq6Oj8/UAMvqfmVFNAwPkoxBUBB2/62X1hWpXGpSZSimCMMfE7CPK
	 GBR3IYUHsqjAzRrnflgrRbC0MW9n3200pCkSdvmh3DAshs9jjdj3ikpyAb81vLUHFArs6
	 kX8N2pR/fyYoeM/5J30M+WD5FIzBr8vlCcnNrDiG/nB/SPo6OzrOVVd63N7M+0kDmSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T371u+AcX7s3PQR+Ou2IELdDmg/kEMfO1/VFnTk8pYU=;
	b=hmQ2T8KqjZF8PPfkppft/uA9Gy2iWIXkggXplUMPNGEXqpeni69ja3CkOKLuc5rEEyuf
	 9sldh0X5Og6xLT34qGCRlOclP764tUc4AxIH03lcr1joE0FC7aWGlr7wxxe4fz7Pcr0S1
	 tDZoflm4xdOC8VV1ehDcvioEZ+XTHWje6JfQnGJIiT6lqJ3fWXPRsMcPLjrJbXSQDrjH2
	 PCzqLhK5LHaX6BjSuHQf30T5MOvy2mX9gxT0i5dQykkN3zYRWrFcrDKOwHjPrJzDriLav
	 MR/gk5TKQmxaxUseVizY7GgTbbX+bdQKZEm1n/5jd7cP9dvKsIsY4BUtgqEhSJjoh1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yiaHV6Bs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED84606A31E;
	Wed, 25 Nov 2026 16:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yiaHV6Bs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C264E1F000C0;
	Wed, 25 Nov 2026 16:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625183;
	bh=T371u+AcX7s3PQR+Ou2IELdDmg/kEMfO1/VFnTk8pYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yiaHV6BsaVDf4YklnNgVEY2lVx581wLMUYp99Sbao5A7MnzEmJ+F3I5DFYfuLEar6
	 gPiigfxpuk5eXigE6kIkSh0s+7OCx+eL+7aaiZkIBYJkoXF0wS6NtShd97ubSzw5kL
	 gvJk4AP/eqKWaCAoTqMs18RJ6Xcn49O8NN9cEqLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 434/816] ACPI: PCC: Free channel on OpRegion deactivation
Date: Wed, 25 Nov 2026 15:33:02 +0100
Message-ID: <20261125143859.238341252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: kept the tree's existing kzalloc(sizeof(*data), GFP_KERNEL) allocation line instead of upstream's kzalloc_obj(*data) to resolve the context mismatch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pcc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/acpi_pcc.c b/drivers/acpi/acpi_pcc.c
index 683924a708ba0..04bb232603965 100644
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
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return AE_NO_MEMORY;
-- 
2.53.0



