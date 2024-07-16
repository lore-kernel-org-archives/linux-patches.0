Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9ECCA40;
	Tue, 16 Jul 2024 15:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144154; cv=none; b=ZCxwxYI8/JfbtULkaIcD32afT8dTrwnS0zpuxu4GTuay2dtTjFN7EOU04RDvh86oVeD1EMpBod9Xq2/ShHMLWknstaPLPDh8hPYBJzjs+wZkEiW72L0wFtikykAIYU/2QGTh701lCHDhIHstiyCkt8CHc2dKUgCImxMasIBYdMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144154; c=relaxed/simple;
	bh=N5FfzCPU0qJ9tcUHrQk/VgfrGCXlp7yNfON3cN9NyjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+maIVNgO8EDl9BU/RxX8MhhFBsx4nNGDcrZaVtQQy38pCSpxAPF3X190M4qI/aMxYji9T8eauJJ2wkEYLfYsN2u102EkkdEGUs5J4LmVeaEonwwgOWWoMDHV9wx1AYx7JKFBjFH4n76jA8yP4BmRfnUCfQadbbZJXVNw8l8XTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyVSMW+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyVSMW+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889D7C116B1;
	Tue, 16 Jul 2024 15:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144153;
	bh=N5FfzCPU0qJ9tcUHrQk/VgfrGCXlp7yNfON3cN9NyjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyVSMW+feKpSz9ke4hNLmENaLBVv3joB8ubRvnojxDakc99cpZ0dLa1whsFPzebuA
	 hf9U93qdrTobiYUI1gF5BjFAcu4qNEU9Yy0Af+R7ba28OgU3TNKP8y6IDHokhA8K1T
	 e+LNs0OkhbjxouiwtE2AQiv6b4yy2kzN0nCWTyeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/66] net: lantiq_etop: add blank line after declaration
Date: Tue, 16 Jul 2024 17:31:19 +0200
Message-ID: <20240716152739.850217342@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 4c46625bb586a741b8d0e6bdbddbcb2549fa1d36 ]

This patch adds a missing line after the declaration and
fixes the checkpatch warning:

WARNING: Missing a blank line after declarations
+		int desc;
+		for (desc = 0; desc < LTQ_DESC_NUM; desc++)

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Link: https://lore.kernel.org/r/20211228220031.71576-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e1533b6319ab ("net: ethernet: lantiq_etop: fix double free in detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_etop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 8c58ae565073f..fd391cbd5774e 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -222,6 +222,7 @@ ltq_etop_free_channel(struct net_device *dev, struct ltq_etop_chan *ch)
 		free_irq(ch->dma.irq, priv);
 	if (IS_RX(ch->idx)) {
 		int desc;
+
 		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
 			dev_kfree_skb_any(ch->skb[ch->dma.desc]);
 	}
-- 
2.43.0



