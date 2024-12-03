Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CEB1F6696;
	Tue,  3 Dec 2024 15:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238975; cv=none; b=Tt/P+SZ9ML6SU2QkI9RIzy4KmMiidT268+I5YPk2JUQe8oMCxIZR1sndj1o6vph7af0zyNi1OE+BfXChBJdi25uCkZKnLGApqQgvJREEEDUeJ/QlfxiES24I1wdkV1iWsfFjDHjAxVV7TOQ6dtTlDj71ylDkBr9fLR2SRJUMplI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238975; c=relaxed/simple;
	bh=7ACmJdlaAgC1vGOS5L+p6UJOIGn2CxxFOdMkF4mF+YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4wb8OmEiF+Mozqg1lesRQ/5J4lWo2QIXxoZX1Np4jSJ6C1ShlsnTpzyndWR3ofyHXI7FDI658Ma9TVV/ZvoTvpps4H/9QLMmZG3gNW0ta16SDGxfTX0GQN7ExgHkR6J2n6r/yhMmrJSnMCBmSGPsPfxy2X6xNHAgKQ3hWhuL6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2Tyhcog; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2Tyhcog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF8CC4CECF;
	Tue,  3 Dec 2024 15:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238975;
	bh=7ACmJdlaAgC1vGOS5L+p6UJOIGn2CxxFOdMkF4mF+YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2TyhcogqDUoLvZfTRHwllTKCJ4WaMELlVB9N1flh0gxCBEC4XkYgq+fI9zt4pwjo
	 pfjZQtUGnUYqM3ES1E+ckqJi01C5ZHakkMkJdXfgF83fG8SIvfgIB6s5Ljgk9PkUHF
	 etbuNBjZI8vEaKZR/DHps0WhfaJrZJePgO3gFHxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 461/817] KVM: PPC: Book3S HV: Fix kmv -> kvm typo
Date: Tue,  3 Dec 2024 15:40:33 +0100
Message-ID: <20241203144013.870095723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 590d2f9347f7974d7954400e5d937672fd844a8b ]

Fix typo in the following kvm function names from:

 kmvhv_counters_tracepoint_regfunc -> kvmhv_counters_tracepoint_regfunc
 kmvhv_counters_tracepoint_unregfunc -> kvmhv_counters_tracepoint_unregfunc

Fixes: e1f288d2f9c6 ("KVM: PPC: Book3S HV nestedv2: Add support for reading VPA counters for pseries guests")
Reported-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241114085020.1147912-1-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_book3s_64.h | 4 ++--
 arch/powerpc/kvm/book3s_hv.c             | 4 ++--
 arch/powerpc/kvm/trace_hv.h              | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index 2ef9a5f4e5d14..11065313d4c12 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -684,8 +684,8 @@ int kvmhv_nestedv2_set_ptbl_entry(unsigned long lpid, u64 dw0, u64 dw1);
 int kvmhv_nestedv2_parse_output(struct kvm_vcpu *vcpu);
 int kvmhv_nestedv2_set_vpa(struct kvm_vcpu *vcpu, unsigned long vpa);
 
-int kmvhv_counters_tracepoint_regfunc(void);
-void kmvhv_counters_tracepoint_unregfunc(void);
+int kvmhv_counters_tracepoint_regfunc(void);
+void kvmhv_counters_tracepoint_unregfunc(void);
 int kvmhv_get_l2_counters_status(void);
 void kvmhv_set_l2_counters_status(int cpu, bool status);
 
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index b0432e78fa629..45b24706f7512 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4148,7 +4148,7 @@ void kvmhv_set_l2_counters_status(int cpu, bool status)
 		lppaca_of(cpu).l2_counters_enable = 0;
 }
 
-int kmvhv_counters_tracepoint_regfunc(void)
+int kvmhv_counters_tracepoint_regfunc(void)
 {
 	int cpu;
 
@@ -4158,7 +4158,7 @@ int kmvhv_counters_tracepoint_regfunc(void)
 	return 0;
 }
 
-void kmvhv_counters_tracepoint_unregfunc(void)
+void kvmhv_counters_tracepoint_unregfunc(void)
 {
 	int cpu;
 
diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
index 77ebc724e6cdf..35fccaa575cc1 100644
--- a/arch/powerpc/kvm/trace_hv.h
+++ b/arch/powerpc/kvm/trace_hv.h
@@ -538,7 +538,7 @@ TRACE_EVENT_FN_COND(kvmppc_vcpu_stats,
 	TP_printk("VCPU %d: l1_to_l2_cs_time=%llu ns l2_to_l1_cs_time=%llu ns l2_runtime=%llu ns",
 		__entry->vcpu_id,  __entry->l1_to_l2_cs,
 		__entry->l2_to_l1_cs, __entry->l2_runtime),
-	kmvhv_counters_tracepoint_regfunc, kmvhv_counters_tracepoint_unregfunc
+	kvmhv_counters_tracepoint_regfunc, kvmhv_counters_tracepoint_unregfunc
 );
 #endif
 #endif /* _TRACE_KVM_HV_H */
-- 
2.43.0



