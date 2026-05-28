Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5CA33F5B4;
	Thu, 28 May 2026 20:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999077; cv=none; b=XMoqlNSyqFaB/G9FKGDOcbk3Ah34onGgK7uM4Q4m+ErFNObpaYgHh8NBeu21wSELmCJJVBaO9G4YLydjEUJZiO0oMIrL3cibmYMXyrM00285IilbcBD7Wr/jHNyZTJu/hEgVLsVyFb/wanrVNz8S50CQF3xXKCXquPN93H9jZX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999077; c=relaxed/simple;
	bh=UbzBxR1D6xG30ZtVMjhyc9CDzztePRYNJSaX35OUR/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlrNCOfDzXwPKVbeSFRX99J4fBf1mosU4LSjoAdMe9KISBcbUsa5aurylRQq642UUEFDyu936jtSwy4qyprpIVMxl/erajNA36bP7e7uD5w8S7O/861YC6Sitq3VHZnEC48Zh4Ut+AFFzjtvNEwn410xYsRPSGTjm+UtOCHPRtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRiWvZtM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRiWvZtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA9E1F00A3A;
	Thu, 28 May 2026 20:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999076;
	bh=CfCVJZtIDgjUy3FQej9/jGvMZIfpQI7Dih58CQvc1ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRiWvZtMZZf6w2X+PvqrIQvjGfAF6B4tsR0IzrVhQZKubJ+n68QM2RxxKYVkWVKqz
	 y9zCnFmAZY2pu4zsL1BMphfCDIDpMuEE/lCpOTGqYbxRZO3sTi76PT7CZT0elLGUDV
	 WYqpaMKJU6xQwcKwiANc5PCrCMYicVKW9r1OoJFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 401/461] RDMA/mana_ib: Report max_msg_sz in mana_ib_query_port
Date: Thu, 28 May 2026 21:48:50 +0200
Message-ID: <20260528194659.082504416@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiraz Saleem <shirazsaleem@microsoft.com>

[ Upstream commit c9a40f6531b81baa9619bcc2697ff86896afcce7 ]

Report max_msg_sz for mana_ib, which is 16MB.

Fixes: 4bda1d5332ec ("RDMA/mana_ib: Implement port parameters")
Signed-off-by: Shiraz Saleem <shirazsaleem@microsoft.com>
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://patch.msgid.link/20260512094209.264955-1-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 8d99cd00f002c..d913f885b3ef9 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -639,6 +639,7 @@ int mana_ib_query_port(struct ib_device *ibdev, u32 port,
 	if (mana_ib_is_rnic(dev)) {
 		props->gid_tbl_len = 16;
 		props->ip_gids = true;
+		props->max_msg_sz = SZ_16M;
 		if (port == 1)
 			props->port_cap_flags = IB_PORT_CM_SUP;
 	}
-- 
2.53.0



