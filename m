Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604953596E9;
	Wed,  3 Dec 2025 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778872; cv=none; b=jPmfspiLqI7A2eVYOrCd1A1kfl4t4DLO7ImRNdU1JirbKMKnoQh0jbgOQfgCznMFmC02UtaPRiKuQX1+kZWPgYQeA3SRThZi+Oast/d/QB2tq91DOWEZ/VOzVY8NHkjihGDn99PgDc2jn/irF/5CjEOfxqabsjdAgt52W030wqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778872; c=relaxed/simple;
	bh=5MNVrpJq7Cb5Hb/AACOgqJ05B2d7JkW5B4GnBs5i+XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHo5nx1ESMpoPASH875MhrxmQRc21Sd9kg8iF+kn+NTKvWi1uLIR3U9s5pp1CQqOdRU/LfUxpOcdZfdO+31vY3vAKUq+83ZkV/a1QxcGCAE4v+xgEwNGlwb21P+3rb0Zyyv58fOQLjPwBOChZpu3wIpQ7OI/kbvYuGLrSoSSKlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyGMCLZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyGMCLZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434DBC4CEF5;
	Wed,  3 Dec 2025 16:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778871;
	bh=5MNVrpJq7Cb5Hb/AACOgqJ05B2d7JkW5B4GnBs5i+XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyGMCLZEyVjQU1tUrdUSCYr3NVaMoNLY5dmAtBFmxdYplHRyCsjjIxRQnu28D5s6/
	 r4YtbA+pPQJipNEPa+d06oHc65wNOH9lo+iX977aznrYAUCwGwHXt1FIY4g99pZERm
	 n3tGW5Uu6Lhe4bAySQUxYfEngVYdAr74/ooxRQmA=
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
Subject: [PATCH 6.1 068/568] ACPI: PPTT: Remove acpi_find_cache_levels()
Date: Wed,  3 Dec 2025 16:21:10 +0100
Message-ID: <20251203152443.196963155@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

[ Upstream commit fa4d566a605bc4cf32d69f16ef8cf9696635f75a ]

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


