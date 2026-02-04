Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35812D6611;
	Wed,  4 Feb 2026 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219208; cv=none; b=si8kCGHaDV14G2erXJ6dYH/bmvRsCYu46pRWTWLNPsgoA8M33fkF6rMODBYUb2CAfVdC3pB1ZLU9uSl6zSTvBJGtZbFcfvosFAqy7mcInz4RSFv3dokULrUmJVsGCUhj0m92343oLvH/e1wlscdG19/CR1PDpRrocPLAPt/EUJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219208; c=relaxed/simple;
	bh=1HdbdOsyKfAuWCY2LF4DX7FyRoLTruJ192Xc+8CdgGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCjzdirM1BcQPU8ZcIl0VbYYI30VMYOOLKADPNnMhsFj3NcrliG78FEUji+S85ThF2mj2J1JHQRLG4jj55397lRM9Sn202jXUG6AuDk6vd7wVRoVaIORGsRfYSEVjGR4DR/dqwXCmgTeIRggo/P3SmnssEfYoQpEIZz0iiagdmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCunQM/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCunQM/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223C3C4CEF7;
	Wed,  4 Feb 2026 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219208;
	bh=1HdbdOsyKfAuWCY2LF4DX7FyRoLTruJ192Xc+8CdgGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCunQM/h5loGOE0765QBm5Mmi76y2OoZj58fRNwZ1subcZMG7fkQhcPi9QwMwjitw
	 mpo4GaDZ4bF4HszaOZXXKV01bfTdNvWVPY/JuxcC0NWMR5g67+sGCgDP6coHOXxEdB
	 Dn3cSF+FL99WEn2tBL/f8gz2NogfFn7nl1DQGH6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	"Guo Ren (Alibaba Damo Academy)" <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 065/122] riscv: compat: fix COMPAT_UTS_MACHINE definition
Date: Wed,  4 Feb 2026 15:40:47 +0100
Message-ID: <20260204143854.195929021@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


