Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBF43C196E;
	Wed,  4 Feb 2026 15:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218081; cv=none; b=Fp3c96GikmoysQFp72QKPvp4lLAm0BVcu3D3NohS5HP5dUMaI8ltqk1wvi1jd15VSVlLc7FYJIaCyhhD809LAoPGMO/mA5c+gRWHAmWlUdYDuPoKauWnWOBz/nrKWj6JG1XJVesNnFPj9TSykQlliRJZ6S7mfXGHN5Pr/EFw4Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218081; c=relaxed/simple;
	bh=7O8fhQ6la0JGfPuCb9wdi/MxaoAQmx4GuW30WRkddRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cagWxKmJ3KHtCGQklDO9bvYCfpgX7dGsRL/NGWISoOO3hdIiqQVF7RYEENWUpQgSbUeuLmijvkTzshI5Dmm3xgM0zEz5T9bsaKYMlqpTsQIhkF4tkyQb+3CN+0FdiyRsx6eshFfiTzts6Ke3A0lOtnpOGepU1a0yj48aq/r+g/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqy6FVIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqy6FVIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EB8C4CEF7;
	Wed,  4 Feb 2026 15:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218081;
	bh=7O8fhQ6la0JGfPuCb9wdi/MxaoAQmx4GuW30WRkddRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqy6FVIYVgkmTyWVgmTifVSIwXwQiSxyXNTi6GPnxCprMIBgD46kA+hIlwdMEKoBg
	 zDq6PFt00o1h3uY8Pxf1DBvG7Aai8Ac9jd5+bnZQNzzdgaGbY01MuPV9qh8D/DKzgc
	 Jy0hhTYjuBz8kzZJIpFOhw3GmC+EVCLOkfK8DC0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	"Guo Ren (Alibaba Damo Academy)" <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.1 207/280] riscv: compat: fix COMPAT_UTS_MACHINE definition
Date: Wed,  4 Feb 2026 15:39:41 +0100
Message-ID: <20260204143917.050884305@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Gao <gaohan@iscas.ac.cn>

commit 0ea05c4f7527a98f5946f96c829733788934311d upstream.

The COMPAT_UTS_MACHINE for riscv was incorrectly defined as "riscv".
Change it to "riscv32" to reflect the correct 32-bit compat name.

Fixes: 06d0e3723647 ("riscv: compat: Add basic compat data type implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
Reviewed-by: Guo Ren (Alibaba Damo Academy) <guoren@kernel.org>
Link: https://patch.msgid.link/20260127190711.2264664-1-gaohan@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/compat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/compat.h
+++ b/arch/riscv/include/asm/compat.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_COMPAT_H
 #define __ASM_COMPAT_H
 
-#define COMPAT_UTS_MACHINE	"riscv\0\0"
+#define COMPAT_UTS_MACHINE	"riscv32\0\0"
 
 /*
  * Architecture specific compatibility types


