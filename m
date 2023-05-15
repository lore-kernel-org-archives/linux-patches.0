Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05E6D512
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FB5C433EF;
	Mon, 15 May 2023 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168413;
	bh=d9P0oSvCc74Gj+kWRbi7jGzC0aVuIpRL7lB0mWSqU7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nig7tHkpx3YP3+sZkqtHXffvJIpzLMyE8ZCHxcUZG5ULUhFBi6FVk0uu6NdpSBTGv
	 c53Cyqw4GSPzyGSCdTY7qHShS7xicQjJd0ltzziEnNspkMg8j/ZdgLaHKbIzJ3pdzV
	 R1fgoUHuTuSzfxi9FODeb3LoBM/sjYwWiz1wwkQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 042/116] Revert "Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work"
Date: Mon, 15 May 2023 18:25:39 +0200
Message-Id: <20230515161659.658406662@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
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
index bd55bf7a9914c..20142bc77554c 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -353,7 +353,6 @@ static void btsdio_remove(struct sdio_func *func)
 
 	BT_DBG("func %p", func);
 
-	cancel_work_sync(&data->work);
 	if (!data)
 		return;
 
-- 
2.39.2



