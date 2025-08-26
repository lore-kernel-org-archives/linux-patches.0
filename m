Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB3A352FC2;
	Tue, 26 Aug 2025 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217361; cv=none; b=cfoOIRSplLwhUyHL03okHtC/smKO7yu1K3DSjiBfI1KWV4wqu2K8Ch3FS1jv41r4BpG5vxBZyF4MJuGAdF7jq1n4b624iqcGGdy/ctn5JDANt+zhk6SX7Jw14xbvXzYGQcgt0ns5lYBJxG7049+I7ilMbf/YB21m5Gr1M4rCG7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217361; c=relaxed/simple;
	bh=gq7UkdcWBn/K0icl6IcgbuvQo+l5IfzXG4YR+EnMYIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkCINdBBpJFV0KptoVXUvlBaXulYrarN32K3eIYa4fC82HYzW6N98LIeME1e8MY4H56pc/vXjxpRqXO691yQ4MdaXO8dah11V+42OmjbmP1Ios9cPIfVTJdVjW9F5/DoppIlp7c8seFXK/eywds055LbojsuJBvusbtLq+BII5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vws9+4Hc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vws9+4Hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3376EC16AAE;
	Tue, 26 Aug 2025 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217361;
	bh=gq7UkdcWBn/K0icl6IcgbuvQo+l5IfzXG4YR+EnMYIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vws9+4Hc0dHs9nXhpcbZrbn23v2oiHUCobxyKfQ38MOFJX1c9YGjatYKVAxC/j5hF
	 tdKABTz4PBTnMxVTBTQg0DUF8oUBaEMeymaqjTWLXxYXbnj2hWoyHtLLZTx+yI1/Za
	 7BmrxklGE5CMMyQRKy4ljNbLTxqg+6hz4UbR2ZQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/523] can: kvaser_pciefd: Store device channel index
Date: Tue, 26 Aug 2025 13:05:25 +0200
Message-ID: <20250826110927.360761923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit d54b16b40ddadb7d0a77fff48af7b319a0cd6aae ]

Store device channel index in netdev.dev_port.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://patch.msgid.link/20250725123230.8-6-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 197390dfc6ab..42c2b56d783e 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -955,6 +955,7 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		can->err_rep_cnt = 0;
 		can->bec.txerr = 0;
 		can->bec.rxerr = 0;
+		can->can.dev->dev_port = i;
 
 		init_completion(&can->start_comp);
 		init_completion(&can->flush_comp);
-- 
2.39.5



