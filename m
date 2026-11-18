Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045533;
	b=aR4iGPAXnwABW4o/8MvWpyZgrpcZWdOVnNjg3bxl3d6jWRVSwSCEwpCNqk2r0eLrXN7V
	 /iOhKysp02xsssg8ywNvEIEX0pr97iYopemhc0kdVJwtWzkaT6Xtli6+1G1LqkAiS2KjI
	 Bpu0I4CEExH3hjYKPjUlWIKbUxQzvxbXztBCebQZ+T08Q9RxRrx+UmsY9QZ11ZbF/Qte2
	 HbRMr4ZtL69yKu9ZRmzCbAxDBILqDvyn2ejAID9isjJeVBlVDQhSb3fZVll8jXMYJt/D4
	 z4ILyww2mlSJs5S+psOq2daZomnB+P+TNbpHREnkpklgq55WvVbGkkQaknKP39xULtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QRKaulJZupHxW1YZtMXQevXptX9rwgQr3XlzocnEYRw=;
	b=Zid852hzqbG0SLKAB4WUweuC2FKIMjs7GJerajSUHz2qv9Alc7c5Qysc6d8Hd49L0zLN
	 t1x8k1PCt0WanlXIirroHoQSpnG0b0UewyX+XBwj1rxcUASxYW7uMHDOIgSNHr5Sh2Nu6
	 zb9OZS5AMEZmVc3EePDeJktKq8TPESpeB91+yzkcSHXO4a9KsW8mbgxzPim/lRLBlFqqc
	 2g5u+URo4rukMp0cRhHj9SBzrzTdNE2EMJ/+M4bHZpkqGO7F0m3eJkYGQikJzLxPoQNWi
	 dP5cK5nbCAOqKFgXQiXpG896yjtl/vuN9mduANdUpN9gucxO74XNO8aV5SgKQk7kDKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZ0FDt0o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973B6606A325;
	Wed, 18 Nov 2026 23:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZ0FDt0o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECB11F000C4;
	Wed, 18 Nov 2026 23:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045533;
	bh=QRKaulJZupHxW1YZtMXQevXptX9rwgQr3XlzocnEYRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZ0FDt0oxagh6XokSDUDNZyhpOWtc7fsfSreBQ/48Oqa8Bw3hP3ad6LP34fNqrDcp
	 mNdLdqVthqqBfv92wUvGo8+L/tXR2wLbno2Bb8i9s08Nlan3FsMqq+FPzFndAn2oSk
	 7beyvrUei1FeWcD2E//LBZRyF5W4VJgyqEnCLdqw=
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
Subject: [PATCH 6.1 0958/2857] irqchip/gic-v3-its: Dont clamp nvecs to zero when id_bits is 32
Date: Wed, 18 Nov 2026 15:33:12 +0100
Message-ID: <20261118150236.096493556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 105b8e24905ed..b9138eda000b4 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3396,7 +3396,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
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



