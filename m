Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053740;
	b=WJXlod4nyLcFY+mFInUH7wnjVBQe8+kuCMv68np26XoCHxB+4sUZFKbJSggfOrvflFnt
	 idOYxrOF3aQBRbxNAfGldqsrt1yCFdqhpIyUCQLkhbp6vDcQUwiFMTXciE0q+SOaM6UyV
	 eLy+TuboDmhASQseLUjHodkIiCltjwecMvjKqgLJyNYYb8uGspyrfyMz5YtKXDnF+nQpS
	 TKmWrzgSzoEzxP7NQdNgu/CIlbzVMNAzeJO5RyGgokltCgRZ0l4J3Vjr6zO7pMMlNYnj5
	 gB7KVqdI+M3/Emfr23IxP2nBNi4CszjkV5biF0DVAWjomXWIHk4E1vqRbTNhCDymvGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TOggJ/WZw4FTbOcywY9JBoO/ptLrejynKZ1yr1ify+4=;
	b=zg4C9Q0T39XIUOreKDYTGKBmorDtrmaapXHCuie3SuwC3iMBkRLRzaPeoHMvcUyQB3Ny
	 q6P37v8/uKetM8bIFXDWHk/JY3V9QjLi4QTQ5TJDPhbQA7hCgmVcj21veleYiSlh7VsGd
	 WhzO+agzMJpPJ36cRd2EMw/6026t61vJEE6PfV6UbOBgnYdEWhTOxHVF6oJIcs7yKTYRc
	 dZTxWylYiZtNCI8asqgaiRBqgh5OGkvb6nWlYs7bTNWwwIjLau3Q3xmE+o0TIRQVn5+mz
	 dYBlaOpkj3BW82kDQbqiyWLmcJWpEcOyBq5kcw11kCS8BBvSzl22bA1K6dgUsbDvh1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eeqn6cNm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F349606A320;
	Thu, 19 Nov 2026 02:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eeqn6cNm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8BF1F000C4;
	Thu, 19 Nov 2026 02:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053739;
	bh=TOggJ/WZw4FTbOcywY9JBoO/ptLrejynKZ1yr1ify+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eeqn6cNmYiCGLgL4gUSCF+dpVQNpQlm+h1A6bicNazO2UjpULLDMhqCoXVNl1aUwU
	 67stOdUTIjVI7AJIJ7hj64YY+cczZB0Q05Pt8OHYJDZI0VBT13dNRcvmYiP3L1izWm
	 owf8dGhyF/U/FjyAWYO4InPvelUVRSOSQTQ03A2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0985/2214] KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
Date: Wed, 18 Nov 2026 15:44:21 +0100
Message-ID: <20261118150051.637153325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8a88a46b86ca3dbbd24522760d29edfb3f24ac2a ]

vgic_register_redist_iodev() assigns a redistributor region and base
address to the vCPU before adding its iodev to the MMIO bus. However, the
region's free_index is advanced only after registration succeeds.

If kvm_io_bus_register_dev() fails, the vCPU retains the assignment while
free_index still identifies the same slot as free. A later registration can
therefore reuse a slot that remains assigned to the vCPU.

Reserve the slot before registering its iodev. The caller holds slots_lock,
so a registration failure cannot race with a later assignment. Undo the
reservation and clear the cached assignment on failure.

Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260831081005.41346-2-kmehltretter@gmail.com
[maz: moved helper into the sole caller]
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: adapted locking to rely on the caller-held kvm->lock instead of config_lock and guard(mutex). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index fd1fa2561520e..c3c0204b3eb1e 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -739,16 +739,21 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rd_registers);
 	rd_dev->redist_vcpu = vcpu;
 
+	/* Protected by kvm->lock */
+	rdreg->free_index++;
+
 	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
 				      2 * SZ_64K, &rd_dev->dev);
 	mutex_unlock(&kvm->slots_lock);
 
-	if (ret)
-		return ret;
+	if (ret) {
+		vgic_cpu->rdreg->free_index--;
+		vgic_cpu->rdreg = NULL;
+		vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	}
 
-	rdreg->free_index++;
-	return 0;
+	return ret;
 }
 
 void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
-- 
2.53.0



