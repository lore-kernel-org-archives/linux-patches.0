Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031279;
	b=eHtppo3ni4cNCx4Y+E01yxIgn4s2udkU8eEs6VhArRsBfhMkM+ur/P359p/M0Qb3sDhS
	 Ej+ItPoJMkT4bptDMMUK3PI3BXCy7Pu5Wkt6348agXlH0jY2oaUObOUcWVBytj2ZgB07a
	 soJzWQD1YCuK66vDf7SdGcSJOfx3edYIGhjuZWfSOe8Mb8+J/znRYe8OA3y5Hu86K+Fmn
	 XSb4wLRZWNSe+GtvQWO18r79JdV9wyGj/Ad9SWgdK1/CAcO9noZn4/DmatZVY2kI2s50T
	 s34w6WkvTnlmVf1Gsj+D+ZI9iOzlxpt5w/LKVjV+jnyR1CnVpAsnL4qOh+Bbe/OvBQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tIVpmhoeALyQ4zbNszKsITCYvy/uNhGRpFhkcjU3nyI=;
	b=iV5gqUeUTrX9vi/z1rWsOMhrVI8U0k0UDmJXhGoiriYx6S8Ym9QUlvyG4J7fxQq5UdJ0
	 ebxCuTmqdDLW6hIaCyX/hRxelECWuJ6PdGKSHGrj6JjpJxxD9QelMr2BhuCf44iW2FC9e
	 rKQqM9G1bCUnGD73XIVRmThF/ks2tCjwizD4clvY13GIYp8Zf0b9/DSwrrmeXOLGeLKfD
	 CcKtkpjgvncBQph9qc1/vvE86Ms8lttrCTUqHM/GUaUY2BSIE9IeuyuFZOoTDzspnQQK4
	 dsSYafXp63sNoGV8Mqq+x728eWOe1xEQvJLTfg70QTJCNHqIKBinxICwbEs5iQJ/8aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJZvc+PT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48122606A31C;
	Wed, 18 Nov 2026 19:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJZvc+PT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C581F000C4;
	Wed, 18 Nov 2026 19:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031278;
	bh=tIVpmhoeALyQ4zbNszKsITCYvy/uNhGRpFhkcjU3nyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJZvc+PTi21PQjtA/lXMGuuFqlrEzSv6C6WnvxPweuHNcGgGi/PzjGL/Cgk7gG0pc
	 grqOUruJA/y66xasRRNTMYbshRw4f5gZTcZYyfbsx87wanT1ncv6cDFxZApD6Ynj2E
	 Pw9TTTwEBDt5dPJussZvgk3m2LeD0P0oe0kFS/sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Abraham P <george.abraham.p@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1001/1756] crypto: qat - force an edge when re-enabling all VF2PF interrupts
Date: Wed, 18 Nov 2026 15:52:08 +0100
Message-ID: <20261118150050.013266863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: George Abraham P <george.abraham.p@intel.com>

[ Upstream commit 2b91570f72670054ddae5b11b8c70a79c340014a ]

VF2PF interrupts are edge-triggered: a source only fires on a
masked -> unmasked transition of VM2PF_MSK, not by being unmasked.
adf_enable_all_vf2pf_interrupts() does a plain read-modify-write
unmask, assuming VM2PF_MSK still holds the all-masked value left by
adf_disable_all_vf2pf_interrupts().

That breaks across a device reset: adf_dev_autoreset() (and AER
recovery) FLR the PF while VFs stay alive, so a VF can latch a source
in VM2PF_SOU with no vectors set up to deliver it. The FLR then resets
VM2PF_MSK to its power-on default of 0 (unmasked) without a software
write, so the following RMW unmask writes 0 over an already-0
register: no edge occurs and the latched VF2PF message is never
delivered.

Fix by having adf_enable_all_vf2pf_interrupts() mask all sources
immediately before unmasking them, mirroring the idiom already used in
adf_gen4_disable_pending_vf2pf_interrupts(), forcing the required edge
regardless of the prior state of VM2PF_MSK.

Fixes: 575185000539 ("crypto: qat - keep VFs enabled during reset")
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_isr.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_isr.c
index 7683f04adc582..3468149d393d9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
@@ -70,6 +70,7 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 void adf_enable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 num_vfs)
 {
 	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
+	struct adf_pfvf_ops *pfvf_ops = GET_PFVF_OPS(accel_dev);
 	unsigned long flags;
 	u32 vf_mask;
 
@@ -79,7 +80,19 @@ void adf_enable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 num_vf
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
 	WRITE_ONCE(accel_dev->pf.vf2pf_disabled, false);
-	GET_PFVF_OPS(accel_dev)->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	/*
+	 * A VF2PF interrupt is only generated when a source transitions from
+	 * masked to unmasked. A VF may write to its VF2PF CSR while the source
+	 * is masked or while the MSI-X vectors are torn down, for example
+	 * during a device reset, leaving the source latched with no interrupt
+	 * pending. The FLR performed as part of a device reset returns the mask
+	 * register to its default value, which leaves all the sources unmasked,
+	 * so simply unmasking is not guaranteed to be a transition. Mask all the
+	 * sources first, so that unmasking always generates an interrupt for
+	 * the sources latched in the meantime.
+	 */
+	pfvf_ops->disable_all_vf2pf_interrupts(pmisc_addr);
+	pfvf_ops->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
 
-- 
2.53.0



