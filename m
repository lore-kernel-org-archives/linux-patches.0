Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BB0C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06DCC433C9;
	Mon, 26 Jun 2023 18:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804628;
	bh=gOlwZNLr8Saa3uQulc+67b8HfRPJx8sctzYSPSUTjig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3/Yye689u7hzYsnGKqXGBdufKpNsy4eTGrGEn7j9WbkqlqO5oT26NTkP4MWqK3As
	 Wl2AytzD4o5Xqt63jTEbhTAt9+dWcFiS1GaOCX8jVsNdXD+d6j0D15y/6KshelSuvw
	 rMRRBsiAooQU97L8MIccU1fniZwjMd1tpIbI0/hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Muhammad <osmtendev@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/60] nfcsim.c: Fix error checking for debugfs_create_dir
Date: Mon, 26 Jun 2023 20:12:27 +0200
Message-ID: <20230626180741.556401766@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180739.558575012@linuxfoundation.org>
References: <20230626180739.558575012@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Osama Muhammad <osmtendev@gmail.com>

[ Upstream commit 9b9e46aa07273ceb96866b2e812b46f1ee0b8d2f ]

This patch fixes the error checking in nfcsim.c.
The DebugFS kernel API is developed in
a way that the caller can safely ignore the errors that
occur during the creation of DebugFS nodes.

Signed-off-by: Osama Muhammad <osmtendev@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nfcsim.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nfc/nfcsim.c b/drivers/nfc/nfcsim.c
index dd27c85190d34..b42d386350b72 100644
--- a/drivers/nfc/nfcsim.c
+++ b/drivers/nfc/nfcsim.c
@@ -336,10 +336,6 @@ static struct dentry *nfcsim_debugfs_root;
 static void nfcsim_debugfs_init(void)
 {
 	nfcsim_debugfs_root = debugfs_create_dir("nfcsim", NULL);
-
-	if (!nfcsim_debugfs_root)
-		pr_err("Could not create debugfs entry\n");
-
 }
 
 static void nfcsim_debugfs_remove(void)
-- 
2.39.2



