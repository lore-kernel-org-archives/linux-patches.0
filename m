Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059370;
	b=d54T3ypuF6YL4UqjYiNNlYlwCk7YjFw/YGwphvyINSTsXslo5pKllzmWiISeOr+Tm4+r
	 rH/N12K5catcyP3euRpyDROBxlgvrpgLRvh+u8+YFM4SXL9URja197uWmAAP9YgPwDuKR
	 rrOER8T3FhVmz5sWAyun19LIx8KtoJ/iSIHauiKFLeDiq4u3lMQhHLaILI3CM6mTbKyr2
	 8kfiFgEUwi1uzu2R5Jmq8M1TkraloJHP9ZzUrD0F/iYBjzP6yuuq+rnEhkOk5Ajz9HqyB
	 ZkBYbVHGxOZwY/NA8FEd5j7VnZU6fZeXCQKhyfhACISVK91HeTcNCTYdjyH9Hr210sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hexTMQuSfdVLwhUE/5Me16AsaImvT1S4T1aGRXAMU90=;
	b=rxyxwATwj06rOJR/dN/az6p950KeEoLpi61RKoUx7ky3NUexkxkE7DsNgX6DwgvPZsQf
	 oXOYc8GiuEfmhW7VrLuv8kofcMevMXFed01iWpwEF4gem3aucuPMltApDR7s4bM3CkD5j
	 4/ucBNUj/7mOiV/5YQc/FWTRE8OPZuWk7bQ+diB9IShSrK7/jDdgpal0zh6f3Cf29s3zn
	 Ra9yUBvbG6Y41TgNQX7MNVEeu88Z4T+Bsxb8BK5ePHSqJjIOR41UH12KeReklKsE/sWPU
	 2mTI/+x3XIroBvYZqtstnR+E0ioAROEOT6r4grlBhu3AotVqQRyahGOREb9AUYWo7Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zo5ySaOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DCA606A31C;
	Thu, 19 Nov 2026 03:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zo5ySaOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D0A1F000C4;
	Thu, 19 Nov 2026 03:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059370;
	bh=hexTMQuSfdVLwhUE/5Me16AsaImvT1S4T1aGRXAMU90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zo5ySaOQsx4+fFoD5Pln+l9pulxOqnve01i+xaYtqiuq7GuosNGZfj5A0DgHH2m5U
	 os3NV26zXSSa8ZVpUOWM8UMoq32nwvTy5lR9C0H6SjydXgXmqtvkZfYPUoQl3gymfy
	 qvqbaGo2s7bKGf1ulfEY2YS/y8Q1F4dFRvlGNsdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0817/1848] KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
Date: Wed, 18 Nov 2026 15:47:35 +0100
Message-ID: <20261118145950.629688501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted failure cleanup to rely on existing kvm->lock protection instead of a config_lock guard ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 7a6360eba3214..d7c06cf6dc0f9 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -731,16 +731,21 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
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
 
 static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
-- 
2.53.0



