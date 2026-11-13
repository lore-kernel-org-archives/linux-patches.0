Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590599;
	b=aXpfo0BsA6dNsm166DU5aJakFTIbcEvFKAiSwIttNpg1DvVZOb/jLqFIfRZBbnNHvQge
	 p9qJkscm8R3pHTsxpxT00XKJ/V+b5qMt7wX/BMXnj+5wcTmx/rSN9NoWPnf/RbXvdBMwT
	 Fp/ujxatLudfHecYdRa9+7OICxeN2ZGn3ekWyaQAokhxGkUIkgegPwBeUSxjAzwlMZJwu
	 +hTA78epgBV4ZzCZJXATAxyDXwhFlR5oj+k/R5VwMtD9uhPCO8ZA/60RkRMiXAjukFLy9
	 Ob48Ow2Dq4NsjzBmVbXcr4vC+5kSN9EnVSpAqrHxV0TlurucA2KagXc+snGcB8DaWKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZrCKa8ra1k7wCJ/ysMx3XGJvDYpIL0Gvs+XQEDm92ys=;
	b=3EOfv7QIINurlAMjnpDx30U9eIEW6Y0UUCbVhqmF+x+PWLj4kTMqgBIkbxcQAy4iegaL
	 k4S+OMtT7x9isTx6Xd5cre2SFrB7oE/FaqxqUn+11jHwz5q4novOgvhOKsXEHwUttHmEE
	 HAPYaSewcuWU1VLwdJHRS8hQA9499mWKerPjkuLb9eWVnS3UxweirkFPkKfmJ2g0zmoHY
	 CnXFVgTAl66w6ijqlhdeqnGjTjYXMoWyavwa2nETRA8gf1RUeIPd1UlB330WlaXVgfKF/
	 GmCa7UCsfDJuBwUs8elvKIGN48cTWl/X9JEo0AD6Yc18uwyFOr6Vm3k3IZMApJNMvzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1LGml0m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3605F606A887;
	Fri, 13 Nov 2026 17:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1LGml0m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AAE1F000C4;
	Fri, 13 Nov 2026 17:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590599;
	bh=ZrCKa8ra1k7wCJ/ysMx3XGJvDYpIL0Gvs+XQEDm92ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1LGml0mw6ab1Owtqhff/1rJNtFPvBJ/nHmQCLovB5HCsl69MEoA0oY+xVjnXaL37
	 EjxNxyJmwUvs6XZkSuWHqKI+Z0QfMEMXHUELr1x1jjbPc2MTs19xKx/2PIYTkPvep4
	 uvVJNQ2xH5H8tFtHr5wr43jU6CNXjpnLitI6/1Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 528/686] KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM
Date: Fri, 13 Nov 2026 10:51:01 -0500
Message-ID: <20261113153839.024133474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
[ sashal: Replaced the unavailable __get_host_hyp_vcpus() helper with equivalent inline checks in handle___kvm_adjust_pc(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 6e7547b7ca432..1363758035bd1 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -385,8 +385,34 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct kvm_vcpu *host_vcpu;
+
+	host_vcpu = kern_hyp_va(vcpu);
+	if (unlikely(is_protected_kvm_enabled())) {
+		hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+
+		if (!hyp_vcpu || hyp_vcpu->host_vcpu != host_vcpu)
+			host_vcpu = NULL;
+	}
+
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



