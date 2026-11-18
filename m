Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029257;
	b=xIchh0YcptjN5gfBBUrOAzPQYn2CvIaBaJt/tgnAIYPmjEWwoGHBmMlIq3nMRlhSfwD/
	 E8HHJlzXmykAAxjBbkwIUweqo3ngTZa5kae/Edthup55UirwbB0V+KPVY2SKPvqI0CNCU
	 t/c+YsndmHc/tDPd2KyoEkTtuM/OMH/1yQxSkas4DhbkV1CdKAFxfmGixeST3Jt07MTyg
	 rArrPefH6ws1TrXEKAMulqou3MkpJyVqIv1HIsrUh2fh2i96DDbIbtfQ9kFwKqqHqJUGJ
	 vsrxeAYDB+eWNQt7ErqcszJefDhmgxZbAZ1xaOdLNTintsbmjgg8NgLENE+9YZSWfpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BUEbwvz9scLU7bF76n0C533KzSV28BGPiVyOwFd/hjA=;
	b=kxdINSXU90vzoYx6FfaABYGExyF0HvmhYQj+jZMBQFOvStK18v4NO1RquLH4XaO1mVI6
	 +Rp+mXZqnPTw1OogCan8RX24xvI5vhLR75ZkWB4EgZHaYUj9UN93AmDLdF6daHILGn41E
	 sEZHICTayie7N6wfEjyETJOsvw9qhaS+u73RcuYZt5sSLSVkv0D4BNlfz7aHRZ5DPiCjH
	 6Fz/RY1S1Rpc3sM1AsdmNm6kkpe9FguZqYwR4T2j/pczTRVMmAJBaeD10JtYBPq81GWvF
	 EsIA9SB3moFS0i6xcfEQPZ4Kkp8TEuxvOMXo3xbaw6l8EYj+/Kpq5rJ2OUBxpOpJRZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vyef6jUU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A612606A31C;
	Wed, 18 Nov 2026 19:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vyef6jUU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24941F000C5;
	Wed, 18 Nov 2026 19:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029257;
	bh=BUEbwvz9scLU7bF76n0C533KzSV28BGPiVyOwFd/hjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vyef6jUUb54DxCBKxS8C78drM6J6A8E9yizSguZmdSkAVGhrgzW4tErVyvChZPHmm
	 7s4tTU4sNwS+psjGbsE9k0IRvihfZBWEtFTbRXso2tpash2822QvV4mykWURBLb2bj
	 w/Utzke5p+JCpDAeq+YfsgGkMiatecRYzq8ytx1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosalinux.ru>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0286/1756] wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()
Date: Wed, 18 Nov 2026 15:40:13 +0100
Message-ID: <20261118150019.786944964@linuxfoundation.org>
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

From: Mikhail Lobanov <m.lobanov@rosalinux.ru>

[ Upstream commit 52953d149ab4da0432d54b09f3c8add42b4d4a82 ]

The previous logic in ath11k_ce_rx_post_pipe() incorrectly required both
dest_ring and status_ring to be NULL in order to exit the function.
This caused the function to continue even if only one of the pointers
was NULL, potentially leading to null pointer dereferences in
ath11k_ce_rx_buf_enqueue_pipe().

Fix the condition by modifying the logic so that the function returns
early if either dest_ring or status_ring is NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosalinux.ru>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20240909150824.28195-1-m.lobanov@rosalinux.ru
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/ce.c b/drivers/net/wireless/ath/ath11k/ce.c
index 39d9aad33bc69..7f2c91fd7ab3a 100644
--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -324,7 +324,7 @@ static int ath11k_ce_rx_post_pipe(struct ath11k_ce_pipe *pipe)
 	dma_addr_t paddr;
 	int ret = 0;
 
-	if (!(pipe->dest_ring || pipe->status_ring))
+	if (!pipe->dest_ring || !pipe->status_ring)
 		return 0;
 
 	spin_lock_bh(&ab->ce.ce_lock);
-- 
2.53.0



