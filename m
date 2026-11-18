Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032554;
	b=WxUdMLf5yLVXftQcXrFZDxgSjB0jQQKMMCH9pU+Dy4INQckfmSd/m4Yi+qYG/fWqCk17
	 16CWuEOwKwEwchj+u/JE+CBoDwiWsm3FCC1MnIsTGZX2o50CcK+zu54/Pe3k5AcPcdB5L
	 k1n/GbogYPDPfZ1KImsdjmA/TgiMo6UY/Qe3Ju43Mg82TZHQLBEnTmbDVTdXRvd7W6RHY
	 OEW+yBfVdW99f6ZVLUo3V+H1Iks7MG9l0pW/PLYKup0h1P3v8OIqXaa4fkjDA7lT/qYJ8
	 UnflB7T4CI3MtK7G6edrI/NwqVOa0ywere81GvQFn1z5LLAKoEjZWCJ7EnY4qZi6jRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4MjQt3joNPSCBcV9zFHtV+h118qsy+4eMCUjlGbdkeI=;
	b=NPY/XLQvpZ4+ZKhlEnu/F6VEPsHr8ZvZjOELs9ovHmzP6kRmRPiAHZ8y5NA/TblWGXRv
	 PudLHB2ZNRYW4XpqVWl1JmAR3YYLr0w2D6y2nfDQ8sYWPwIGjzBfMe5JhXdtz+TmXITRp
	 XyHsxpxAZDnPBr/Y/KTdQchSubjUbRRxe6EowRNtfRUFnGB+IDk8Z8NwPCh9lKK/WHobK
	 Yr3bjrFMkBUci51peABA8w1hdhJ5N/dWJ9MiTONoFtpBsHK2S75dTEI82u+26kxxUMrIY
	 +NX/RoW4NL1xAh+qVLQiF8QlVc9A00gNoa+h2YPdTWi6ib7DEdZjfWL6eZ5tFwp8vtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpSbIkGR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37A060A2600;
	Wed, 18 Nov 2026 20:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpSbIkGR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410051F000C4;
	Wed, 18 Nov 2026 20:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032553;
	bh=4MjQt3joNPSCBcV9zFHtV+h118qsy+4eMCUjlGbdkeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpSbIkGRcTgA+adB7YaQLTv5sqYzTwp6zJ5dZPTk0Wh5PHYngwsqjUUaRlZ99TXc9
	 57bts0Vql2BP+bBt9wl+ZbcAGhleKKc6qV6qMnmVC7Ft/PeCFTRv/ITfE7ijx9uGqy
	 x24yboH62Ud5bzQEDFfQ9SoXIKTcbl94i3nHUZwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1451/1756] net: bcmasp: fix mib counters struct alignment with ethtool stats
Date: Wed, 18 Nov 2026 15:59:38 +0100
Message-ID: <20261118150106.866978557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index e238507be40af..65ce944a01911 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.h
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
@@ -249,10 +249,6 @@ struct bcmasp_intf_stats64 {
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



