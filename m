Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054695;
	b=Xd94tEsLL3GVpfZgQrOPp63DNEhtZZxHMtZBSMsZyYAQeVEb9oaDkAeC384JMdj0T5s1
	 qINbOVYtGaTUXYhyk4gAIDtmUhE2NnohRQ7OYY8gMBLllOyXKElBr+852kTT1ufsGHvZI
	 EiW++MR80Aida2P8EF3R8whhn8PQAmvoWkbnznjT6zaDEAE9/gxfi4eSySs8ef+74+/fv
	 aufc6WOYbvWXjidb0gMCJJ08/7Bdzbke5DfS5RapeFCARS14SCHUi5GPekMBzqsyo3vbK
	 netLlST++o9Pfh6B1p7TvRs5j2zV/jvfJoaAZ/nlJNc5xs45+aVG+p47nu3SJKppdWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jK4onPKQ0merlzD9A8CM/A8EXgBMPb0C9S/vDyYM4iI=;
	b=ypLlPOltnFa+z+hZyJi+JIw5XI33zaPwYaJ8CaY9UdRrzZv/uwlMGAY1COH/l65gPBG7
	 cAppxHhua5W8OZLztezCkXgv6dNjjBO8Zh2ldSM9/coxowiOyZkwKYyeiaF2r8fbgKBy3
	 dlPyJLnFpPWCy4aOh3tpDxKJd5CpjEvkN4AboKf7fb1rnx5oANB9LwAAwt6U1su5ickLU
	 gWGxDzCbHcBZ6uZlZNePwLf5jJ9A5lLoFhA72MWfi1AnCYQsrgqseiQmiFVEZDS0kgziw
	 CIyF0/IQjzHWMpkkhwas1ssPy8fBCTG3PuMx0GpNW8AQuWnptNinIjMMbNAEGCR2y1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObAdOcG9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4906606A31C;
	Thu, 19 Nov 2026 02:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObAdOcG9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1422C1F000C4;
	Thu, 19 Nov 2026 02:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054695;
	bh=jK4onPKQ0merlzD9A8CM/A8EXgBMPb0C9S/vDyYM4iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObAdOcG9AcAT7rNvG7LkeaZejs9Pb/54tFoYb6iTsH2dHU8bVEuLAGbJdLu+mtwhi
	 7mtQOKJCx1zzsXnV5zudIfCQUjphwR2qLFaVS9Xvw5k91hx793c54oUiHz+u3sGfIJ
	 OdnjflJ6bCrMc13nl7TPD7i2i16UtgnasTXsocn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1365/2214] staging: rtl8723bs: remove wrapper rtw_init_recv_timer
Date: Wed, 18 Nov 2026 15:50:41 +0100
Message-ID: <20261118150106.056156604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5eae3ccb1ff59..280b9f7facfdf 100644
--- a/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
@@ -244,7 +244,9 @@ struct	sta_info *rtw_alloc_stainfo(struct	sta_priv *pstapriv, u8 *hwaddr)
 
 			_rtw_init_queue(&preorder_ctrl->pending_recvframe_queue);
 
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
index 88a69c7ca8f25..ccabbb4a815b7 100644
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



