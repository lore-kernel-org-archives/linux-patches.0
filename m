Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055549;
	b=I6ByRrTjdLvIKT9hxYrIEZqFqwp8tzDme/7lRzMzICR2GKODZvqDm6tJlZQl6vy81owI
	 cJ3dlkLakzKxh2NF6E3Y0JmV4+aoY8GGC3Y96uV6v7yE/B9dDm/DxjFVTT8AtLl7/cViW
	 hOTnMgADC4Znq50ArUl4WCttoWdG1J10I5mMWr1gclgGWFTXegxF07sc44qfWv4EZ13sU
	 kY4CEm+VF6jTmm/veVA0HSJsJSYxNeSVsDuCtyk0WfdtVQfl2eyyVtu/6FivO8E/PBuCP
	 2PnXJFnPIuWDQ1u/uqdzTlNX/cY4LG9tGp8Y3DFqN6SrPh9UAHWFPZJ74JayYz6kGjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q3uQEk5rrtFeUBtQJmbkZIBcX5Yw2J2WHAAGxJXEX58=;
	b=L+38kZukGYX5MHz7owRpRP3SbKGWCf9TezMhCWXcC8oSSZhxm/tV39scR9JVIjdPFzjD
	 3aKe20IHaf4utSDv9EmeIu0SxftD0M5LffeFB8t1k5Nd4UalhLDITYGVp8rVlILBUEipD
	 Lv6Ml61cFSzyqPe3k5pzrubqkms1f03rW7GQh6S2FVp6l6FDQOPaATVbs4jyYz7WPfp0g
	 sX8IwAyVadHgFEzAYNPr6ouJjxy3+/YTTHD4jAHkZcDHLepZ0KrrVeKpvyhPKDUnttIpU
	 rf/E4GpacR/F9sJUUSUNPycDXbiPb4eQYkEu/oMVm7+g2f++VVtFEoA7FR1DXagLCdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsQu1p77;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085E6606A335;
	Thu, 19 Nov 2026 02:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsQu1p77
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4E61F000C4;
	Thu, 19 Nov 2026 02:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055548;
	bh=Q3uQEk5rrtFeUBtQJmbkZIBcX5Yw2J2WHAAGxJXEX58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsQu1p77gWBEkDiAOz7lSF5Oxk2h4qoBEBngscfAfvkttCoKY2goKYeiemzGoyueZ
	 QfFSun2Mw5XNtpRYQ1IRj6cFc0bpJ2Zthnbh6LBLLab6laSeHRRNGfEH3ZOXU4tmWp
	 ptnfV/+pDvZg0N/eZOgDJ7wOL5HnWg3s+c3m3gdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1670/2214] clk: ti: adpll: unregister OF clock provider on remove
Date: Wed, 18 Nov 2026 15:55:46 +0100
Message-ID: <20261118150118.648668822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 4c943ddfc24340f1b899762b1ff35c38306b7a35 ]

ti_adpll_probe() registers the driver's onecell clock provider with
of_clk_add_provider().  The remove path only frees the clock resources,
leaving the provider registered after the backing data has been torn
down.

Unregister the OF clock provider before freeing the ADPLL resources so
the provider no longer points at released driver data after device
removal.

Fixes: 21330497f303 ("clk: ti: Add support for dm814x ADPLL")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/adpll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/adpll.c b/drivers/clk/ti/adpll.c
index b341cd990be7f..eadd58e6756f3 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -944,6 +944,7 @@ static int ti_adpll_remove(struct platform_device *pdev)
 {
 	struct ti_adpll_data *d = dev_get_drvdata(&pdev->dev);
 
+	of_clk_del_provider(d->np);
 	ti_adpll_free_resources(d);
 
 	return 0;
-- 
2.53.0



