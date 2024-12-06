Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D091474AF;
	Fri,  6 Dec 2024 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497496; cv=none; b=Wl+iciyHVzt6caJplB2JDDCtAfGjgIoPaFxqk4gRz5GY04OMOvCOkPevQRY0s8bARDG063Ei9j+sgtH/ofsgN4ZtnREZPbbKonNOKk7iMyA45t19yz55zoCCd5z6wgq2rKRMWvfP80y4U9IdUpF84zPTrN5QG5TdK5iMC8kU4sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497496; c=relaxed/simple;
	bh=CRDYoJwHHra7UhdgCVZtTJ+jJdEZi73GihkqY+IJc8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1A0EtMIg1GSnla0E/ppuqaQRhWanurgwIDF7BREiNhly16ix9LZCZFwf1V04nyh31zOQ//F7JTlCkojzPDCkkzm91JBcWpPALtVEKEgeiW3NF2BCJzhoh4/Zjidh9/fg2I/OMK0jj12iRboqsC2CF5hLDdnCrdhbl3FbURvBFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0JrHlN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0JrHlN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A6AC4CEDC;
	Fri,  6 Dec 2024 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497496;
	bh=CRDYoJwHHra7UhdgCVZtTJ+jJdEZi73GihkqY+IJc8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0JrHlN6+VppJENRalpKceBV0W0YBICXrV/njUGF6Q1zbVcDSK80Pns/Vg822Xt6K
	 lJ4JjGx36nAjFpQ0q/zfGu783BV24gwyIEawx9NKbS1Awf9NgTeUxbKY/CIRePI1cM
	 YFvLojbcSOZkTk6g0K3TEtOs7xIrzkJSn8i4tix4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 307/676] x86/tdx: Make macros of TDCALLs consistent with the spec
Date: Fri,  6 Dec 2024 15:32:06 +0100
Message-ID: <20241206143705.331505605@linuxfoundation.org>
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

From: Kai Huang <kai.huang@intel.com>

[ Upstream commit f0024dbfc48d8814d915eb5bd5253496b9b8a6df ]

The TDX spec names all TDCALLs with prefix "TDG".  Currently, the kernel
doesn't follow such convention for the macros of those TDCALLs but uses
prefix "TDX_" for all of them.  Although it's arguable whether the TDX
spec names those TDCALLs properly, it's better for the kernel to follow
the spec when naming those macros.

Change all macros of TDCALLs to make them consistent with the spec.  As
a bonus, they get distinguished easily from the host-side SEAMCALLs,
which all have prefix "TDH".

No functional change intended.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/all/516dccd0bd8fb9a0b6af30d25bb2d971aa03d598.1692096753.git.kai.huang%40intel.com
Stable-dep-of: f65aa0ad79fc ("x86/tdx: Dynamically disable SEPT violations from causing #VEs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/coco/tdx/tdx-shared.c    |  4 ++--
 arch/x86/coco/tdx/tdx.c           |  8 ++++----
 arch/x86/include/asm/shared/tdx.h | 10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx-shared.c b/arch/x86/coco/tdx/tdx-shared.c
index ef20ddc37b58a..f10cd3e4a04ed 100644
--- a/arch/x86/coco/tdx/tdx-shared.c
+++ b/arch/x86/coco/tdx/tdx-shared.c
@@ -35,7 +35,7 @@ static unsigned long try_accept_one(phys_addr_t start, unsigned long len,
 	}
 
 	tdcall_rcx = start | page_size;
-	if (__tdx_module_call(TDX_ACCEPT_PAGE, tdcall_rcx, 0, 0, 0, NULL))
+	if (__tdx_module_call(TDG_MEM_PAGE_ACCEPT, tdcall_rcx, 0, 0, 0, NULL))
 		return 0;
 
 	return accept_size;
@@ -45,7 +45,7 @@ bool tdx_accept_memory(phys_addr_t start, phys_addr_t end)
 {
 	/*
 	 * For shared->private conversion, accept the page using
-	 * TDX_ACCEPT_PAGE TDX module call.
+	 * TDG_MEM_PAGE_ACCEPT TDX module call.
 	 */
 	while (start < end) {
 		unsigned long len = end - start;
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 905ac8a3f7165..fd389b137fab8 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -93,7 +93,7 @@ int tdx_mcall_get_report0(u8 *reportdata, u8 *tdreport)
 {
 	u64 ret;
 
-	ret = __tdx_module_call(TDX_GET_REPORT, virt_to_phys(tdreport),
+	ret = __tdx_module_call(TDG_MR_REPORT, virt_to_phys(tdreport),
 				virt_to_phys(reportdata), TDREPORT_SUBTYPE_0,
 				0, NULL);
 	if (ret) {
@@ -154,7 +154,7 @@ static void tdx_parse_tdinfo(u64 *cc_mask)
 	 * Guest-Host-Communication Interface (GHCI), section 2.4.2 TDCALL
 	 * [TDG.VP.INFO].
 	 */
-	tdx_module_call(TDX_GET_INFO, 0, 0, 0, 0, &out);
+	tdx_module_call(TDG_VP_INFO, 0, 0, 0, 0, &out);
 
 	/*
 	 * The highest bit of a guest physical address is the "sharing" bit.
@@ -600,7 +600,7 @@ void tdx_get_ve_info(struct ve_info *ve)
 	 * Note, the TDX module treats virtual NMIs as inhibited if the #VE
 	 * valid flag is set. It means that NMI=>#VE will not result in a #DF.
 	 */
-	tdx_module_call(TDX_GET_VEINFO, 0, 0, 0, 0, &out);
+	tdx_module_call(TDG_VP_VEINFO_GET, 0, 0, 0, 0, &out);
 
 	/* Transfer the output parameters */
 	ve->exit_reason = out.rcx;
@@ -780,7 +780,7 @@ void __init tdx_early_init(void)
 	cc_set_mask(cc_mask);
 
 	/* Kernel does not use NOTIFY_ENABLES and does not need random #VEs */
-	tdx_module_call(TDX_WR, 0, TDCS_NOTIFY_ENABLES, 0, -1ULL, NULL);
+	tdx_module_call(TDG_VM_WR, 0, TDCS_NOTIFY_ENABLES, 0, -1ULL, NULL);
 
 	/*
 	 * All bits above GPA width are reserved and kernel treats shared bit
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 7513b3bb69b7e..78f109446da6f 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -11,11 +11,11 @@
 #define TDX_IDENT		"IntelTDX    "
 
 /* TDX module Call Leaf IDs */
-#define TDX_GET_INFO			1
-#define TDX_GET_VEINFO			3
-#define TDX_GET_REPORT			4
-#define TDX_ACCEPT_PAGE			6
-#define TDX_WR				8
+#define TDG_VP_INFO			1
+#define TDG_VP_VEINFO_GET		3
+#define TDG_MR_REPORT			4
+#define TDG_MEM_PAGE_ACCEPT		6
+#define TDG_VM_WR			8
 
 /* TDCS fields. To be used by TDG.VM.WR and TDG.VM.RD module calls */
 #define TDCS_NOTIFY_ENABLES		0x9100000000000010
-- 
2.43.0



