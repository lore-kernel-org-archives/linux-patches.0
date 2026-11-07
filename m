Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064358;
	b=bKfMhdJf9n3cPOYtafDG4Tp8ZFlklkxL5QFe+20bH+ikryVGNYZwzQuLdpWBskHChWQG
	 sHLuRkSknWwz8KX1axXOXSU7rxejLkNTBA33S1xlV2hW4UMu6SD5q6/m9EbIZps3vgmL4
	 iE4CswRiiLki9eR3wTOPcO0z8kwB0rrXLnDonOEzGTMaBuRRIdoDtJps5I+PqKCnAOE2P
	 tYVlmFV8S7ulIpJ220JLQDhNx1X2lMj1CIiZfJLjj3CzrpoKXzdc59Y4XKvMUMekOT7Nx
	 SUgxwsMSnMr4tbQBEaBZB7EteY+LTzmdseesompDpGsGKIuoHoqmKumYGo4lHBpeBlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Is8kUUfzlAtWNAuKrnZ/HWViNWJ2ogyxK5c+hsbsv/E=;
	b=wHHRT5pEHOBqtITcHQ2B62ML0xAEfbDccNnS9FgNQ0CNcjd09AXvYv1pAUr5SpnJux16
	 wVOdpuzRXH04mprh3XnGnt77Cp9b+gV4tlGkGDFTBuZ8xDV6vGV5m4Nc+d3WLvr/MSlZE
	 jx/56b/TrHzOYhRBt+BhmY+WsZdEAFF9HLmuc/99jQ1VFTZa1gZ4t2n0PX6vAfT0dPRVp
	 GY4nkmhBOfnHZFKZrsd9CsS93z8u1tJcid03Ns8U6+JiK1M6muUwGC+fJ212E867ljorz
	 i2k+fUQg44VlTCBfGBuCZasCokCytBFYAwGz/BJEvTeeosXEM1aAjerH8M7ks3kWEVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v+7L+TKF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D31F606B88E;
	Sat,  7 Nov 2026 15:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v+7L+TKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10431F0089F;
	Sat,  7 Nov 2026 15:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064358;
	bh=Is8kUUfzlAtWNAuKrnZ/HWViNWJ2ogyxK5c+hsbsv/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v+7L+TKFWoA4bpgRRFAjNblI2I4mr2JDP0tQXtaPh8e3FEW756imeptGYRxzSaM8g
	 6qNqHvIAW/bsuvlh3/39bFPP/4f0eKW/XyBndUFJCBqSxOICc2EwCkCviptcBtjzUt
	 x0Z2SJ5HQSSGzxb2c6yUa+iEXW5zQaHcGmkgsnnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0440/1257] KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
Date: Sat,  7 Nov 2026 08:45:36 -0500
Message-ID: <20261107134951.638950422@linuxfoundation.org>
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
index 5913a20d83019..8fb0a3eb3457d 100644
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



