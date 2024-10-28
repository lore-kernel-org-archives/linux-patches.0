Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13638837;
	Mon, 28 Oct 2024 06:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098392; cv=none; b=YPiZsPRrf2YKWPUBX906LYPdHZVlPmOieuTZe6goH36qn2KIPuWwL6JF1/KO6haNYXlb/IOi1nxRuhsSe/g/p2BmsOC2FeQLsmADsqO4jyuDH1QiSyHMjnSD5N4dQxbfe0RKGssWaBae340PcbhM7ffovUa7O8mu27cRqoAvl2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098392; c=relaxed/simple;
	bh=DcNAKwwCcrR7ZQ5uDjxD8QXJUhzki5cowCNSUuBsGec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9BIFLa/5KYlbYYIop5Lmi7KLRRJ/jbVeba3+HEFycvYMllQKbbUS676Pl414q/WHQsEsbABjn1472SQO2Xc9cHbr2cwFwlCPhO0IZtJtCeluQ5Pv3B+pgexrCCTkDMgg4QWSl7pDioFE/yDCSCQ5zBtofWMlQKBTOb9dn39GFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZR1Z+xG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZR1Z+xG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EADC4CEC3;
	Mon, 28 Oct 2024 06:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098392;
	bh=DcNAKwwCcrR7ZQ5uDjxD8QXJUhzki5cowCNSUuBsGec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZR1Z+xGz5+3MB6oDWoGcz+3dufynfa2Mmx7ZIY5Eho7csCFmoSbHCes75w5ejjR+
	 9bS7v4mdOa0EQgPqUp61jrijaghlIPh2ma3heSWbGSoAEXIZPAZOswOk9wfThJvTdp
	 P0yEh36+0wbsJpwM62HuUsytbAjs+tMU3HpzV2tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gong <richard.gong@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>
Subject: [PATCH 6.11 205/261] x86/amd_nb: Add new PCI ID for AMD family 1Ah model 20h
Date: Mon, 28 Oct 2024 07:25:47 +0100
Message-ID: <20241028062317.206068793@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Gong <richard.gong@amd.com>

commit f8bc84b6096f1ffa67252f0f88d86e77f6bbe348 upstream.

Add new PCI ID for Device 18h and Function 4.

Signed-off-by: Richard Gong <richard.gong@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Link: https://lore.kernel.org/r/20240913162903.649519-1-richard.gong@amd.com
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/amd_nb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -44,6 +44,7 @@
 #define PCI_DEVICE_ID_AMD_19H_M70H_DF_F4	0x14f4
 #define PCI_DEVICE_ID_AMD_19H_M78H_DF_F4	0x12fc
 #define PCI_DEVICE_ID_AMD_1AH_M00H_DF_F4	0x12c4
+#define PCI_DEVICE_ID_AMD_1AH_M20H_DF_F4	0x16fc
 #define PCI_DEVICE_ID_AMD_1AH_M60H_DF_F4	0x124c
 #define PCI_DEVICE_ID_AMD_1AH_M70H_DF_F4	0x12bc
 #define PCI_DEVICE_ID_AMD_MI200_DF_F4		0x14d4
@@ -127,6 +128,7 @@ static const struct pci_device_id amd_nb
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M78H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CNB17H_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M00H_DF_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M20H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M60H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M70H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_MI200_DF_F4) },


