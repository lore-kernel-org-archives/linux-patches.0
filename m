Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054893;
	b=FiCadeepQ8DFufZRACaUHRAhjzeWzaQ28ekvIAH10BuQwYEKZ8EN/2EUREPo9odluXRj
	 SPp8AnlodHobqkMUdAKTnNGm5JWKw0vOx3CzUHehgMvdl22pTq/A2wewVHTN0xi7xFsHE
	 8qohb5NkuxDw3FUqsgI+KJNGgHM5vx+cu9+oemuXqY5nV6BVlIdPDHp3DiLTkExb7eDWl
	 Kcxmenha0qdM4TzVa59cO+iUbR9x40uvB01O49qAJpNv/7r5gWY3DwKUYEm5O0xKnNlmZ
	 tfmFoLjrrhxpUZvoqFiaW44YMLVGLtJ1yQn82PcX/cbgP5J8Aakk9LPZsVBWcV/E+ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oYSBekXq5kfj+obdno2aPnGwV2bGL/HWo95DQEdI/d4=;
	b=qrzDWW1P5fn76nEU1Mv9KKYz8FVqPzHo3XXW4u3v3xeCteC3ZU5otN5SwZOa41Ce30Li
	 W/srwpewuN6Q+lohYDP1geFpaP7QhaEoStt7QWkei6VoU9Rw72qgCMdP/2qRE/nQWv3ws
	 b8xWKhr4re9lbRMyw38zTblaw3KkZStlJLNHOxwcDErGeWP1mzAxGvOEIF+G0NCWw0gQL
	 Vgar7VgP0oGLYWVwHCWpHjfnE/6yBU/3E0NgAqwUkuv6CmKnkUfi29anmVjiPxfYdXL8o
	 6ldxJwsINnn4/OQe2emKvfp+k8CeMlZA2aHeTJHT6CBsFi85Wks5tO6tNTTmXi5RO3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x0jpOnPS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD21606A31C;
	Thu, 19 Nov 2026 02:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x0jpOnPS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B5B1F000C4;
	Thu, 19 Nov 2026 02:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054893;
	bh=oYSBekXq5kfj+obdno2aPnGwV2bGL/HWo95DQEdI/d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x0jpOnPSQopiQbTGNLmwWpLRaOqEh/+0DBDb7cwxr4YEj9akR+Rvfqx+PT/8Mls3X
	 q/1ACpVjE2Wq15WxPZH816K5g304bCfdBZDmUGkDf0foxKlMt2bdsOLsxeWj0lg6EN
	 uNB9T51Eq8QyFcxCMiBqI+koeGUbun8bkq5UnLAc=
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
Subject: [PATCH 5.15 1420/2214] wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()
Date: Wed, 18 Nov 2026 15:51:36 +0100
Message-ID: <20261118150108.023158367@linuxfoundation.org>
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
index de8b632b058ce..348886bbc2ec7 100644
--- a/drivers/net/wireless/ath/ath11k/ce.c
+++ b/drivers/net/wireless/ath/ath11k/ce.c
@@ -316,7 +316,7 @@ static int ath11k_ce_rx_post_pipe(struct ath11k_ce_pipe *pipe)
 	dma_addr_t paddr;
 	int ret = 0;
 
-	if (!(pipe->dest_ring || pipe->status_ring))
+	if (!pipe->dest_ring || !pipe->status_ring)
 		return 0;
 
 	spin_lock_bh(&ab->ce.ce_lock);
-- 
2.53.0



