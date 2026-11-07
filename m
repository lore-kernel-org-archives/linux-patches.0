Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064872;
	b=4h5f6pTfVSw2rx2jTXGMrUjRnbT0kw6useEsEuharpDCJ8f8UXpZ/lmFtr7DYa2gmAV0
	 aWUpRftU7vqHxellgdCjHcPYTzp6hSRAjRBvYWLeThrIU//pvwRzSDPTBqlFhX478a+P/
	 QxSw4W98LKGUL0B4cwBLSi/OOJmKLzVMZrf17L9IXobHAZYMhKzIBxlTo5tt+/VPIiJvb
	 TeB2oEa7A95xEnC1auhJkq9O4T48jmekTHp7riMJjCO12tXWJsAqiEC7eptSIVc16BIeg
	 mIeNs5El2/VLlSkGL83HaMjKwk4y1rLLM7zuHJMQXQ1CqL7R/FlmmDpN8mz8fOXj76w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kyZSBbCGNgwnWEAEc8ANuGKIWHqfZerSczITiL5RPBc=;
	b=TehkyBnUdySh5bEo6uxTCz3Y0Bmj3cicwJN6pc6M7BApCaCtck1gVzHJ+J8HtVuKiF8d
	 YrUk3dboBf3g2v57pRzJVfjb8QZHWL/EC42iXZ3+f8Ediu/khZ2ArgJd8GWrUHNe2hsW4
	 g1aQRi4njB0D5AqlcgB5h2C/wrW1gJ6Vug87xRLMA95+PdnSAbxAsS+i9Z+HR+me9rWKS
	 /15pcUWhc244sfSwgYZhkmR3l6S5GKx0QtwAF52JVV3qpagP4kygIBqE/9Ynqe63g/MWV
	 KFh89UOY8vejovuWqbPEeSwHZrZLS77MItNTf+UAtgrCD/fY5iW1USDDAKg1iP2ji6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvVvI6e2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17606606CE48;
	Sat,  7 Nov 2026 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvVvI6e2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CF31F0089F;
	Sat,  7 Nov 2026 15:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064871;
	bh=kyZSBbCGNgwnWEAEc8ANuGKIWHqfZerSczITiL5RPBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvVvI6e26MdrfLYqS6cdkXNpkKb3FJsFmRQ+ZE/0HqOU56GyVeWnrbzULMxT60fex
	 pCI9lO9Toulw+N2OsEmLdYBfUJxlaEbgW0U/6rDCdeqfwoMKqck6bBrbNPQPobIXYH
	 rUwzR2Z/9/hoM49kxbJ2MLie7LwDmH7V3lBBQDGo=
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
Subject: [PATCH 7.3 0787/1257] irqchip/gic-v3-its: Dont clamp nvecs to zero when id_bits is 32
Date: Sat,  7 Nov 2026 08:51:23 -0500
Message-ID: <20261107135001.056856260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index e9807af235373..81a96149f9154 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3484,7 +3484,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
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



