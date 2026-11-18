Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029723;
	b=L7Mps07XZrWX5pG9RSU4oUF8cy6YplU7Z9mm7X9R4f912YJJOgi2JREO9K182S7qKVXi
	 Mu2gG6Yfy+lKRbhb/a/g+myz1WG/E7Ix7LSD4sOKD1H4X/AkLYkgqOG1l6U/7tLSjyAG0
	 DZ7eMAqXryyo8B/QECTecVNwPrufRVgyHvQGrO1f1bVTCI2igj133yE1VAShBXaA3KlhT
	 yo2UORUVUBYTZ2DuY4Xlv7g5wp3slz9G8y+U+wxoJ8SgoHcIdm7HoiP5w5c+bHPta9Y+Q
	 IJAmvJm3nlWJZq1x8TNwjWXH4GOByFA7GhIPRaKzKejVJ7txR01cd+3pqdGMORGvIUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029723;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HdZ+SCU/3TaVhq6s6Jvyv3bKySVd31ylOcXNdp43h8s=;
	b=jcvhGhyetCeLGOSXSfF2bTYT+U/GAWpdNW7czV9vXf3nwKI0c/V1626Xn6wzQtmPI+23
	 PuSUVoAZM6cSWuQnXPS8cbzt88CLjLTHkZFYq18IywCMzhN9HuXItPdq2T8rCooRmr8Jf
	 +sarlL91RwTeypoG1D3FxNALl2c+nxoRopGUUaFBmzD9OOzz/6Un/SYH3HXu1ZgEIcoJf
	 q7byEZqEZRr9i5ZhPwJ3ilEyIs6DZxEyQBH+jiVYhX4mq79lS2fwOSNXqbKElo4wr+l4/
	 J/dPOFeMjsF+/S8oeHWji34+wW9FEy9kvfA2asdYB339qH/OYd2Avu9dqaQTY3CqklQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JR+uc/ud";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF9F606A32A;
	Wed, 18 Nov 2026 19:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JR+uc/ud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CAE1F000C5;
	Wed, 18 Nov 2026 19:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029723;
	bh=HdZ+SCU/3TaVhq6s6Jvyv3bKySVd31ylOcXNdp43h8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JR+uc/udCRIJlV3fxUCyPhzesyqd8nfutxlAqLMhpgWr4hOvZ9mtSRykx7JCva4dm
	 mRU4XUl6JL5j14SmBVRLp1fDTsmLGP1yIEGZBvyxRb+6QAFslmH8VrTc3HMeR4to2D
	 Xe7Dj8BOJfUYv6n26S6F8UDuPWAkAr2yvfVjk2us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slavin Liu <bolin.liu@seu.edu.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0424/1756] ACPI: tables: handle failed initrd override mappings
Date: Wed, 18 Nov 2026 15:42:31 +0100
Message-ID: <20261118150025.640795429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 9e1b01c350702..75f570d66ece7 100644
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



