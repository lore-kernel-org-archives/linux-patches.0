Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035714;
	b=sk62uD+OPVXuRu5gqrnqeG/J+J8oHT5L4CittWl/4PNWqnnnd6FlJUnn9JPznEefMqDq
	 OzQwCPsk8ekQP8NMShInNilteMoDxP183bZoSdnjhBPOMHRKeRDSDIqZeF3krSB8hMDPK
	 hAc/WQf5QQYqLhGmGh7tYg7Oe0MIRzkPwihwJa/zzlcAh8Nvu5bOnTw5mU6xpSmKaTE88
	 FKYZEGdJjlDyDSULDzN2RoaqCOfcdv7r4CtyT6JEMp2IcTsFqd1p93d5/J3kvmnuonKs7
	 yDDqcxQNlfqVRlUuuuRl9d9yLebPkr0drISUwamQ8lGKRicIz06V7WCn76aU/H0eepQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GA4/cb1FPuQnJvvHXVG4PwuUICG3UozIKoQCJ7a8f1k=;
	b=MkrYicsUDENrcIMa5CIdNTRIIyh/ax7IkZSxiOHjc/kniqUkUwbmeaCJvuiK/KUIKW15
	 jxa/ytusJ9PpDb54uSHe4EshOmzaskpWkjejB+9Gh6EijguMGlONEwq7OUEKmQY+UVGnp
	 qiQz4iyOjGGmATpzq+A0x/iD5r+4s9Bm6SkmfEunv3RrlCd1K54r1hs5daoR19+B3wZG4
	 +2fYvTPkGjNumKIb7UjwTN4zF4Kl+BOq+XENjdHb5u3Jif1P3Y2RTN9CJoyhcqmqVplw0
	 x9ehdD9mmHs0mz5HwKx5FfVvf27Zo8pJJKarSyWW6JSNymRJreq6Ny1FDdoaWT1kz2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROxXqmTA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F250606A33E;
	Wed, 18 Nov 2026 21:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ROxXqmTA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEDD1F000C4;
	Wed, 18 Nov 2026 21:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035713;
	bh=GA4/cb1FPuQnJvvHXVG4PwuUICG3UozIKoQCJ7a8f1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROxXqmTAhHLCif096mB/6A7KtNTF6jN5Nq0X+5D6tgggZAYIDds556y/GTgKea91o
	 lpcWlp5Imq6suXyFG1HRU2ZT/qnqesbeCmrPAh4q78u3NkPi4O5Ey8ENORhymskVtU
	 y9qnOwE3NNlmatfhk2Byx9aT5fpNr3oxX9Yxrym8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0802/3318] media: meson-ir-tx: Ensure clock is disabled on unbind
Date: Wed, 18 Nov 2026 15:23:44 +0100
Message-ID: <20261118150343.004166330@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 1517326fcc9dfdb9acb24f42472366ac1b4b8237 ]

clk_prepare_enable() needs a call to clk_disable_unprepare() on
driver unbind. Make it devm managed.

Fixes: 49be1c78d575 ("media: rc: introduce Meson IR TX driver")
Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index 6355b79893fb2..2ecf8d320ade7 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -288,11 +288,12 @@ static int meson_irtx_mod_clock_probe(struct meson_irtx *ir,
 	if (!np)
 		return -ENODEV;
 
-	clock = devm_clk_get(ir->dev, "xtal");
-	if (IS_ERR(clock) || clk_prepare_enable(clock))
+	*clk_nr = IRB_MOD_XTAL3_CLK;
+
+	clock = devm_clk_get_enabled(ir->dev, "xtal");
+	if (IS_ERR(clock))
 		return -ENODEV;
 
-	*clk_nr = IRB_MOD_XTAL3_CLK;
 	ir->clk_rate = clk_get_rate(clock) / 3;
 
 	if (ir->clk_rate < IRB_MOD_1US_CLK_RATE) {
-- 
2.53.0



