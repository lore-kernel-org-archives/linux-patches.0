Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8906B423A85;
	Wed,  9 Sep 2026 13:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962205; cv=none; b=UuaAADA6lBGRuUfb6GFsAGI4TJe8fnAQcSp4Nx9sPcfYDVKubgt7ZI40O1vwfsmiD0nwYVXk736p5iF6AQuM9yIQGZDXCfFnTphb6701DVfS9qR0ykfukfr1cGxPQaCWapLk3qUKP+7Lymbpi3bPRRJjvLRCSnQ3+akkUtgL+T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962205; c=relaxed/simple;
	bh=cueySLiQYThj+FEZf64Bb3or6/dWaqTd2PG/Mlc2KoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+NoWt81pfKrjoqsiK1OvFoxVjLcWlvU9irhvo8a1aE4teGvMmWHpFLytpaMCYuhR/5gWxZuFrlU3cpCYfOAi/MsHgS8ckDnkvxu81cOsQEyTZM0D6ZN+0ysY3HUEMxsOnWtZwIzLiTNewI/ciSZqNDQOhmRS2+PW0iLiyMEZH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uahd2J+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uahd2J+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA221F00A3A;
	Wed,  9 Sep 2026 13:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962204;
	bh=Q9q/xTrb6rlUKyYwUGyThwFVPdXZvtt35ruAdxX2xhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uahd2J+Fosz1jloQwr8kV9Q1Uj0UGGlOLw42CH0oi42o6RozD2bJY7ERu8R15uVBX
	 ZLD/Ci5uFdApBoaW+duJuvLnh+VtrL78vLFJvUyBRjopINq2StbOwSPYREqxg3PQ3w
	 TyfTVZRvDR3MMyknAb0jVWbhTPXReTXXCOos3tzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 7.2 208/556] clk: mediatek: mt8196: Select REGMAP_MMIO for vlpckgen
Date: Wed,  9 Sep 2026 15:38:08 +0200
Message-ID: <20260909134237.704547225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akari Tsuyukusa <akkun11.open@gmail.com>

commit f63aecdb45e9dd19c340fd62df698374d95b9024 upstream.

The MediaTek MT8196 vlpckgen clock driver uses
__devm_regmap_init_mmio_clk() by devm_regmap_init_mmio(),
which is defined in drivers/base/regmap/regmap-mmio.c.
However, the driver's Kconfig entry does not select REGMAP_MMIO.
This causes a linker error when REGMAP_MMIO is not enabled.

Fix this by selecting REGMAP_MMIO in the Kconfig entry.

Fixes: 2f8b3ae6f0cb ("clk: mediatek: Add MT8196 vlpckgen clock support")
Cc: stable@vger.kernel.org
Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mediatek/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/mediatek/Kconfig
+++ b/drivers/clk/mediatek/Kconfig
@@ -1006,6 +1006,7 @@ config COMMON_CLK_MT8196
 	tristate "Clock driver for MediaTek MT8196"
 	depends on ARM64 || COMPILE_TEST
 	select COMMON_CLK_MEDIATEK
+	select REGMAP_MMIO
 	default ARCH_MEDIATEK
 	help
 	  This driver supports MediaTek MT8196 basic clocks.


