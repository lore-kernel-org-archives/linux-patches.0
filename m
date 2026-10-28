Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213691;
	b=h6yUD2expfhou9GyHYaaVjGyQq/Xko5NI5PiTVaOdcBp/XczjkNsRKyv0Gh7iDEQecPX
	 1VObtm1limPpDO/9ugSreD0/NAcezZi33OX3jxsYsNZ4oi4lBebpmkUfFYjJGl6M9ZiJg
	 DmdDQhAC6OJypbudv5KzgDcTuMLUnplomJkOOYZ1x5HPKjhBi8DfNZ1TQjTmYLmk6igTZ
	 MoqDmijhtsFt89od6KAAERyO+eTPtEq7gnWLoTylAUnZkvJb1SOs3MZWF+HnT/MyKAp49
	 Mqml+gBV2niy1AHOAbYdGmaYDgQ7tVSq3EqJRW9y6DEq3L0SFqlEakU7r9A4HSlTT6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hdMajnidqrMOnxcseJxhii34ImD2odhFZHoBwnOcdRE=;
	b=U1TC4uwhCVU1L8m6ArpDl6LizIwZbcm8mAPdMToCLvPsRcBebHlDderHn+R8BoPCWxlp
	 IN9Bk6OJjvd1ToIFr3IgMVhn5hitD9k6jm+sNruLJpv9qJa6n3ui7m0+EqU5TJzHtimj5
	 P4mkPJh9E2N0oGfGNuQSnp1rjL1NObzNOdHyfgjbWriCZxszH1vj8KxXdAdBeTJiq10LR
	 wzECZNby/6OLX3QFB60H4O9NXir1iCPWM3Ow2PBG2dK016nfNlP7YHFeIW4UCbcjKvlgF
	 eAs740Q2ruGM2MuNnxTtOVRpojdKYDN6uHgxPrJYfTTMsoEueCUDwn6qc+rmi7NFJSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxH0UHV2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCE0606A327;
	Wed, 28 Oct 2026 18:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxH0UHV2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2839A1F01825;
	Wed, 28 Oct 2026 18:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213690;
	bh=hdMajnidqrMOnxcseJxhii34ImD2odhFZHoBwnOcdRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxH0UHV2yhNYo3AopnT/WJkdh5dzjqcvr9XGoHoBUP1YhyveU6C0Yp3wE4IAwomOc
	 UVMRmrNXEOYzz0RCrour3wWnnR9cWwDywUCvn6BTnWc2+MPdGpDIR0grYTRL+Bc3ZI
	 TWrY4AmQ28Ht7C4coyCQSg/w+2skDnOH7Yqp4+mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Atish Patra <atishp@rivosinc.com>,
	Fei Wu <fei2.wu@intel.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0595/1887] perf: RISCV: Fix panic on pmu overflow handler
Date: Wed, 28 Oct 2026 17:44:51 +0100
Message-ID: <20261028170512.957560866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Wu <fei2.wu@intel.com>

[ Upstream commit 34b567868777e9fd39ec5333969728a7f0cf179c ]

(1 << idx) of int is not desired when setting bits in unsigned long
overflowed_ctrs, use BIT() instead. This panic happens when running
'perf record -e branches' on sophgo sg2042.

[  273.311852] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098
[  273.320851] Oops [#1]
[  273.323179] Modules linked in:
[  273.326303] CPU: 0 PID: 1475 Comm: perf Not tainted 6.6.0-rc3+ #9
[  273.332521] Hardware name: Sophgo Mango (DT)
[  273.336878] epc : riscv_pmu_ctr_get_width_mask+0x8/0x62
[  273.342291]  ra : pmu_sbi_ovf_handler+0x2e0/0x34e
[  273.347091] epc : ffffffff80aecd98 ra : ffffffff80aee056 sp : fffffff6e36928b0
[  273.354454]  gp : ffffffff821f82d0 tp : ffffffd90c353200 t0 : 0000002ade4f9978
[  273.361815]  t1 : 0000000000504d55 t2 : ffffffff8016cd8c s0 : fffffff6e3692a70
[  273.369180]  s1 : 0000000000000020 a0 : 0000000000000000 a1 : 00001a8e81800000
[  273.376540]  a2 : 0000003c00070198 a3 : 0000003c00db75a4 a4 : 0000000000000015
[  273.383901]  a5 : ffffffd7ff8804b0 a6 : 0000000000000015 a7 : 000000000000002a
[  273.391327]  s2 : 000000000000ffff s3 : 0000000000000000 s4 : ffffffd7ff8803b0
[  273.398773]  s5 : 0000000000504d55 s6 : ffffffd905069800 s7 : ffffffff821fe210
[  273.406139]  s8 : 000000007fffffff s9 : ffffffd7ff8803b0 s10: ffffffd903f29098
[  273.413660]  s11: 0000000080000000 t3 : 0000000000000003 t4 : ffffffff8017a0ca
[  273.421022]  t5 : ffffffff8023cfc2 t6 : ffffffd9040780e8
[  273.426437] status: 0000000200000100 badaddr: 0000000000000098 cause: 000000000000000d
[  273.434512] [<ffffffff80aecd98>] riscv_pmu_ctr_get_width_mask+0x8/0x62
[  273.441169] [<ffffffff80076bd8>] handle_percpu_devid_irq+0x98/0x1ee
[  273.447562] [<ffffffff80071158>] generic_handle_domain_irq+0x28/0x36
[  273.454151] [<ffffffff8047a99a>] riscv_intc_irq+0x36/0x4e
[  273.459659] [<ffffffff80c944de>] handle_riscv_irq+0x4a/0x74
[  273.465442] [<ffffffff80c94c48>] do_irq+0x62/0x92
[  273.470360] Code: 0420 60a2 6402 5529 0141 8082 0013 0000 0013 0000 (6d5c) b783
[  273.477921] ---[ end trace 0000000000000000 ]---
[  273.482630] Kernel panic - not syncing: Fatal exception in interrupt

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Fei Wu <fei2.wu@intel.com>
Link: https://lore.kernel.org/r/20240228115425.2613856-1-fei2.wu@intel.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_sbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 622fe7c982509..9dbbcdbb97ce0 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -651,14 +651,14 @@ static irqreturn_t pmu_sbi_ovf_handler(int irq, void *dev)
 		/* compute hardware counter index */
 		hidx = info->csr - CSR_CYCLE;
 		/* check if the corresponding bit is set in sscountovf */
-		if (!(overflow & (1 << hidx)))
+		if (!(overflow & BIT(hidx)))
 			continue;
 
 		/*
 		 * Keep a track of overflowed counters so that they can be started
 		 * with updated initial value.
 		 */
-		overflowed_ctrs |= 1 << lidx;
+		overflowed_ctrs |= BIT(lidx);
 		hw_evt = &event->hw;
 		riscv_pmu_event_update(event);
 		perf_sample_data_init(&data, 0, hw_evt->last_period);
-- 
2.53.0



