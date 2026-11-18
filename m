Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049902;
	b=v69HFqb3+ltGuVO6DFtdzzjzwQe53rmDmTkdKAsatUbckepg2dQaMg+GpUrfUECdOjgH
	 gEUzA0axsUG84mP08f26Pb6v7pIZJaqFxGF4FmSCOY0z7ujfQTG/6WIbvNecRzq+qrAEq
	 iIzUhF9AaebJHSnbrUUGgZiCoOtrlybeP8WpLFvuCaxNOgSaZK/fObsHWDUnlnL+qVjpM
	 oX6kYnrTBDIpEwWYU+nckFPe8GYq6pvRATMQ0bULibSsTNeJVZ6XkqqogXVgDhF8sftOv
	 7Sv3//B/k/Taz9NRGLrNUxclf0YQNooqsVsFhNGqI1uX9RI9ef3cx8u4V/Zb9QdseXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k5n3CDNEjRzX+aYXQdLWqbQ1nipcMmSWTRGsajNI5Fc=;
	b=5V6G1hkoZzGqv+Cizvwn30YTOQCk3yWQUJFNQtb7hp0YePP2i+BEr3Tj0ibLpW9hadCn
	 HYMM24JDLKN6DiZYXgvQPV+QSmg9B3ETV4U4Z1ymTtTfODksfrLmGjAqAwiqx/glQh/2g
	 BnjGE0UwCAcPSzJCX+MrlJuUV4vQEYnlVOhJ1Ptwu4sfWgNzIOvf5MZ3WeUYDzI8CiOI5
	 CIt/V8noRUjpmwBVHAS5zgcVxkkAHEiEBzezOJTaivnGHgSGJ0IMrOd0/f8bzQmAEu5FL
	 pa9fgiixqsRfOBuTad7VzsWsZ2XA9IXaeAotEizF5uhZf8aTS5Vs5GmXp8JpC3fYGMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgypFvws;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0578B606A339;
	Thu, 19 Nov 2026 00:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HgypFvws
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617311F000C4;
	Thu, 19 Nov 2026 00:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049901;
	bh=k5n3CDNEjRzX+aYXQdLWqbQ1nipcMmSWTRGsajNI5Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgypFvwsjCilcFVoieri2VARlFh/Ufwe5OKtS7Z1Y1X+XfXc0BJdeQ9Elc9I0JfYK
	 z8JSzYFxgoC/pdkFcO89znDUTZCNJizhFDylic1BkWUnX+Xs8Q983185FVWyyRqIUh
	 axkjBvnx9vIkH5SlS352UwrDzbZb14vetKQaZdFU=
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
Subject: [PATCH 6.1 2517/2857] irqchip/gic-v3-its: Clear vpt_page after freeing the pending table
Date: Wed, 18 Nov 2026 15:59:11 +0100
Message-ID: <20261118150332.171465157@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d1e0c4af03c6c..63ae7ab1ab975 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4460,6 +4460,7 @@ static void its_vpe_teardown(struct its_vpe *vpe)
 	its_vpe_db_proxy_unmap(vpe);
 	its_vpe_id_free(vpe->vpe_id);
 	its_free_pending_table(vpe->vpt_page);
+	vpe->vpt_page = NULL;
 }
 
 static void its_vpe_irq_domain_free(struct irq_domain *domain,
-- 
2.53.0



