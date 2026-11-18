Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039929;
	b=xI5KpqFJCmIKwCk8OVsu+VBULEZc/buvsJAgPMOzkqXPrjj1YFT2BNv3DeoKRmgTw2R6
	 44Ne61+qv0dh5gAvkca5FpFiLOdS/SUw4SFvFCXGWiSbeZJbsWSuTneWtfGQe1Rrw7SGy
	 dCMCCUKmarZnaL6YR0Awi2IUlIuy+Hxqx3knYkAnInkNA9qvGnR7KcXFGj37iQHj18/EZ
	 loaoGWZ1EeDJYnfYy6VYYk9cCrEnzvkpjOassHF+CTAfoQMC5wbb4tFPcX+F1lHxOD9rr
	 7l8JYakZdQ6St2NejZFoLyNr9I9XdySRHiSD59kFmWzZQDHMD5nYlNr6rR5sHRCc7Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2fjGr4wQ6/pT94C4drx/O6sCIlTIehK+wf6Vk+zkWPc=;
	b=SQqAUvFwLO/PLl10tjynOWnds0EZ2PBzbtlBKp9DPP7438CBvdaABADMpJZDEL3J2ykV
	 oFc8YgeVLl1l/aOUGN2T+ezrY42N28UwPl2nM1+XvIowECEgCEwpkJ/PoZ10OTa6+VjtD
	 xYvsWlDoUey8cQg/MVACVStqK6jg2Eb7UQEzvcin5uPCqfWtLpLfn+UoAg7sX4sNf0nA4
	 TTx1Lo1ISFjAWsrvb+7EK1JeWEc5MPnPyOyAgthxluuoQInuSwjnqY0OyMKGeEIIFG8SL
	 eiw2sun9vLLe7Z8humJu659mj7rhBlSIygHE67HiuSGguriNe3IWyBAMXzRHa29udYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/URZgWd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98460606A325;
	Wed, 18 Nov 2026 22:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/URZgWd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99D81F000C4;
	Wed, 18 Nov 2026 22:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039929;
	bh=2fjGr4wQ6/pT94C4drx/O6sCIlTIehK+wf6Vk+zkWPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/URZgWdwrjgVCUTy5SnH6j5AXH6HBc3qjdgEyqrXfTc+YxJPSJ5els6zV3BYebLy
	 SV4nGdUHcB9DevsQA5gIv7fbSlyyuq1odX7VUXY5JwTYhxuGDQ+iqqX+G1+2N7xxez
	 yfQGiz01V+dm1Dja4GTjdD8i7oKUHQL73qI1ZBWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2234/3318] ACPI: tables: handle failed initrd override mappings
Date: Wed, 18 Nov 2026 15:47:36 +0100
Message-ID: <20261118150428.888124919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8ab0a82b4da41..029f3b2e3bebf 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -717,6 +717,9 @@ acpi_table_initrd_override(struct acpi_table_header *existing_table,
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



