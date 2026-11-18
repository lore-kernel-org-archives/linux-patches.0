Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036246;
	b=jL96k2TH7LT3GyCtA0fBHMFh7yxIUjFKhavSaOvLRCjx64psdOXd1YHHhOVkhbj1EgzG
	 9u+uhLrRrt6DTGUuIMBHOfT5mwobWiw6gTK3LMauPDxIpyjK79gmPcs+6onMrBJd/u7Yt
	 sAIEvWagLTfOtDlR45X9qZHliIZ5tYzv3KCIpIpegHiZHNpDrQ/YNfdJGOomJX/vx1hsT
	 zWgmJEoTn1eMLVDJygZl8PxN3gd066H1/wprpn1+qBAdkNcTZAumLdBvsRCeP/CJIQ0KY
	 gZzt7pF0bJyzb9hD1U4HTgTIzPIvKE49WnKdLQYAyMDNqSGbA0+QPa2h1RastKRhpGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lwnvCdhwXZoPZRYtVZ+gOlmJv9+o/x3R8AR4bRNz3dI=;
	b=S2So81ctR0Z8n01qPzItP/6uGIekFi4QtFrBzKb4GqWOJS+d4P21exUUKq/dkGhkzSr0
	 jnEHS63snPamO61neSzr6ROVJb6bJIfOYQ4GgAV5Uv8itWOXAMSYxid3bez7ocP10+jqb
	 4bExyuBWMz4246GRz3VhJ8Di3O2SyvCF3DjMgwHUTy/HXkOCYjYZXRCyY0tyfTi2YeBmX
	 WO423Cgk4Pa6vhYfP/SUC9UHA5z2ZGgYWhw5t1SKJkOLv3rTF5/0NTB/+AJ3Wrb7LsScP
	 zuFaVUpMEk9WydnCCI4lujnZP/pcV21gpG2WH3SgUXckwt0DBHZ/XSnlD/t7PPY6j5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZ4ZpDT6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10184606A320;
	Wed, 18 Nov 2026 21:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZ4ZpDT6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6336B1F000C4;
	Wed, 18 Nov 2026 21:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036245;
	bh=lwnvCdhwXZoPZRYtVZ+gOlmJv9+o/x3R8AR4bRNz3dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZ4ZpDT6VrfLRTkWV3F1lzUJl+7itELFMwHDs4L/PqwlhJosMCKJciz9oxmNqrx1o
	 1JD1uOh8IZKC/yLpf7uVOXfeGFsPljM+5K5MfCvy8LfUqjToStYiF5ZuwOCmZ+aACH
	 caYvNDQgo/e+yIo2j+CMy9uQ+vzF9kFB4mBbxB3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0991/3318] KVM: arm64: vgic-v3: Undo assignment on iodev registration failure
Date: Wed, 18 Nov 2026 15:26:53 +0100
Message-ID: <20261118150349.542173798@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4c470f20adab4..a58a2633bb676 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -816,16 +816,21 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
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



