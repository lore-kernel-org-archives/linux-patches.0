Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8345B13E03A;
	Fri,  6 Dec 2024 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497513; cv=none; b=I2QUNEb+BQ7bl30nJqIKi4400ssDlCRO9c6FkpiwC4OIXb1W1yk4DZIODc8WKMR4sfydiWx7lPeE4qZ/d3GMULB5Pr2APnv3RjGiCDs9/vGXh46qqmHk85gGV1xRly3lCjUCxVTWRGrE2SWBNTQtldp/J6A+5M5TKP5yY2AVrOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497513; c=relaxed/simple;
	bh=pzttmzl3/l+t+t0XIPy5D/aHt0zEaSta8K9k2iCDwgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1RDN1GeKlBlj+AgiebT+cdapDtr9s1zTlNya47KTF2BHMihiam9DTKWC5g+HCDFVcBDob4VGnBV1ZQex5FdtNvNbgsrxNKwJ+M7Z29EpDknyVfwCSYjcp8IFPm8L0dIWb6EsB4JFRLm1EO9c68Abz+yI/MMa2sq8LsxDekDyS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RImQDIsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RImQDIsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0821C4CED1;
	Fri,  6 Dec 2024 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497513;
	bh=pzttmzl3/l+t+t0XIPy5D/aHt0zEaSta8K9k2iCDwgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RImQDIsw0UMm+R+Lz/F5zV7oLKzxAUIPl2wcROwR3Gm+wk+RaAPV7kbQUfVSuoHJu
	 1be288BBBTmqoD+cNwngkehZCqjX1t+W5LvqwdwkwvYxh/H+dkzkIP/9bkuSLj8UsC
	 WUyNInO/Bl6o6GWM9jfvT2+mVEaL6zibdFy8OJWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 311/676] x86/tdx: Rename tdx_parse_tdinfo() to tdx_setup()
Date: Fri,  6 Dec 2024 15:32:10 +0100
Message-ID: <20241206143705.487034116@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

[ Upstream commit b064043d9565786b385f85e6436ca5716bbd5552 ]

Rename tdx_parse_tdinfo() to tdx_setup() and move setting NOTIFY_ENABLES
there.

The function will be extended to adjust TD configuration.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/all/20241104103803.195705-3-kirill.shutemov%40linux.intel.com
Stable-dep-of: f65aa0ad79fc ("x86/tdx: Dynamically disable SEPT violations from causing #VEs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/tdx/tdx.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 0bb895344497e..de4ff833fcf00 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -169,7 +169,7 @@ static void __noreturn tdx_panic(const char *msg)
 		__tdx_hypercall(&args);
 }
 
-static void tdx_parse_tdinfo(u64 *cc_mask)
+static void tdx_setup(u64 *cc_mask)
 {
 	struct tdx_module_args args = {};
 	unsigned int gpa_width;
@@ -194,6 +194,9 @@ static void tdx_parse_tdinfo(u64 *cc_mask)
 	gpa_width = args.rcx & GENMASK(5, 0);
 	*cc_mask = BIT_ULL(gpa_width - 1);
 
+	/* Kernel does not use NOTIFY_ENABLES and does not need random #VEs */
+	tdg_vm_wr(TDCS_NOTIFY_ENABLES, 0, -1ULL);
+
 	/*
 	 * The kernel can not handle #VE's when accessing normal kernel
 	 * memory.  Ensure that no #VE will be delivered for accesses to
@@ -804,11 +807,11 @@ void __init tdx_early_init(void)
 	setup_force_cpu_cap(X86_FEATURE_TDX_GUEST);
 
 	cc_vendor = CC_VENDOR_INTEL;
-	tdx_parse_tdinfo(&cc_mask);
-	cc_set_mask(cc_mask);
 
-	/* Kernel does not use NOTIFY_ENABLES and does not need random #VEs */
-	tdg_vm_wr(TDCS_NOTIFY_ENABLES, 0, -1ULL);
+	/* Configure the TD */
+	tdx_setup(&cc_mask);
+
+	cc_set_mask(cc_mask);
 
 	/*
 	 * All bits above GPA width are reserved and kernel treats shared bit
-- 
2.43.0



