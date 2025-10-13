Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66900224B05;
	Mon, 13 Oct 2025 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366885; cv=none; b=BrJkvi+b+B06JjQm0ykzuufXEUgIqZNUgmn2aSKDvtz3LM38prjsNTwhjJI2e0Uh9huzcP4MziSCrXIQiidqb2jZS2PkTuuWHLDZatGFgTAJ4BrTBcIh3vJPqrpOlC06Lb39ArZjVFSLplDigue3i3DtWLO5JWTF51/0Qjq6SsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366885; c=relaxed/simple;
	bh=BGzU7GM9774+Wia/6a3tRPX9cRylWw6mjjVIpoNg9vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SczZVq76DhpCLZoaawP+HPbYgISGN1MC5izA7GpAN56BW4k7ZZjIknXjxCzfuL1M6X3dwiHEDI0GhmyYHR/esWl/Xk+nVf3XcI5AwLxKmb1KN5Sxu8wCWz9FgKHCK+O/+GbMvx2MP4/D/eP83f4kysu3iu0EqsObkZmKfHROeZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsHgHnn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsHgHnn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB94C4CEE7;
	Mon, 13 Oct 2025 14:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366884;
	bh=BGzU7GM9774+Wia/6a3tRPX9cRylWw6mjjVIpoNg9vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsHgHnn+EcZBQemxf0b2AB9mpeh6S8WDnwzb7QIy7XX+XnoyU4G2o4tRQtosNtWRM
	 vSz1AUxJA4hYNsVoNTlbldXdatZpwjMPZbI0OZ8rfbwcZTTojpcIAI3jbx8MkDcLFx
	 X4XgIz7B3CgqvqfBC4oy/bqn73LUDIl8w4ZQJSOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 006/196] ACPI: PPTT: Remove acpi_find_cache_levels()
Date: Mon, 13 Oct 2025 16:42:59 +0200
Message-ID: <20251013144314.791422707@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Gondois <pierre.gondois@arm.com>

commit fa4d566a605bc4cf32d69f16ef8cf9696635f75a upstream.

acpi_find_cache_levels() is used at a single place and is short
enough to be merged into the calling function. The removal allows
an easier renaming of the calling function in the next patch.

Also reorder the local variables in the 'reversed Christmas tree'
order.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Acked-by: Rafael J. Wysocki  <rafael.j.wysocki@intel.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/r/20230104183033.755668-5-pierre.gondois@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/pptt.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/drivers/acpi/pptt.c
+++ b/drivers/acpi/pptt.c
@@ -286,19 +286,6 @@ static struct acpi_pptt_processor *acpi_
 	return NULL;
 }
 
-static int acpi_find_cache_levels(struct acpi_table_header *table_hdr,
-				  u32 acpi_cpu_id)
-{
-	int number_of_levels = 0;
-	struct acpi_pptt_processor *cpu;
-
-	cpu = acpi_find_processor_node(table_hdr, acpi_cpu_id);
-	if (cpu)
-		number_of_levels = acpi_count_levels(table_hdr, cpu);
-
-	return number_of_levels;
-}
-
 static u8 acpi_cache_type(enum cache_type type)
 {
 	switch (type) {
@@ -621,9 +608,10 @@ static int check_acpi_cpu_flag(unsigned
  */
 int acpi_find_last_cache_level(unsigned int cpu)
 {
-	u32 acpi_cpu_id;
+	struct acpi_pptt_processor *cpu_node;
 	struct acpi_table_header *table;
 	int number_of_levels = 0;
+	u32 acpi_cpu_id;
 
 	table = acpi_get_pptt();
 	if (!table)
@@ -632,7 +620,10 @@ int acpi_find_last_cache_level(unsigned
 	pr_debug("Cache Setup find last level CPU=%d\n", cpu);
 
 	acpi_cpu_id = get_acpi_id_for_cpu(cpu);
-	number_of_levels = acpi_find_cache_levels(table, acpi_cpu_id);
+	cpu_node = acpi_find_processor_node(table, acpi_cpu_id);
+	if (cpu_node)
+		number_of_levels = acpi_count_levels(table, cpu_node);
+
 	pr_debug("Cache Setup find last level level=%d\n", number_of_levels);
 
 	return number_of_levels;


