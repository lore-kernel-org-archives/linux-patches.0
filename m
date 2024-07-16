Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E34AB641;
	Tue, 16 Jul 2024 15:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144429; cv=none; b=gkUVAbCMgut4IuLBfWLQkQNWAHgdEil+y8GN812nTk6tgLTUXwyHLGqd7WEoWHlAmwixYI6RnrScd03FGNXADL6yMTRQUTPW4DhLOJT6yqLR8u+w1U9Wuz4Lxc8a5EeJJZuBXNK7AC3mgCPDc9/Z5x/unG40tuwhQpLvpAI6q3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144429; c=relaxed/simple;
	bh=8kQEFuKlBx/MTdIGSm3GObPp5bUz5LvSLyN+IH+7z+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKMDj+kmXVFh4fw2CfpohU0dpOYAirzaqG0EM3BJ3PTXmBS+jIIBkp8bPScUQ5mLgYmiBC10FdsbXK3dvNsu/6toyHJP+uy2eGfFyRO3oCHmulAuWGbzbaabViJq6MQDg0mia2zLe8ttECbFZfAJOlRigrpB8Q6HxbaNvroS6d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiLJNydc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiLJNydc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9602C116B1;
	Tue, 16 Jul 2024 15:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144429;
	bh=8kQEFuKlBx/MTdIGSm3GObPp5bUz5LvSLyN+IH+7z+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiLJNydc6tUh4ZN9b2BEuMKgQzHpbVmE7sWXWmv/4cCknufuSmCAdZdI9EPVS6Sz8
	 Oo6I2XW+b/UiTmr4SoNZBzA73+sYSzxczVuYKrumMx6svV3RtNUM5/lgqXHj0n0cgD
	 NuosnXlvPwDU/unTXDbNIk7Hs2r/mBBPXRx9VLmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/78] net: lantiq_etop: add blank line after declaration
Date: Tue, 16 Jul 2024 17:31:24 +0200
Message-ID: <20240716152742.654264677@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 12e8b0f957d3d..98aa172da051f 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -214,6 +214,7 @@ ltq_etop_free_channel(struct net_device *dev, struct ltq_etop_chan *ch)
 		free_irq(ch->dma.irq, priv);
 	if (IS_RX(ch->idx)) {
 		int desc;
+
 		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
 			dev_kfree_skb_any(ch->skb[ch->dma.desc]);
 	}
-- 
2.43.0



