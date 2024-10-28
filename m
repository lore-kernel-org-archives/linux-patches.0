Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD0E8837;
	Mon, 28 Oct 2024 06:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098390; cv=none; b=BP0u5qqMK1oAR/w197DK+94qa4ogwqbCD/9m+TfyOi2o8U+jBTGHT3SCITEeBGiaSbq+zJYbaCnM+KOmUHqgElEjUPqvI04ltWDuu12AsGA1faos/fInWqF03waJ5kZs8GS2eFgM47GHHH9dvOJ+x1PZ0wnKgIUisPu2ZvWIDVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098390; c=relaxed/simple;
	bh=XyR67GEnlWdhVWkjwNmOQFt8L4KAaOJ5lWsMc0jxICc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRxvz6APydmvW7LgSXUsBpx1PDrN3ddcgRCEDUtBFHld9c8/UuFKVDC3p3eY+L6t9kG3Sgl/Ml9A72PHOOOVelggTjb7MuwWmubXF8tN9RJXtceuj/g4SbpVD3FMRyOVX0++w5/oa5iIORvOR1DFzFeu68BhAt32CSDSbildT2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHl2tiRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHl2tiRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D047CC4CEC3;
	Mon, 28 Oct 2024 06:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098390;
	bh=XyR67GEnlWdhVWkjwNmOQFt8L4KAaOJ5lWsMc0jxICc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHl2tiRkDOX/coA0xt4lry/lS4z1jMBMmKeSTzuuG6YI4oBLaGla9y89NPN3hhysB
	 AgS4TEGTT2zwKQESmJTg8U1iJXSslWpAafMDyjZ8mlqDCasnON7FHvEV9o0drlRSWe
	 A5jxkvqcEOYoYVX0YQXADSSIujrlnShM8HN3GYMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gong <richard.gong@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>
Subject: [PATCH 6.11 204/261] x86/amd_nb: Add new PCI IDs for AMD family 1Ah model 60h-70h
Date: Mon, 28 Oct 2024 07:25:46 +0100
Message-ID: <20241028062317.179125352@linuxfoundation.org>
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

commit 0f70fdd42559b4eed8f74bf7389656a8ae3eb5c3 upstream.

Add new PCI IDs for Device 18h and Function 4 to enable the amd_atl driver
on those systems.

Signed-off-by: Richard Gong <richard.gong@amd.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Link: https://lore.kernel.org/all/20240819123041.915734-1-richard.gong@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/amd_nb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -44,6 +44,8 @@
 #define PCI_DEVICE_ID_AMD_19H_M70H_DF_F4	0x14f4
 #define PCI_DEVICE_ID_AMD_19H_M78H_DF_F4	0x12fc
 #define PCI_DEVICE_ID_AMD_1AH_M00H_DF_F4	0x12c4
+#define PCI_DEVICE_ID_AMD_1AH_M60H_DF_F4	0x124c
+#define PCI_DEVICE_ID_AMD_1AH_M70H_DF_F4	0x12bc
 #define PCI_DEVICE_ID_AMD_MI200_DF_F4		0x14d4
 #define PCI_DEVICE_ID_AMD_MI300_DF_F4		0x152c
 
@@ -125,6 +127,8 @@ static const struct pci_device_id amd_nb
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_19H_M78H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CNB17H_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M00H_DF_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M60H_DF_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_1AH_M70H_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_MI200_DF_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_MI300_DF_F4) },
 	{}


