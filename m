Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826887;
	b=HNbB+jKKVnnvytjygnicxHl0ZQRrd1aUd2Y81hs+HmkjbroEMRvUz8J7zUTKKIgYRLNk
	 iKhENBepKcXfZc6yR2sN/rw3UEQxFBoX0tNXefMITBnQu21c2KVbelz3aw2TDVZ8tWzDj
	 Gm9tIeLXmi6oedCkg/g8KWRS6Wy+FYmBGp2GevlrCODhKrNaIpv7jaHc5XxN0r4i6l6zZ
	 HfTVYgVCF6g5dHG8+pBl2bC3sUR5Nd9SbpSVUdTqd2xEes0mKycoY/Twa2PJ1ZK3g07KE
	 EQNsFdO0ben8zL3CXQ1xydugc6h8TMZXzH9iMp1yKOR5VN1RmlKXQvR6AxpadV0CdWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LXOWoFeUQlZzVUZ3GtJ2V5p8Zxxwe6uttlmx+d15jTA=;
	b=XyxAnxP5LQINW42MZvlm7foYra6HV7eFrnhymv3xKPPRWNJz2RGdZz7Beb+Q7dQNkKXW
	 tFkZdig/IKoq33Y47k6ongOIQjjKgDQlp0lXAYikkvh/WMUYIvfClxDkoJVOPZpp+PHxm
	 Qz1FCn2SxnHZFR2taV+dX3RCiXKUhSLbrNj8lexMqZWdPDLOpjRZyZmmzgAjx9bph/k4e
	 IIqQWbZQNxe5OTJ5Zf7BQJSQJpd2umP7zG3CLNPqAo7brfGCrygiHGp+owFgH2L/cVdRI
	 pVIxLl2t2E01T5Iwk+Nb/8WqnnodXjGUO/5o5yJ3nB8xEb+REG74a9UEUAimTpHUhpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYmnfpI4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB99607267B;
	Wed,  4 Nov 2026 21:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jYmnfpI4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8491F00919;
	Wed,  4 Nov 2026 21:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826886;
	bh=LXOWoFeUQlZzVUZ3GtJ2V5p8Zxxwe6uttlmx+d15jTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYmnfpI4cvWmeiom3Ugl/xE6wEPk44nqOiTAs5EbVazn/aVZzbdesy53l0cfbF376
	 tH4D7HJMGNs2JoaDKMuDh67avIuhN4m4sXDGSOtO6sOMtUdR6CaMQT2MyyHq5PW5Pp
	 J2mT1zhJj+SFoWs3wiS16t3SDREs7f3Yv6gMt//s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 7.3 066/547] clk: renesas: r9a08g046: Propagate clk rate for ETH TX mux clocks
Date: Wed,  4 Nov 2026 16:04:10 -0500
Message-ID: <20261104211040.145897890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

commit e018c27e6052ec58de3c1e7b340521ef162a8b81 upstream.

Add CLK_SET_RATE_PARENT flag to the sel_eth0_tx and sel_eth1_tx mux
clocks so that rate-setting requests on these clocks propagate up to
their parent clocks.  Without this flag, a clk_set_rate() call on the
downstream GBETH clocks has no effect on the actual PLL/divider chain
feeding the TX clock, leaving the requested rate unapplied.

Fixes: d55a0dfec40b ("clk: renesas: r9a08g046: Add GBETH clocks and resets")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260914165026.184612-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/renesas/r9a08g046-cpg.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/clk/renesas/r9a08g046-cpg.c
+++ b/drivers/clk/renesas/r9a08g046-cpg.c
@@ -277,10 +277,12 @@ static const struct cpg_core_clk r9a08g0
 	DEF_MUX(".sel_rspi0", CLK_SEL_RSPI0, G3L_SEL_RSPI0, sel_rsci_rspi),
 	DEF_MUX(".sel_rspi1", CLK_SEL_RSPI1, G3L_SEL_RSPI1, sel_rsci_rspi),
 	DEF_MUX(".sel_rspi2", CLK_SEL_RSPI2, G3L_SEL_RSPI2, sel_rsci_rspi),
-	DEF_MUX(".sel_eth0_tx", CLK_SEL_ETH0_TX, G3L_SEL_ETH0_TX, sel_eth0_tx),
+	DEF_MUX_FLAGS(".sel_eth0_tx", CLK_SEL_ETH0_TX, G3L_SEL_ETH0_TX, sel_eth0_tx,
+		      CLK_SET_RATE_PARENT),
 	DEF_MUX(".sel_eth0_rx", CLK_SEL_ETH0_RX, G3L_SEL_ETH0_RX, sel_eth0_rx),
 	DEF_MUX(".sel_eth0_rm", CLK_SEL_ETH0_RM, G3L_SEL_ETH0_RM, sel_eth0_rm),
-	DEF_MUX(".sel_eth1_tx", CLK_SEL_ETH1_TX, G3L_SEL_ETH1_TX, sel_eth1_tx),
+	DEF_MUX_FLAGS(".sel_eth1_tx", CLK_SEL_ETH1_TX, G3L_SEL_ETH1_TX, sel_eth1_tx,
+		      CLK_SET_RATE_PARENT),
 	DEF_MUX(".sel_eth1_rx", CLK_SEL_ETH1_RX, G3L_SEL_ETH1_RX, sel_eth1_rx),
 	DEF_MUX(".sel_eth1_rm", CLK_SEL_ETH1_RM, G3L_SEL_ETH1_RM, sel_eth1_rm),
 	DEF_DIV(".div_eth0_tr", CLK_ETH0_TR, CLK_PLL6, G3L_SDIV_ETH_A, dtable_4_200),


