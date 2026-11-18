Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037017;
	b=FsDwbZyfm+xMrLVwPgH82F7V0BRhwW5FBRCwZmYkUuSJ2krgWbVQoHdc2oBTz7I0Rhko
	 g3D5b5nCGo/dk118it51oYcIgaiY6AXqL733jO9H3ITNTNUVe8aXCXUIPBxNeqg5USaFz
	 IqjYYf4eROXIHUyUFA62jOZSiCXVmaCqLgLckwu9wtwNfIr1bQThuZN6zWkpmOSaZs2ex
	 Z2nkwblutLeLKOWCPNG6oggHpBayeqzuuWvsmpiADD4P38Ir5hRoVyg2IRu16xy2Slm+A
	 BauwTkzP59MO6FrGADYNMS2UJgGKossbSmtkpWQ9Sau/77oJqnx+C74lqCYbLclnkkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Iy9YWT5u5Og9B1Fjnr/BGGM+H6sQKKcGPpSl1QP93Mw=;
	b=AmiJXOT3d76LAtGyiOS/4MU4yjNJI0HRXooG+fdUij99A3lD7TENlAH8KMoRR7WnKM9o
	 4QGub9D3L2kzwICaxvtXMWga7bCgwmBLNpNKw/7j4tAeLVt7dDFv22u8sYcZAzU/lXYFS
	 N5qyqiEZFZnRyjQNIjQrfYKmuMfXdxVnF8DjsLk2i946j+XjrasD2Y00dutwvoMN37TzX
	 eCrsi5v0PF9M9B9YY1iTvN5xxBlQhv6whXDSLlO4vhFcuZtgVNe8d4p2eIa7ZSQjf7756
	 qoMOKYWNP6zPm77O41aQlubzcK2SgbuHvoX4yXZbGLylY0RXzCwCdmeM7lvqwUSzKYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AePwR/XA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6002B606A31C;
	Wed, 18 Nov 2026 21:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AePwR/XA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7768A1F000C6;
	Wed, 18 Nov 2026 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037017;
	bh=Iy9YWT5u5Og9B1Fjnr/BGGM+H6sQKKcGPpSl1QP93Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AePwR/XAL4Xj8JYf14ZlG9CJQ/RDMklO9mUn/JNpQU43rzCoYlh34E9d8JX3D4tx9
	 n7ppMzFDrMAvHSDzjhdcgIekKHOV6hZhsEANFcjbBBZ7aaWE5I9V+ed7KQwkjgR7vI
	 oGRJZGOu21YOlU6Eo2mKTFtVobBoMQvQ2zPFhbmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiale Yao <yaojiale02@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1264/3318] drm/amdkfd: validate SRAT subtables before parsing
Date: Wed, 18 Nov 2026 15:31:26 +0100
Message-ID: <20261118150358.138238042@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 9866cb13ba4d39aa8fed34b765d4aecabe04f02e ]

The KFD SRAT walker reads the first subtable length without checking
that a header is present and trusts subsequent lengths when accessing
CPU and generic affinity records. Invalid firmware lengths can therefore
cause out-of-bounds reads.

Validate the table header, every generic subtable range, and each
supported typed record before reading its fields.

Fixes: ddec8d3be0f8 ("drm/amdkfd: add ACPI SRAT parsing for topology")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d76b655c98e8cc9e791b31502ad274f47dee2aae)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 35 ++++++++++++++++++---------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index 2753e98dac2f8..e513127ae8a1a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1859,27 +1859,33 @@ static void kfd_find_numa_node_in_srat(struct kfd_node *kdev)
 		return;
 	}
 
+	if (table_header->length < sizeof(struct acpi_table_srat))
+		goto invalid_srat;
+
 	table_end = (unsigned long)table_header + table_header->length;
 
 	/* Parse all entries looking for a match. */
 	sub_header = (struct acpi_subtable_header *)
 			((unsigned long)table_header +
 			sizeof(struct acpi_table_srat));
-	subtable_len = sub_header->length;
 
-	while (((unsigned long)sub_header) + subtable_len  < table_end) {
-		/*
-		 * If length is 0, break from this loop to avoid
-		 * infinite loop.
-		 */
-		if (subtable_len == 0) {
-			pr_err("SRAT invalid zero length\n");
-			break;
-		}
+	while ((unsigned long)sub_header < table_end) {
+		unsigned long start = (unsigned long)sub_header;
+
+		if (table_end - start < sizeof(*sub_header))
+			goto invalid_srat;
+
+		subtable_len = sub_header->length;
+		if (subtable_len < sizeof(*sub_header) ||
+		    subtable_len > table_end - start)
+			goto invalid_srat;
 
 		switch (sub_header->type) {
 		case ACPI_SRAT_TYPE_CPU_AFFINITY:
 			cpu = (struct acpi_srat_cpu_affinity *)sub_header;
+			if (subtable_len < sizeof(*cpu))
+				goto invalid_srat;
+
 			pxm = *((u32 *)cpu->proximity_domain_hi) << 8 |
 					cpu->proximity_domain_lo;
 			if (pxm > max_pxm)
@@ -1887,6 +1893,9 @@ static void kfd_find_numa_node_in_srat(struct kfd_node *kdev)
 			break;
 		case ACPI_SRAT_TYPE_GENERIC_AFFINITY:
 			gpu = (struct acpi_srat_generic_affinity *)sub_header;
+			if (subtable_len < sizeof(*gpu))
+				goto invalid_srat;
+
 			bdf = *((u16 *)(&gpu->device_handle[0])) << 16 |
 					*((u16 *)(&gpu->device_handle[2]));
 			if (bdf == pci_id) {
@@ -1903,9 +1912,13 @@ static void kfd_find_numa_node_in_srat(struct kfd_node *kdev)
 
 		sub_header = (struct acpi_subtable_header *)
 				((unsigned long)sub_header + subtable_len);
-		subtable_len = sub_header->length;
 	}
 
+	goto out;
+
+invalid_srat:
+	pr_err("SRAT contains an invalid subtable\n");
+out:
 	acpi_put_table(table_header);
 
 	/* Workaround bad cpu-gpu binding case */
-- 
2.53.0



