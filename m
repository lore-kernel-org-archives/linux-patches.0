Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6289B125DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5F5C433D2;
	Mon,  8 May 2023 10:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541980;
	bh=WBQHgrZivu1/vaqI2bSpJ1ggUsNp54OLvpEqeScgugQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXJFRZDVdoYrEkMksl8SXr3ALu5QNhOnK6PrK+KIGh3YVci1yKVhoYaP/3HoIRBvh
	 EJKWteaNaVNhHjETcqv4l2CqZSA5r7gK6TzCzp4GppgAkLCDSGDIVr6NprmXmgQVpD
	 YY3c8rInHaqteVkauN/iFEkGTJGOwKB+JjuICiok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+555908813b2ea35dae9a@syzkaller.appspotmail.com
Subject: [PATCH 6.2 288/663] wifi: ath6kl: reduce WARN to dev_dbg() in callback
Date: Mon,  8 May 2023 11:41:54 +0200
Message-Id: <20230508094437.555946167@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 75c4a8154cb6c7239fb55d5550f481f6765fb83c ]

The warn is triggered on a known race condition, documented in the code above
the test, that is correctly handled.  Using WARN() hinders automated testing.
Reducing severity.

Fixes: de2070fc4aa7 ("ath6kl: Fix kernel panic on continuous driver load/unload")
Reported-and-tested-by: syzbot+555908813b2ea35dae9a@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230126182431.867984-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index c68848819a52d..9b88d96bfe96c 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -960,8 +960,8 @@ static int ath6kl_htc_pipe_rx_complete(struct ath6kl *ar, struct sk_buff *skb,
 	 * Thus the possibility of ar->htc_target being NULL
 	 * via ath6kl_recv_complete -> ath6kl_usb_io_comp_work.
 	 */
-	if (WARN_ON_ONCE(!target)) {
-		ath6kl_err("Target not yet initialized\n");
+	if (!target) {
+		ath6kl_dbg(ATH6KL_DBG_HTC, "Target not yet initialized\n");
 		status = -EINVAL;
 		goto free_skb;
 	}
-- 
2.39.2



