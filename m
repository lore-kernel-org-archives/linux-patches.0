Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052663;
	b=ySFRRDXOPxNMAps2XQakaKwEQK1OzxiYzrO2xaBHks9Mqrini5KL0sIajvepHe+b0KhU
	 jkezXhSQP6nritOcskHeor3607zmEqzIWV5Adhys2d65Y2drkPUwlBkOf3JI32KdpZVIM
	 MysE0+ct/b+QtU7eB3OQENVYhWqQ6pn5l2rTy5lL96wDYNISd0//KxaEpR/iNtWqgJzpu
	 P1G4wdnBX/wiZvkQn0+cGfb/7G0zfmjWB1JubZ4PrKvD1tOwpTWkYMOXV6PFs3U2d4uJm
	 gNL+9OaqLfgsm8jdoqNSZ2sDr37CjS66zxjVIyZbSB909C5UwECDjJia2hLfBDa/nxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lTIhW+jDXBTbX4wf8B5N1XUPESnl8w6vglZHpq2RAtI=;
	b=dG7RiXjJoOAB0IU0b/TbrYwJucCFkiNUjiDyQD2BagQdYdvMEUyxft3UlOgrxKDtYDT3
	 97Y5fFvhNrKJrtxL3KxmgSF1Ans6t6u1EHR6EmbVUJMjVLaOsSuqbLICAJCsi/1kIk4We
	 2+4tQcgzOAiVEgF7Vui6WaGgFufEfL/X6KORNKma0Z2+DDHNwd9vzOessc7uXRvrl9hO+
	 uruL5xMIJL1DsUVW0pCBZXuVubh8leoDDDdClhSHtHlR7/2Xm1jfclli+PTGCamoWI2aT
	 cFc/Dx0YzQeTfw81tZlngIcoRZ6o2qvdGIlI2JgSL+G/ixGZI2WJpWz+V421l3N6ChQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ihxOzuQ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836AB606A320;
	Thu, 19 Nov 2026 01:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ihxOzuQ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F4F1F000C4;
	Thu, 19 Nov 2026 01:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052663;
	bh=lTIhW+jDXBTbX4wf8B5N1XUPESnl8w6vglZHpq2RAtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihxOzuQ/kVswWoS3X16f1hwdkCI3oirRcDXVhZ7ztthrNJ2VZXT2C13ZEan2cmsZE
	 Do/vR+I4rti7/fvWxeZ5MY8R3i9FnAbZaAHFhLvrqMvLomwF1NFMD7dh9AwhbT3GJ/
	 6T+cqctNs1S5g2CxfR+BdqOyFmWPX32jljPsxyQk=
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
Subject: [PATCH 5.15 0645/2214] irqchip/gic-v3-its: Dont clamp nvecs to zero when id_bits is 32
Date: Wed, 18 Nov 2026 15:38:41 +0100
Message-ID: <20261118150037.130620681@linuxfoundation.org>
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
index 297c76cb6e054..9e857e2b5985f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3411,7 +3411,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	 * Also honor the ITS's own EID limit.
 	 */
 	id_bits = FIELD_GET(GITS_TYPER_IDBITS, its->typer) + 1;
-	nvecs = min_t(unsigned int, nvecs, BIT(id_bits));
+	nvecs = min_t(u64, nvecs, BIT_ULL(id_bits));
 	nr_ites = max(2, nvecs);
 	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
 	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
-- 
2.53.0



