Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043172;
	b=4zBsWoHXSti9iwY9RDrXMGUpE7rJOnddzKA753eEArbxmTXy1Ud7W8xGebXjTHvrEs25
	 big4PTKzUAs7tPgUQ9hDNUvzcB/LvxMtMigdYHcUhE/eV2+XxU9jnyw1dEEn5V+vrHlXp
	 7/dTfKIwmQabsvvcwbURMRcypsAECMLUEAPd7sj7uMsW+vsOWJB80grYD2ik6j7kgfzAs
	 XbUw76HtipDk3mzq8LK9oLd2SquOmDF6bxgXdHq8QZrJPBtY4erk5FHtTXg95sPZiuWlH
	 lXn5uqufs2whofJJ0NRj902Kapvgb1gg6okuV6GWbAbEZSxpRivPIqoBil9wH603sVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2aQjos85i+PfAM9x78/nparFfmIBSMG8bHw/xqEwjBA=;
	b=OZvrNhzvqoy97pWdkTmj/zwSRMWK7XvL8+RoHBv2obaj2Ku7Pchu0x/6X0UYFL6ujNrZ
	 RDNJG876s5ZU0Np46Ldy7Y8gEJYE2kT1QnNVv0JkFBrVJp37t2a21j/R0g7Qj7OHt+UXk
	 CqS3yVuHLu6zMPsTrHyp1w59O6UKWwAyhpjbuHNLDMLmCrhIi1IDEWGKBiBAeyli4vdI5
	 Mi+im7m+aijYoM69IbSkyQuI3v0NVUBx5Fufwow2SOF07jz9a7d4UsCJn7saDmY7F/e9e
	 YhlZIV5JDbJPQL8MHEdn7raoxbO+9ycNcg9R9uU7yecq7i/M5z9cVU9JhMbh8eCsfJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUKi9kdd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96F5606A32A;
	Wed, 18 Nov 2026 23:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUKi9kdd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AD41F000C4;
	Wed, 18 Nov 2026 23:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043172;
	bh=2aQjos85i+PfAM9x78/nparFfmIBSMG8bHw/xqEwjBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUKi9kddCwCSNnCcJfhOUh6neUcCudpOTo0O1PcEXKq1qAXef2bWw23IJB3s3lGGx
	 SuH+OOaPoCnAbSWVyha9XtjBsVrOWdPLs8gLPrKVNttUBn4dl6TOeVI7gufplxYrYM
	 znFtgNissE373sL44wBOZlj3xWVNOscjV6DyJtqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0117/2857] misc: hpilo: validate device queue entries before use
Date: Wed, 18 Nov 2026 15:19:11 +0100
Message-ID: <20261118150205.569133988@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 7bf6940d7cf41f1f0330a9bae4b7a886e18fd8e3 ]

ilo_pkt_dequeue() trusts descriptor IDs and lengths read from the shared
FIFO entry. A bad entry can select a descriptor outside the allocated
queue memory or report a packet length larger than one descriptor.

Reject entries whose descriptor index or packet length exceeds the queue
layout before deriving the packet pointer returned to read and write
paths.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260624190919.3432-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/hpilo.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 8d00df9243c43..64795066e196f 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -158,11 +158,16 @@ static int ilo_pkt_dequeue(struct ilo_hwinfo *hw, struct ccb *ccb,
 
 	ret = fifo_dequeue(hw, fifobar, &entry);
 	if (ret) {
+		int pkt_len;
+
 		pkt_id = get_entry_id(entry);
+		pkt_len = get_entry_len(entry);
+		if (pkt_id >= NR_QENTRY || pkt_len > desc_mem_sz(1))
+			return 0;
 		if (id)
 			*id = pkt_id;
 		if (len)
-			*len = get_entry_len(entry);
+			*len = pkt_len;
 		if (pkt)
 			*pkt = (void *)(desc + desc_mem_sz(pkt_id));
 	}
-- 
2.53.0



