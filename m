Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831309;
	b=y8cH+nmJcXhMBI9uHrXNjfHIESh3kKswFs/AciSW2L8scKK/Z1JNgJAEwulkf6XUwqXj
	 4tOs+aK46jTB/MXF6vhrengYi414aE5trGTU/wHfN6il5Yqi+yZ5Z6iTqOmTIp1ZsvHMS
	 7xS+8eIeRYoopH/u2KfK562VHZpXSxA5gKmI8DOmTVQGazKueowZrBVETFK5j+WSDYCht
	 7JikF4vZ3Ohi4AZcGu51W9PyoirpImo+OjhYedYC7vp5QqZcQQB65oTK3TpYeVVeDPEkd
	 RuD1rXgADFmI5O4Gd1r1Jsclk+uuGSYWaZLvrTY4FwFXgQPm5p2zIPFwCLSBcDABTEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pAW/eo/h+kW6AOeEAEqNajoXODwnd6U5Db2bpDwBW3E=;
	b=sNAk4gL3CYUTT4enOCpuSnn4nlQ04FiWKD0jvE1rWgKMoHWwBKPKxF5lL1LXDFpJUjzM
	 9nrtev0hOt20lkbs9E5bBgF+QUFQIQTim7IipF0APrkMfHFSuGySilGwv1vO1tYqSMwR7
	 Wy+hQxrjde7mlq07vg5eO7OFjPQiBXqk9zjriQ8/RMXG5/HulcqaM+pgohQe23GMicCqU
	 BB+MoHmB4lBREQjsgwo0AoqAJGKBNLUQeFi36qWr68iEhRxxD8/1+yD1L/2wqv1pDgaI5
	 pM9bZxmHchuq+cIRQo7u480b/8KywmecsJpb69AsmcKSJhnIEaWRiHeB1EN9cOcjuFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gBub2xbG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5429606B2F8;
	Wed,  4 Nov 2026 22:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gBub2xbG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF8B1F00919;
	Wed,  4 Nov 2026 22:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831308;
	bh=pAW/eo/h+kW6AOeEAEqNajoXODwnd6U5Db2bpDwBW3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gBub2xbGAPHyByRs86r0+ywQPNiEKZHkNy5pgoUimDg3IfVhwU/VD4EQ8HvNp061F
	 dlmi99oyozCDAzCJt7k4ISXl+lEd5tIA6I0YPkKLxCh9QNn1cmVYk/fvcnoo+WINi/
	 Z7+PVgh1RWLMRDRY72LS4Pt5HPWG1h/hFLdeCsJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <jiakaiPeanut@gmail.com>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0624/1005] RISC-V: KVM: Fix double-free of sdata in kvm_pmu_clear_snapshot_area()
Date: Wed,  4 Nov 2026 16:05:57 -0500
Message-ID: <20261104211101.288487360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiakai Xu <xujiakai2025@iscas.ac.cn>

[ Upstream commit 310e2096b082ae0010e7afef666073b966ac2fa7 ]

In kvm_riscv_vcpu_pmu_snapshot_set_shmem(), when kvm_vcpu_write_guest()
fails, kvpmu->sdata is freed but not set to NULL. This leaves a dangling
pointer that will be freed again when kvm_pmu_clear_snapshot_area() is
called during vcpu teardown, triggering a KASAN double-free report.

First free occurs in kvm_riscv_vcpu_pmu_snapshot_set_shmem():
 kvm_riscv_vcpu_pmu_snapshot_set_shmem arch/riscv/kvm/vcpu_pmu.c:443
 kvm_sbi_ext_pmu_handler arch/riscv/kvm/vcpu_sbi_pmu.c:74
 kvm_riscv_vcpu_sbi_ecall arch/riscv/kvm/vcpu_sbi.c:608
 kvm_riscv_vcpu_exit arch/riscv/kvm/vcpu_exit.c:240
 kvm_arch_vcpu_ioctl_run arch/riscv/kvm/vcpu.c:1008
 kvm_vcpu_ioctl virt/kvm/kvm_main.c:4476

Second free (double-free) occurs in kvm_pmu_clear_snapshot_area():
 kvm_pmu_clear_snapshot_area arch/riscv/kvm/vcpu_pmu.c:403 [inline]
 kvm_riscv_vcpu_pmu_deinit.part arch/riscv/kvm/vcpu_pmu.c:905
 kvm_riscv_vcpu_pmu_deinit arch/riscv/kvm/vcpu_pmu.c:893
 kvm_arch_vcpu_destroy arch/riscv/kvm/vcpu.c:199
 kvm_vcpu_destroy virt/kvm/kvm_main.c:469 [inline]
 kvm_destroy_vcpus virt/kvm/kvm_main.c:489
 kvm_arch_destroy_vm arch/riscv/kvm/vm.c:54
 kvm_destroy_vm virt/kvm/kvm_main.c:1301 [inline]
 kvm_put_kvm virt/kvm/kvm_main.c:1338
 kvm_vm_release virt/kvm/kvm_main.c:1361

Fix it by setting kvpmu->sdata to NULL after kfree() in
kvm_riscv_vcpu_pmu_snapshot_set_shmem(), so that the subsequent
kfree(NULL) in kvm_pmu_clear_snapshot_area() becomes a safe no-op.

This bug was found by fuzzing the KVM RISC-V PMU interface.

Fixes: c2f41ddbcdd756 ("RISC-V: KVM: Implement SBI PMU Snapshot feature")
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260318092956.708246-1-xujiakai2025@iscas.ac.cn
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index d5a0a3a33f6b2..b3ce82cfd78f3 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -454,6 +454,7 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
 	/* No need to check writable slot explicitly as kvm_vcpu_write_guest does it internally */
 	if (kvm_vcpu_write_guest(vcpu, saddr, kvpmu->sdata, snapshot_area_size)) {
 		kfree(kvpmu->sdata);
+		kvpmu->sdata = NULL;
 		sbiret = SBI_ERR_INVALID_ADDRESS;
 		goto out;
 	}
-- 
2.53.0



