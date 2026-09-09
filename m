Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB69B52E054;
	Wed,  9 Sep 2026 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963640; cv=none; b=F8FDCymlFvKVsYzO9jYGKbmIpYwgyNswElkQ1FduvDN/CIWCMYwocpUncOjp8JUYNidFbLPAcQvMyrezBm1eQ1vGsMpRL/RJ+sia+a8zrMqlp5y7IQ7hc0lCCbc6yvX81OM+4GHws2x+0s+kpgpH8Dc0Wa3O4A18LCCdpAEvQ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963640; c=relaxed/simple;
	bh=phP6cCrfjvche4ANS9nDQL/FGf3dal4Dvjy+Jp80zhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKUYJPXGyqEK7kAfBB3jvtk8VbK7SLS8HABVhdHSuUsa0SJQRFRXAhl2twZbVUiucWyX6fXOwgTBGvwdamkgu4htVwwjnbB1Ws8vIiz7gkjJSlqbT+k1AwomtjSmK/HIvUGzSgbrbY4JFQqXASm1tKUeKekXkolhGtPBCEgfDU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DafMunSR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DafMunSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C37D1F00A3A;
	Wed,  9 Sep 2026 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963638;
	bh=3rIqDWuht1F8mXryouzsz+EwRkunYMqw4x+W/2SHF4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DafMunSRL6G2vVcypDuhVzhif8qagsNn21jy5MR9phbl9yOp6EaWLyqIO5WNtbqyR
	 4gqiJq4yiRHVWQ97PGsCiHmwlvKube9ARSZrxUy5an4zgIyqZC2nh9bGLrd3oYEbdi
	 MrHccWV+XDBpVB4uyGZZrMBW2HuPkpL5UEuE4MdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.18 147/583] clk: mediatek: mt8196: Select REGMAP_MMIO for vlpckgen
Date: Wed,  9 Sep 2026 15:37:12 +0200
Message-ID: <20260909134243.271204856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


