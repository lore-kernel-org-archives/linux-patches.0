Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056352;
	b=T5pPZvGFO1/mKPS0uERUxXWbFBKj8VrIZzgKgozmYWlL1xDS98EsGZEq/3oRQiqpqp/l
	 noood8LVXSzeHic4Bh03FHVIdGONq6hSvedvsH3ZQ/fkxnyj99CE+wpMxnFIKEg0LjNrz
	 aqJxjRdrHP8NEWyjtaEqbKioC+iVfPiAMshRSIWEIkgoB59QJ+cZW9+16NbqbuPGiKjWJ
	 be2TGe/nKUH2dF8MMMyYXL7k74KbleNo22/gBhQMDTAsPHJCM6FFdBtawOstVFoYEuXP6
	 4BXfh9q1tNRqQDBOoaZETbtyHehXcLYrtb6yZig2bfx1zDa53Yp5C6srIaUBo4QijUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3bTYuysrOXAlYEgAmPWrIeQ2UHuH/XoTuIieQ4AtJzI=;
	b=nptEAcnXCGEsxr2x7CYo2mK36IoZWLA3JOUb4t16AlP3dPl6YFil7oekv/HYLaa0+q73
	 WPVdGeZCqdTQF5v2LUNL/Mydc3z8Lz4pMdC9uH1g8fQiXjZ7BXKJIVV8DZgLn4wAOtHWD
	 UnCXU4vxyXI4fMthLpb7lk49TMPHqZBx+zrPlPBYiV/FsgFCIQ0GQdu5KMqAxOKnxAj4y
	 Tni5Rdc2hHtNmtQThlSK/QWeeucCkTNIyMFMw6O2XtY4kCaO8wvljUkkfMT0bMJSwHP0Y
	 RjlNvaEX/IK3MKLTtTqwHqBWmElqV4eCAWFbEBFhk2eCdwv6laIhTfzQFwtyhTp9AhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYMPvTCC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF84606A31C;
	Thu, 19 Nov 2026 02:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYMPvTCC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910061F000C4;
	Thu, 19 Nov 2026 02:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056352;
	bh=3bTYuysrOXAlYEgAmPWrIeQ2UHuH/XoTuIieQ4AtJzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYMPvTCCio5A+7yasSlcKfuSMj4uWgvHDyQTXxvoPTqTXsH51OHA0vmgIfxY2odKb
	 wkJHAL7v+J4cg2+tVsvEdVxadEHcLLzPVjq4ru4zuUc9cGgCl4G/4TVmJhB5uFuXDf
	 TRdbu3Yw/0RHOc5L2C/3fgBw7r6lXSdXARf7vdoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1958/2214] irqchip/gic-v3-its: Dont free the tables of an enabled ITS
Date: Wed, 18 Nov 2026 16:00:34 +0100
Message-ID: <20261118150129.292088602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8dbde5d4ad719..88f92ff12d8af 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5213,16 +5213,18 @@ static int __init its_probe_one(struct its_node *its)
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



