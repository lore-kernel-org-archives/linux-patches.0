Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058546;
	b=pVxSIoQ3JdWAiqlP9tcyGFWZovW6vsNAZ0JqO0BP4JOuWO2XUX720vL1oDSjkqSpGP+Z
	 kCFW8tYp6JQvHYIY1ICMaQwaSJpxROSgA5akCLOa5nlDRLTpNAQJU49K3Rjedk/irx6vY
	 vktFnP8ggxnIiPWKfFz72IuEJ3O1VQWbe3wRoJMfyYgOu94TUFWS+oGq3Uyv1yqpiZYL4
	 kkDvIr/gJE+jvPNQhWd4Husole/vPozA4BkzIrsTgQZjvJRXcw14Kj/V5mrbaIlz0a2Xa
	 NS/CKUoOTwmlifx/nddTlFE8FUIqtnRgTLg2e85Za011KNJzGLpm4+IFU8pDI+v7WlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QgWXbEt0014eqxmGEjvNB5dJHPFyUf9O4LBlhhF6jRg=;
	b=wVUK13ROK6V1TJamUUqV2bkmcDW1REJHlXY4VIv2xGBj5yi2kEt0yLREYk2aT3Xhfg4T
	 WVO2m/+obDPJ1G3KplvqRlclHHtc8h5M8XrWsTh1SX0Wct9uDlCl1tJ72xx8RB4GwRHnG
	 DkGDxdM/IMWnPbsN46DnZH4LNlHigiwoP3ghyNEStc0WWPqXrAZyGweuLLOYxGpW/u8cs
	 aLAhQtYp2AvT4arGwF3UXKTUh/Y2bnkDHMjW4l2F/npDdGFTIcYZKGTnmlA2V0CSqHcKy
	 kye3BrfdP+ngrruigYhn/Lz0FnDkLsUe/YiUpmmlCZFUGiKWnUL7JSLzk4tjOFGOOoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1bCGG9L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006B1606A335;
	Thu, 19 Nov 2026 03:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1bCGG9L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C51B1F000C4;
	Thu, 19 Nov 2026 03:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058545;
	bh=QgWXbEt0014eqxmGEjvNB5dJHPFyUf9O4LBlhhF6jRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1bCGG9LEvfNiz2rHetdRKnarMP9OejHm478NeT4J3v8BYOKHgB5tq8bB47Mtbe6R
	 stpe1r4dmNeKWUlJGFn3ydVgFJtbjhTsEbeDQd9okN2z39eTV86ARKXfjtogdKc+GK
	 A3Kq7PWYrjq4Tj1sb/gO81QTesdHsLK4D1amXcb8=
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
Subject: [PATCH 5.10 0523/1848] irqchip/gic-v3-its: Dont clamp nvecs to zero when id_bits is 32
Date: Wed, 18 Nov 2026 15:42:41 +0100
Message-ID: <20261118145936.672238291@linuxfoundation.org>
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
index 2fd553bfa8f80..cd165d8d0c0d5 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3398,7 +3398,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
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



