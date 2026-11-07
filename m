Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063826;
	b=rhC2BDFTEfLilq+UdCLSk8b0VHuZ9pqnw4mEld3bu0NZOLaxLoYJn3wWQjG5ykGJBCGE
	 rLLD1s4ppQ1yFSoLmT38i3EQFiTaqzCo3Gocm2k3EDl0QT1YEQpIAIVdx0loUwm4Itjx4
	 jBBLHx/y7Iw3U6/P0TeUQmpE7IGPFVY0YIjpRj9HuSECJK42Mb51GJVzyKDecU2Bc1Jwz
	 gN31SXVx2IQ0Pr2jstktgLZGaz2yEVA/gzEfCKne4MWj7QUt6mFZxIiC7+gbSiQ/liuar
	 5HlHQaWKgmjKINxgErs7xMxG70jibanCpDiIK8oFKFT27OvmVbbHHZQoPvtEBjuFWhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qAg1dpiq+f2GKS0EZHnzGglDCWNkYVosgpXhyVt+YZA=;
	b=kTC34u8erGAZ7UGpuDAEzqoCFnWieAywZxpsqKyPb/ILcpzWHyd1G0zYNSxGDkTYX/gn
	 H5biyn5R7CVznjxzPNgqPYCx31/MZ5PcBwInmArncLcyecJa3Oomt2jkV69i8u0Tmra35
	 d70RJKo+3bdvx9XaJtM6RqVngZe5aeUXg+jan/ovEfpPJIUOIoDFdKHCPsrNKbq/CM+4o
	 SFNUocRZAzyNRQwVdAPc/ibuoKwjYKUvU5Eepb37BIE2rHQJtnIdvDOAYyrvc9+SQWf04
	 TMrIK0gr/D3O+tXRtunuEqB56pnUl/zkMnhecEIOnKNeuL+lXj3s/XaxC0Xwr5OS82A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQ4vLPwO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75A5606A326;
	Sat,  7 Nov 2026 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQ4vLPwO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8544D1F008A2;
	Sat,  7 Nov 2026 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063825;
	bh=qAg1dpiq+f2GKS0EZHnzGglDCWNkYVosgpXhyVt+YZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQ4vLPwOJFFELx4y1u7fh+sKEMsDchReRbdgK59q2DxdYiyEiHk0m/xru0Dcoga4c
	 twtNzRRXg4GgtgXvbCAePjamkBvvF453j1O0c1/vPGfq8Tt+7DbPxXxiPa6t6PFmih
	 47u/enc7I422nN5Eo+LQCqxwa6h33SJbGJdhCd34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxi Saparov <masaparov@coreweave.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0040/1257] kho: do not reserve scratch memory in the kdump kernel
Date: Sat,  7 Nov 2026 08:38:56 -0500
Message-ID: <20261107134940.514187004@linuxfoundation.org>
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

From: Maxi Saparov <masaparov@coreweave.com>

[ Upstream commit 48be325089e15077411785d0c41ddb9071a61081 ]

If a kernel with CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y (or kho=on)
does not receive a handover FDT, it reserves KHO scratch memory in
kho_reserve_scratch().

The kdump kernel always takes this path. Since commit a6715d7ec472
("kho: skip KHO for crash kernel"), the kernel does not add KHO
metadata to the crash kimage. As a result, the kdump kernel never
receives a handover FDT and always reserves scratch memory.

The kdump kernel boots in the small crashkernel= memory reservation.
On our x86 hosts, the kernel and initramfs make approximately 176 MB
of early reservations. The scratch areas then use approximately
650 MB more of the crashkernel memory. When a large early allocation
fails, the kdump kernel panics:

  bio: can't create integrity buf pool

A kdump kernel has nothing to hand over: its only task is to dump the
memory of the old kernel and reboot. Fix is to disable KHO at the top of
kho_memory_init() so that the kdump kernel does not reserve scratch
memory.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Maxi Saparov <masaparov@coreweave.com>
Link: https://patch.msgid.link/20260811161857.3096-1-maxi.saparov@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 7c4d86daf86d5..3c87c2a3d6f09 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -12,6 +12,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
+#include <linux/crash_dump.h>
 #include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
 #include <linux/kasan.h>
@@ -1939,6 +1940,12 @@ void __init kho_memory_init_early(void)
 
 void __init kho_memory_init(void)
 {
+	if (is_kdump_kernel()) {
+		kho_enable = false;
+		pr_info("disabled in the kdump kernel\n");
+		return;
+	}
+
 	if (kho_in.scratch_phys)
 		kho_mem_retrieve();
 	else
-- 
2.53.0



