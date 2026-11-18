Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028982;
	b=r9KE6A4ztDOXByneK9OXKMriskSyuVovPJe99CjgW2leKnzLUgDs15LF64pnt21jKSWS
	 0XoIVIlKXK+ZUl9H3wQbx/mUpZMd//EIwIExS+NQxDGDoW8VOM3txrERgM9ILcLUUbTw4
	 0L0TROX2grRkOTnw+VZs/Px9g6fee1DzXQkSG0mlLi2xFTYR09zRMc2L5q+O1+XObqvok
	 ep4r8ChNprks+Xgg5aPE/RyWRzM3zepJrmS/MdQCLKfSk/xNfmgblIS+BvgKV457dLpa2
	 qBgBBOGGarQT69DdSygJ1BDpcU9H+lLcOOpM55DaoSIsvG9ugDUqazn6Y9AXpvFzfrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MlmLgTLNal2OTam+NsXvI3vDO24Bf+grMkXWMx5/q6I=;
	b=yBsGdMRlFsMZmlVZVecBIeZTW+M2GWBybKO6DfUjgxdXXd0XT37Z38ibw9Ww/KPeLEg5
	 yN/hLXr+B11bC/x7ie3snIQK5RJtkpFgMprG1yBO0tplU4LIKryAnANDerhnmjM78oZa+
	 +I3vUtol2yP6SG7/GYTxZm8zprzs76C2/bCpJsEY3pFA80Je8ht4kIeLvZGkhlAXPCHUk
	 0Uc1/JnAjCO9sWVXaXk22msjyo/Q+Sgc2Asf/B4AtVoWTh+BHz5KaTsWA4RVK2HZAYe6m
	 Z9q4SK6cLin0vjVweO7zuj/B0KWhzFapmq2BbMhMoctaMSxKZ7agMKMgkvOnHJn3mKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbFdjr8O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9A3606A320;
	Wed, 18 Nov 2026 19:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbFdjr8O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0BE1F000C5;
	Wed, 18 Nov 2026 19:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028981;
	bh=MlmLgTLNal2OTam+NsXvI3vDO24Bf+grMkXWMx5/q6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbFdjr8OY7yhQ+vhyJj6Mr9B0aGhduEFNGr5lQZNwViaUQuZKLMFeByCULH2G/K7y
	 Ov5zzWTMLQwEiBzpwZrn8LhXS86/G4mPaaY1afjRNpgMJsKDY0ZkJqgCo5Se1JKEci
	 Mg7QmTVA2eMY2MJTqlXCmZ7V1InCWi7hz9Lb4SR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0188/1756] staging: rtl8723bs: remove wrapper rtw_init_recv_timer
Date: Wed, 18 Nov 2026 15:38:35 +0100
Message-ID: <20261118150015.887260495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1b72f2196a1cf..6995b61aa67d5 100644
--- a/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
@@ -247,7 +247,9 @@ struct	sta_info *rtw_alloc_stainfo(struct	sta_priv *pstapriv, u8 *hwaddr)
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
index ca808ded61ac0..f76aaff15fd01 100644
--- a/drivers/staging/rtl8723bs/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/recv_linux.c
@@ -219,10 +219,3 @@ int rtw_recv_indicatepkt(struct adapter *padapter, union recv_frame *precv_frame
 
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



