Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CD0381DC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcnnJfdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F0CC433C8;
	Wed, 15 Nov 2023 19:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076935;
	bh=xNphWY4pnYBG6cOvTHL/NQlB9y719hbvUUH1ZATFHw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcnnJfdE91a56jCsQTMnCwfQdg/fQgkVQMX6FBzXzAyQJLREOIqD/otA/Oog3npDW
	 GQFK4NrksTxei26SfGPD18yVlIAnIoeNJTx7r7ain8R6o6y2l9aOaZ8LmPAtlZJw0P
	 Pmr7SuViybpirZAeGVhvrmJxcXOGKs46A786NJJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/603] wifi: rtw88: debug: Fix the NULL vs IS_ERR() bug for debugfs_create_file()
Date: Wed, 15 Nov 2023 14:10:18 -0500
Message-ID: <20231115191618.160955591@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 74f7957c9b1b95553faaf146a2553e023a9d1720 ]

Since debugfs_create_file() return ERR_PTR and never return NULL, so use
IS_ERR() to check it instead of checking NULL.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230919050651.962694-1-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index f8ba133baff06..35bc37a3c469d 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -1233,9 +1233,9 @@ static struct rtw_debugfs_priv rtw_debug_priv_dm_cap = {
 #define rtw_debugfs_add_core(name, mode, fopname, parent)		\
 	do {								\
 		rtw_debug_priv_ ##name.rtwdev = rtwdev;			\
-		if (!debugfs_create_file(#name, mode,			\
+		if (IS_ERR(debugfs_create_file(#name, mode,		\
 					 parent, &rtw_debug_priv_ ##name,\
-					 &file_ops_ ##fopname))		\
+					 &file_ops_ ##fopname)))	\
 			pr_debug("Unable to initialize debugfs:%s\n",	\
 			       #name);					\
 	} while (0)
-- 
2.42.0



