Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829727;
	b=5Voq2bmlVYBeAtxUwNeTYKaD7RKZsagRydopI7XKJx3PCkhI/A1ZtDajnF3rYc6klvKh
	 Jj7YMiHNmppQITJrPAGh1xCLHrB8bDehR9P+egF1V7tDZiTLsJLDehCzuy24sO+4hXKx7
	 ano0yWmUlp6CDlZjN3mW7VTzBD3nSsv0sLeaXoVlm4/8viTbncVa1D8n+0WG1+XHXwxWT
	 /vowZvVjgx21GjfNOcw1JaY+56v6+M3co9Y/J10OAyBteYrGqlCwCim5g8vY66O9wUZlj
	 abMWa/6H1gqhtWxrWH9PuJA1hIBIZcWIE7PDwfuALQWHZPMpLa+yWG2gook+IdH4c3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6zQ8fr3Qk0atKsQ2DiymSj/y/vdPaKR0SwKZyVSq7fQ=;
	b=kbc20yZSEcL+GQmAkI6nPLEul1un6ir22YOHlnTq0m66P9P56HFA24FRcfCq5K3yX+Rn
	 r8YmSRmBKWBLXTIfLtSkO7Wvy0kVdqC4y8PJbZNvjwHyb8r4PZGqueL7R9r/ecRqNaAvV
	 CQo2o7hprbOTrayDAfFNFw2hS8nx31bGxc1aL/HwhdYBhZC4KmWcWzFs7lEoeL3IMNO+t
	 ha87+qnIpsgf6djkYFYgFF6Kpz//AwIO6aUf1L7mi0EleOPSO1Y6VOLe+pWkv+IToj57H
	 hJWXoptIXM2pwnCjxokA5l9UZeay3tX4awXbukNRYWMAU7qRTVfYGbyGQ12adJbXLRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSFT28d6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4989606C90F;
	Wed,  4 Nov 2026 22:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aSFT28d6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EA91F000C1;
	Wed,  4 Nov 2026 22:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829726;
	bh=6zQ8fr3Qk0atKsQ2DiymSj/y/vdPaKR0SwKZyVSq7fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSFT28d6R1I+tRWYcJ1EIQ1UMPN72h+5FjP79YK6dgEVYqpMHjCD5gzPXmhGdOwU2
	 KXStoniQXh40Jnd8ZY5+8UCa8Q1ziIbWd9oCgrGoMm++PI30JOWMu/msDnZ3FmIa1l
	 /aGjgsn6Zqm5t9zBi5yS/TNw8kFmjvVFM9wcKoX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0265/1005] clk: mediatek: mt6735-vencsys: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:59:58 -0500
Message-ID: <20261104211051.293924130@linuxfoundation.org>
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

[ Upstream commit 36cf8d279ff90835f4b002dec28eedb059554842 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt6735-vencsys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mediatek/clk-mt6735-vencsys.c b/drivers/clk/mediatek/clk-mt6735-vencsys.c
index 8dec7f98492ac..64ba9da9fd427 100644
--- a/drivers/clk/mediatek/clk-mt6735-vencsys.c
+++ b/drivers/clk/mediatek/clk-mt6735-vencsys.c
@@ -37,6 +37,7 @@ static const struct of_device_id of_match_mt6735_vencsys[] = {
 	{ .compatible = "mediatek,mt6735-vencsys", .data = &vencsys_clks },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, of_match_mt6735_vencsys);
 
 static struct platform_driver clk_mt6735_vencsys = {
 	.probe = mtk_clk_simple_probe,
-- 
2.53.0



