Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039231;
	b=lQQdQFjlMkWgC/nAyIrS1WoIvHYKhK4iuaW/mOcmEOci6AkEiI/kVuGmQDp44LnOD//H
	 0/EaSEBSdGdY3bubtK8Tb6W0aRGx0apY+eTBAZD+TMWJRc9m5CqAygvqdd8IDFxWanmeM
	 C5d1rB3sJl+hBDl/Lhbd6nMWrsRUQNHOx3K0kMFfl1YQkWpaElqtxv1J+upEz78b1cmRT
	 DOyxBnXRLxIH52pBZLi6d95s7Gkr3Z7NSa6IYmI/5KKyE6eyG9kI7s37y4yLVxczhjaCA
	 m6N0ZmXwjVH0zdD+smuKKxgjJD2n+oBa9EaY1JnlbWSyWs9HhM4+eDrZd9BzryCrSVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iQi0iihcprGFw1RPFaEGJ4De5yelgi1OevIAk3OhXjA=;
	b=eOLdzFvVqAT9dK5eAU1XSzdNdobwfPvp3WZ0Okbf7K2s7zrur3I6UoxM1sE5+6btXSxR
	 HrdEBfKRjjK1OXm4caH8FSYPcMs8OcVooFXW/xVsNRLQCYojPpH56xCRfqyCrM6lF9RC4
	 2qrLyqBUDJIZ9XJxMyG7G242gg8xZlD3Jgp+tgYeKmxZKVAiBpvV4n3mFklE8v1Ty45YG
	 6bdRp+EF9LUKEtouokb5D1LGxn2liIA3DphzFKyWiBEx3TRgQMQ3Tfe3oGIVXmhPfdbUd
	 5gPolma7WFxbtBGkwkmmbOgw3suopg1M3yo4qJ+Sj+BBDyimQecthFGELaAXtoTY4IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VDqwIbft;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08262606A31C;
	Wed, 18 Nov 2026 22:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VDqwIbft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1E51F000C4;
	Wed, 18 Nov 2026 22:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039230;
	bh=iQi0iihcprGFw1RPFaEGJ4De5yelgi1OevIAk3OhXjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDqwIbftKulp8V74RVZsnx9ofCwTeuUeTwqq632n3vvVn4Z5kKHYbx1l/5vcLS9lG
	 LjuXKaZURY0AGrBJDV9QVocLDyNSRMajhcNio6ldCgWCg3NE/izRffX7sihp5TZMms
	 C1xoPIcb0imWhLX05uCFkn/PnC92BoxvaWGBZUDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2026/3318] staging: rtl8723bs: remove wrapper rtw_init_recv_timer
Date: Wed, 18 Nov 2026 15:44:08 +0100
Message-ID: <20261118150422.820041418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Straube <straube.linux@gmail.com>

[ Upstream commit 0149f27d1a248f013fe36d29bc391c303e853ee0 ]

The function rtw_init_recv_timer in os_dep/recv_linux.c is jsut a wrapper
around timer_setup. Use timer_setup directly and remove the wrapper to
reduce code in the os_dep directory.

Signed-off-by: Michael Straube <straube.linux@gmail.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250822135418.118115-2-straube.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: baa84b1bb164 ("staging: rtl8723bs: disable SDIO function on block size failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c   | 4 +++-
 drivers/staging/rtl8723bs/include/recv_osdep.h | 3 ---
 drivers/staging/rtl8723bs/os_dep/recv_linux.c  | 7 -------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c b/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
index 1593980d2c6a0..7bf6cdd43ec43 100644
--- a/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
@@ -249,7 +249,9 @@ struct	sta_info *rtw_alloc_stainfo(struct	sta_priv *pstapriv, u8 *hwaddr)
 			INIT_LIST_HEAD(&preorder_ctrl->pending_recvframe_queue.queue);
 			spin_lock_init(&preorder_ctrl->pending_recvframe_queue.lock);
 
-			rtw_init_recv_timer(preorder_ctrl);
+			/* init recv timer */
+			timer_setup(&preorder_ctrl->reordering_ctrl_timer,
+				    rtw_reordering_ctrl_timeout_handler, 0);
 		}
 
 		/* init for DM */
diff --git a/drivers/staging/rtl8723bs/include/recv_osdep.h b/drivers/staging/rtl8723bs/include/recv_osdep.h
index 83330ea98fbf7..ea0b58aa0ba05 100644
--- a/drivers/staging/rtl8723bs/include/recv_osdep.h
+++ b/drivers/staging/rtl8723bs/include/recv_osdep.h
@@ -34,7 +34,4 @@ void rtw_os_recvbuf_resource_free(struct adapter *padapter, struct recv_buf *pre
 struct sk_buff *rtw_os_alloc_msdu_pkt(union recv_frame *prframe, u16 nSubframe_Length, u8 *pdata);
 void rtw_os_recv_indicate_pkt(struct adapter *padapter, struct sk_buff *pkt, struct rx_pkt_attrib *pattrib);
 
-void rtw_init_recv_timer(struct recv_reorder_ctrl *preorder_ctrl);
-
-
 #endif /*  */
diff --git a/drivers/staging/rtl8723bs/os_dep/recv_linux.c b/drivers/staging/rtl8723bs/os_dep/recv_linux.c
index 4d28b300b2358..b2baba97c06fe 100644
--- a/drivers/staging/rtl8723bs/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/recv_linux.c
@@ -220,10 +220,3 @@ int rtw_recv_indicatepkt(struct adapter *padapter, union recv_frame *precv_frame
 
 	return _FAIL;
 }
-
-void rtw_init_recv_timer(struct recv_reorder_ctrl *preorder_ctrl)
-{
-	timer_setup(&preorder_ctrl->reordering_ctrl_timer,
-		    rtw_reordering_ctrl_timeout_handler, 0);
-
-}
-- 
2.53.0



