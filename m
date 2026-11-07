Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065530;
	b=h7IDMhR0A2WjKgMz5qTUY3k35JgflcFTa1VGg3U+E8xkl8/R3NcrZSFaNFFZUe5xgdUX
	 0a7PoVNDxW1cmEeZegRnTFSszns/Al78u+LYEMRqhZkpbBPL3uTyWtiSd+wW7VrdHNS/R
	 WbGWG0Ny91P3+O3pu4hVrsqbBhnJgpqBs49hxeBw5FYgfAb2W8Wmf7HymZjeQWkD+mYox
	 kGFYhZhZKJKwtTpFOYS60B6fRi0hzhHf1ciNiulPXwvOEH65i2+WyA8i/QwU10JYrD7aq
	 PVUN/hRRm8yPDyc34JpEEg16gtq67MYFIA8/zQZvWpSZS8SHpko7/Bs+Pwkl/Ep2o8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ScIKLNj+1qhr6VHagrLKDNKRLj4wTCh/Rb0t2vRMHYc=;
	b=LaJqNEv1BVCRCjJIbJjnPW8owCr9Dr4Arms6sqF8sgyJPHfktbzhMTFB5kqhEBmZQjXu
	 KCU4edPD3LGOTfIEKfuiG1yLI3xdoKpvZMp0Y43rsuDlwqUwGgQOnvYNsEIOTfzAue+jo
	 VPhoy3sjGkuIUnzfEXThPBLhPqJCem0IXBwI4rLUUepfP17z1D9G+h09HtBAkCcx3KMAc
	 KehxJeY8fAcgcx9+X+5vvYJhHHUKUGLE4QgJLOI2qhVGslXIyb5mv/576mqwdtBNjo5t6
	 5iKsjlPIQUPh9wxnq+QND8Y6KUcyY0E5jIxAoALLde5INoXUOMSVxdXfmNB+hNe3ucQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n4his9yT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC556606A32C;
	Sat,  7 Nov 2026 15:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n4his9yT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEB71F0089F;
	Sat,  7 Nov 2026 15:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065529;
	bh=ScIKLNj+1qhr6VHagrLKDNKRLj4wTCh/Rb0t2vRMHYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n4his9yTQvQKv3JeowRxXuLxX6P254Y/aIfYG9O1bggJUsUL92y7X1u8PKbFv38bu
	 Z1goc4uVVjmEmnyKyqGcgvz36YhAaZbPsOuEqKTEZ+fQFogWqkCEH5IlJD95WQ+TqG
	 ZaMPXOEshBCpK/JUwmzb80JtrdjrCOzESvbYcJq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1170/1257] LoongArch: Fix perf hardware breakpoint failure via installation
Date: Sat,  7 Nov 2026 08:57:46 -0500
Message-ID: <20261107135011.494558547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit f5c0f8427469e703465c719c4304ce91282a32eb ]

In hw_breakpoint_control(), the logic to enable CSR_PRMD_PWE (global
watchpoint enable) incorrectly relies on TIF_LOAD_WATCH. This thread
flag is only set during ptrace operations, meaning that the standard
hardware breakpoints created via perf_event_open() will never have
this flag set.

As a result, the CSR_PRMD_PWE switch is skipped, leaving the hardware
breakpoint completely inactive in perf usage.

Fix this by decoupling the CSR_PRMD_PWE from the ptrace specific flag
TIF_LOAD_WATCH, which ensures that CSR_PRMD_PWE is enabled whenever a
hardware breakpoint is installed.

Here is a user-space reproducer to demonstrate the issue:

(1) Test program (test_perf_install.c):

  #include <stdio.h>
  #include <unistd.h>
  #include <sys/syscall.h>
  #include <sys/ioctl.h>
  #include <linux/perf_event.h>
  #include <linux/hw_breakpoint.h>

  static int var = 0;

  int main(void)
  {
  	size_t count = 0;
  	struct perf_event_attr attr = {
  		.type = PERF_TYPE_BREAKPOINT,
  		.size = sizeof(attr),
  		.bp_type = HW_BREAKPOINT_W,
  		.bp_addr = (unsigned long)&var,
  		.bp_len = HW_BREAKPOINT_LEN_1,
  		.exclude_kernel = 1,
  	};

  	int fd = syscall(__NR_perf_event_open, &attr, 0, -1, -1, 0);
  	ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);

  	asm volatile("st.b %1, %0" : "=m"(var) : "r"(11) : "memory");

  	ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
  	read(fd, &count, sizeof(size_t));

  	printf("Watchpoint counts: expected = 1, actual = %zu\n", count);

  	close(fd);
  	return 0;
  }

(2) Test steps:

  $ gcc test_perf_install.c -o test_perf_install
  $ ./test_perf_install

(3) Test results:

Without this patch:

  Watchpoint counts: expected = 1, actual = 0

With this patch:

  Watchpoint counts: expected = 1, actual = 1

Cc: stable@vger.kernel.org
Fixes: 3892b11eac5a ("LoongArch: Check TIF_LOAD_WATCH to enable user space watchpoint")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/hw_breakpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/hw_breakpoint.c b/arch/loongarch/kernel/hw_breakpoint.c
index d009ed780cf02..1a05350159f7b 100644
--- a/arch/loongarch/kernel/hw_breakpoint.c
+++ b/arch/loongarch/kernel/hw_breakpoint.c
@@ -233,7 +233,7 @@ static int hw_breakpoint_control(struct perf_event *bp,
 		}
 		enable = csr_read64(LOONGARCH_CSR_CRMD);
 		csr_write64(CSR_CRMD_WE | enable, LOONGARCH_CSR_CRMD);
-		if (bp->hw.target && test_tsk_thread_flag(bp->hw.target, TIF_LOAD_WATCH))
+		if (bp->hw.target)
 			regs->csr_prmd |= CSR_PRMD_PWE;
 		break;
 	case HW_BREAKPOINT_UNINSTALL:
-- 
2.53.0



