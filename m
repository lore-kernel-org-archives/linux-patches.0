Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051174;
	b=V138bUvdOiLfi2FZ2WPYLPbN412nI5o6wb0yE7PTXGDHMuBcQI4S5J203vhSBNEbqN+a
	 MOk/bEkxpVCP/HQ6Nq+621Vi2FJDst1MAng9QpLq4Du652VsrE9DsBPTaBOehSVWYxG6g
	 tBkyBenvU40XT49s1dyTkgXiVSZDirt8scSbcjSb4j8GkOVkloFwEujR5EvlyaFHtEXNQ
	 R2Eesvr9naw8r9dR6l7w43oiMe59/Ye4FRw6edmEdyLzUKPZiaXkuw7K9rutfSKOb/mir
	 ZuxqD5chncPgW+8hfAMdtq7nFRGEO0V5wpxQR3l8QaRAj85t2x1meCPJErfo3y+nutA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fFJLnTTwqOCjLJMIPXRzqQ9ZGsB8ulcnrM3ETCjRgt0=;
	b=bd2vTVyNUKtZRxcVEchstukbXo0fUo7fiYwxn21REB8YxzuU6p8CPkQHoYWLt1al6V7b
	 vb0CeoXejCRrg9AO5fyEgWRbhXxuZTsT/hzgF7hcKO2S6xlqjJ6w/Kt0zFdroeMi1Ppqe
	 m2p7mOEXCsWLVzHNrXatUy/aRuEvR2+UaTrGc89ArvUlMzDSiHt+muuM0dRkHaY9wbuvc
	 gpu9RWn1w/JwH7FNaH2XknwcRiBlmbPxdyWkvJS6vP5rndN8SHJ7O6fP6d/I6FAdoMXkk
	 SmHpDUjt+PHbSjnA2GQNvmUCYlzO3B5p0MT0BYXfxjSwkj3ltyJjNX/u9SG+fSBAkjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WWYON5Er;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4159E606A331;
	Thu, 19 Nov 2026 01:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WWYON5Er
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF9E1F000C5;
	Thu, 19 Nov 2026 01:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051174;
	bh=fFJLnTTwqOCjLJMIPXRzqQ9ZGsB8ulcnrM3ETCjRgt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWYON5ErxF3DJnd8ELPZhDv+U+A9sOj9qg/ZZ9S63134tOOPIpyzWn3pPvP+otdgh
	 xOzLz8pqjvR9Isf6fyDqHkF8ggurfAruDGzusHd16LoiFzYIIjHQVz2DttiL0Z/Ksw
	 GkiT/zPd6ZSRV1ayCOi1c4sEt38yAIoCKAB8bDBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0114/2214] ACPI: FPDT: validate table and record lengths
Date: Wed, 18 Nov 2026 15:29:50 +0100
Message-ID: <20261118150014.504300116@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 458b40fcdd04a9a0334830de5a536d8425454e4b ]

FPDT records are supplied by firmware and are walked through
length fields stored in the table itself.

Check the main-table entry length before reading an entry, check
the mapped subtable length before remapping it, and check each
record length before saving a typed record pointer for sysfs.

This keeps malformed firmware records from being interpreted as
complete resume, suspend, or boot records when the current item
is shorter than the structure consumed by the driver.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706094141.82438-1-pengpeng@iscas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_fpdt.c | 53 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_fpdt.c b/drivers/acpi/acpi_fpdt.c
index 271092f2700a1..058d1ad47699a 100644
--- a/drivers/acpi/acpi_fpdt.c
+++ b/drivers/acpi/acpi_fpdt.c
@@ -165,7 +165,7 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 	struct fpdt_subtable_header *subtable_header;
 	struct fpdt_record_header *record_header;
 	char *signature = (subtable_type == SUBTABLE_FBPT ? "FBPT" : "S3PT");
