Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065498;
	b=wMpU1fKQxuu3A4suK3Suhra4YAbPO0RaTOFicWPz7obIamr/yNH6Z6dMKwaQ6LmUgx1C
	 VPJdis+1aEtcNXM2yPl11pxu2BfezDTBEJITghYjRM5XBmLU2jjKivWj4IUoL+cr50sNL
	 TqGIsoN/1cl70U/9uRL/9TLESvhQNyBeZQsy9CIib3254aoLtEJcctG3iQHCiKWD0seqS
	 YCLrlLusiKLuM3EvAmiaWz/fDCaszfIx2lFNqRB40HmmBbC2CmBkn2VtpAD4RpgdxyBxf
	 Z8U0HHctPTxZVF5uNRGz051zJwohE0lH4sTN1M11zcs8yXwEOKr2Ji/FtXt8YvPC2Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2TRIaqwBbjbwvE9lrg4NRQvw2ox1SMkplE1ua6qSiH8=;
	b=MlRqQpFDNlET3qGVCzhgkCzxla2wiG5U2kMwiUiaT2kbJlPaUgIY3aNkRa7j7vYvTiUT
	 Gk3GwqKIwJUXAsujSQSPwgfLb6sTLwTyA+SelXn99xaIaK48wQ51LQWnT/BQrJxgraCSn
	 ZCeGuPTXhq75G+W6XDgF2BRdSfLyj32F0iStM1tcwy2LotJLrcVrewXMOWheGsUNQxNTw
	 /lU7GWNG97OqnNRR5AblFJqhU5rO2ue8oshTciiTdkfZcDSHxPK7D9LTBM5pmYBUkz00T
	 NXXmZ3k5kAA/YKfkqbtIw5rnItlU/OZEYZKrIDPre0gQUlnfZL7WFkbkBUL0czNukuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SH5UcOQH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A943606D804;
	Sat,  7 Nov 2026 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SH5UcOQH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999351F0089F;
	Sat,  7 Nov 2026 15:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065497;
	bh=2TRIaqwBbjbwvE9lrg4NRQvw2ox1SMkplE1ua6qSiH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SH5UcOQHAphkPGUEkTWH1nStbObwZxlLEowuoROVvZjdGlJn4DpKCT/qyjJT9MAwa
	 YLoC/9ohH0Oic3MXd3uNcGO9GiXZH6WmghN3y0Y4hLUzTWnmCTdoO111S5dgDBHLST
	 PTqGiWLgX7Lo0VvI5fJ+1fbL7dKtT0MwF1Y4bGi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiale Yao <yaojiale02@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1186/1257] drm/amdkfd: validate SRAT subtables before parsing
Date: Sat,  7 Nov 2026 08:58:02 -0500
Message-ID: <20261107135011.923764474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6e0df685503d0..32d7573dffc94 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -2056,27 +2056,33 @@ static void kfd_find_numa_node_in_srat(struct kfd_node *kdev)
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
@@ -2084,6 +2090,9 @@ static void kfd_find_numa_node_in_srat(struct kfd_node *kdev)
 			break;
 		case ACPI_SRAT_TYPE_GENERIC_AFFINITY:
 			gpu = (struct acpi_srat_generic_affinity *)sub_header;
+			if (subtable_len < sizeof(*gpu))
+				goto invalid_srat;
+
 			bdf = *((u16 *)(&gpu->device_handle[0])) << 16 |
 					*((u16 *)(&gpu->device_handle[2]));
 			if (bdf == pci_id) {
@@ -2100,9 +2109,13 @@ static void kfd_find_numa_node_in_srat(struct kfd_node *kdev)
 
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



