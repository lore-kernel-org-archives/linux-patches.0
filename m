Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040491;
	b=kVzcwEuoT1tXQhZt0tFlZoY++Tg1OavWYCq/F02mqN0bTyUmxibN0Ker/ox7C51exUHT
	 H6MGHbybXGh9Gdi0aAbJKuQH9lhcSaiXnr8ErrIbFvbARx/eTEzmjzByVo4ACNgWbEySP
	 ICPvAszkLrFL0VEDjOUaQvqGxpBTxdf56dxUEbzRVOo8r5UQNFyguvb4wXC2yIIc0TOj1
	 wNl78TMd2HdlXoW4q50UqGFsDsL0s5qkp+vpU2gIMfhogweP24zMRup93dCOY+QpY5qrX
	 tUKTAcn05WkRA8k13hTXthZ6ZuycigaAl8TOFOl9Ko/eHA5oTl+PF+NfPAlNQcg3Abg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b1QJgYTn0mxChRLl2w+jpc8SF5a8cYenpA/G6FAnNQY=;
	b=33JS+Vwm9zJRfCgTVsu9sTH2V9uqZiY8e+mAVXiBA+GpzBjnnlQISa3qIuwH85rtpIkW
	 8NBzCMGo58YKDZlZO03TqGRZMsfQTYnT9NQi88QhwTYaxNhkq8X59nmfK6Lk2GACewGdQ
	 EnAsfVrvKV999W+kRzeBsY21eM1j3zXCWvaMDDy1pcku9baDzaHAK2Gb1gqkAYiof9XHD
	 hmjKVzjxeA1T0kpOseESW35nZOSQUKwxrlH115uxhu4UE3p/gSSNO0BuU4pkr54tOh9yN
	 yFahb5PEF2u0XWJGucFhZyJk/vEniMNzU8gfRpqgDTwvTAj614KwsvU0oddVIbdh73A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LHdoBZ6T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77405606A320;
	Wed, 18 Nov 2026 22:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LHdoBZ6T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00FB1F000C4;
	Wed, 18 Nov 2026 22:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040491;
	bh=b1QJgYTn0mxChRLl2w+jpc8SF5a8cYenpA/G6FAnNQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LHdoBZ6TEWsMAMej+5/But2yCczx7kNuxW6HKMMTpwVILBpuUIw/vQc9FLUYGs7qx
	 J1WzBWgj5XY1ZL3HdMCOYZ4dKrEuCYP5Dy+pZyHH+8dNmtypkgRa722wBJqrdUZcju
	 w/U1hjH8S/AtMM1ka8ADl5/P5QJByW/PNOHY8PEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2449/3318] RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
Date: Wed, 18 Nov 2026 15:51:11 +0100
Message-ID: <20261118150434.912660947@linuxfoundation.org>
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

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 4d8168a3b7c93385c11dc836df569d337089b218 ]

wqe is declared once above the WR loop and never zeroed, so
wqe.flags holds indeterminate stack contents on the first WR and the
previous WR's stale value thereafter. This propagates straight into
the hardware-visible srqe->flags in bnxt_qplib_post_srq_recv().

Most values of the wqe struct is set except flags. So initialize
flags also.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 3007733e6036d..536f8beb1fc07 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1892,6 +1892,7 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 	spin_lock_irqsave(&srq->lock, flags);
 	while (wr) {
 		/* Transcribe each ib_recv_wr to qplib_swqe */
+		wqe.flags = 0;
 		wqe.num_sge = wr->num_sge;
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
-- 
2.53.0



