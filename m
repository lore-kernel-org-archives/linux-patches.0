Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041699;
	b=YWbSpaoT4sKQIJ/B+jhkvLgLfJj/q3FDyyIi051FPwoQ5k9wWJJyzKUFBtV8XtTPv1kr
	 ixBXI9PbEOhJdexzzYgNbUF4AonUT/Faycdbbo2XwECtfHgLPgdVn3juAQXfbZCW4WuIo
	 0AuoaqHMZ1A/gP4tLLsfBLct+DwawCF9uy25mOgZNpL19z6U0S9kSB/A8IWhdDYXhgGNK
	 bmdSdfuBt7AB3NVPg72xGV15xa3djTA8hHDT/knbddh/N8IpvxY7O4eWQ9tO5gpk6bRc5
	 mG8c8QV6ECxuygP68FW2jafq2SMuS+PapkR7UszzgdOPLUiqKQgwUNRIUE4KT7moAQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ksRv0mjE9q6RMHdjyAkQvLXhggWWJLtNvDkrv5/Rozk=;
	b=QatpjEskvQW+tG1RscqFHsiT/O5roWRO7SEzGnxTLLrxsayEDRTyoSFfGzEMwi4nmcNx
	 y7s3rw2ULvrhRZ9p7tFLcX7UkV0/x01k/6OIRT7Umz6013GlimJY5c5eVsVfgG9gCc544
	 L0eAnMLmhSH+YQ6vKx+sdnwoX0ENccGpipqkQkmbG3coFTqUfivrXb2ke+WVdrB8Q7Jcj
	 iaSsjN08NPfuCWIUAT52dcLTPfeRHePjoEbJ7paBwmDOFgZ7f7JH9hzK7KKVIG9nn6ewF
	 vahBrhyt0l/xcYFdSETxUW8VQgKxPiYvwUy9ZUSCGleF5KqSs65DAtI+cIdxO/EGDvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fy5eCQqW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7FA606A31C;
	Wed, 18 Nov 2026 22:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fy5eCQqW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0616D1F000C4;
	Wed, 18 Nov 2026 22:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041699;
	bh=ksRv0mjE9q6RMHdjyAkQvLXhggWWJLtNvDkrv5/Rozk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fy5eCQqWwUSmgyWyO8ySJed17BGAiQMBJuCJxnnFuiAnAlM6ipxMcuCvQn83JUFco
	 ff9bFsG9jhq7CtYT3viX8VX6vg7cHSU3d5BrGulBowpGLqNNsbg9wo+DGWQJW1J+Dl
	 AGzVofQmFbLuwUzNn9ZN+cVxzO3zEfbMkTqbZn7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2908/3318] irqchip/gic-v3-its: Dont free the tables of an enabled ITS
Date: Wed, 18 Nov 2026 15:58:50 +0100
Message-ID: <20261118150447.699916004@linuxfoundation.org>
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
index 1447d91cf6f7f..bf16e8f11539f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5263,16 +5263,18 @@ static int __init its_probe_one(struct its_node *its)
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



