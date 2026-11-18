Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023715;
	b=Efit0Qsvx1E0GHLUQpytANPmTxpvs/vOZe10o36Pbd6BWB08vVYAcELC7s9uY2QvaS7Q
	 yZ+06IWscU0rJP+qpOCte7Nm+OZXk9tVe/OZaCnhnojqup7OKYJfs6b2AZooQ8GxZOb7Y
	 VjfBW4Ra9NVJFWn4GF7GxE3fG+8QZ43Hnf4exgZptLFCSQ9Cb3WrgJfCmVpiHjNQPwk43
	 aBnGcjx40vzAuBwyK/ycQP2g+cN43Edi1knDJqw9q+hQRqL4OekwCJqnE0qiLcIjeCyLB
	 umDJHxn2WuJY9QVBFnp1TGadWIQxNVH2soYx4OYygnk0PRcjfE/HLt8YXGo0ivCVziA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WFqA8UEqiPzJ3blgrCioUmM8yBSqF1b2Dt7c6SM/GVY=;
	b=tlqaGkC0M0+RXGF4AIpi4FKJ+2EN3JEnzhUuzJyj5ycBT1rfRyvQ8eJqb1zGAYx5IIw5
	 Lt8DcCJPmqe69NmwGen42jWJTLqvQvzgTt+Z11xQ+fNUcyl95vlXR1xNGtp8cu2KqjKx7
	 p4gaezpAvyoh+FXwFFzr5CKxl2EyBixh47V1X7bDvLxqsPExpKdrzsEyqyKrF9h1dYBWA
	 pCICJHGf6MMUOMM3FNTkzHBwgIknc85B0vN7oWANWYNqqCePztXlnjuRbbRQ06+OwJzlu
	 0DXjkK3aOEiFhfOupZY9XegC2tLQ1m9JuSKl+XWSZf4SJvwOSSYR6QI1WgIDsCM177Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQ2tkoLr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D70606A31C;
	Wed, 18 Nov 2026 17:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQ2tkoLr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2CE1F000C4;
	Wed, 18 Nov 2026 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023715;
	bh=WFqA8UEqiPzJ3blgrCioUmM8yBSqF1b2Dt7c6SM/GVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQ2tkoLrCHgRyQlS9vV8bDximWOsG7Uo81fUa2aafAHCefcUL2hDXI7HXzXihgA21
	 kNwzSIBrIsONyHHodslZfPF4+Qf9T6tu849pyIhjPsQI8P/F9J6hQKFaiNt8f2DGjw
	 qrYkfhV1/35mlPv3ae0YuZIVbY+4lEh3sowKFkoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0466/2151] ACPI: tables: handle failed initrd override mappings
Date: Wed, 18 Nov 2026 15:36:41 +0100
Message-ID: <20261118150138.992159808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Slavin Liu <bolin.liu@seu.edu.cn>

[ Upstream commit 047c834d939df75386cfc0603c7ddeaa23a349a4 ]

The runtime AML table-loading path can invoke initrd override after
permanent mappings are enabled. Mapping bookkeeping can then fail.

Return AE_NO_MEMORY in that case to prevent a NULL pointer dereference
when attempting to read the table length.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: b2a35003dfbc ("ACPI: Implement physical address table override")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
[ rjw: Added empty code line after conditional, changelog edits ]
Link: https://patch.msgid.link/20260913125123.109803-1-bolin.liu@seu.edu.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/tables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 57fc8bc56166b..cd467dc1c665d 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -559,6 +559,9 @@ acpi_table_initrd_override(struct acpi_table_header *existing_table,
 	while (table_offset + ACPI_HEADER_SIZE <= all_tables_size) {
 		table = acpi_os_map_memory(acpi_tables_addr + table_offset,
 					   ACPI_HEADER_SIZE);
+		if (!table)
+			return AE_NO_MEMORY;
+
 		if (table_offset + table->length > all_tables_size) {
 			acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
 			WARN_ON(1);
-- 
2.53.0



