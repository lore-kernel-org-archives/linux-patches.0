Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061465;
	b=pizpJIYX08CGQ5WLhk6BMNKRSRzz3SD3jyFiCF+VcSt0JRSq+1rd/cv/h7XPUVj9Q1Hm
	 GSmkbrF7rq9Xbsc3KMGuntcJeTUjGoHjB1GJhSa3PFccSFi5LOvoSJDEtmPnP1EqCb1Cp
	 31kPG6Uuooq6YlO32t9l32pB5cm5Qrf70tfpNl3cwpLxBuKAfJkyeGWc5N1w8/mCMpwdy
	 N2dbaD3Y4k0TJAsqpcWIdJoExB9HjIjNTV4v6jFcBhV/e82VDWtgZfsg/mqXasSWWY3Tu
	 Y9IyW4aqFDFldsjjyGlSlZk5K6vGHXdo21PtUbMEyswIZ0Zb2/CFaftr2BS5Pp9PhOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ACzd6TSiitx002leitP2gTN+9ommgBh0IF3cl91Qo3s=;
	b=aZmZfygKQ7c7JI+UR19P6N+/PzX9xx/p/EBK4USoTZ3a6YU/xtehcPJVw5fP6Ci8YPNW
	 6KW8u5tmNF5CpRY4aSa6RAWa+/YilSBz1ychrRyDCNsODqFsyhTSmCdcoxMzVpjoV3q5R
	 oGbjmYA9DgAY/Y6M9QZV+f+SAXuUBOglrHG0lXDYZWZdsegJ1zDRFcGIuAr4/0TuSLg5u
	 L/kLd8reUeUXg/xvBZ5iHISA6exMC+rNo+sq5JYni2wPIu3ZsRJyO4Poi5iLQrFG/dF6l
	 lZ7ckOGCET02D0h3pTflem3H8Y3O9QaKMTD4Lr4cjb1ydHmrdaulT+KDZv1iWPjB5dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJwn1mba;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2325A606A331;
	Sat,  7 Nov 2026 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJwn1mba
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7B81F0089F;
	Sat,  7 Nov 2026 14:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061465;
	bh=ACzd6TSiitx002leitP2gTN+9ommgBh0IF3cl91Qo3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJwn1mbauM4i1SMjSsvU54FwHyrtRJ3Sq6Vzf5NfiPDKzqBXF6RvLkcpkMXClXuCU
	 rIgtNdUwafE2otiOU5CfkVjkQeUA5zfBBA54NFW7fqqsbZLxaN9VUqRsh54bBLDCd2
	 u8Jt7VHCf+FgNlvKjm4j49LSdbuiUrVSq11gR/FQ=
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
Subject: [PATCH 6.12 0566/1536] RISC-V: KVM: Fix double-free of sdata in kvm_pmu_clear_snapshot_area()
Date: Sat,  7 Nov 2026 08:43:02 -0500
Message-ID: <20261107135013.475942608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Kept the local SBI_ERR_FAILURE error code in the context line, since upstream has SBI_ERR_INVALID_ADDRESS there, and added the same kvpmu->sdata = NULL; line. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_pmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 516a0570bdf6a..9270119cd44da 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -451,6 +451,7 @@ int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long s
 
 	if (kvm_vcpu_write_guest(vcpu, saddr, kvpmu->sdata, snapshot_area_size)) {
 		kfree(kvpmu->sdata);
+		kvpmu->sdata = NULL;
 		sbiret = SBI_ERR_FAILURE;
 		goto out;
 	}
-- 
2.53.0



