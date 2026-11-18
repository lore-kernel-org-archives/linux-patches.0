Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046536;
	b=GmTJ+Y2dqtIC10+ks3PAWr3W2jaa55qvOdadwRklX5f60zRNbhdSSOPQytlK46LPnOEE
	 GlxgtI6sbhdEYBFu1D3WmQnfzNThfJb/nQ3tdvpnxktm8XzSRuiZqOiZJ+pPzpWpfPmdh
	 cKUS3ohK1O7v+HoLGIsQYNuDKpbvUoK743158vJh/Byx5wYCIFbra9HgR5Vvm/oswi7iH
	 rzRlLZu3kVwBDsXJkP3L0aabYutaCeCGiFakX5lNC+y81uYBGLRTBrOktiVc2+/QHPC4m
	 VmNp+DzM0D99zEzQDcv19GOXFjpXXP989oSUvZMXrp73YPrsap+vz4nMIxbTLydNSLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K2Lfta8/3weexPRbWhXpyVpfyQhY5jzZ0qH0W56qqmU=;
	b=l+P8IqgRJrMBsruQBteH4DGOFa5dEJoPI/iOtwFS8eMRIgUJNPm0fvuIR2cWIlV9NOtI
	 1AKzh+GzpE22f6YyrwQW93GLpUev9RHHLvPq+uz+pZt2BVXNNwx1T0iZyti0OnRQ6P9Wj
	 DFj2VnkTVhTBrCAKZURs7WsvVwU/3gbE5ltYIleJsoDQ7D+Q5wNW55OvtkNaK3jBdqSHe
	 IxBt6P+WEGh8B3NXcDNy+2ft6Stc/XPNREjRieR+br8t5KqvjDtFNj1Zhj/ICmVAh3jYi
	 YtL7Rpaakq5eI4N75RhFcdBb0dOoiGjbrrMPsC9TmA2pTMYF4b2VFmOM6v/hNttE3kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1n0TxpIs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E47606A334;
	Thu, 19 Nov 2026 00:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1n0TxpIs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCA01F000C4;
	Thu, 19 Nov 2026 00:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046536;
	bh=K2Lfta8/3weexPRbWhXpyVpfyQhY5jzZ0qH0W56qqmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1n0TxpIsUwhQBB7xf5g8nQvaTjs1dVCEuRrT0RHO0x2AP/vRLiM2yJVe9qKA1t05q
	 BpxvCykHbeg8Etrpb2eHEVAUDoxjR313HuM57yQy8/PQqogN8yy7V56J/9MoC+T46L
	 +YKu4zXrEU1yZvMre11Gvlk/+OHl/BkkEnQtBKz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akshay Jindal <Akshay.Jindal@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1316/2857] iommu/amd: Skip non-IVMD entries when parsing IVRS memory definitions
Date: Wed, 18 Nov 2026 15:39:10 +0100
Message-ID: <20261118150248.836023266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 22f596957146d..39d260ae6ff39 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2572,6 +2572,15 @@ static int __init init_unity_map_range(struct ivmd_header *m,
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
@@ -2583,10 +2592,11 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 
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



