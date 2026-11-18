Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036604;
	b=4nOaPhklKOs2o5vSVU5VqeLi3IsyFCHEXzYYlJmioejKUR7qFlclFKff+bdCcZbtMDsP
	 qpOpTiofQHkh5+OkThnGH0GZY1a4DYhWkQ5sYmBlKXELJCExE2QrDUe6D5pLVjmF5D3TD
	 gEX9GTAELfLyPdFKiarsgJmKLqnSayLlLmUwpgJeZ/btLxFUevOdE02aAzFqqVuOkAEOE
	 MFmkdWjnwzv4HDkgbzDv9/qxiT8VpQi70+SYz2a6hxB+qf4FmF1GRITn+vx2W4L03Y7gh
	 /NFEfyu+BJZbJA/Uxxp84Lac4FWKsEpMbsndaCmeHha8mMQY6F1BAAJ7fF8xbtsXaUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C1lzGOiLs4fNvwh79fYHAZvVuq6oW/vPTRMn0U6MZRw=;
	b=eh9XCXwfoqSh/R3Zr+W3xmN83Yo6KAQ4CuSNqsg1h89hUi3r0ghYLp2KA7bk+8ycDn0B
	 lw5LYxmvqGNiPVTcZnZsf7urTgpSPWhVJdTrtMxOYtzcd37zwbEFLWhjkFOCmybjyv1vM
	 y3joqWFfGeSvoKc8IAPbKFRGBuOdnUh5ssGqECSG+EcpNY1EjU53N01Jza/XAqsNdzwBe
	 0KKYnpQ/iQGzjdPNBVSue1oPJBUPISb8ZG28gjA46+atdEypMZ7Qo1Q4TQHvpDSs6/VbU
	 0NF/KxkPuHIJjWugodDqTDsYsQf4yaLuugPTp1H+lt3tYzcz61yKkPeqxs4m+zr8O/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZigJFM8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5496606A320;
	Wed, 18 Nov 2026 21:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZigJFM8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3875D1F000C4;
	Wed, 18 Nov 2026 21:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036604;
	bh=C1lzGOiLs4fNvwh79fYHAZvVuq6oW/vPTRMn0U6MZRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZigJFM8AyvSXWglH6UIDt5MV7I3KaiRGNQ8A7pZ7PIkjYZk4EromMOH+7xXxS1lJ
	 f0lxCL06+CpP7R4/s3AKHZ5xLrEJgkxo5BFRS+JIt14J4zIkJqyvrY3IwjFebPbRik
	 bww8r1KtlcCIyHzldrM0Ut2owuhEq72dA3DtsX6E=
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
Subject: [PATCH 6.6 1120/3318] irqchip/gic-v3-its: Dont clamp nvecs to zero when id_bits is 32
Date: Wed, 18 Nov 2026 15:29:02 +0100
Message-ID: <20261118150353.629483126@linuxfoundation.org>
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
index 592050e0246b9..224319b4eee6d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3416,7 +3416,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
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



