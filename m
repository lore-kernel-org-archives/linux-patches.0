Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622623;
	b=pApxTeR6tMAoV4WlLZZqkL6TZgWnFOABIHTJKAJSJAvGGAKuRx+dP/zWyTeFgCHXi5s0
	 g8+XbMCudlBLU+xz01+bTQGpP1k7eZu11a+mlVNQnJm16FtoEdunFlmOmkE9OTdFxaHMv
	 ARCSr3YlKpINcoUafRfK3xAhoIne24uAv93dwue8iIiUTYfQ8o2Yq8D3VPSeFmiMqbX2s
	 Hrf+N+TZ4fmm486eEDcYEzQg9lu6YeACt1XmWattHxbaNS3gekueSR4srWKprTqs/6MUC
	 Buw0P6nLCGJ1MpZwlEC0l+jWXlMyQzVxt2h/kp2lyoUf01bQtC2CAN3/weF0RF/dGWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lf9VL+YcGvmFumB+UCLZLP3s30if+2V+ixxBAjamHG8=;
	b=WBHqS77E9IDVCaNktApaSIMl1A2CRAYVdv/OeQe4SdPuPgbVtEQPoLhS+A68gC6nJCHO
	 LbM4N3JpaQkVZ8HCYo1CvPh3aykIcdHsJ7mdNSxO9AqzzIg6D/7gYdfA81QS+ys+WoFf7
	 urHGnzkxsVWfns4+9Sywv/bNKcXo48Z0fihqFhLYZ4ZEayNGS0RqlnOdt+ySp/K5gAFh0
	 5OYjBS2IUeczmLcN3jHBvISgRB8DNwwrkEp+qTEp2Wv97JZPyTqjKesQQGRP5dcCcpGBc
	 VmIsyQIdx0ch4OvLwRmaY/U4jXTNM6Ekr2dVUzDi/+WzzxMYfJH4znTWBlsBRw7BGbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEmp2yh4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3318606A31E;
	Wed, 25 Nov 2026 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEmp2yh4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F64C1F000D2;
	Wed, 25 Nov 2026 16:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622623;
	bh=Lf9VL+YcGvmFumB+UCLZLP3s30if+2V+ixxBAjamHG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEmp2yh4QVi+Cjz8Sppq6Ri1luLn1AUEDXi7ufSmUrM83Aa3bOwSfcfN+TMqQQ/2I
	 RTwclv2Sv1ttN+dr2RfeQlrNYvaabYE4sO3a3cX3I3yJvBiTZP0r11hQPWFMRlbdOP
	 9PN0JV+UnwiVfaKvzeAbkDsoxyrEuNORMM++gQzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 551/990] ACPI: PCC: Free channel on OpRegion deactivation
Date: Wed, 25 Nov 2026 15:31:58 +0100
Message-ID: <20261125143835.006887419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: kept the existing kzalloc(sizeof(*data), GFP_KERNEL) allocation line instead of upstream's kzalloc_obj(*data), which only affected the surrounding context. ]
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



