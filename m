Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E765242668F;
	Wed,  4 Feb 2026 15:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218418; cv=none; b=iNhgO8KGBw1DhHRB9wwcGi3yU+OUoOVC9VOyYmZf7Uinl6cP4kSt4UCD0xcLQbMC/dw4GC4TAUKJm70xkBgIvkJDA9QZpM86dwPVQJWQPAyYKx9RLjIVrfB6eiTK6M0TUTAceDKx+6FXKuyonD3D2yZobmH1kfJcyXnF7hmG9S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218418; c=relaxed/simple;
	bh=w00N7yddceT+HnmIqfjocLVaX8gAHasN6WWqInhqTpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PA4SFs0wgPGbe0Tl7VIGUP9teqrKgBT7za2T/wOPiusKvdueEboaYn+xlCfPOahLQBtFk0uIMhYaFeS/w2uY8om0vKgWSeQhUXDtt35qJ1OI5qFb0+fhlx53UlJHxXtjQCEk6NFKN4RRPL8m3jLliSN9fPXGBCSAYgSchqGCvrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riPTGu5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riPTGu5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01010C2BC86;
	Wed,  4 Feb 2026 15:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218417;
	bh=w00N7yddceT+HnmIqfjocLVaX8gAHasN6WWqInhqTpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=riPTGu5K96OftF0VjpjxcrFH5Q+mhLMljeA3ACCN0SFX/EIWCbyY4yc7ArGE+NcwP
	 qO/utL2Jjuqs7MuziY2T3ij3ZZyQXnHFtCd0eWMGKTaUkX3Ja3VEu7wcshsWvxUNzV
	 qqF/aiYOqc2ZcF6Ic0RHcv79CRhJndh+X68kNkiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	"Guo Ren (Alibaba Damo Academy)" <guoren@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.6 24/72] riscv: compat: fix COMPAT_UTS_MACHINE definition
Date: Wed,  4 Feb 2026 15:40:27 +0100
Message-ID: <20260204143846.500747095@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


