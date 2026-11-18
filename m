Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047803;
	b=UYdhU8GkVxMQNxma5XboLpwH1TkY/4ipdgNbfkQV4N1Z7O+iW29VKnEIbPcTrnlnmUj8
	 GdmWxTJvyODb6YzVF9lhSMbLMFZCAYnjUwzQ5bMYpwvj3tRlVce3cOSad8q5KaaX2FQIs
	 eoO28wPWee5CCjBX5lOxIDOlEPKD0jYYHokM0VK6AG3qW3V0HhmUEOCMO2dVTAeEBjYYs
	 j5l5eP3N01RFo/YFOCJRbtswugYDWSec4s9F2aUvT0zyqw2+FCTMVqDsfRsY06BLEKSXH
	 CA7t0jlCN/nB1+rASozYP7dmSlf8C3RqQhEQt0pSig2hq6Hbpg1o6ICduv+PFaW3b3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GvUopHRKBIX6WYbgom8FjI5lA/Nbu0WPMG2fABrJtmo=;
	b=3I4Q+2z2YNN4mKqeoRhVluttgJEnHW6qfKldZ9AwxHQMX8fhVFnkclJRtpNwoKLJJZte
	 m5ptm/+XChejKEZtwyaYQwvVLqJm2f4XA5yvJ31O7O4OIv1K+lGL6eV5/KSQQh4uRl7q6
	 uMTHEVhvPsV4shuCqrRQu/q8eAjwV4oJ3khkmkowJQ3fqfo9od+v7HtKFzH7iLbjkBR+B
	 V4iXfSpPYl10deE8jQsJHDapl9aalb3DW55C5RCXmH4/e32Pm1a3EtRHUJqTd4qlcRd3B
	 rB6VsyHKnmwUANXXZgSmb63/XW+/G1ePVA7hP66Fngld3M8FpN1O1u8K7YaYnqHb2ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mlZz/Xoz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DE0606A320;
	Thu, 19 Nov 2026 00:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlZz/Xoz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976F71F000C4;
	Thu, 19 Nov 2026 00:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047803;
	bh=GvUopHRKBIX6WYbgom8FjI5lA/Nbu0WPMG2fABrJtmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlZz/Xozn/iucLPhSbY7vhHYJ8QJflPFXl5qMYvNMhO3wJ2CHVHmBzSwcYMcKS8tb
	 QCu170NU1+vhZG7ceLdHitkzNu3D67ci6hwNuaN4mfnzkMeIjJ2uZ5OKPZaMEJWCrd
	 HZUXUQzEk+EHTsqPoY1o0cHFSnA+Y4ftgZoV59vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1767/2857] staging: rtl8723bs: remove wrapper rtw_init_recv_timer
Date: Wed, 18 Nov 2026 15:46:41 +0100
Message-ID: <20261118150304.910425837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c7de81f21bec0..39452e340c3da 100644
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



