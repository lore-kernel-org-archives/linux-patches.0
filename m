Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060812;
	b=wNBQ7/kLakcVB6QVvJKpWZzJVGoPwyzMDk3C86m9vnndDLclnXjlUj33bQGurlQwgq2J
	 aXjjyaudx/UYDPZf8tmcSjctdHRQusIcWb9Pjg16rOCu4DwPUkVO/iC4zSKC1ZPE2CLDR
	 9F3qz0at7LXqJQoQ0F9j6UiDpSmrq+3s7lAiTenyQgtdXWiK4doMz+9Se96Io0RdgcpIi
	 /Y/XV26SeLBwpvLlPs6RXr3VwR15NwUIWMkYOwdqtPy8kb8aTRzHVL50zbFzwx7gmmnpC
	 n13LGfGdi4tkQbFOlpS+DIOVkDzxdgFUtOIyLPMnVVAbZPCL9bbI/4oms3YtQC7SkJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PS9O2EyVqUqFBLdVlNnpKXrhb1u0Grs4vhPgz68QHlg=;
	b=r/svL7sfrLZgoVB33WYvCzm2Jn3cpdPHRO3QEEsW6474JURGnWn2ruuJT7umQhXMaNsq
	 DYHNMCMCLEWCk+u9/sasooqGzuIVsRMHuyTEbEod16iYB/3Rmkicc7/eczM2BRnhfRr64
	 ffCF0/9sBOr/CJVy1f+cXWd6NC4N2MWzCKjGgMFuO5AsSPXky4b7L84vrQ3RlraMFGxsg
	 1UG6zh9SMpqHDaGB9FAt4bVyhYa9fqKbJrejIOX+H+UGH2drfZ5J0B1l9iycFLdHgOlme
	 OHsoCjFl32UP+390JHgkWpWlf9+h+Fa85NO1LNEUOWPsr65IuV3uYEBGVvQd/iwSrkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g65E//Xp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56E7606A326;
	Sat,  7 Nov 2026 14:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g65E//Xp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908721F0089F;
	Sat,  7 Nov 2026 14:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060811;
	bh=PS9O2EyVqUqFBLdVlNnpKXrhb1u0Grs4vhPgz68QHlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g65E//XpbKjTQbhtC+Lv9Jy4E4piY9IZ3bJX46sNyqK1zHzuP1jrFwFPz95ItZ+5E
	 je5m31OSgCNBJ67ts0RjiVuf5CngKDPbMnXghV7rEZuhIBNIbm2+8A/XLv6KsNwK6s
	 gVfUwsYVtj/Kk9QeXv9bWDfx1ffB3r+6A6YPXPvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0171/1536] ACPI: FPDT: validate table and record lengths
Date: Sat,  7 Nov 2026 08:36:27 -0500
Message-ID: <20261107135002.464091954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



