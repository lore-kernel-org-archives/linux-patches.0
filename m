Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAE8148315;
	Tue, 25 Jun 2024 09:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308268; cv=none; b=tx6tvyL31n7/9vW42z1mZ6sNb19LKx4w5VNtBzyXoYKw3LIXPJAYdvQuinPLNH1JyCF/iVL6Y3SHTBZb2AUgY5SvoLcHLGD4yOuo99CKKm52P1fC/fAsRva5ejWRpGttrhnoIQZezxnBt0f4aAskcHYUOp10rKfjncdiuDc++lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308268; c=relaxed/simple;
	bh=vaG1o4ljMqbp4VCUBSfvCjA2sv2ALjXRH+6FT9HUfiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF5ZbctXNqctgKqe+KIjnEPQJJPX50bZoLlVGq66hNCbeYhg/ifA6X8aZSUcPNzQ+fTgbPUCJxDMBXim8e7lz5OS9H9UViK65t23R927DyWtPbDjcZGGTuQQukMbw1FRB+NH3XvVq2UKHYIz/A9oPbV1ncsDVV0ThlsnImrfC3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COX4OcW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COX4OcW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65B7C32781;
	Tue, 25 Jun 2024 09:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308268;
	bh=vaG1o4ljMqbp4VCUBSfvCjA2sv2ALjXRH+6FT9HUfiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COX4OcW+FEZ09ReXYDzSkHbtT6E3Bjf+ISW8kAlGZjk8uVzYkvuaW7kFaylL0SK+W
	 8dgWOL4yWB99GzeAcp/hH9qiPxYrNq2TTd7wry4EZX7CR4FQJ02eYn5K/EnyWVUr48
	 BYu55k3PzQmMn+cQStMUeHgbcWO80kex6qqnvD/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiqi Liu <shiqiliu@hust.edu.cn>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 032/250] arm64/sysreg: Update PIE permission encodings
Date: Tue, 25 Jun 2024 11:29:50 +0200
Message-ID: <20240625085549.290588719@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiqi Liu <shiqiliu@hust.edu.cn>

[ Upstream commit 12d712dc8e4f1a30b18f8c3789adfbc07f5eb050 ]

Fix left shift overflow issue when the parameter idx is greater than or
equal to 8 in the calculation of perm in PIRx_ELx_PERM macro.

Fix this by modifying the encoding to use a long integer type.

Signed-off-by: Shiqi Liu <shiqiliu@hust.edu.cn>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20240421063328.29710-1-shiqiliu@hust.edu.cn
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/sysreg.h       | 24 ++++++++++++------------
 tools/arch/arm64/include/asm/sysreg.h | 24 ++++++++++++------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9e8999592f3af..af3b206fa4239 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1036,18 +1036,18 @@
  * Permission Indirection Extension (PIE) permission encodings.
  * Encodings with the _O suffix, have overlays applied (Permission Overlay Extension).
  */
-#define PIE_NONE_O	0x0
-#define PIE_R_O		0x1
-#define PIE_X_O		0x2
-#define PIE_RX_O	0x3
-#define PIE_RW_O	0x5
-#define PIE_RWnX_O	0x6
-#define PIE_RWX_O	0x7
-#define PIE_R		0x8
-#define PIE_GCS		0x9
-#define PIE_RX		0xa
-#define PIE_RW		0xc
-#define PIE_RWX		0xe
+#define PIE_NONE_O	UL(0x0)
+#define PIE_R_O		UL(0x1)
+#define PIE_X_O		UL(0x2)
+#define PIE_RX_O	UL(0x3)
+#define PIE_RW_O	UL(0x5)
+#define PIE_RWnX_O	UL(0x6)
+#define PIE_RWX_O	UL(0x7)
+#define PIE_R		UL(0x8)
+#define PIE_GCS		UL(0x9)
+#define PIE_RX		UL(0xa)
+#define PIE_RW		UL(0xc)
+#define PIE_RWX		UL(0xe)
 
 #define PIRx_ELx_PERM(idx, perm)	((perm) << ((idx) * 4))
 
diff --git a/tools/arch/arm64/include/asm/sysreg.h b/tools/arch/arm64/include/asm/sysreg.h
index ccc13e9913760..cd8420e8c3ad8 100644
--- a/tools/arch/arm64/include/asm/sysreg.h
+++ b/tools/arch/arm64/include/asm/sysreg.h
@@ -701,18 +701,18 @@
  * Permission Indirection Extension (PIE) permission encodings.
  * Encodings with the _O suffix, have overlays applied (Permission Overlay Extension).
  */
-#define PIE_NONE_O	0x0
-#define PIE_R_O		0x1
-#define PIE_X_O		0x2
-#define PIE_RX_O	0x3
-#define PIE_RW_O	0x5
-#define PIE_RWnX_O	0x6
-#define PIE_RWX_O	0x7
-#define PIE_R		0x8
-#define PIE_GCS		0x9
-#define PIE_RX		0xa
-#define PIE_RW		0xc
-#define PIE_RWX		0xe
+#define PIE_NONE_O	UL(0x0)
+#define PIE_R_O		UL(0x1)
+#define PIE_X_O		UL(0x2)
+#define PIE_RX_O	UL(0x3)
+#define PIE_RW_O	UL(0x5)
+#define PIE_RWnX_O	UL(0x6)
+#define PIE_RWX_O	UL(0x7)
+#define PIE_R		UL(0x8)
+#define PIE_GCS		UL(0x9)
+#define PIE_RX		UL(0xa)
+#define PIE_RW		UL(0xc)
+#define PIE_RWX		UL(0xe)
 
 #define PIRx_ELx_PERM(idx, perm)	((perm) << ((idx) * 4))
 
-- 
2.43.0



