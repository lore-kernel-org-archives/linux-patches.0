Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A863879DC;
	Sat, 30 Dec 2023 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwLH8D72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5017C433C7;
	Sat, 30 Dec 2023 12:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938259;
	bh=lG3FKdWaDrDqT5IX39F1jX1TtnwNTNIdxxkpsttm4yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwLH8D72n7KNpUXGI1k/cm4jPS3s6rzgyt2I0vqA2RFycFrNwEwKnerieGFmvOeZ5
	 dhuxSTQjCTb4Ytym5S7EwzW4LSW6/YfPqXBoo+iMK5GUcwj3sWd+D71VXj2N8VIzJA
	 f3d1q2M2TPsBBmgh1VnX2X+95Fd4NUfx4gmjeY8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko.stuebner@vrull.eu>,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/112] RISC-V: Fix do_notify_resume / do_work_pending prototype
Date: Sat, 30 Dec 2023 12:00:01 +0000
Message-ID: <20231230115809.636708449@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko.stuebner@vrull.eu>

[ Upstream commit 285b6a18daf1358e70a4c842884d9ff2d2fe53e2 ]

Commit b0f4c74eadbf ("RISC-V: Fix unannoted hardirqs-on in return to
userspace slow-path") renamed the do_notify_resume function to
do_work_pending but did not change the prototype in signal.h
Do that now, as the original function does not exist anymore.

Fixes: b0f4c74eadbf ("RISC-V: Fix unannoted hardirqs-on in return to userspace slow-path")
Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230118142252.337103-1-heiko@sntech.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/signal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/signal.h b/arch/riscv/include/asm/signal.h
index 532c29ef03769..956ae0a01bad1 100644
--- a/arch/riscv/include/asm/signal.h
+++ b/arch/riscv/include/asm/signal.h
@@ -7,6 +7,6 @@
 #include <uapi/asm/ptrace.h>
 
 asmlinkage __visible
-void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags);
+void do_work_pending(struct pt_regs *regs, unsigned long thread_info_flags);
 
 #endif
-- 
2.43.0



