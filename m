Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061766;
	b=h3ArKUCkEtQ8Vv5i8DZVvyhm8L+Gh+AJeCKoEMQvOf6L+vui1mu9hgZpQ7J9fgzlPq5t
	 6WvroUe9DselJ7oVjprPnFWrAWFXoC6d3r0XxGgm7YTh3YwvmYwnnudVdRhDznXF4hmDZ
	 4dWxLMeG+SReyOrH3G6WtmGIW+7doSAEPXBTTPWg27gKe0N7zgY8Ueg/nFvYQr9TYhz0b
	 GmKTwOmoLH/tAiGdjLgdbADgZf8KWwH72mSjP1RUOui3Y8JwtX7Dz4dFFAu0TT6Cj6gbQ
	 TxfbqI+spAUrEO5eaiM0iGNIoyB4TMJBXvRBgGEuTaf3sm9b1SDlwSMQQtkSgc6T7rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qCWIRHERQxXC2vQrXbKciLaHtWmh6H4we2+kC27OPIY=;
	b=z5IeyUyujujDJ+Mr9XpPC/s2QjKgo11EI4j8NfdQx+C9HXa+ynNJZGng64TOExbCRpv6
	 bQp1D/Sjo1oCBKtUt0I7aLib3A76uxRh8SILbQxikEpiTIt26wwpq+/6vp8iq7BxB99Vb
	 Ox/pmsB0Beg2bjb+2xR7J+Tp5n4bS3wXmeJaW8tlwrw7vqiRCRm84T7YRIvtHiQbgej00
	 rqtjQkv8R2VQyp2xnjLCCQ56D231kOU7rR/DVSWNeWIlVLgdo9VmGkIyWTsOJ1mN8HV4Y
	 SWC/4gkCqlR1jSRP4JVMMDwicyJYZAZ0Tu/n4CQnu2OFWF7dAGbOmSiZ9jtXrHDvZlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+Lq+rtk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D574606A330;
	Thu, 19 Nov 2026 04:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+Lq+rtk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D191F000C4;
	Thu, 19 Nov 2026 04:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061766;
	bh=qCWIRHERQxXC2vQrXbKciLaHtWmh6H4we2+kC27OPIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+Lq+rtkNEklYIW3YIyCCi5h5p2Hm8JNxo2KxHXY/vev6x09kHw0Bdc2eLlo52ENv
	 V1439J6HxmIOPuMrIB2TK4C8m7jp7Acd4DO6Nu/N2G3qjWYs+GQu+saTvnrn4GxVF4
	 LNgGJC1ynuOTmjRDF/+ySRsuUDl5cQnz7EaVz8NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1669/1848] irqchip/gic-v3-its: Dont free the tables of an enabled ITS
Date: Wed, 18 Nov 2026 16:01:47 +0100
Message-ID: <20261118150029.702717759@linuxfoundation.org>
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
index 8db6d5462de79..830bfbf1b14be 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5186,16 +5186,18 @@ static int __init its_probe_one(struct its_node *its)
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



