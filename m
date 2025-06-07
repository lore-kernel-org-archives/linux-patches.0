Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C66E15D1;
	Sat,  7 Jun 2025 10:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291061; cv=none; b=J1arItfMVxzqJ4d0TKSRBMKi5N+Jsv66TfieCavzd13WexoyU+spv2VjKvfc72CGLMs3u1Cp66u8EVBxQK+ZaeS1tBPAl9U+VWbzbnUDeT5oFVFvLJSC8oDB6Vu3mmircqjkOkCDbdmUQC4DKlcM8XZ2Kc6m1MtICNHRzEXpRZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291061; c=relaxed/simple;
	bh=Tj941XFhDqujdKHzHzwymLNSMmKOPKaHNTicg9MPF90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfDAqEf+yGSYYgK26SUIPNBvaR7q3f3G5JnK3PDxFqvabdCVWRkv+VYWudTeQsZrAK5lniMlargFhPCHxjWrTjMteGAv23GKg2pehl/eExIGrMisfZz3Ih0dOla5rtTX/5bqtykq9ksQ10HSnB85eGo+pX3+AKrCEXKIWLHcK9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUJGOkfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUJGOkfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0ECC4CEE4;
	Sat,  7 Jun 2025 10:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291060;
	bh=Tj941XFhDqujdKHzHzwymLNSMmKOPKaHNTicg9MPF90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUJGOkfvZMOAR2BvtnQ/iTD+57WMdmVrphUWSRB7xzyR3YAboFgTWp3YFJ2VhRjKq
	 HEbAcRefAL3GhQMnzyGS8yhXPtqfOwGkcmA0FAFs5erVEkq6CFJ1C6JcsE8+ISVdFq
	 +YcTe018LUPpM9RYg9LeuLJuVV32GBamiZYcf2es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Salem <x0rw3ll@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.15 05/34] ACPICA: Apply ACPI_NONSTRING in more places
Date: Sat,  7 Jun 2025 12:07:46 +0200
Message-ID: <20250607100719.931637473@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Salem <x0rw3ll@gmail.com>

commit 70662db73d5455ebc8a1da29973fa70237b18cd2 upstream.

ACPICA commit 1035a3d453f7dd49a235a59ee84ebda9d2d2f41b

Add ACPI_NONSTRING for destination char arrays without a terminating NUL
character. This is a follow-up to commit 35ad99236f3a ("ACPICA: Apply
ACPI_NONSTRING") where not all instances received the same treatment, in
preparation for replacing strncpy() calls with memcpy()

Link: https://github.com/acpica/acpica/commit/1035a3d4
Signed-off-by: Ahmed Salem <x0rw3ll@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3833065.MHq7AAxBmi@rjwysocki.net
Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/acdebug.h                            |    2 +-
 include/acpi/actbl.h                                     |    6 +++---
 tools/power/acpi/os_specific/service_layers/oslinuxtbl.c |    2 +-
 tools/power/acpi/tools/acpidump/apfiles.c                |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/acpi/acpica/acdebug.h
+++ b/drivers/acpi/acpica/acdebug.h
@@ -37,7 +37,7 @@ struct acpi_db_argument_info {
 struct acpi_db_execute_walk {
 	u32 count;
 	u32 max_count;
-	char name_seg[ACPI_NAMESEG_SIZE + 1];
+	char name_seg[ACPI_NAMESEG_SIZE + 1] ACPI_NONSTRING;
 };
 
 #define PARAM_LIST(pl)                  pl
--- a/include/acpi/actbl.h
+++ b/include/acpi/actbl.h
@@ -66,12 +66,12 @@
  ******************************************************************************/
 
 struct acpi_table_header {
-	char signature[ACPI_NAMESEG_SIZE] __nonstring;	/* ASCII table signature */
+	char signature[ACPI_NAMESEG_SIZE] ACPI_NONSTRING;	/* ASCII table signature */
 	u32 length;		/* Length of table in bytes, including this header */
 	u8 revision;		/* ACPI Specification minor version number */
 	u8 checksum;		/* To make sum of entire table == 0 */
-	char oem_id[ACPI_OEM_ID_SIZE];	/* ASCII OEM identification */
-	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE];	/* ASCII OEM table identification */
+	char oem_id[ACPI_OEM_ID_SIZE] ACPI_NONSTRING;	/* ASCII OEM identification */
+	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE] ACPI_NONSTRING;	/* ASCII OEM table identification */
 	u32 oem_revision;	/* OEM revision number */
 	char asl_compiler_id[ACPI_NAMESEG_SIZE];	/* ASCII ASL compiler vendor ID */
 	u32 asl_compiler_revision;	/* ASL compiler version */
--- a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
+++ b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
@@ -19,7 +19,7 @@ ACPI_MODULE_NAME("oslinuxtbl")
 typedef struct osl_table_info {
 	struct osl_table_info *next;
 	u32 instance;
-	char signature[ACPI_NAMESEG_SIZE];
+	char signature[ACPI_NAMESEG_SIZE] ACPI_NONSTRING;
 
 } osl_table_info;
 
--- a/tools/power/acpi/tools/acpidump/apfiles.c
+++ b/tools/power/acpi/tools/acpidump/apfiles.c
@@ -103,7 +103,7 @@ int ap_open_output_file(char *pathname)
 
 int ap_write_to_binary_file(struct acpi_table_header *table, u32 instance)
 {
-	char filename[ACPI_NAMESEG_SIZE + 16];
+	char filename[ACPI_NAMESEG_SIZE + 16] ACPI_NONSTRING;
 	char instance_str[16];
 	ACPI_FILE file;
 	acpi_size actual;


