Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021284;
	b=tqtinpFAibe6jNx1hQ1aVpT1hbLpV0cZdoz5GCXJln9PdKwFCCQhyVQCq7ccnjYIOY0u
	 BBGssOZb6ElvC7DbkWzu2gEdg3hhQ3f0Q5WeeZ20ixPl7Px5D01GOJM+iTl/W7VtwHcLN
	 LU3GMYBuSx979CoQas/10YjtKQwwY+PEPqH2C8jbO4QIe7psqyuRhPmb7Dh3fbHty1u0G
	 Nut2pxs6lgCC/qoONQpwd1/7pU9BrTwtU6lMfdzcZbTeg0GHjG0wW8Y4zKdRNwAvEcNVX
	 ToBzKRc0VpVFYCXyPosxHlppquBiLMdPbAs8zZY8s1BDtBePdJz0C4kZYxNwx5tfQGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FuSPAZfh8+S5VG0ADmwLUa51x9Gbja4BL+cQrGrhr4I=;
	b=fWARpYlTOpIGj9EyCNatJ/q7qlJ2WGlY7wS2qh9/N7bvaso+C/0P1UOSFEqaXdi9BQo9
	 0s7MxTaSmYpt3Cybobb+Zr2Vu2cKmkCfngdq4bwpQ6FHeMMRqCwpoOEtGu8xNBBcikRMa
	 guEGdeMdQpLb+aoTGKMtcq3tO+PP7kNVtvo7DBZf0RQ6CV7SsKjStLSy/Xr89TcLTN5TX
	 67440BxIvkG+9VivuHKe0tW9ljoFriYbvFyruA/xSgfC/BivJ5LZQK+irYy2n/5e9OglO
	 RBHYxoAwgNlnG0KRfA1HngA5UiHCN+F3MuDlklAeBqSDezVeGj9N6aQlesAY2W3GIlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQUcWP4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3710460A2604;
	Wed, 18 Nov 2026 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WQUcWP4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1351F000C7;
	Wed, 18 Nov 2026 17:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021284;
	bh=FuSPAZfh8+S5VG0ADmwLUa51x9Gbja4BL+cQrGrhr4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQUcWP4BUVsFFjG8LsgTFAcoJjkizfxe/P5wrABgk95xLGZQqMvFOYPNPUPpUQar1
	 0wdGVMhbP9pu5SSbKmp4YiqE6CMXx5kjuDvTLS8YEJGBXr50vpNUapynfqURk0316j
	 DUhbzIZ3SHiOktdlsLbgUjiK1+9OXeydIvmnr94w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2252/2651] net: bcmasp: fix mib counters struct alignment with ethtool stats
Date: Wed, 18 Nov 2026 15:58:12 +0100
Message-ID: <20261118150406.517459354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit db45c15c98134f5ebd13c4dc5b6be5d1cd3fc706 ]

When EDPKT stats were removed in commit e9f31435ee7d ("net: bcmasp: Add
support for asp-v3.0"), the corresponding entries were removed from
bcmasp_gstrings_stats in bcmasp_ethtool.c, but the edpkt_* fields were
left at the beginning of struct bcmasp_mib_counters in bcmasp.h.

Because bcmasp_update_mib_counters() and bcmasp_get_ethtool_stats() index
into struct bcmasp_mib_counters sequentially based on the order of
bcmasp_gstrings_stats, this 16-byte offset caused ethtool to read from
shifted offsets: the first four software counters read unused fields and
reported 0, the next four software counters reported the values of
alloc_rx_skb_failed, tx_dma_failed, mc_filters_full_cnt, and
uc_filters_full_cnt, while filters_combine_cnt, promisc_filters_cnt,
tx_realloc_offload_failed, and tx_timeout_cnt were never reported.

Remove the obsolete edpkt_* fields from struct bcmasp_mib_counters so
that it aligns with bcmasp_gstrings_stats.

Fixes: e9f31435ee7d ("net: bcmasp: Add support for asp-v3.0")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-2-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.h b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
index 8c8ffaeadc79f..9c9721da1662b 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.h
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
@@ -250,10 +250,6 @@ struct bcmasp_intf_stats64 {
 };
 
 struct bcmasp_mib_counters {
-	u32	edpkt_ts;
-	u32	edpkt_rx_pkt_cnt;
-	u32	edpkt_hdr_ext_cnt;
-	u32	edpkt_hdr_out_cnt;
 	u32	umac_frm_cnt;
 	u32	fb_frm_cnt;
 	u32	fb_rx_fifo_depth;
-- 
2.53.0



