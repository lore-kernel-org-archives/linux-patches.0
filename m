Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829569;
	b=Y/tmY6wvIfkGJzCnO1Vr3cNgvhd3CZso0biNnQvJBAZwQKjqbTEJo4YVD8U8dvXHWt/g
	 ATMz/7O/oTQK2t6SqcvojBwbmZ+72HOxTtlUhij1+zs1QM3L22TzEk4VCjPKMJBsKzz2V
	 GzktC/faDTqhLQsoq8NWAQQtDn3bbNE/DNckmTaPWDT31EB8plRJEjh+rcjAur2Hv7cqV
	 yS7WMqLOMxXstV/1DEm8F42La9GBFcWZOjmWPmn9OLGJi29C0hlK/NUZrmmHw4SqFr7ja
	 nou3/vLmffwJQdvJAC273tMFO3ReByinDaV3JkDyiLP+SASfkoREwRvjW8fNSyckzdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JsofAWaFv+fK/chHWN9sV669aiYXs7d6chyc7TNkD04=;
	b=kP1cAzlGGfS2E/W24P1nQMliZ0Cvpo1AYojZwHk3UypOYq0QrF4XQiWnwlrqopENfooB
	 gOhZ7648J/oegepoJALJ31LRmP7vOgV1ZWfQzhsOMeWfg3h8ifpKudfiVCdBNCB/Lzi+Y
	 m799kofRM05xj+yV9P3KMUDjNK0Cmepg8hs3vZ1jEVhDEjVzPmxG5MbAL2jjcr/MShMu+
	 yLpXPap8WAQAGT6RtPczrfCj6I2rDb5wPEMw42VeCo4xP3d3ocOelvhqgUzCM8Hz5wMv2
	 t/OQ+DHKwUaDZszx4pn/QTWkNqk2zQ3liUCKodwJ1Pz7PBKOmSO5e7Uu5Rt/D8iUrCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wM4u3Kt+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D15606A33E;
	Wed,  4 Nov 2026 21:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wM4u3Kt+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9081F000C1;
	Wed,  4 Nov 2026 21:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829569;
	bh=JsofAWaFv+fK/chHWN9sV669aiYXs7d6chyc7TNkD04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wM4u3Kt+2ON0v+4doKLP9CRM4LWFm/F6pEa1EYCCCnqYL498rn8g5upR8cNu8VnaU
	 fmu/QOJnxOSY65K1FqgYT3tr5PajbNBsuafcrtjNt7fIdiULqf+wQYMIcMpODrqvJc
	 kyqwqkFJWgS6aW1TGFDjPDvGCOWNsTJTF6+Go3dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0207/1005] ACPI: FPDT: validate table and record lengths
Date: Wed,  4 Nov 2026 15:59:00 -0500
Message-ID: <20261104211049.600322567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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



