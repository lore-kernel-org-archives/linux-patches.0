Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC13DDC5;
	Thu, 28 May 2026 20:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000196; cv=none; b=J/UAJcqBB0nvL7xFeuYHwYLlgcdca2SB2PRzv0JCauCHoOnZ6K9PeK1K2XjT1uXxEzotMDjmgpblkuFslcpdOPicpd8NExyvlOhIsUrvvWoTcI2SujchW+5TUpv6G4lLJT+sKPL7Wlf5MiDarN2wpxvhl9U0X6NXIjLmdR6Tnak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000196; c=relaxed/simple;
	bh=SNGeyUku1yR0M+j4bDuQtfiOogVvdMEfujIb8vTnVZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ir9Nz1wkcjWbARg8AqLgHA8yaHdNSh5OZS4SP6EXHnBDf/Z5chKi7oyjrBY6HgkzRj0HTyeStZsSxDBVC1xkrw/N6DfuccRltx2quu3hTIg80x2Bzk5aRDSfpPKxcN+nhxNWf+cTHe+JTpatcIm7JOtBJp/xWb+UrIAdwW9TtXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfwHEFi6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfwHEFi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2890A1F000E9;
	Thu, 28 May 2026 20:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000195;
	bh=hLJ6hCJLFeivxUTIFNIOi7OzlakrUG1dHcB4eor9J4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfwHEFi6qZgy43BPO3VaYlyHGUDOxp6EY6pfTmIxanaWAdN36uTwXEhDA888178Tm
	 xhFb09iyJUFnUlQ0TsoN09d6Z2fqxSOSSiN779ADVW5Iv+Ji28jLgXYbICrQWo/Fli
	 aGo51iPy+Kbq9YTsFw6FjL54vNEuGBYw2VUD7Rh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shirazsaleem@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 336/377] RDMA/mana_ib: Report max_msg_sz in mana_ib_query_port
Date: Thu, 28 May 2026 21:49:34 +0200
Message-ID: <20260528194648.145467960@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fac159f7128d9..4143be70eea20 100644
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



