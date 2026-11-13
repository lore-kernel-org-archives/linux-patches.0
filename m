Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585847;
	b=T8C2pZFDotcCpqPKWR+S4o3kOhKcg7qADPSfdrrV5VtfcUL7kmckCV9JA4XQTvq1cZhP
	 xtjQift1Y3Az3TAOgx5QxQXDdtUg4blrXxJ0j53FufwYH1hL+zVIfI4y9uvA/GVvIsg3n
	 Dd3QVla6q8zFqcMFd8qxMAEGz9aIB5VeirnHeD1mUIlD5V1WrP+sez189AwjMx1ZzCMQq
	 g/maJJIN2PQDGig9v2Oosf0kTrTJWTYALftWyuX0zQR2sDclPWWTmiwYwqGj9Cot8phIY
	 4r4RJrCtcsWf6HR3d+KJ35vpqQrxusbML4kCuCnTRx4Kv9E63KoiLweg9fOV9tWnVZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MT9WIGt4XEAS7xeDWVF0QzHEi1jbcSbcli8DbInKUX0=;
	b=dArsdq0cQ6uRkA3VQrYC+BajbdjCjwX9Nd79CB809avj4c7IoClBtWg7z3ERUoIdP+a1
	 kgOyB7C4OSELHEyKzkw9qW/pVYb1u798onqfcJMP3URI6glIeNOPOfK0eV1jvOk8+UACF
	 oA8bcyCxADfvIBrSH/8nLi9pYX56CAOBck3ZilDaiLOHI6L0WI/3Hn8d7x6Dlz9Vly7H+
	 v89uSzAetFxgwHq+TR6BXshodJr+FWeSrnczAlf7LWZ+h0y7kYIVmBjnnv9mIyyGrxBeF
	 ZCrPcbxtgoVj9A2ViKeViO5eicE5tIceQkIw8dHSfXPCacVird8EPHbeUsv30eJe+Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JrG8NtNk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF460606BAB5;
	Fri, 13 Nov 2026 16:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JrG8NtNk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B43D1F000C4;
	Fri, 13 Nov 2026 16:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585847;
	bh=MT9WIGt4XEAS7xeDWVF0QzHEi1jbcSbcli8DbInKUX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrG8NtNk6+7UiGm55oE9Ee+XZ3MDyy0yDfehe1nlI02J7hfx2R82L34zDTUhr8zK9
	 FMeHZHXjOb8Sm7zkBpgKQbwwLM3Il2RGtw75zHwBiyP9ef8mxEpTwPUeKEjJZv1Edp
	 d/XDJxaQO9AGaUqREYhKwDdqcpqqGl/pvzGcD6Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akshay Jindal <Akshay.Jindal@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 425/507] iommu/amd: Skip non-IVMD entries when parsing IVRS memory definitions
Date: Fri, 13 Nov 2026 10:52:09 -0500
Message-ID: <20261113153811.160083893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Akshay Jindal <Akshay.Jindal@amd.com>

[ Upstream commit e62df37e0eff4d670e78bbd415be2c1675883c15 ]

init_memory_definitions() walks every top-level subtable including the
IVHD blocks (type 0x10/0x11/0x40) in the IVRS ACPI table. It interprets
each one as a 'struct ivmd_header', solely on m->flags, without first
checking that the subtable's type actually is one of the IVMD types
(ACPI_IVMD_TYPE, ACPI_IVMD_TYPE_ALL, ACPI_IVMD_TYPE_RANGE).

    if (m->flags & (IVMD_FLAG_UNITY_MAP | IVMD_FLAG_EXCL_RANGE))
            init_unity_map_range(m, table);

IVMD_FLAG_UNITY_MAP (0x01) occupies the same bit position as the IVHD
flags field's HtTunEn bit. Unlike real hardware, QEMU's AMD IOMMU
emulation sets HtTunEn unconditionally (flags=0xD1 for type 0x10,
0x11 for type 0x11), so every QEMU-emitted IVHD block is misidentified
as a unity-map/exclusion-range IVMD entry, which subsequently results
in the creation of a bogus pci segment. Eg:

    AMD-Vi: PCI segment : 0x4000, last bdf : 0x0000

Fix by checking the subtable's type before treating it as IVMD.

Fixes: be2a022c0dd0 ("x86, AMD IOMMU: add functions to parse IOMMU memory mapping requirements for devices")
Cc: stable@vger.kernel.org
Signed-off-by: Akshay Jindal <Akshay.Jindal@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 0506617b27c29..2632764197b04 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2708,6 +2708,15 @@ static int __init init_unity_map_range(struct ivmd_header *m,
 	return 0;
 }
 
+static bool ivrs_block_type_ivmd(u8 type)
+{
+	if (type == ACPI_IVMD_TYPE ||
+	    type == ACPI_IVMD_TYPE_ALL ||
+	    type == ACPI_IVMD_TYPE_RANGE)
+		return true;
+	return false;
+}
+
 /* iterates over all memory definitions we find in the ACPI table */
 static int __init init_memory_definitions(struct acpi_table_header *table)
 {
@@ -2719,10 +2728,11 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 
 	while (p < end) {
 		m = (struct ivmd_header *)p;
+		p += m->length;
+		if (!ivrs_block_type_ivmd(m->type))
+			continue;
 		if (m->flags & (IVMD_FLAG_UNITY_MAP | IVMD_FLAG_EXCL_RANGE))
 			init_unity_map_range(m, table);
-
-		p += m->length;
 	}
 
 	return 0;
-- 
2.53.0



