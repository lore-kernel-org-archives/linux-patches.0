Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063718;
	b=baMkSs82k85cclPPz5kOyv4CTHJLjeVHXODYzBnwxj8P6FVzjuaDCOmLQ+WPAMiBPuf/
	 vj5Ne/3QD3IepwgjJuPt+sC9w5l2nmVQ/QzSI1tE4rFfXaA+YZxqdyqcQ8GdAfw3WuxTQ
	 qdrk/GWWkIdUR0AHaH3EKPJWFLgVKfH2+rfOuVDgxiaAZQIEmRED9px6Em2EsD8mql/as
	 LikQi7jopaCgn+3eX3hiNAP8zXDcjY0csVzBH1gNoYhA0EOwrp5ZegQ0lP2sE9A8nfXXH
	 Y0Sp4gjiQdb1avN3bpLf+zLLPTqHxTb5CxAhlYzAR3YgMPpq9k2x5SESN5hwKNijyvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rUoozHSqT8KCkljhHqewdCrloWX2f0Oz1UmZv7pQhYU=;
	b=0XmYZHM9E/RKs3hpnnLzWSJIymlIKHW8A22h73htoioiBBYGjPxUpDdHtyD0y48R3pQl
	 nk5GdAToHvtH1DHVaHUfvxmxYaNS0ZUBaBoiQs/yNabqNnQRt5MVqyMPP7ETf6t7oCrup
	 OI/n4zEc6W/bLK39JncQtEmCsrCIfBT0nKOaNU6lm5qERTc6zsEJEpIuIez5eWMzXiPBD
	 jWm9MN1SGkAY647QPkPp/X17Ir/jwNxcIQwga1p3eYkD7MiUeJhsc3hGRuAXkE3KIqSab
	 6JI5pez/uAYtcEllq2EljsUuwjUXTsgf2wH4iKO72lxXY/ukcG3LBiPXKvhgbbEhb/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AcEOE0XB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C831F606D83F;
	Sat,  7 Nov 2026 15:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AcEOE0XB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779FB1F0089F;
	Sat,  7 Nov 2026 15:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063717;
	bh=rUoozHSqT8KCkljhHqewdCrloWX2f0Oz1UmZv7pQhYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AcEOE0XBIUNMk7kWU7qhL6eCcOVRPTTD8D3012FsHItr7P/L6rBu16X4vLybK/bEb
	 ShXN/cpP5qyHaOBwymGZF5UIJguzZ+oMnziub+ThQKloW50d3tCQQVe8xPH4Z5L0Ot
	 6hq8PIWMwWILcpiSyKSlqimuamrJi7w6WQVy5p1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiale Yao <yaojiale02@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 818/869] drm/amdkfd: validate SRAT subtables before parsing
Date: Sat,  7 Nov 2026 08:58:20 -0500
Message-ID: <20261107134920.728991707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index b0e87bdc29114..ee6c17e88976a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -2051,27 +2051,33 @@ static void kfd_find_numa_node_in_srat(struct kfd_node *kdev)
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
@@ -2079,6 +2085,9 @@ static void kfd_find_numa_node_in_srat(struct kfd_node *kdev)
 			break;
 		case ACPI_SRAT_TYPE_GENERIC_AFFINITY:
 			gpu = (struct acpi_srat_generic_affinity *)sub_header;
+			if (subtable_len < sizeof(*gpu))
+				goto invalid_srat;
+
 			bdf = *((u16 *)(&gpu->device_handle[0])) << 16 |
 					*((u16 *)(&gpu->device_handle[2]));
 			if (bdf == pci_id) {
@@ -2095,9 +2104,13 @@ static void kfd_find_numa_node_in_srat(struct kfd_node *kdev)
 
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