-	u32 length, offset;
+	u32 length, offset, remaining;
 	int result;
 
 	if (!fpdt_address_valid(address)) {
@@ -179,10 +179,17 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 
 	if (strncmp((char *)&subtable_header->signature, signature, 4)) {
 		pr_info(FW_BUG "subtable signature and type mismatch!\n");
+		acpi_os_unmap_memory(subtable_header, sizeof(*subtable_header));
 		return -EINVAL;
 	}
 
 	length = subtable_header->length;
+	if (length < sizeof(*subtable_header)) {
+		pr_err(FW_BUG "Invalid FPDT subtable length %u.\n", length);
+		acpi_os_unmap_memory(subtable_header, sizeof(*subtable_header));
+		return -EINVAL;
+	}
+
 	acpi_os_unmap_memory(subtable_header, sizeof(*subtable_header));
 
 	subtable_header = acpi_os_map_memory(address, length);
@@ -191,17 +198,29 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 
 	offset = sizeof(*subtable_header);
 	while (offset < length) {
-		record_header = (void *)subtable_header + offset;
-		offset += record_header->length;
+		remaining = length - offset;
+		if (remaining < sizeof(*record_header)) {
+			pr_err(FW_BUG "Truncated FPDT record header.\n");
+			result = -EINVAL;
+			goto err;
+		}
 
-		if (!record_header->length) {
-			pr_err(FW_BUG "Zero-length record found in FPTD.\n");
+		record_header = (void *)subtable_header + offset;
+		if (record_header->length < sizeof(*record_header) ||
+		    record_header->length > remaining) {
+			pr_err(FW_BUG "Invalid FPDT record length %u.\n",
+			       record_header->length);
 			result = -EINVAL;
 			goto err;
 		}
+		offset += record_header->length;
 
 		switch (record_header->type) {
 		case RECORD_S3_RESUME:
+			if (record_header->length < sizeof(*record_resume)) {
+				result = -EINVAL;
+				goto err;
+			}
 			if (subtable_type != SUBTABLE_S3PT) {
 				pr_err(FW_BUG "Invalid record %d for subtable %s\n",
 				     record_header->type, signature);
@@ -218,6 +237,10 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 				goto err;
 			break;
 		case RECORD_S3_SUSPEND:
+			if (record_header->length < sizeof(*record_suspend)) {
+				result = -EINVAL;
+				goto err;
+			}
 			if (subtable_type != SUBTABLE_S3PT) {
 				pr_err(FW_BUG "Invalid %d for subtable %s\n",
 				     record_header->type, signature);
@@ -233,6 +256,10 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 				goto err;
 			break;
 		case RECORD_BOOT:
+			if (record_header->length < sizeof(*record_boot)) {
+				result = -EINVAL;
+				goto err;
+			}
 			if (subtable_type != SUBTABLE_FBPT) {
 				pr_err(FW_BUG "Invalid %d for subtable %s\n",
 				     record_header->type, signature);
@@ -289,7 +316,21 @@ static int __init acpi_init_fpdt(void)
 	}
 
 	while (offset < header->length) {
+		if (header->length - offset < sizeof(*subtable)) {
+			pr_err(FW_BUG "Truncated FPDT subtable entry.\n");
+			result = -EINVAL;
+			goto err_subtable;
+		}
+
 		subtable = (void *)header + offset;
+		if (subtable->length < sizeof(*subtable) ||
+		    subtable->length > header->length - offset) {
+			pr_err(FW_BUG "Invalid FPDT subtable entry length %u.\n",
+			       subtable->length);
+			result = -EINVAL;
+			goto err_subtable;
+		}
+
 		switch (subtable->type) {
 		case SUBTABLE_FBPT:
 		case SUBTABLE_S3PT:
@@ -302,7 +343,7 @@ static int __init acpi_init_fpdt(void)
 			/* Other types are reserved in ACPI 6.4 spec. */
 			break;
 		}
-		offset += sizeof(*subtable);
+		offset += subtable->length;
 	}
 	return 0;
 err_subtable:
-- 
2.53.0



