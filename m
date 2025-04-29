Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82BF242D68;
	Tue, 29 Apr 2025 17:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948371; cv=none; b=hDic383QCthIyzujnDsrUFsxo6XOjf848QG9oKmi7+J4U4N0q3hsYferk4sYMaYinayV8z4qcohuy595Uw/vkP4chU9fFbrWXPh6thH7aJKk4Eghs6AFM7zU91AEjl2S7Ej2KFMe6uDdqDdVvVttq1UIEKuwZYgS1OG8fEnZAGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948371; c=relaxed/simple;
	bh=U2zG9EimSFUOxWp+zjcChNw9qhpGXk71bCA9qjzYTow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTtxJ5ziZcAIbeacV4FzPNE5HprTcfx6TU3h26t9FLmPKlUI+2IIV+tuR+LORkKCILps01wCX2kLSTiNlFPUx+3hWu8E9HaceAZdTNhQuIYCXgatw5+Uxh/rqzuaNeC9sqIsL5P+wHpapODRMQmXIaS32bHv48cq6oDyNOtbGYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INtd/vCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INtd/vCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1DFC4CEE3;
	Tue, 29 Apr 2025 17:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948371;
	bh=U2zG9EimSFUOxWp+zjcChNw9qhpGXk71bCA9qjzYTow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INtd/vCDntQvV8TtgG5kbM1RjosA26+DbxCB61jrqdYKpuSnTMf6WrSJc7oYx7zoA
	 AAcsHmO0C3yQDDHIJ8K8/0J1N8IJtpyX/AS5MH05l/KoqBYrdicsnTjZI/ozkvsgQT
	 I98Vhrg5qgvzCIfxOIZ037WHcywTs+QQs6gXprbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/280] riscv: Provide all alternative macros all the time
Date: Tue, 29 Apr 2025 18:42:59 +0200
Message-ID: <20250429161124.858942726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit fb53a9aa5f5b8bf302f3260a7f1f5a24345ce62a ]

We need to provide all six forms of the alternative macros
(ALTERNATIVE, ALTERNATIVE_2, _ALTERNATIVE_CFG, _ALTERNATIVE_CFG_2,
__ALTERNATIVE_CFG, __ALTERNATIVE_CFG_2) for all four cases derived
from the two ifdefs (RISCV_ALTERNATIVE, __ASSEMBLY__) in order to
ensure all configs can compile. Define this missing ones and ensure
all are defined to consume all parameters passed.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504130710.3IKz6Ibs-lkp@intel.com/
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20250414120947.135173-2-ajones@ventanamicro.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/alternative-macros.h | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/include/asm/alternative-macros.h b/arch/riscv/include/asm/alternative-macros.h
index 721ec275ce57e..231d777d936c2 100644
--- a/arch/riscv/include/asm/alternative-macros.h
+++ b/arch/riscv/include/asm/alternative-macros.h
@@ -115,24 +115,19 @@
 	\old_c
 .endm
 
-#define _ALTERNATIVE_CFG(old_c, ...)	\
-	ALTERNATIVE_CFG old_c
-
-#define _ALTERNATIVE_CFG_2(old_c, ...)	\
-	ALTERNATIVE_CFG old_c
+#define __ALTERNATIVE_CFG(old_c, ...)		ALTERNATIVE_CFG old_c
+#define __ALTERNATIVE_CFG_2(old_c, ...)		ALTERNATIVE_CFG old_c
 
 #else /* !__ASSEMBLY__ */
 
-#define __ALTERNATIVE_CFG(old_c)	\
-	old_c "\n"
+#define __ALTERNATIVE_CFG(old_c, ...)		old_c "\n"
+#define __ALTERNATIVE_CFG_2(old_c, ...)		old_c "\n"
 
-#define _ALTERNATIVE_CFG(old_c, ...)	\
-	__ALTERNATIVE_CFG(old_c)
+#endif /* __ASSEMBLY__ */
 
-#define _ALTERNATIVE_CFG_2(old_c, ...)	\
-	__ALTERNATIVE_CFG(old_c)
+#define _ALTERNATIVE_CFG(old_c, ...)		__ALTERNATIVE_CFG(old_c)
+#define _ALTERNATIVE_CFG_2(old_c, ...)		__ALTERNATIVE_CFG_2(old_c)
 
-#endif /* __ASSEMBLY__ */
 #endif /* CONFIG_RISCV_ALTERNATIVE */
 
 /*
-- 
2.39.5



