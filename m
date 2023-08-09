Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D071773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89324C433C8;
	Wed,  9 Aug 2023 11:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579870;
	bh=l0Ua5GK+ughoS+OZYlkfIYWZsEhrTxFr92Gg/l9diaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cj/xI/9lUrIX7Yd8NXFmjqPtkNnxod54FLdvRUQkEmZZdeTC/Gre05G7zKlVPPCy9
	 a8//M+zoWM5AJrcUe0Q4F3yw9r+f/lWcjwcKoTUbLfIrOuHl/cDW/fdMGjW568XR2h
	 gP2trPuL9tMkV07EJjH1MKJPm44k0CtffL/AsskM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Serge Semin <fancer.lancer@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 146/323] NTB: ntb_tool: Add check for devm_kcalloc
Date: Wed,  9 Aug 2023 12:39:44 +0200
Message-ID: <20230809103704.827684830@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 2790143f09938776a3b4f69685b380bae8fd06c7 ]

As the devm_kcalloc may return NULL pointer,
it should be better to add check for the return
value, as same as the others.

Fixes: 7f46c8b3a552 ("NTB: ntb_tool: Add full multi-port NTB API support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/test/ntb_tool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ntb/test/ntb_tool.c b/drivers/ntb/test/ntb_tool.c
index 6301aa413c3b8..1f64146546221 100644
--- a/drivers/ntb/test/ntb_tool.c
+++ b/drivers/ntb/test/ntb_tool.c
@@ -998,6 +998,8 @@ static int tool_init_mws(struct tool_ctx *tc)
 		tc->peers[pidx].outmws =
 			devm_kcalloc(&tc->ntb->dev, tc->peers[pidx].outmw_cnt,
 				   sizeof(*tc->peers[pidx].outmws), GFP_KERNEL);
+		if (tc->peers[pidx].outmws == NULL)
+			return -ENOMEM;
 
 		for (widx = 0; widx < tc->peers[pidx].outmw_cnt; widx++) {
 			tc->peers[pidx].outmws[widx].pidx = pidx;
-- 
2.39.2



