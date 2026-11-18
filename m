Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015353;
	b=UU3tQHFfCOluXqrfSX4Is7N2+piwXXn3neZ5TU7raHozXhjlaL4BOp8Sy+f7jNvVsJE/
	 IUtrz24KICWTqAGGhd1bj9H1ckb4KXyJrJtp6EfvIpa2SPDwBfKvSEY1rgbnVdDQi0lWQ
	 IBqHOMtK+EBB/YBwKIDJOGMxt1+Hv5lsRqlg6wVgar+WglUCABFZ5cvydPmGs4uCdcupM
	 iA8ynKEe0Si5dWRcxGiBbdqJObU8D+JRFQ7iKGbUH7xQ1+4Tcj9eUxSQT11zwWwcorM/a
	 S+HxClSpQPgcgDrl4x6wmwtMm3p28Jm+QQE9IOTsolsJiFUant1B1ZhiC4H2nlD9ztg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DAbgQ6AbIIWjg9T5A/7otg/jU1DrctgKKG8AcK0udL8=;
	b=zWs9xRGIv6ClcKHg3Ryn/xpusA6n2srniNmpvXQBGMV7w6UPrVaFDQ3p6CBzcQ5ri8NV
	 xoXfqK8RAeRXuCxpxBS8jQIH+zhDYoyovpAT4VMJ42102vaFRbRdoXDCp5jb6DdG4lQvb
	 xLmqUQeBTVEC4gP+tjzZn30glWA+A8wNCD6oLPLf8iGRx9QXzeTd6TO3Hx/oPjZ/kchL/
	 QsVBp0aZoDx1txj0UAt2QVxlVfVVnTIQLJuK4jMAsfrInnr+uXzQM63Nx0feyx6AxMCvB
	 zS+TLqh9AJekfZrzZrK4JCHq0BKUd8Z/HajS/2Nu53QEwEc5D2vxOED/5D4ATjvGAAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KgO7b5bw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA6F60A2603;
	Wed, 18 Nov 2026 15:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KgO7b5bw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28091F000C5;
	Wed, 18 Nov 2026 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015353;
	bh=DAbgQ6AbIIWjg9T5A/7otg/jU1DrctgKKG8AcK0udL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgO7b5bw6f8PU/9qAllW9wl4ixvr6bvnpxFY92Qj+7lMSdO1ynePaA2rzbC5EeQ49
	 DvkGybtp0bRJ6bE888EPr+K+pxjF3jGpVV6QmQlIGbNKYJT+n2A8bFw3B0NlDQFelC
	 aEuJ2PcnqC3P8QjHzgxmP6nsVPdv2Vn7RBr33qzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orgad Shaneh <orgads@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0143/2651] staging: octeon: schedule the TX cleanup tasklet every 1024th packet
Date: Wed, 18 Nov 2026 15:23:03 +0100
Message-ID: <20261118150252.996435136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orgad Shaneh <orgads@gmail.com>

[ Upstream commit db57f6517bf65523968ae29cd34a790bfa7d32af ]

cvm_oct_xmit() means to schedule the cleanup tasklet once every 1024
packets, as its comment says, to cover the pathological case of heavy
traffic on one port delaying the cleanup of another port blocked
waiting for it.

The test is inverted: total_to_clean & 0x3ff is true for 1023 of every
1024 values, and false only on the multiples of 1024. So the tasklet is
scheduled on nearly every packet, and skipped on exactly the packet the
comment wants. That costs one TASKLET softirq per transmitted packet,
each walking every port and doing an FAU fetch-and-add per non-empty
queue, and it buys nothing for this port, which already frees its
completed skbs inline from the skb_to_free value it reads out of the
FAU.

Test the mask against zero. On a CN50XX board (2 cores at 300MHz)
carrying ~6.9k transmitted packets/s, TASKLET softirqs drop from 7133/s
to 597/s with no throughput change; the freeing work is conserved, so
this removes softirq entries, not work.

Fixes: 4898c560103f ("Staging: Octeon:  Free transmit SKBs in a timely manner")
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260820113239.8169-1-orgads@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index cc20c1e6791fc..5e536827f87ad 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -481,7 +481,7 @@ netdev_tx_t cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 			cvmx_fau_fetch_and_add32(FAU_TOTAL_TX_TO_CLEAN, 1);
 	}
 
-	if (total_to_clean & 0x3ff) {
+	if ((total_to_clean & 0x3ff) == 0) {
 		/*
 		 * Schedule the cleanup tasklet every 1024 packets for
 		 * the pathological case of high traffic on one port
-- 
2.53.0



