Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048434;
	b=PUBArgzSw4w2icBW+QWh1zisHpqpV5lzro5ErRbHft6SFobyQKLRAD3fzD3QGEgzgKRI
	 /wJGLBvbwUf+bBXfKEnNRjWyj5+SD9Cxbmm3UVYIb6v2fCmZEPSMPTeOUcs7n6kjcbX86
	 oR0FCSqVkBclb3SHmq6rjrjMeI2+q88W7Jv2Cr22avlL8/XoeU33rsPiWewBltOGwarO2
	 67V72Qq7Ua5YEm+NC4xgKAIH0ZFTwR1EdUj0C2Qi43JEFWyNp7b2Le8Rhl4YQqYmv25q2
	 QXurs9sGSiufz1Vsin9kBZNGT2l8MPrFHUK2HXgT6Z4kttbkRDYe3/x/myE7Y9x4VgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N41C6DidQh3OxBo3jN8jHz4/191UQZtW+TuLLoBEtew=;
	b=a2c3Gjk+Ya0g7Z2H626jnkj7JD5ybIt+8JOldSIGdu9bv5iYiAh9GOMOIk92uayj5x3e
	 4vwk2bINOycDmR5TClIuE4T8ZcxrZcPrQex/MtTix4e9JESW42F15fKUcyfjDT/M2rrsB
	 tLUI2jpf6cNS0tQ1+IVOY9ukpwFmCLgehuhK79GiU1OhUO2NAkrUFNiKYmaJgHCkPOx0t
	 RrThjqdckbbfYQU59iy2NaDi12wYDk5LM6HXWsW/4/lizDam+vrAQKTCmxyoRQBd+lBO7
	 xaJ2rgqjtbpgILRwx5aY8Z/xwhscLzYDuEenH9e8bi28zx7nOuNxIpJMXBftfdd5QSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSvatvQ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E2E60A260C;
	Thu, 19 Nov 2026 00:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BSvatvQ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFE81F000C4;
	Thu, 19 Nov 2026 00:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048434;
	bh=N41C6DidQh3OxBo3jN8jHz4/191UQZtW+TuLLoBEtew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSvatvQ9vc6U2ApplSeaEpWvho6CQZl/4U9ZLs3mxbmnEkQyZ/QMy4eIToVuj90Js
	 R0txIE+WiEBQ+30ygFalxZescv3SG3zJsbYOujT1+rgFjJh1oPQkcqnPFRT4w6I8NV
	 L7rCwiqrMto4Tfdc9tlKxzVtrPpSIi7wBZ+cqX8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1952/2857] ACPI: tables: handle failed initrd override mappings
Date: Wed, 18 Nov 2026 15:49:46 +0100
Message-ID: <20261118150311.694330606@linuxfoundation.org>
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
index 47ec11d4c68ed..8d4377d82ace4 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -696,6 +696,9 @@ acpi_table_initrd_override(struct acpi_table_header *existing_table,
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



