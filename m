Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063406;
	b=c3HmZ4NOzCGZW9qwbkdilcZknfx1dOEHG31AmK9K7A2NR1acTc+pa4D+ldwaCRHTLAjj
	 xM1mvgEPMuxiWrHf4RZICbVAWmNHNLaRoHkQTm5rH7rJSLekCzxgce32FL8L5ZkwP+r5n
	 v5eogo51x39MVI2pjwbAMI5pdg3oayRhFhpluVx7pOS/WyDTjP2tMD0chR+WAj0VCqgya
	 rlW/gfNOdfxX1rBcl98w3qS03yoFZ6Z7mQmQ7NOVWuovdohLl6nPK+XLsW+OYsI+hIM+u
	 4uQ7vLz+LYv40vYXRxE7VKjcJ6B3VBszu5aERTZdKPVmkZnFOWrDGDQRAvHrZAhQA8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FDJ6nMImWKbuUMK7Ez0WGtoKDMRORAl8TjLm0x8H3gw=;
	b=ffodMiTLghPXKEeOMthCc2j9WLgsG424qxXAefV0k64vQyrRVKV7x8BZslNWaAkLBnLh
	 /NHj10Ukpurvo5aBXWMLwcAPnRNkPU0cPQEq3sNrf5287Qp3oIMx1w4GIcwYEnhvZibXe
	 97psZjOa0cKgfkG8mQpjuZU8b21sxVz6e5Gb4RCXnPL4hf/JGH/f1T9F8K6/S7ybD+myU
	 IRDIBvGYKC56z52v5t0jFw9ihGj/FAMXzu+ZNK4nL+zrueyNdL2mZM9Y3u4n7xVVoGeHk
	 +IRPSvGkJuHEsmIVn6XertD4kMCG4w0vA832Nstfg2c/fgLKNEQmM5PTDAc7xZJk6bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTZfXGn4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBB8606EEA1;
	Sat,  7 Nov 2026 14:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTZfXGn4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEA41F008A1;
	Sat,  7 Nov 2026 14:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063405;
	bh=FDJ6nMImWKbuUMK7Ez0WGtoKDMRORAl8TjLm0x8H3gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTZfXGn4FELlQL+Lzb+dGlekF35Bo53+nFhVc2oF4aMevGjonbUK/D7ySUQCYoYA5
	 sqEaUOayMenoQxps1o7Rh1Pe6yO2MAbI7T7xUC8ulv+uA4lDIplAuwEtIwINMZD0mB
	 y1XwcdGJjlTHyWd+2jMBbqnukgzks87V87HklPCc=
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
Subject: [PATCH 6.18 576/869] irqchip/gic-v3-its: Dont clamp nvecs to zero when id_bits is 32
Date: Sat,  7 Nov 2026 08:54:18 -0500
Message-ID: <20261107134912.738552554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 5a9d62555e7164ec79a5fe70153d79cf1fdfd614 ]

GITS_TYPER_IDBITS is five bits, so id_bits reaches 32 and
min_t(unsigned int, ...) truncates BIT(32) to 0. nvecs becomes 0,
its_lpi_alloc() rejects that, and its_msi_prepare() returns -ENOMEM.
On 32-bit ARM the shift is undefined instead.

The clamp is correct for every value below the maximum, so only that
one value is affected.

Fixes: ce9e40a9a5e5c ("irqchip/gic-v3-its: Limit number of per-device MSIs to the range the ITS supports")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: Radu Rendec <radu@rendec.net>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260908142632.2795308-3-fuad.tabba@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 8607ed0d98841..4443bf46e390d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3488,7 +3488,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	 * Also honor the ITS's own EID limit.
 	 */
 	id_bits = FIELD_GET(GITS_TYPER_IDBITS, its->typer) + 1;
-	nvecs = min_t(unsigned int, nvecs, BIT(id_bits));
+	nvecs = min_t(u64, nvecs, BIT_ULL(id_bits));
 	nr_ites = max(2, nvecs);
 	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
 	sz = max(sz, ITS_ITT_ALIGN);
-- 
2.53.0



