Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064543;
	b=ma51ixDHKxpxsvQu22T6+ed0PsgweigiZrhOP0B/+lZn4Awv2HtRow9DJRxNE7ij4/iM
	 N4J5MrZkjR/OzcX5ltkbRtq3I3cS04/jxLfZDFux5x02yadPs8V8iZnxhfQt3yBmuExUx
	 cyAftjlhSKYkmwZP8i2KjvsTUZ7j+AtJvpQIFJSXRBMSH7CJ6MhT3sOzYUZdvHXGyLU8X
	 uhaGyrnQMbl+3Xfu3scMTDJld7L6lpf94FhJK/Rrs0ncxLkn+3N+q5m2f0V5Xi7jOG099
	 yV4Wt39dpDSWLdZP6A+mtWC4+tW1Hc/XKid9BVLoAqzyiHbSa7fqDDEtP2ODZRAPkRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3v3sS/jS56IbY8+sgAWg8MfGjRwIb3vde27/8Lw115g=;
	b=cw0bKjm/xDgXDi2TBdCBGh+m6k/G7pl5gGn0DnDlrYfQj5ixSuFsDS4N7X2EOpA0SUPu
	 JfMyhYGKyYs7X5wmZ01kO/caOv0YS3HltP0mbp3vlNc8blj3MW5X61ljlW+6vmypLyTUe
	 TIIrdNpwj8GgaRPHJRug7ZcEg0TmP9KeMNMhwDL2aC+PfckWdMC+I7nNdgGAMWNJZGM/h
	 bLQIqoUuIQZWialyCTdl+U8oxw/PLOcOo9z2mvv1nTTB9IvSRQzdvA10uzxOgWAVvc27J
	 IY+eTz/KmHj54qfeX5bM4W9RUKqADnJ/wgeM4anb5crzXDsyP6vu9f/Ih1ouwAHe4Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Zoj/5jev";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA970606CE69;
	Sat,  7 Nov 2026 15:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zoj/5jev
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E3B1F008A7;
	Sat,  7 Nov 2026 15:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064542;
	bh=3v3sS/jS56IbY8+sgAWg8MfGjRwIb3vde27/8Lw115g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zoj/5jevFBH1Ps5WjziR97rC4jnQWsA36InEGjcavWF5OEU3u9ktpRye0I7y/5s9I
	 MbpLMbWO8bTT+8rdIXmYg25acbFdzYTRdqj1VHUlNQOMEvqA7X2a0gBHXbkc2MLfFK
	 HUdVW+pb3NsH7F8hrdk9ad6iRQ8JebyWW+j6zDD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0569/1257] riscv: cfi: Only write envcfg CSR when task is current
Date: Sat,  7 Nov 2026 08:47:45 -0500
Message-ID: <20261107134955.073786100@linuxfoundation.org>
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

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit ca47e289113552fcbd7ab9268cee1f0c27d35590 ]

set_shstk_status() and set_indir_lp_status() take a task argument, which
lets them operate on tasks other than current, but they always write the
envcfg CSR for the current task. Fix this with the envcfg_update_bits()
helper, which only writes the envcfg CSR when operating on current.

Fixes: 61a0200211d31e ("riscv: Implement arch-agnostic shadow stack prctls")
Fixes: 8a9e22d2ca5855 ("riscv: Implement indirect branch tracking prctls")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://patch.msgid.link/20261007155748.291814-2-samuel.holland@sifive.com
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/usercfi.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 23c4d6d9d8cbc..86141e5bab822 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -15,6 +15,7 @@
 #include <linux/syscalls.h>
 #include <linux/prctl.h>
 #include <asm/csr.h>
+#include <asm/switch_to.h>
 #include <asm/usercfi.h>
 
 unsigned long riscv_nousercfi __read_mostly;
@@ -66,12 +67,7 @@ void set_shstk_status(struct task_struct *task, bool enable)
 
 	task->thread_info.user_cfi_state.ubcfi_en = enable ? 1 : 0;
 
-	if (enable)
-		task->thread.envcfg |= ENVCFG_SSE;
-	else
-		task->thread.envcfg &= ~ENVCFG_SSE;
-
-	csr_write(CSR_ENVCFG, task->thread.envcfg);
+	envcfg_update_bits(task, ENVCFG_SSE, enable ? ENVCFG_SSE : 0);
 }
 
 void set_shstk_lock(struct task_struct *task, bool lock)
@@ -96,12 +92,7 @@ void set_indir_lp_status(struct task_struct *task, bool enable)
 
 	task->thread_info.user_cfi_state.ufcfi_en = enable ? 1 : 0;
 
-	if (enable)
-		task->thread.envcfg |= ENVCFG_LPE;
-	else
-		task->thread.envcfg &= ~ENVCFG_LPE;
-
-	csr_write(CSR_ENVCFG, task->thread.envcfg);
+	envcfg_update_bits(task, ENVCFG_LPE, enable ? ENVCFG_LPE : 0);
 }
 
 void set_indir_lp_lock(struct task_struct *task, bool lock)
-- 
2.53.0



