Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032019;
	b=W4g+pVW52qOADgfBusLROj6VXNv41m64N0S3TLQwPlgNBGzIxkWf/OBtfwaAa1eVu81W
	 XcPOPK2hO2RODJHtIzNRYBdxRLbLy/rcgg4KaESOPqhsj0RZEQ93RWuYR2WBUTGUHYsLB
	 eNL6BLwahs9u1j2bI9Dzya1uc43HtzKs0pl2KGBrQIO+T2AphAZzwjeY8/obUns0HtNTO
	 KsJ+Ea+F9uSr6CVH/iVrEWO/9AdtVUdCg9pVB9ifrixSVEg/GxK8aJSIl0sdmoGKjgU/M
	 IUgz74cG7sm/JXOscY3J3tdk3rCurZM7o/Y4BBd5DD63rg7+pmxv/MNsZ0rn0Xzvxwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9iQZ6TOsC+jzm8EP2pLfl7XJEjJJwXr946hf9Ha0YJg=;
	b=oP8Ay5zosWunSryCiI5qiBwakVMZUOZQ7ViDVWqGlhpNEUZfRZOG2pX8g44Snhe9Iygg
	 HENDSTx0PDWP5Jbz7lLKWp1AJBVQjkI2FMSq85EDYPmFmh90YRPwdMTWVyscV6uuGAOWv
	 p2acspPpFjpruhkPezleJbGFz1WFvRcjdLnFiXQRLT8efCi4VMY2ZX2DJZ4vtw837zfPC
	 gV8WpIQM+6ASvh/FXQksMEtT+kDcZsGHGpuNKL1Yp2724E29TaG06Yw78V13FjWJ5Y+ZE
	 4YDODOdngiMcadhGUawoLqQW99AJlh4lqtRE0ftFTLbwSEarvu6LES+9VE0doB7cFMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zgc3wsSs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE38606A31C;
	Wed, 18 Nov 2026 20:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zgc3wsSs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334F21F000C4;
	Wed, 18 Nov 2026 20:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032018;
	bh=9iQZ6TOsC+jzm8EP2pLfl7XJEjJJwXr946hf9Ha0YJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zgc3wsSsaMgf+hZP9wWawYOxlX5nw2YsYDl1ZlMPmxZsrZYSKRZaqZlbbi056p7R5
	 qxrB03rt98FYflp2ANESGkNqEpnzzd2fwk5Ti/JfeJ7BqcfZ1CNemq7ZKupql9A6ql
	 8mBQaRh0QBf/ttaGsoEvDxvprgPRd+FE2fYXsxMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1263/1756] irqchip/gic-v3-its: Clear vpt_page after freeing the pending table
Date: Wed, 18 Nov 2026 15:56:30 +0100
Message-ID: <20261118150059.946043171@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 0d604b1e4617d18dbb5573290ba447d7369251d1 ]

its_vpe_teardown() frees vpt_page without clearing it, so its
vpt_page == NULL guard only holds the first time it runs on a vPE.
struct its_vpe outlives a failed KVM_DEV_ARM_VGIC_CTRL_INIT, so a retry
that fails again frees the pending table and the vPE ID a second time.

Fixes: 325ff3e78c64c ("irqchip/gic-v3-its: Prevent leak in its_vpe_irq_domain_alloc()")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: Radu Rendec <radu@rendec.net>
Link: https://patch.msgid.link/20260908142632.2795308-4-fuad.tabba@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index a98acf21becce..c138796d792eb 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4514,6 +4514,7 @@ static void its_vpe_teardown(struct its_vpe *vpe)
 	its_vpe_db_proxy_unmap(vpe);
 	its_vpe_id_free(vpe->vpe_id);
 	its_free_pending_table(vpe->vpt_page);
+	vpe->vpt_page = NULL;
 }
 
 static void its_vpe_irq_domain_free(struct irq_domain *domain,
-- 
2.53.0



