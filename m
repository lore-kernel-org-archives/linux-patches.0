Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E23171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57175C433EF;
	Mon,  8 May 2023 11:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546024;
	bh=QLwEUQ8r5I1I2kHhKLZebL/h2n+2wf1rb1yeKN38Q7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vv9VXI8V/uNnnnisLcLGW3kEsDuQKK7iFTB8hAKa5CQeWzsLuTKiT1Z6B+jrSs+bl
	 TkrbL+3QArKoFwARWHfDWEe66swersc95QK/ZLZbWPX6xilYvBneinv55+Yv8zVnzo
	 kzs+vYLQZ1KuaZjEj/lrNQHf1kdj3qIdYIZfBkao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/371] Revert "Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work"
Date: Mon,  8 May 2023 11:47:13 +0200
Message-Id: <20230508094821.276949044@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit db2bf510bd5d57f064d9e1db395ed86a08320c54 ]

This reverts commit 1e9ac114c4428fdb7ff4635b45d4f46017e8916f.

This patch introduces a possible null-ptr-def problem. Revert it. And the
fixed bug by this patch have resolved by commit 73f7b171b7c0 ("Bluetooth:
btsdio: fix use after free bug in btsdio_remove due to race condition").

Fixes: 1e9ac114c442 ("Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btsdio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
index 7050a16e7efeb..199e8f7d426d9 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -352,7 +352,6 @@ static void btsdio_remove(struct sdio_func *func)
 
 	BT_DBG("func %p", func);
 
-	cancel_work_sync(&data->work);
 	if (!data)
 		return;
 
-- 
2.39.2



