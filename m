Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062388;
	b=G67VCu/3/liEjWoZDWSq1MoXEHmdh9QspodHgu230TH9ZS0jtf9x4q0mhLuczaz0DFl2
	 /IdDBnMT4GjJnMvPr7mCQg5ALFjevJxPoMkW6k0LU9B/XiBS/1NBfvwP912ucMkIEbzD8
	 gG25T4Rpow6XEwF2cAwWMLyJjuE8LpveQyIJTSDZwhuTc59ic427d3IYsevZt7hq6ivyR
	 xg0DnCEvUMuB1q5uATjV3+uADA5LGtGIwlyPlGYr6O1LVo0u09E7g6Qu05EvqdAJxjjWT
	 x0t4PB4mmAaPGZwz3o+Hk4rH9hsMdkwhX2tohsVTB+U3q27Y+R/OuFYLfFEevp3xW4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mSHNDXNttT6VloW1b6CRlE8GXdswv8KOnrH3y2lRnnU=;
	b=T+DYL/LkGW75549UU94fhimIa/4eh8666p/Gd+ymqWrPe5iM2R5KmlGR6JlC6LtsLKI+
	 GALW+UEqa2LIoIAzOXSOFWsVbhevvecnHG5sYb725VIXQ3c8tJjHIhgaQ+CDKdNlWUOdy
	 p3ROtkR+jSePW+4HIPnzmhkeDzA3jKRrZMlTApa5PezRhIIrSRttRHKydfpgU8kiLzjOp
	 06bdCKURIiWeish3Vk2eD/KUpXxqzOjh4iBQ9y/ruBkajH28WSjlh74FUtBsjet8F8aEi
	 H8UopDoiavtopXRp2p/XM6v+Ni39kIZI3g+7VlXPVc7cHhpI3b8XgkPBnzeFqZJRM4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=se20a3BW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D682C606A338;
	Sat,  7 Nov 2026 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=se20a3BW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882F61F008A2;
	Sat,  7 Nov 2026 14:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062387;
	bh=mSHNDXNttT6VloW1b6CRlE8GXdswv8KOnrH3y2lRnnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=se20a3BWTWx21W4Ae2lgW2ngrH83sUjeFwE98f0Fgc2gK58JrkJna2L5yIDTXNf+/
	 vp9hC04o5w3SsxBayYT8KkB1O6CKP7bopCQdtCSjJ9LOTIxw9774ugkrxYwiudToTG
	 UDZljhkJzT1cr3puDI9iLrbdKZT4vleYpvomjNvk=
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
Subject: [PATCH 6.12 1307/1536] irqchip/gic-v3-its: Dont clamp nvecs to zero when id_bits is 32
Date: Sat,  7 Nov 2026 08:55:23 -0500
Message-ID: <20261107135034.504368687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index fdf8f1bd157ea..7ab93108c1096 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3407,7 +3407,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
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



