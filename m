Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829691;
	b=pnWiAkQscBuVj8voLiN/X2KGKV1SvjQNc0ImLt0XfH1r2EWjU2WkqLXSaXOmxGo9FGdl
	 IXrjWcbg4H5rVovPCEvJ2t/DZ0JRGatrMskC7KTHzynwqwyMe7DG5C5W8GNsJ1ulTD/Ai
	 PTpFpSWkQBsidzizCni3DC5lILzhA28XULsL4YavDbkGyNI1VS/1xWI8eygfMAcpruSKd
	 2KaaA/h/IP5AMnWuRPvtQ8AeymMUOuoZ0KNWhUCrtCpsqlnqa3/oAwPCbl6fP7D7Mwm5O
	 Hi96vawWzihQirJHfC43IqEmgRQy8Mpxfds6twQgXbXMbv637msNaRBfs6JNVbnD/eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V3MHf11IprB5QkU/GZ7G8ynquAbIemi/2a3wEIbO+zs=;
	b=ZhnBPD1vbphXQgF0oaGJ2BtUel5ejqQ7++sKjV8t1AcT1EkAEJK0hPSKjjjDUnvqFBKa
	 4iSzYOvTdP9uFpowRDhwCfVcf2AD4hZk/oODSCsR5kIVrezoQdKX49VlEv2m9SP3fJvOJ
	 L5jotv7kSWEosV+aD7r/d1jMLhzDcnv6Uk/MsmTFWRNSUnXPPeXCotTtWK1oqUrJpC+fC
	 /qnRb1wU8cWK1bHO3WuPEs1cUFNYDLP1S7ANBXcZAWm/Os18KGRHff5cj7+pTdUP7KzC0
	 raZddS7cprpR2O3obHpg1Jprvr+t9IzdwYGBbUx1cb8pPd8EWUGiIm7PrrtovS7ws8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQbHuXdU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022E2606BA30;
	Wed,  4 Nov 2026 22:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQbHuXdU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5403F1F00A18;
	Wed,  4 Nov 2026 22:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829690;
	bh=V3MHf11IprB5QkU/GZ7G8ynquAbIemi/2a3wEIbO+zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQbHuXdUsIH0q+B+vlS/Vfq5VPZmlxIzkXVyodKJyv13ivA4wPgn4E1/MJIVvcfEI
	 trwMFMFQDDYsR2+1j2sSgPZeq/5iSK3cHGVvs/RCnNkl4KzUNBIGCBYEaf/bb/zmqe
	 uF1o99pTku08N+U4CYa71t9vhD1x9PXe99at+tNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0282/1005] soc: mediatek: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 16:00:15 -0500
Message-ID: <20261104211051.793013612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ec762057868d70d474a9816e9c293c2ef801c3c9 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-dvfsrc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/mediatek/mtk-dvfsrc.c b/drivers/soc/mediatek/mtk-dvfsrc.c
index 41add5636b03c..af35d71615baf 100644
--- a/drivers/soc/mediatek/mtk-dvfsrc.c
+++ b/drivers/soc/mediatek/mtk-dvfsrc.c
@@ -562,6 +562,7 @@ static const struct of_device_id mtk_dvfsrc_of_match[] = {
 	{ .compatible = "mediatek,mt8195-dvfsrc", .data = &mt8195_data },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, mtk_dvfsrc_of_match);
 
 static struct platform_driver mtk_dvfsrc_driver = {
 	.probe	= mtk_dvfsrc_probe,
-- 
2.53.0



