Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B87D21ABD0;
	Tue, 12 Aug 2025 18:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024096; cv=none; b=ABm/SFCGfPwAWGtzfhcSYJqTxmX8XTIvory8ALLquG/ELXF3nxcpbUdrKsffCdK2K3QEtanhJIhy1lGnaz4nXL7FvQPmAMxaJQTAAHrN7+NlXtWrcOdXeIuULGYuatr6B1v7VhauW8zpV0senMihyqMLF+iTdI96d/3a7pW7gAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024096; c=relaxed/simple;
	bh=VCyfwtlwx0/2BQda1wE8TZT4sA10ttzJkmdCHc6NWUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfAV7V0rgGfXvz8RZvAjOJKm5ZzX3BP06RuIg2wFiVtCaeGfPQThzq0MJZZaMoZ4qA4yu5BrU4mWpi+dr2AYFsAgbHSyafe0c0ukNLAmBWX/8nOLekBIlcWwRCFG7Rbh1fOBLW1e9eIY24iHSnNFM48806N15nN5zVjQEqyiH7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rN0BwbVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rN0BwbVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A841C4CEF0;
	Tue, 12 Aug 2025 18:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024096;
	bh=VCyfwtlwx0/2BQda1wE8TZT4sA10ttzJkmdCHc6NWUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rN0BwbVE7cb00t3/qhTDSkl5qmF/zstGThGckTD9Eht1+xdPKjQcIlIjAR0hhFuHP
	 wyubeSUU0QWLa8rD13bXnXFakq/yx2DcZiJj6DXzkMEj66qWCX28EAtVuxF4DIluZ6
	 SWQD9XG7LnCbYr8Z8JnZWLehlBz2BKrp1wAl0ZPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 271/627] can: kvaser_pciefd: Store device channel index
Date: Tue, 12 Aug 2025 19:29:26 +0200
Message-ID: <20250812173429.627560740@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 09510663988c..dc748797416e 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -982,6 +982,7 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		can->completed_tx_bytes = 0;
 		can->bec.txerr = 0;
 		can->bec.rxerr = 0;
+		can->can.dev->dev_port = i;
 
 		init_completion(&can->start_comp);
 		init_completion(&can->flush_comp);
-- 
2.39.5



