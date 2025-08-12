Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EF21B87F2;
	Tue, 12 Aug 2025 18:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022527; cv=none; b=G182gFGmB49s7mWCgfSRpG1ooq6otirj9mbvTWSXiKmZqTM8LhgTgl5NjIu/Tro4uk0WoimGMXuHRnstq/21cwLueDQ6Ac2XrIAPgksXtUL7k148gK1YavpAYYFpztntbbsPwruZsafdUwSX/hZ0ZCrwWytrPQlBYHyDFHLSwHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022527; c=relaxed/simple;
	bh=CnZaCvyX/BIY4azgZh5uaYjFk2KnIKQb1uqb2h6Ifec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thORwXJnG9zaeJmOdJMskZdgiHp0TsCElmgFXf9AqE/eGpgl3cnuRwqO0Xj6g7JDcW8MyN2+BODebsIXg2qhRfNvlGJFc6hry+yXXYbAMiMBEkWcJOYodfZAuVonBA9iTNovMumkK/OLb9fBFRrJX/9wApaqV2+72hfjTsrxUIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGd1leYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGd1leYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7026C4CEF0;
	Tue, 12 Aug 2025 18:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022527;
	bh=CnZaCvyX/BIY4azgZh5uaYjFk2KnIKQb1uqb2h6Ifec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGd1leYzHIajCLQwrTTe4Z8BaVujPuWz+DxkaPTAKV9SB4pwtvS8Abqh6AKDEUy0j
	 +s2RMCoDc1wOava8ZgMy9lsGeJmhh+byrELpyi+spSCM/t81dpZW+tCtZEc7gZ9jbp
	 3WSsMV7pv2pEnpIS8hEL61quJ9iNBKngcS92dgpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/369] can: kvaser_pciefd: Store device channel index
Date: Tue, 12 Aug 2025 19:27:14 +0200
Message-ID: <20250812173019.931395425@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3fa83f05bfcc..2bef6da4befa 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -981,6 +981,7 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		can->completed_tx_bytes = 0;
 		can->bec.txerr = 0;
 		can->bec.rxerr = 0;
+		can->can.dev->dev_port = i;
 
 		init_completion(&can->start_comp);
 		init_completion(&can->flush_comp);
-- 
2.39.5



