Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016351;
	b=LXfGlIRk+2PWSdhCIQkufXa/jY05O3TUANkrRJhwE8tDWAtGk4iroaKfGqgBZ124/jGb
	 MdDIaZHNvYsVT3+BaXfmMtXjxJslb+DvgFsEYwqoqMQsIoiMBterD3bGEY4TjIb+q7/Q1
	 3gJuT8WI9LBRj1OIoHU5dyAvy0GAgkt3JXqdxeFwVEZaGBvBLHGdL+gUzpzjNy6q65+Yk
	 cJuYiFwSwC6u/DMyAzP7dqsB+zFlKk6MHCUNoQnLinGgepFzgerH8oF6iEYUQeS0KzP4a
	 u3FzMiXxX1d4EQ3XD/OkhsvliwyaCJNfmHZdqJAdxvuyvifB3biIILQGpRmROZAFEbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4HmKIMvgF48emDhsXYS1rMPRpyzxmE/75AARYN136uQ=;
	b=v2hgxaVi8pvwolkZGJC0YJoSNZNNKkTRlpkLxdzA1QzG84jZZhn7GMRgmpSPqSQ40vd1
	 fAxfVtfgInjaQ//tUUvBSE6R0sl5XHHBdxtTt5nmrIP8kv9RJNAYdKvcMJkqpeQbqa0bp
	 VFEDHTsr45AadhEPu002GqWMDLbPGbklLaZUsDsAT3z9IAaJzmA0N1jeqYc5PVwyXGnun
	 HUhEdlr45w/LSiq80c7FrG+FK53EOgbhu8T9HiHRV7PIb5CW09ZKJJhwvO87u5kVOrlTa
	 CIEoGmqAyzO5vW9SaQBJ90toXyc2CXunj/ngY9n+42J3tLB654vzx7/ja4J+1fnUzEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tB4FmlKI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0F4606A31C;
	Wed, 18 Nov 2026 15:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tB4FmlKI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC8A1F000C5;
	Wed, 18 Nov 2026 15:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016351;
	bh=4HmKIMvgF48emDhsXYS1rMPRpyzxmE/75AARYN136uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tB4FmlKIKPZDwC2O+2I/IORRhLMGAJfFpHahrLr717wZwcQwzmM5yIbra5gH4D41m
	 N4jU4XjqLtXQ7h7MSYPPMiY2ZqdPqL8GuANRQAaOoJBBqBX4qgCVMsxOgeOlKHiTv5
	 AoG7QrmKvqMmXn/kN0aaQjSf6cpryZiL7cYaAO3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0498/2651] ACPI: tables: handle failed initrd override mappings
Date: Wed, 18 Nov 2026 15:28:58 +0100
Message-ID: <20261118150305.695746914@linuxfoundation.org>
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
index eb93c060426ff..aaa1de79bccfd 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -560,6 +560,9 @@ acpi_table_initrd_override(struct acpi_table_header *existing_table,
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



