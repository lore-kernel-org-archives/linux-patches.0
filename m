Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041691;
	b=h1yxCvisrjUBvfhEoWY8VC84gHKCavhIU7n7Se4J044K5ARfGxKDeTpOEzLzp+xhvtCg
	 /rkndAateqgZS8cVqZLCJcJM3Ely1vpkyC1iNBQR/0/+iLQHQyPDYeYkOQNdZUKtHpt45
	 wiyBnVAlI1xTlJGMMIwYV/fFkbSja7RkQQsP/CQsfV9dyvA6x1CZdI1fwolJAGgoP5hCG
	 JZT51wuNByHTI/BdgM5b8N1UDlXPu243xK5IuAz+88lws2f7Biu3sI5F0aQRgXybnoG60
	 Lz0LHS4lQyr5nQSQfnp6+LCBfh2EW2r/PoUSxV14PaUxFB/YDKfgi1cK7sCpqQYMnKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0qPM2Vnv6muDUJRmEtWlrhI4RwOV7kFk0D1CfuJKwOk=;
	b=bZJmev+2RStMSpusdrGHUkqIsoqGh9c5BGWSA2LHXY3u++kFEZK0Ffxak+qtzWnkc5AC
	 FMr0Xi8oZxxY21MMvJCFUaesZX5zd4R/lz/hrwOVUnwXX2SVhrmLUTKtqq7dCwg09E/Yn
	 IAyjyjDDeBhVW0WdIF1jPW1Pz5D+NBE5z6t2NZACoTKgjBNmk9AfpuxOCpZ6ymnIiAn1y
	 VeV01MyRyNh2wctRiCswYdrYOxbYygHEINY9z5MkGhXA1YBcuzIt76rErBEydxUo75blB
	 f1sTsto6X74mzGbBs2meCtSMELM1NCZfsSfqQ+v9ue3wtsaaNN4ZnDdg7DE8cXe/XmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKPcUUHf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE2C606A31C;
	Wed, 18 Nov 2026 22:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKPcUUHf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53991F000C4;
	Wed, 18 Nov 2026 22:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041691;
	bh=0qPM2Vnv6muDUJRmEtWlrhI4RwOV7kFk0D1CfuJKwOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKPcUUHf8VFUvgbsBpI55Eqxi/lQw3csl3KnYdpZVB/34/L5xLQXtPxQ8jUCBEWe5
	 aTyUXSrjXSMgpGJlys8hJGI+MdFXhvBgygzfFwDry7sWYTvOydhQ8AbR66n9luU81L
	 Nd5F67WqhJy6DNuvaPjHhgFY9SauZlkarmoxQkGw=
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
Subject: [PATCH 6.6 2905/3318] irqchip/gic-v3-its: Clear vpt_page after freeing the pending table
Date: Wed, 18 Nov 2026 15:58:47 +0100
Message-ID: <20261118150447.619374631@linuxfoundation.org>
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
index 2a10cc5ae4d65..973c6f96e7613 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4485,6 +4485,7 @@ static void its_vpe_teardown(struct its_vpe *vpe)
 	its_vpe_db_proxy_unmap(vpe);
 	its_vpe_id_free(vpe->vpe_id);
 	its_free_pending_table(vpe->vpt_page);
+	vpe->vpt_page = NULL;
 }
 
 static void its_vpe_irq_domain_free(struct irq_domain *domain,
-- 
2.53.0



