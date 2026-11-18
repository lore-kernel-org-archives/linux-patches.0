Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032032;
	b=LRcpS6u6it2KkAQZh5ylmnTH1av6os+Hi1KgDF8IhnIzOnLewOPUd+/I8HCs60rF2tru
	 UtEVwpZRuWdkhGvnXl0KHpN/PFAosE63xC5t3ql4JfkDigaiBkf9ohLAwBaV9r+s2JIcu
	 f14TmHzL4p8ajLU8lQqbLZ3EQPGmAo1gKKO4HL/hG5dlCk/zowC7+ZE1JCftJdO5QV9Rl
	 sjN0SuoS/mOiY2FWN2DP7+1ViuabLOFe81tNrIFmdZ7LO66hRb4oIf36iVX+rOkYE3xrW
	 I/HlEsVOYubw1VGNZ/wcw3GNAzKgCkYsRr4jY4kQOVQRd2+d0KrW26fwQ8UXng09t3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nloHG0kztwmhLlkWWtWocMv4EOiZWeC6Z7HZtTppsY0=;
	b=MtvKm7iixsinhgTSbsD7vX1J7tLcFEZlORfAmUa5hjjFRqyzXRD6VJAaRwaqhYLdUUmx
	 hj8P3n375To8II+LdElJCr/RJbxDW9Ob80TeNf+VOwwJ9Yy6nicci7T8SRp2TqkBFkWDZ
	 IesQmEQZ7C6Plg8Vfv7VlrR8TWZ7wMf66zqQAmalbiBOrauAc5Z2FGpn+8vtEFz/l9Yg8
	 tyUeNqirW2ZbZ4jIPmm06dZWyjn42wc2Ec/bNU6QJ0WHevDUCW4YuvRlT9re1AEy5tIcQ
	 cytpzZ+bjQC9ZRFU6XRI4S1mdLsEeRUqtCFKn31MJIKex7H5pBn3JR0wv+eH5U3QGbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E5c/Iui4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981B4606A33D;
	Wed, 18 Nov 2026 20:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E5c/Iui4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9FE1F000C4;
	Wed, 18 Nov 2026 20:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032032;
	bh=nloHG0kztwmhLlkWWtWocMv4EOiZWeC6Z7HZtTppsY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5c/Iui4STlinw8dJuLbm8A42gS3jn7uPx5mRnGm/ytarzwItVmRXFyq6tUw4N2kT
	 YPvhmfE1HCwy6CorEYcQSoVn+Md8cYbRf3XMMNvzw9emr1y0O7ajFuRNh6kj7iAL9i
	 0eIP4jfK13gTCdMAOuXkEszdMCLmN1XmWrPkNG+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1267/1756] irqchip/gic-v3-its: Dont free the tables of an enabled ITS
Date: Wed, 18 Nov 2026 15:56:34 +0100
Message-ID: <20261118150100.092804167@linuxfoundation.org>
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

[ Upstream commit d09b36d8e0e60f35bd1cd7d63aadc6dfad61700c ]

its_probe_one() enables the ITS before its_init_domain(), the last step
that can fail, and the unwind from there frees the tables and the
command queue without disabling it. The kernel comes up with an enabled
ITS pointing at freed pages.

Enable the ITS last. Nothing reaches the new domain before then: this
runs from init_IRQ(), and the ITS joins its_nodes only after the enable.

Fixes: 4c21f3c26ecc2 ("irqchip: GICv3: ITS: DT probing and initialization")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://patch.msgid.link/20260925085000.753400-3-fuad.tabba@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 298555efd5657..d1d5acc44190a 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5315,16 +5315,18 @@ static int __init its_probe_one(struct its_node *its)
 	}
 
 	gits_write_cwriter(0, its->base + GITS_CWRITER);
+
+	err = its_init_domain(its);
+	if (err)
+		goto out_free_collection;
+
+	/* Enable last: the unwind frees memory an enabled ITS may access */
 	ctlr = readl_relaxed(its->base + GITS_CTLR);
 	ctlr |= GITS_CTLR_ENABLE;
 	if (is_v4(its))
 		ctlr |= GITS_CTLR_ImDe;
 	writel_relaxed(ctlr, its->base + GITS_CTLR);
 
-	err = its_init_domain(its);
-	if (err)
-		goto out_free_collection;
-
 	raw_spin_lock(&its_lock);
 	list_add(&its->entry, &its_nodes);
 	raw_spin_unlock(&its_lock);
-- 
2.53.0



