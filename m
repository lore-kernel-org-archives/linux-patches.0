Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5348BEB;
	Sat, 30 Dec 2023 12:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjtXKi5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22173C433C7;
	Sat, 30 Dec 2023 12:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937940;
	bh=jf7eSm5x4JRFstv+8idq0370oHuuL3tEKreDZdRcPb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjtXKi5cLf5Wi1ZyT7i6aS4eslrgIpV9G+YpL0H1npmaE/nf2JCdtcFdiQRl2Q63L
	 z9iUQc4J10td/mvXW6JL4l6+ZsmHO4XzE+xb+djK3cMy36/O02vkkMmYfGHdQx0CMQ
	 F6zrytFLMXjY7C6nUS0wFp0V+zrChjMhcVbNPRHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Lai Peter Jun Ann <jun.ann.lai@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 122/156] net: stmmac: fix incorrect flag check in timestamp interrupt
Date: Sat, 30 Dec 2023 11:59:36 +0000
Message-ID: <20231230115816.355447319@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Peter Jun Ann <jun.ann.lai@intel.com>

commit bd7f77dae69532ffc027ee50ff99e3792dc30b7f upstream.

The driver should continue get the timestamp if STMMAC_FLAG_EXT_SNAPSHOT_EN
flag is set.

Fixes: aa5513f5d95f ("net: stmmac: replace the ext_snapshot_en field with a flag")
Cc: <stable@vger.kernel.org> # 6.6
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
index 540f6a4ec0b8..f05bd757dfe5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
@@ -237,7 +237,7 @@ static void timestamp_interrupt(struct stmmac_priv *priv)
 	 */
 	ts_status = readl(priv->ioaddr + GMAC_TIMESTAMP_STATUS);
 
-	if (priv->plat->flags & STMMAC_FLAG_EXT_SNAPSHOT_EN)
+	if (!(priv->plat->flags & STMMAC_FLAG_EXT_SNAPSHOT_EN))
 		return;
 
 	num_snapshot = (ts_status & GMAC_TIMESTAMP_ATSNS_MASK) >>
-- 
2.43.0



