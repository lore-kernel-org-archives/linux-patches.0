Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD0840FD98;
	Wed,  4 Feb 2026 15:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218701; cv=none; b=mdhIlKsNITKU99ilNVIkz8rIH96oz/QW8/7p/BIOeQeEZDe1L0UApWza2WU6IRtZ6gDuzJb2ONo6RMunabXJbLuYcqaF4c0kw5OslPfukoKjIK9wlKRaVBrCRZVj/7rtGtua4Hm/9Lch8Ble40jg6552z1PmzXmWaf3tUY7/sRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218701; c=relaxed/simple;
	bh=pWjdrjUHSivLZm+HQiW2oM1oAGJlO//KI6ecpHF8doQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nF5ucly4nYH2d2nBovP2Ug4/2SyyRjChJB2ih0IZZ1oGpF5AKM3ZUIAjysODcJx9x8fZJo4wquln+enc24I2AywA3gmcU4wbuA1GtRtqWYvJ5L3pgUO/voougckckws0bKd9Iq4hT5jlA/wUeKqNBZDWYcE4z4zzmOkHXJ60+gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2o2hILtq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2o2hILtq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4C0C4CEF7;
	Wed,  4 Feb 2026 15:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218701;
	bh=pWjdrjUHSivLZm+HQiW2oM1oAGJlO//KI6ecpHF8doQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2o2hILtqPShySMU5l9eAe+NyY4icx2XjuyHee501vO9IQ3qWBgkRxZzboR0ReDiFD
	 CfGmYnOZYfvAeWXbAaq+ysXCm7BpT8JBl+UNyaHO7QS9aAoe+haIkBt7xD10irKbPX
	 ZmNwrcfaQRZDY3ac2YqlJIVuaHUqGg/NA9938B7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	"Guo Ren (Alibaba Damo Academy)" <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.12 35/87] riscv: compat: fix COMPAT_UTS_MACHINE definition
Date: Wed,  4 Feb 2026 15:40:33 +0100
Message-ID: <20260204143848.177407215@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


