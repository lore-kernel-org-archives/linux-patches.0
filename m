Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061742;
	b=KlEnZT+z5KvQVYwLxoOosbNJqpGk6if03J4JWeflougtVXVeNZURTpYdjHlQN83Vd5pc
	 9WvJ57l9dO7vGbn38ef88wpjFpGo3da/xsGv3GYb4tZCQHF0AL7qf/cWMk/IVcM/xRvK8
	 XzMQJsKxrR5UluXonxPJlB2OQUSF/VzTl1BCQRylIUxRaKypYEiTRewJI7HAAXvevG0HD
	 0sjpLCQ1afzFEH7K7c2PpiCZjs28Djmn0/ya2o2+GFMutrSjuQTK//B7kosELlgarqhFq
	 ymvGl3ijrPKdSJYBFFsmVjn1FKadSLvbiFMYBRPf7WXIA4Xj9bOZOcPwMlB8of5Ue7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7U8qz+5P1O+0c2z+glDhnOj0gOu1ur/nfzCi1vK7SkU=;
	b=kqz9MeMvzyzEfh0vfVo3Zz10C8ts8nvQlcO1ikMv9WhqA/KkEuhmn4vaqaUeu/uhHWp/
	 ebX8DSaeDoDwOG6UEn7uQQFIzP+PjwVtBg/+jXYQLPoaV7wRKzGTy1/xIhXHgAVZWOr4S
	 hfZYsUTTdQuM3U8K/hMHiYCGpMNPx6sohGiwLg9d8BC0aaC8p7R87kc1Y1cQhdo1aVC/x
	 maLX57lX9SCa9WoqZ4KLQZfXDOtzPwoIPUj+Rx/OvkMIdwRbJnGWzEAsGvx8dCsRVSYcQ
	 j/IxJqMX9tjF9u6BWHXjXGakTXWVH1HZm7l4P5W72AGurveBhVFxcnQj/Kb9A2n4Dyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqap1L8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B02606A326;
	Thu, 19 Nov 2026 04:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dqap1L8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7441F000C4;
	Thu, 19 Nov 2026 04:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061741;
	bh=7U8qz+5P1O+0c2z+glDhnOj0gOu1ur/nfzCi1vK7SkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqap1L8fIYEYX2jgtEcqJRaD2Q9kvJqbdiHnSounnlS7qqlEtzQ5dntBf6IsobMPn
	 Cg2+Fau5d8rPtgSEFvgur+WVNsWn8XF1rjV2rOD+a/8Fmyz8/tJTn4OgUuliLLxjNC
	 AnZLfbkpZ4fDCnigNSCzvPu7ExVxBijTjzAUkZZo=
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
Subject: [PATCH 5.10 1661/1848] irqchip/gic-v3-its: Clear vpt_page after freeing the pending table
Date: Wed, 18 Nov 2026 16:01:39 +0100
Message-ID: <20261118150029.346636650@linuxfoundation.org>
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
index 8b11d5f5f4058..7740ad6af91bd 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4455,6 +4455,7 @@ static void its_vpe_teardown(struct its_vpe *vpe)
 	its_vpe_db_proxy_unmap(vpe);
 	its_vpe_id_free(vpe->vpe_id);
 	its_free_pending_table(vpe->vpt_page);
+	vpe->vpt_page = NULL;
 }
 
 static void its_vpe_irq_domain_free(struct irq_domain *domain,
-- 
2.53.0



