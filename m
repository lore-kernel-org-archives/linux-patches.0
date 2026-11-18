Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055110;
	b=377efGpqS46BVpmV1iWeT5FPYTdhghXAYBb/7Dk21UH5nNaLQeXyP6uNe9oeE0DlGlel
	 608AOe6qX8758e+e39OYvUV4hpLkdS6+azS8jJ2jSjqykBlTGB6TEDizNPqhBuUVHBsjc
	 /pqUCuKKFbkRqQkA9S6UoAkRH7jA0LUWz4Pi+51PM0oBKs1KL+OeJtW3FsfxGWFjSo5Dr
	 6T7P2iC+f34F3cCgbKewPIeZgGjiyIwPC1GRBi0WzSYJQ2KLuXdq8OzUaPMGSi6dAHTkR
	 A8nPyLWZ5H+4l2YIlPJbOyBRsXaRuyxFu0vlGp47AiuZMvJIDLCxX/M6h2fXgqrSmhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XR6uNW7AHbfTt3T2yCgKn669nLat6yuDhxBuDeSvqWg=;
	b=eeKJvty5vlIXNH8bLIFNSfpPzgaZABa0KFZCSlrdvKB/dzedM0ZlZvzbObOHqKeIVfiv
	 VsYjaov9L1YU9o7diTjrr6pRAurqkjZ9hX2sP9HMlekIV0ZkXsLW3tdIEIbD9GacB3Ynx
	 x3lHM54W+ns6VPcBUKJReV7SQiUqQrMWCrKpjI3YRlBlADA6Vs7VZHl0KP1HRz2mNIyFe
	 sd9ttXi7f/wHou47r2IejJfM3IbiouDxroTI07w98S7I/Ecy7dS+ZfY8jpgZrK5ptet8r
	 g/AZZYlW9IktZUvbMb3EbW3U4/F/pUj4gRZ/8NRMb9c+kMUURWsnjmnbQJrRmp4Fjbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECui2lNP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B104606A320;
	Thu, 19 Nov 2026 02:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECui2lNP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22661F000C4;
	Thu, 19 Nov 2026 02:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055110;
	bh=XR6uNW7AHbfTt3T2yCgKn669nLat6yuDhxBuDeSvqWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECui2lNPJuqcYymKYuBt9W2ZTCqcT1HBuO2+yJ5DmT16KDx2yx/+Xv4CgqBbW3U0Y
	 lu1Zvjuid+jaPcy9NUKTF3l2XQbg0/HgoXycqjFuFHkVGZXXtch0N7m11wNv7W2A9l
	 cgfoKxH56NXmfbu0Wz9AwQJYcmEczQLBRodhrts8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1515/2214] ACPI: tables: handle failed initrd override mappings
Date: Wed, 18 Nov 2026 15:53:11 +0100
Message-ID: <20261118150112.641244796@linuxfoundation.org>
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
index 71419eb16e09f..cef62b6aa8284 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -651,6 +651,9 @@ acpi_table_initrd_override(struct acpi_table_header *existing_table,
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



