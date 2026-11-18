Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020400;
	b=s+NLK8v0h+5wHc6OhYMzHG5GhzKl2+unC2M5rC5C9jBKIp+pTvh7RCjrEWTFMNi4oI+k
	 j9h9R8UtuceU1w/oFWEtPoqT5dzKpHth1MyMY5/cc/d+ri3KlhYaJT3a2CTRlh5QQWUF0
	 TS7KuUt2IW74q8cfzKEPuX66XDTcd9Qpig6GFtYxra2IkWNRsVL9Xw1+FdnwTui3qgMKp
	 gW1oDucavTpL9b0mSH5MCZEhb1itFMqIhRt0+rE258w3TJucqE3rJl34SSoWLlRaVYmVV
	 OiKKllkL1tPGF9h5olMk6Tlq9KS3zxYrprEHLKF8iGyXEsqiuU7HcKNO0Q0CHvrWPqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6jBy4AmgTIpTlQogAw1EiklmalM2dw6i/0i1BMXa8qw=;
	b=PkTtHyXfHCcPWRq/ZqIUM4xOL7LGUeSNnDnZheDaqPUcYnmzvh5BixopBJ7ING63hfOQ
	 9hhEKvdAXUNNpWYD4Q41HdC+7R5MwU4C5sYEctd67HfLpioZO/stln6LGIyDtbNe58jNr
	 /lYmU+NfEmh9bxLN3aF6P2u91lUTTS09lXzlRBBewRGa1qlT20YTXx8EJF6vx+3MCCUSg
	 YO5d+U4qRQBuSHEOEFFl1rgYzeUvWTJRoz2jnboSiZ1rDw/HiG8xCrrptDQobb5unzcVW
	 FdaJ8DIdFTPKjsD7tF/OhSuMioSLouxjB6OGqgWabyAJ/a4rE6MnDkwnVvxYFPjKiLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pbkVDunB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AB6606A320;
	Wed, 18 Nov 2026 16:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pbkVDunB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A441F000C4;
	Wed, 18 Nov 2026 16:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020399;
	bh=6jBy4AmgTIpTlQogAw1EiklmalM2dw6i/0i1BMXa8qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbkVDunB4awC3LZP1GjGQl+53ZNCTmoL2vTm1eqAjZhAG4+nxDS+CkCjKCOxCuTSi
	 cpnQVT5AvtgLCim8HhgNmLXc4Rp+LYgkrEMFqkc8yT2c144duw+2Nb7xmbPdxgqWzB
	 a5Q8vAMf57DgKgqudmSXl2zQAgDmQ8CkU5ScNCwc=
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
Subject: [PATCH 7.3 1939/2651] irqchip/gic-v3-its: Clear vpt_page after freeing the pending table
Date: Wed, 18 Nov 2026 15:52:59 +0100
Message-ID: <20261118150356.439961099@linuxfoundation.org>
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
index 1bef7ecd3090c..4083265750b6b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4600,6 +4600,7 @@ static void its_vpe_teardown(struct its_vpe *vpe)
 	its_vpe_db_proxy_unmap(vpe);
 	its_vpe_id_free(vpe->vpe_id);
 	its_free_pending_table(vpe->vpt_page);
+	vpe->vpt_page = NULL;
 }
 
 static void its_vpe_irq_domain_free(struct irq_domain *domain,
-- 
2.53.0



