Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064356;
	b=QLOxOrGoil3BADWLYhFMvp3cqt8S3OTALVVwVVRyzIOvYtZbjKsJEcr8GGB+OmWMYViZ
	 7+6T3UQ1Xwi+jibOo7XTdrX4BxxK4mDR1OlDzdc/nmBp1j8yhp8zI4yiETO/KQ56O4qOG
	 adPFb2EFjdIJmrhJaNS6w6NCjmNZNiXCudPg3kZcgv3m8+60QbCdSGyOeS4feG2p/TB5V
	 NTzk2rqmFu+/aYoI2EW7d6d6esIo3bVQRpz+Zxzc9RGOME1Iw4irchZDQ1sJfcefZmzLl
	 UUwlpSL/KAjNVqnnDYW16I3ruGNxOfKUVdmS2XZ9mtPPiDGuNn944z1oKWYzunHUJHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6PtHn0QYEG9lW0E303Wv+Fvl6QLYnSkiusnvL05FFY0=;
	b=WVY2Yi7bAok0Oam9tljuQ5gReuLSWemXJrQK7/I0hr0NLJ+Ho1raC6O53PHwCB2/0qhS
	 XjQVsKQdSCnTZPy4p+ZxOj9XY3E62cj2H4fsLvGImmNWMhIcyTjAT8v40xfDehU45jEUM
	 6fNkMkr9Gp92oJwEQr4Gxt//alDPqWBGIJ4NMtSc0CLA3FV5KetwGol/tQYaNNgcC/3rv
	 5b3c72M5kTR4ZEbmmLwIlUtYg2It4OfFgC7kZKbBKGBfLK7imOv5fyvW3KuIwfHIHX3EQ
	 eV7hwYclSdAYxYl8sgy56pTW/vH1IPUhCkgowINWGxmJIQ9gwV4wsIHm45Hi+F0NCpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zhDf/35b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DBA606B88D;
	Sat,  7 Nov 2026 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhDf/35b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D301F008A1;
	Sat,  7 Nov 2026 15:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064355;
	bh=6PtHn0QYEG9lW0E303Wv+Fvl6QLYnSkiusnvL05FFY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhDf/35b4FBC9rxs9DKeLk5Mvfni95AuE1nFqGk5kU8SujNC3afGBjVLjI3uGUSXN
	 zT1dNiOw7AMotTObdM/IIadGRPOpa625RJ1O3sjBSnBQXGbig8/x+6I/KLlM+TXn7o
	 IFavtG6x9AW//ETXaqE/DWGh7L/AOl/uADSRyxQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0438/1257] KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM
Date: Sat,  7 Nov 2026 08:45:34 -0500
Message-ID: <20261107134951.584725267@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit a2bb5f5c67a95ac97fcd6859dab51be421cf26fe ]

Under pKVM, a page the host shares with EL2 is mapped at EL2 only while
it's pinned, and the host vCPU is pinned at its first KVM_RUN.
KVM_SET_VCPU_EVENTS with ext_dabt_pending reaches __kvm_adjust_pc() at
EL2 before that, and dereferencing the unmapped host vCPU panics the
hypervisor. Any process holding /dev/kvm on a pKVM host can trigger it.

Pin the host vCPU around the adjustment when no hyp vCPU is loaded for
it. A loaded hyp vCPU implies it's pinned. A pin fails only for memory
the host isn't sharing, and the request is then dropped like any other
bad host pointer.

Fixes: efa1368ba9f4b ("KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately")
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261001135711.1640520-4-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index ac64a036b0a95..c8e6e50d2f353 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -543,8 +543,27 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct kvm_vcpu *host_vcpu;
+
+	host_vcpu = __get_host_hyp_vcpus(vcpu, &hyp_vcpu);
+	if (host_vcpu) {
+		__kvm_adjust_pc(host_vcpu);
+		return;
+	}
+
+	/*
+	 * With no hyp vCPU loaded for it, the host vCPU may be unpinned,
+	 * and so unmapped at EL2: its first run pins it. A pin fails only
+	 * for memory the host isn't sharing, a bad pointer, so the request
+	 * is dropped.
+	 */
+	host_vcpu = kern_hyp_va(vcpu);
+	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
+		return;
 
-	__kvm_adjust_pc(kern_hyp_va(vcpu));
+	__kvm_adjust_pc(host_vcpu);
+	hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
 }
 
 static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
-- 
2.53.0



