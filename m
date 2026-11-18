Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060617;
	b=xcOmqWRtq4A4mKt4XxM4yxTBG5+sTralv1QSVhe9ctB2pffi6xrMe829qtyzB71Fasjy
	 h87Yq28cjYBGUzNhMAfOChze48tjGqyrOIaWZbRXzL7JvtyG++o/npaa/nWyXJLxhBOIh
	 Kg6FXHlMYO7mBITC9mz5CoJv68wlLUizJ98iP1c7YnaCTf3R4Lc6wyrtaN5vuIXb9G0Oq
	 9GtGZV+i+fihyjtRRl2LHFNkqrDeMjU2i9U19GUu/zx0nop7HQt7iF8+WMSTRICjeW/3w
	 e6Hebz9EfXDVU+W0GSvpR0lDPBilUUEAmEp4nfZklp2M21iPM7qhugQLabOUUNa1m9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rorQAEu0oPfuphsaILUcaC9c5S+qisDP7KIVlyXRZPk=;
	b=kOexPaPmicI9JG9pdNdnQDU9xBXVeC+ZEufjQHc8iDhAR9Nru6rzsbj5QbNZe133JOmv
	 iPAfDCTlNOeuKjvjd7p1CP2EzoiR43y50/t4Uz4Hxt5tS36MZOi5at/ugpukS1piMW3Kq
	 fD3z5rAjYbSQGhQXMFHK4Vk3Vb4c8+Bqz04Qf1cYHidb8rlui3M8mA93JWb1K+Ac1iZXd
	 hUp0mpqksP4/lz0qmrOkZKVmXmculfJ6BMUT0qOuwL90eFn+h09IHmnxpKvffuW/7YPmd
	 v8Tt3OXjMKUsw351iBlG79tvj3LuhHVVHQuwTm/6zqYDjCmkgAncRjUPcV6nqTh5aCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMe3+gJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CCC606A320;
	Thu, 19 Nov 2026 03:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMe3+gJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEBE1F000C4;
	Thu, 19 Nov 2026 03:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060617;
	bh=rorQAEu0oPfuphsaILUcaC9c5S+qisDP7KIVlyXRZPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMe3+gJF+Ttyg//ivQW0h8pu0Jqc+nuV7HkY0dWOYFRZ4+djYC8DqSklMnZdb+mSX
	 GA7UteMHMn80TNht1VqiAk2tOApB/Pq1ZYIiuzvjc4pw3pR3bopYSyLR5XXV+FWKZx
	 qdwicnbJHiQqDQAuiULH32PgSmLYBVr20b+9mTLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1263/1848] ACPI: tables: handle failed initrd override mappings
Date: Wed, 18 Nov 2026 15:55:01 +0100
Message-ID: <20261118150012.573976146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9d581045acff0..59e669ff81d43 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -640,6 +640,9 @@ acpi_table_initrd_override(struct acpi_table_header *existing_table,
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



