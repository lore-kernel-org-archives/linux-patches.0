Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7011133CFD;
	Fri, 24 Nov 2023 18:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDL63n9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD7BC433C8;
	Fri, 24 Nov 2023 18:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851474;
	bh=p8+mJlk9586L2UxCJ/lrO9j22dSJrpHHb8KtFvjUQ6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDL63n9/BAWannGb2rr3WOQ2FQ8anxAkHE9B1+ltXWxrV+0W6eDQxuS696Ic1evcB
	 5J4S/DNarID4xB0jjWSCqXrLTjb5uQTqh9e2DuHKl5QtcSgE8iwrtxPe9qlOTxBE+a
	 2W7sTr2kek7ScROwrlXv5o41H6Vff4VcQmXrHelk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcaov@gmail.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.5 438/491] riscv: kprobes: allow writing to x0
Date: Fri, 24 Nov 2023 17:51:14 +0000
Message-ID: <20231124172037.769576013@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

From: Nam Cao <namcaov@gmail.com>

commit 8cb22bec142624d21bc85ff96b7bad10b6220e6a upstream.

Instructions can write to x0, so we should simulate these instructions
normally.

Currently, the kernel hangs if an instruction who writes to x0 is
simulated.

Fixes: c22b0bcb1dd0 ("riscv: Add kprobes supported")
Cc: stable@vger.kernel.org
Signed-off-by: Nam Cao <namcaov@gmail.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Acked-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20230829182500.61875-1-namcaov@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/probes/simulate-insn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/probes/simulate-insn.c
+++ b/arch/riscv/kernel/probes/simulate-insn.c
@@ -24,7 +24,7 @@ static inline bool rv_insn_reg_set_val(s
 				       unsigned long val)
 {
 	if (index == 0)
-		return false;
+		return true;
 	else if (index <= 31)
 		*((unsigned long *)regs + index) = val;
 	else


