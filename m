Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F1372249;
	Mon, 29 Jan 2024 17:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548512; cv=none; b=JY9KV4aqKpwxNI0zPGqY5E5RQi0PxNWcnsVx2vDw+RVm0U27Xlp6RixlBGGLXXcmJ2T8JirikovF+3Kv2g/cz+nySFrxvHI2ObdUs6S0MsX3wfYdSU2bffYAcKWBp7fv8KZDB97ww+w0Dc9Gx4gEdMD8WY4Ev3amlkabDUftmCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548512; c=relaxed/simple;
	bh=LMpKGrGIYdUeBfHPqR+gYQOqXvkqN2SHX/DhY9fJBrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJh9IHhyoNNN/kw5saPLrhlsHzHJ+LBSn8muc1nFthEbcgs4MpsgknZBurQkdaMj8LD5W5tldOVqNoO/FsObT4f+ZylsqIiLQ7xAXq7sIpP3ZsfSARuBJNn3EglhgL/7SY0XDp6pOnRcBr6Oelp+x+G6dKmRa+/HXtlYV/Xmeqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6U3aii9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6U3aii9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A177C433B2;
	Mon, 29 Jan 2024 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548512;
	bh=LMpKGrGIYdUeBfHPqR+gYQOqXvkqN2SHX/DhY9fJBrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6U3aii9IbNlY9LT2gArXVOC7t2KQk0RZ9McDdz0jdjF9cTKMJ4OjsN1TuSGxu7m+
	 Hzl+Kz9OU7cW0jvV0/s0lD3PczOkVefAXXI0yrq93Ee579aITaJvkB2mpOdzypnwqN
	 /1+9lEN1MZETCHcgLgmmRFDjY4yn4Va14O3c0fjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Leonardo Bras <leobras@redhat.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.6 109/331] riscv: mm: Fixup compat arch_get_mmap_end
Date: Mon, 29 Jan 2024 09:02:53 -0800
Message-ID: <20240129170018.112564616@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Guo Ren <guoren@linux.alibaba.com>

commit 97b7ac69be2e5a683e898f5267f659fde52efdd5 upstream.

When the task is in COMPAT mode, the arch_get_mmap_end should be 2GB,
not TASK_SIZE_64. The TASK_SIZE has contained is_compat_mode()
detection, so change the definition of STACK_TOP_MAX to TASK_SIZE
directly.

Cc: stable@vger.kernel.org
Fixes: add2cc6b6515 ("RISC-V: mm: Restrict address space for sv39,sv48,sv57")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Leonardo Bras <leobras@redhat.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Link: https://lore.kernel.org/r/20231222115703.2404036-3-guoren@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/processor.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/processor.h
+++ b/arch/riscv/include/asm/processor.h
@@ -15,7 +15,7 @@
 
 #ifdef CONFIG_64BIT
 #define DEFAULT_MAP_WINDOW	(UL(1) << (MMAP_VA_BITS - 1))
-#define STACK_TOP_MAX		TASK_SIZE_64
+#define STACK_TOP_MAX		TASK_SIZE
 
 #define arch_get_mmap_end(addr, len, flags)			\
 ({								\


