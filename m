Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16C61A5B92;
	Mon, 18 Aug 2025 13:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525111; cv=none; b=NC9E0EXgIZKRDleIHlx8MHX2WdHHDN8M9oGohoqiWMijSmgZTqyat05+6Pm5Wge1bmyw1UoPwIEWkWs6P9QS4TSzb4woRa1sAR1RRHndIucf1KAT0g3lS/RFXoH1fV29hLVE+96gLB6Gh2uNSi1bwdGC/d6CaD0Vq12QyC3YFM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525111; c=relaxed/simple;
	bh=3OPRIrsP/0e16xIv6gDVxcSz+2PZsp4qQ1jU9MmavUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YM+8KNbVpaxymZti33IU1eYC9QCYwjsgFp2HgaaSvmhtahwEKZ5AfciR0L/iZEkQ84uUdCMp98V7IiFntZIBlNpFZ3ClRDCRefJluRUEsUcgjGGVa8Pv0uPJa9f8vIEItHdxrj1ZM2dDiRcCBL4A85QGG6EDjjqTn/Yme4klLzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JihSws2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JihSws2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E83C4CEF1;
	Mon, 18 Aug 2025 13:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525110;
	bh=3OPRIrsP/0e16xIv6gDVxcSz+2PZsp4qQ1jU9MmavUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JihSws2gp30G4Kspx32bBTGP2sJGfRhgDWQSbUWVmbl0idszKHGDkVBCA+MTOZQXx
	 do4D/apMgz9fYl9KLr2tB5DUUI8p9x0d0cjpAO+C9K3VnNQOl80Bkm8IzEk26qtqWH
	 wGEs4VNRSGbRs4PeO4CyvD7aPikOo4B4Um+aQYtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Qiyu <qiyuzhu2@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 160/570] ACPI: PRM: Reduce unnecessary printing to avoid user confusion
Date: Mon, 18 Aug 2025 14:42:27 +0200
Message-ID: <20250818124511.974094640@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Qiyu <qiyuzhu2@amd.com>

[ Upstream commit 3db5648c4d608b5483470efc1da9780b081242dd ]

Commit 088984c8d54c ("ACPI: PRM: Find EFI_MEMORY_RUNTIME block for PRM
handler and context") introduced non-essential printing "Failed to find
VA for GUID: xxxx, PA: 0x0" which may confuse users to think that
something wrong is going on while it is not the case.

According to the PRM Spec Section 4.1.2 [1], both static data buffer
address and ACPI parameter buffer address may be NULL if they are not
needed, so there is no need to print out the "Failed to find VA ... "
in those cases.

Link: https://uefi.org/sites/default/files/resources/Platform%20Runtime%20Mechanism%20-%20with%20legal%20notice.pdf # [1]
Signed-off-by: Zhu Qiyu <qiyuzhu2@amd.com>
Link: https://patch.msgid.link/20250704014104.82524-1-qiyuzhu2@amd.com
[ rjw: Edits in new comments, subject and changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/prmt.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/prmt.c b/drivers/acpi/prmt.c
index e549914a636c..be033bbb126a 100644
--- a/drivers/acpi/prmt.c
+++ b/drivers/acpi/prmt.c
@@ -85,8 +85,6 @@ static u64 efi_pa_va_lookup(efi_guid_t *guid, u64 pa)
 		}
 	}
 
-	pr_warn("Failed to find VA for GUID: %pUL, PA: 0x%llx", guid, pa);
-
 	return 0;
 }
 
@@ -154,13 +152,37 @@ acpi_parse_prmt(union acpi_subtable_headers *header, const unsigned long end)
 		guid_copy(&th->guid, (guid_t *)handler_info->handler_guid);
 		th->handler_addr =
 			(void *)efi_pa_va_lookup(&th->guid, handler_info->handler_address);
+		/*
+		 * Print a warning message if handler_addr is zero which is not expected to
+		 * ever happen.
+		 */
+		if (unlikely(!th->handler_addr))
+			pr_warn("Failed to find VA of handler for GUID: %pUL, PA: 0x%llx",
+				&th->guid, handler_info->handler_address);
 
 		th->static_data_buffer_addr =
 			efi_pa_va_lookup(&th->guid, handler_info->static_data_buffer_address);
+		/*
+		 * According to the PRM specification, static_data_buffer_address can be zero,
+		 * so avoid printing a warning message in that case.  Otherwise, if the
+		 * return value of efi_pa_va_lookup() is zero, print the message.
+		 */
+		if (unlikely(!th->static_data_buffer_addr && handler_info->static_data_buffer_address))
+			pr_warn("Failed to find VA of static data buffer for GUID: %pUL, PA: 0x%llx",
+				&th->guid, handler_info->static_data_buffer_address);
 
 		th->acpi_param_buffer_addr =
 			efi_pa_va_lookup(&th->guid, handler_info->acpi_param_buffer_address);
 
+		/*
+		 * According to the PRM specification, acpi_param_buffer_address can be zero,
+		 * so avoid printing a warning message in that case.  Otherwise, if the
+		 * return value of efi_pa_va_lookup() is zero, print the message.
+		 */
+		if (unlikely(!th->acpi_param_buffer_addr && handler_info->acpi_param_buffer_address))
+			pr_warn("Failed to find VA of acpi param buffer for GUID: %pUL, PA: 0x%llx",
+				&th->guid, handler_info->acpi_param_buffer_address);
+
 	} while (++cur_handler < tm->handler_count && (handler_info = get_next_handler(handler_info)));
 
 	return 0;
-- 
2.39.5



