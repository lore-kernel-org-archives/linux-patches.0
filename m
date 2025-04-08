Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B184126A087;
	Tue,  8 Apr 2025 11:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111855; cv=none; b=oDbbzrFTF17bEODGshpOxtQwd/T28S1O12g/xJCtUBqJ9S8/Z6QdzSGkBkEfDRmx+0zm+WD/edyMxp8hh8O07nHbTk6KrgWSjyn70q8Hx0O2TdAOPkttr1KGKAdob+1gpiLJj+VQ3H1D4u3Mt3jxJ3Hn45qGd+2V+W7JEuWxPdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111855; c=relaxed/simple;
	bh=wJkuE2Z9ix5rp1Bdr6n4ztJU0zhT7Ix8octq+08gHMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UpUx9y8EESXzHCacm5FqRdLIkhb3fRHAZkAiehKv6tVhSC/CXt3DBPZP+A3lYjSgjzk9qMj7ynVxd1ih7g5UJhkAdOGyavK9zhz/6sGGBANfjCHqMt1K04WgUTXOKtsqNrSQ0dD9D0ca0AiXCFZmm2+i+VrQLc6uBjLltyu3EWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQcjHty6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQcjHty6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439C4C4CEE5;
	Tue,  8 Apr 2025 11:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111855;
	bh=wJkuE2Z9ix5rp1Bdr6n4ztJU0zhT7Ix8octq+08gHMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQcjHty6wg5NJ58kcgL0i4V2Jf73iWwbePlSRmFqapFfGdA6W629zatcGfzPRzPKG
	 jwYWRB5b3qFN1rQXEpu1pUwKSyPIr2BshU1sE0fyPxBb6/VvZtYQZo07HyKWT/kzFM
	 9rD5XcizlIfJzGLpigJ3aZh0D2E0FiTxbNdQHmKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 584/731] riscv: fgraph: Select HAVE_FUNCTION_GRAPH_TRACER depends on HAVE_DYNAMIC_FTRACE_WITH_ARGS
Date: Tue,  8 Apr 2025 12:48:01 +0200
Message-ID: <20250408104927.858067320@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit e8eb8e1bdae94b9e003f5909519fd311d0936890 ]

Currently, fgraph on riscv relies on the infrastructure of
DYNAMIC_FTRACE_WITH_ARGS. However, DYNAMIC_FTRACE_WITH_ARGS may be
turned off on riscv, which will cause the enabled fgraph to be abnormal.
Therefore, let's select HAVE_FUNCTION_GRAPH_TRACER depends on
HAVE_DYNAMIC_FTRACE_WITH_ARGS.

Fixes: a3ed4157b7d8 ("fgraph: Replace fgraph_ret_regs with ftrace_regs")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503160820.dvqMpH0g-lkp@intel.com/
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Björn Töpel <bjorn@rivosinc.com>
Link: https://lore.kernel.org/r/20250317031214.4138436-1-pulehui@huaweicloud.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 7612c52e9b1e3..5d63abc499ce7 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -149,7 +149,7 @@ config RISCV
 	select HAVE_DYNAMIC_FTRACE_WITH_ARGS if HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_GRAPH_FUNC
 	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
-	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_FUNCTION_GRAPH_TRACER if HAVE_DYNAMIC_FTRACE_WITH_ARGS
 	select HAVE_FUNCTION_GRAPH_FREGS
 	select HAVE_FUNCTION_TRACER if !XIP_KERNEL && !PREEMPTION
 	select HAVE_EBPF_JIT if MMU
-- 
2.39.5



