Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019375;
	b=iPyDdUdEvjUR6CHDsWhG4N54xxEOiA++YxrJWp8KiocCJu+Pt2Dc+PxB3T35FShwv20m
	 lMcBM1Sw4Gi8pty+pnrbce73JlXeLShkSdqm6eUrGm3C2pbfpZBpNP5yeeBnCVTe+TnU9
	 2CAugWtOQcBQ2z4w0XWTepF4n+NsmBS/8S2DFVKA/KDbjkSrPEeKv44wesx1U1PGza8Tm
	 YaYuoaeb/LgdXR5eobWujZ3RLpijqtwPzxWSmG1mIEPNu9kkBkNL0dvo52I8I4wgP+qxf
	 ieIoCJ0x8OLqZZ6waQziksw7rCF/7QE+gZj2MdQcIql/H0wCEI0CVyoKaq3juAJP16Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CnEhPkm/QsNed3UetyzhxKeki8kSEDS2KO4Qzzt0Xmo=;
	b=hrneqKS2c6iPYKde2xK+HIJB0gnbJQy68Q136eoGjJNitHWb4DWf4zJMh35lNwgRQ6QD
	 kzBhzH+GITcfoyzxek1mdIzY8LQ5kCCykheFwOBi6xc0SIX5r6uDjRWWYWs+ONxeCv9Xa
	 O2Sp2PbUBt6rorE0QsKzKvDs6olgWk8jBUqM3QvmTilJq2R0Opp1xdPDEqGRD+6fZNat6
	 x48CYuWT+QgoeaYoaPkDYZZW/iJNtzJkIv4JNzV8dcaO6El91kHch4XKpgSlwhJFPFAcL
	 zN4Hvc8o4Z+B0JANePBRjNdD3U8fXQCraX4LoLQZs4TylFLw7M4JKOhXoZ3JEKbRjwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eqg1/az+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2245060A260C;
	Wed, 18 Nov 2026 16:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqg1/az+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4DC1F000C5;
	Wed, 18 Nov 2026 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019374;
	bh=CnEhPkm/QsNed3UetyzhxKeki8kSEDS2KO4Qzzt0Xmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqg1/az+fjy2y/K1HQcOj8CoC3HEjAtKPN6N3AN+7ZnKo3pmGoeY9WMrcH8kPbU+P
	 0nShmW8eEpfuh/3/zL62tKBfL6Xd8SXmlM2mjuG/NdS9dE6/0JKjR8NRJCpsqQlsVZ
	 zQgt97nqVkn746BU1185ncODrnsZbpmnYnFJvGnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Abraham P <george.abraham.p@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1532/2651] crypto: qat - force an edge when re-enabling all VF2PF interrupts
Date: Wed, 18 Nov 2026 15:46:12 +0100
Message-ID: <20261118150343.130348108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 159e91a50106b..0df4b398508eb 100644
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



