Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024878;
	b=yiire+LAebHKrRPurgrSufSQoTwJOTj5BSMzhfRMID7e8JL/V0nStt+cfByyrZrwpDSg
	 yo+cSu9Mcfodb/7gTT0ZWTY3EW6mryn+0mhE0zoRhlg/amkc+HjwCgrONyGNNNiN0tAzX
	 /zp7ikRRSWNREc8eua2Tm23vEbYeUEkHFwcWdtq2uytfQKQLP3MdpAbrhdvhjIyNVLA3s
	 FjjKCkaUDCUF1ocSPFNAr2EDht98NxkCS2HRxjSMIIHmVYLe9Vk9KHjmKWOvjX1wsR2vb
	 68c5dK+uNDgT6lyKw6/MgXiJJkEx2t0KcxvcfyreecnXSYJBb2SO+/kblEkp5ca9ExQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PGJr6YymcDJK8GeLSyKOxy8M5gaZ9zvsqMJMHt4AaVM=;
	b=N6I4RfnIvRqiciBczIyhOIbRGVwGdu+WfMFDGvvJELMTtyYpCjIclNUIhuv932EfOKhg
	 e8vtoRnEHBBg4AtG1ntujonN5qiQF3ACo3GMYuj/g9sdIGZC0vMo7CBoPIlexAeS0Ermc
	 dK/Pmpn2NfQ/ul5Lrx1XSQI2AG7s09K5fyqhjxGClGfYFToAGap61eaBVkvjHA7TeUrHv
	 /2EpOuCWND+qevi10/4g9Sq6PDW5VOz7y9IdQChXPIBiIYn4ftS+i0aoShWm4oz3N302K
	 bGL3P+Nle+ldrsu2WfTQfeuah3YxqinlHbFyx9uRTxJBB7TxvtehI8oPfLJqkSCE8Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Gmtjne0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFA2606A31C;
	Wed, 18 Nov 2026 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Gmtjne0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5AC1F000C4;
	Wed, 18 Nov 2026 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024878;
	bh=PGJr6YymcDJK8GeLSyKOxy8M5gaZ9zvsqMJMHt4AaVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Gmtjne0B79UpcsxaO3be6cm5QhuZ0VZ2wecS1GhJoNZXs3jHs1vJdvzSExEZwCr+
	 U6+dIS0hr4vAMbqZwPeOmfvRRCgWhgNenRvRRw1MxQG8gBRY/gePAO4KiPXA/TQMyz
	 hZfNritNB97IyAJHVAG0onpF335KWlLXcxKGV6/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0882/2151] RDMA/mad: Reject receive completions shorter than GRH
Date: Wed, 18 Nov 2026 15:43:37 +0100
Message-ID: <20261118150154.431100438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 2dc2126e690203d6adbddc7675927a242d810e43 ]

ib_mad_recv_done() derives the OPA MAD length by subtracting the GRH
size from wc->byte_len without ensuring the receive completion covers
the GRH. If it is shorter, the subtraction wraps before the result is
stored in mad_len and an invalid length can be passed downstream.

Reject receive completions shorter than the GRH before inspecting the
MAD header or deriving the MAD length.

Fixes: 8e4349d13f33 ("IB/mad: Add final OPA MAD processing")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260926105927.3183294-1-yaojiale02@163.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index f7ad35233c2df..daad0be9054b6 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2342,6 +2342,8 @@ static void ib_mad_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			    recv->header.mapping,
 			    mad_priv_dma_size(recv),
 			    DMA_FROM_DEVICE);
+	if (unlikely(wc->byte_len < sizeof(struct ib_grh)))
+		goto out;
 
 	/* Setup MAD receive work completion from "normal" work completion */
 	recv->header.wc = *wc;
-- 
2.53.0



