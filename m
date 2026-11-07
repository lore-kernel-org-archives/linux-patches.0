Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063101;
	b=oDjyb6uglMkr6U7YRi0Bq3TBeKSXMOwAIZbWeO6GCll9U2fv90nuZaXRjUJgXRz99r6F
	 /VETDMJpsWLSIDOdaPmisG/wBXMiBRzYhsDl+FOR/MTacgReTW/TGhzMMRsaydAQAcE1L
	 0JwnVloGr6wg3z9b9zoeun2Am8ZzVT8lL+5Rv+q9EgN52Kk2R6e99J9kwpxjKtyjcDKM4
	 3dVVvRfviYe0QvVa1DvdL/RXq/nRZsU4CXs8hr5g0547NwO4+EwDxQDmRcUzIliAB6RWw
	 A2NEILFeR6qJGOcXkTV98UydlG3/uUqG5isa+HXDN6fYsCMCzi5Ovl8HcuC18NR1qKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w7tkv0Q7ibQdpdNIMefMhkxSZtgTb+FZK0Xe69z+ods=;
	b=nTtlkaT3JQaGKuBVUTxdqEZOr4XSm8qq1AkdHBaFNEv4r/8+QmkMVL3vhOUHgSzN8whS
	 af12XOcSyfWWDTJfDhCLc6xUSCwRQwOHexsbU8e2eYxSJfKQWySyu9zbj8s05lnara1ey
	 IDBl+siXZbtSSOREBnqDQE9R76HCCqOWb0b8Pis9PXTquqAyP2Tz2zj7+8DVQzx1zDMZG
	 r02rnWgvXAqRvlVUSmLD2O3C9DVUrSL6/oBlrjFc1aOgjtObBC112yVuvU4S26xP2OxjW
	 kNFuvqj1g6L04nTW3mBaLE8QSLn0QgAXRL3g/yi1rkIGW7RwnqZh/b5EKkFisHBM9EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JjH9UPxC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF999606D804;
	Sat,  7 Nov 2026 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JjH9UPxC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567EE1F0089F;
	Sat,  7 Nov 2026 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063100;
	bh=w7tkv0Q7ibQdpdNIMefMhkxSZtgTb+FZK0Xe69z+ods=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjH9UPxCoR2tDJKdV3uS/XUmBoQdKs/VRhAZODL1EvptfnifbDPaaXpyARZ90lEEo
	 H08Va98gn25PXgUHFPSVn5hurUkvnGLlB0g1IqAtygEv0ESN5f3rVDhhaexdUSmq3+
	 o0haWiq+YjNn3GreHbv1vRlaHD3qRZYCXfDD8l44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 335/869] KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
Date: Sat,  7 Nov 2026 08:50:17 -0500
Message-ID: <20261107134903.773462969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 051d9bf73879c..7d90e6fe076c3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -818,16 +818,21 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rd_registers);
 	rd_dev->redist_vcpu = vcpu;
 
+	/* Protected by slots_lock */
+	rdreg->free_index++;
+
 	mutex_unlock(&kvm->arch.config_lock);
 
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
 				      2 * SZ_64K, &rd_dev->dev);
-	if (ret)
-		return ret;
+	if (ret) {
+		guard(mutex)(&vcpu->kvm->arch.config_lock);
+		vgic_cpu->rdreg->free_index--;
+		vgic_cpu->rdreg = NULL;
+		vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	}
 
-	/* Protected by slots_lock */
-	rdreg->free_index++;
-	return 0;
+	return ret;
 
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.53.0



