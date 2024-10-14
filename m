Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E6619E802;
	Mon, 14 Oct 2024 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917041; cv=none; b=YlvPO6r8goUTst2peblEdr+t7OuE0a8wIiZm2AVxPeLHrnHoPjrCB8EA2BDQGgcMu4LDj8M5bwx38umbYptWE8NktlAnXHgbd7FFLECFej5ji//VfmvZxjX+YO2e57naRRRDxDugfx56+aDC+JJILW5cRHv9uI8a9TMHzuxFfs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917041; c=relaxed/simple;
	bh=Hmf1XgAufj8EDCtFigHDKb3ZwUpmU+sZYVaOnav0lpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKCs0Cqtp4i96j44Ypj+KZjvhVJddsdR4humngrNU969UxZbqTJHakHy3k9m5YZPJBAbNLbhP+I0OyhaOO1RL091XvTnoS2QD0rXQLQajHsqNqCPNmFRipIJrbvZlS3oMx4DFEJFCzcjamN1kdxbczhM4RX8OF2K4+W8h7tI0v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4iecaYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4iecaYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680D7C4CEC3;
	Mon, 14 Oct 2024 14:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917040;
	bh=Hmf1XgAufj8EDCtFigHDKb3ZwUpmU+sZYVaOnav0lpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4iecaYA3kBeVMLkg6Zi1y4HBpxRSvg08xZaTH75+3O+QwlCQL9WD3LkIHdH+/HcK
	 AwaDaFdkUfFt/gIor8B6xqXb3EKQgTPaghmR/A7XtHlB8TSlIYV0VrxGbBw747oz1/
	 OgGcMo5ZyH6CU0Ckc3bdxchfdiyNlGbwpqOoDh0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/213] x86/amd_nb: Add new PCI IDs for AMD family 1Ah model 60h
Date: Mon, 14 Oct 2024 16:20:14 +0200
Message-ID: <20241014141047.183920626@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 59c34008d3bdeef4c8ebc0ed2426109b474334d4 ]

Add new PCI device IDs into the root IDs and miscellaneous IDs lists to
provide support for the latest generation of AMD 1Ah family 60h processor
models.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Link: https://lore.kernel.org/r/20240722092801.3480266-1-Shyam-sundar.S-k@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/amd_nb.c | 3 +++
 drivers/hwmon/k10temp.c  | 1 +
 include/linux/pci_ids.h  | 1 +
 3 files changed, 5 insertions(+)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 8a1a6faf29658..6dabb53f58a44 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -26,6 +26,7 @@
 #define PCI_DEVICE_ID_AMD_19H_M70H_ROOT		0x14e8
 #define PCI_DEVICE_ID_AMD_1AH_M00H_ROOT		0x153a
 #define PCI_DEVICE_ID_AMD_1AH_M20H_ROOT		0x1507
+#define PCI_DEVICE_ID_AMD_1AH_M60H_ROOT		0x1122
 #define PCI_DEVICE_ID_AMD_MI200_ROOT		0x14bb
 
 #define PCI_DEVICE_ID_AMD_17H_DF_F4		0x1464
@@ -61,6 +62,7 @@ static const struct pci_device_id amd_root_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M70H_ROOT) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M00H_ROOT) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M20H_ROOT) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M60H_ROOT) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_MI200_ROOT) },
 	{}
 };
@@ -92,6 +94,7 @@ static const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M78H_DF_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M00H_DF_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M20H_DF_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M60H_DF_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M70H_DF_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_MI200_DF_F3) },
 	{}
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index ae0f454c305d6..c906731c6c2d3 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -545,6 +545,7 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_19H_M78H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M00H_DF_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M20H_DF_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_1AH_M60H_DF_F3) },
 	{ PCI_VDEVICE(HYGON, PCI_DEVICE_ID_AMD_17H_DF_F3) },
 	{}
 };
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f195ebc3ecb57..3dce2be622e74 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -580,6 +580,7 @@
 #define PCI_DEVICE_ID_AMD_19H_M78H_DF_F3 0x12fb
 #define PCI_DEVICE_ID_AMD_1AH_M00H_DF_F3 0x12c3
 #define PCI_DEVICE_ID_AMD_1AH_M20H_DF_F3 0x16fb
+#define PCI_DEVICE_ID_AMD_1AH_M60H_DF_F3 0x124b
 #define PCI_DEVICE_ID_AMD_1AH_M70H_DF_F3 0x12bb
 #define PCI_DEVICE_ID_AMD_MI200_DF_F3	0x14d3
 #define PCI_DEVICE_ID_AMD_VANGOGH_USB	0x163a
-- 
2.43.0



