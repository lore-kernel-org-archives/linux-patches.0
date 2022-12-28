Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D781863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC77C433D2;
	Wed, 28 Dec 2022 15:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241098;
	bh=JHJyKlY87Qy81zBY9v339lqbKvF9+rFMK2/AGZ6o9pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdZrOgqisxTWTvo4Y3pF0+Dd61fXtcdEIB/SVit1UdWitNrxKpC0mvO2Ok10xqQHb
	 csWZ/LGS4kP2BK6HOvY+othUhE2+m/ifFS7t7+sGg2KIpaJ5BIZ87SNOFBOElw1jue
	 5ZHd+ewooJCR1fEzpUP+uP5lyJoNZnxwNy9rdvr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/731] RISC-V: Align the shadow stack
Date: Wed, 28 Dec 2022 15:39:04 +0100
Message-Id: <20221228144309.227108726@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit b003b3b77d65133a0011ae3b7b255347438c12f6 ]

The standard RISC-V ABIs all require 16-byte stack alignment.  We're
only calling that one function on the shadow stack so I doubt it'd
result in a real issue, but might as well keep this lined up.

Fixes: 31da94c25aea ("riscv: add VMAP_STACK overflow detection")
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20221130023515.20217-1-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 2f4cd85fb651..4102c97309cc 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -211,7 +211,7 @@ static DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)],
  * shadow stack, handled_ kernel_ stack_ overflow(in kernel/entry.S) is used
  * to get per-cpu overflow stack(get_overflow_stack).
  */
-long shadow_stack[SHADOW_OVERFLOW_STACK_SIZE/sizeof(long)];
+long shadow_stack[SHADOW_OVERFLOW_STACK_SIZE/sizeof(long)] __aligned(16);
 asmlinkage unsigned long get_overflow_stack(void)
 {
 	return (unsigned long)this_cpu_ptr(overflow_stack) +
-- 
2.35.1



