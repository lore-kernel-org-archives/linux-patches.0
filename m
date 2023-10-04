Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586632134D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16N9McG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8A4C433C8;
	Wed,  4 Oct 2023 18:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444394;
	bh=ZW+gEKsriZZ7O4Dv/oaTMPOePvcylIhltJDIHoUgmAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16N9McG2yFXmPPSA4Zb2YUgWFzJ7TbC4WuoRFfzja36FpCkCzujDlq1CpmQIHKfep
	 RXvDdyPKe0XFvrvo/YZ0kMeI1BENMDOrtYR+VA3bOQpp4JkWmK7TECGFBUKEf6XmSy
	 Oy0Y7n/DuKDtdNCWp/OEyHaw27Zg4xuWOJ2ylAW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 234/321] LoongArch: Use _UL() and _ULL()
Date: Wed,  4 Oct 2023 19:56:19 +0200
Message-ID: <20231004175240.076166667@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3563b477ddfe057ff1ef63636cacf198130276cb ]

Use _UL() and _ULL() that are provided by const.h.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/addrspace.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/loongarch/include/asm/addrspace.h b/arch/loongarch/include/asm/addrspace.h
index 5c9c03bdf9156..b24437e28c6ed 100644
--- a/arch/loongarch/include/asm/addrspace.h
+++ b/arch/loongarch/include/asm/addrspace.h
@@ -19,7 +19,7 @@
  */
 #ifndef __ASSEMBLY__
 #ifndef PHYS_OFFSET
-#define PHYS_OFFSET	_AC(0, UL)
+#define PHYS_OFFSET	_UL(0)
 #endif
 extern unsigned long vm_map_base;
 #endif /* __ASSEMBLY__ */
@@ -43,7 +43,7 @@ extern unsigned long vm_map_base;
  * Memory above this physical address will be considered highmem.
  */
 #ifndef HIGHMEM_START
-#define HIGHMEM_START		(_AC(1, UL) << _AC(DMW_PABITS, UL))
+#define HIGHMEM_START		(_UL(1) << _UL(DMW_PABITS))
 #endif
 
 #define TO_PHYS(x)		(		((x) & TO_PHYS_MASK))
@@ -65,16 +65,16 @@ extern unsigned long vm_map_base;
 #define _ATYPE_
 #define _ATYPE32_
 #define _ATYPE64_
-#define _CONST64_(x)	x
 #else
 #define _ATYPE_		__PTRDIFF_TYPE__
 #define _ATYPE32_	int
 #define _ATYPE64_	__s64
+#endif
+
 #ifdef CONFIG_64BIT
-#define _CONST64_(x)	x ## UL
+#define _CONST64_(x)	_UL(x)
 #else
-#define _CONST64_(x)	x ## ULL
-#endif
+#define _CONST64_(x)	_ULL(x)
 #endif
 
 /*
-- 
2.40.1



