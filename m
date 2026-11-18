Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055538;
	b=x/x7X+JW60ZNUXShEjLBVYjFackw/fDun9lvz5iOv0NIkxsNE+u47IwOXjyOXTmrvrHp
	 vXbkLMvsjZOZrt1DiIF2dJzu4xSjSWAIpmMblgfvzWfVS4AI3yejWBPlyJLoRC+7uZ88s
	 qEqNXmFfZ+YvWsalvWCBWcedJOnY/tFry8B8hLs5/maB7ccZHQFha1j23qelhAkEWCCrb
	 SRpNEsQuLo1Bij5oKGqFP6GDC5CPJYxKgnEV26SyNwU3sWmG/7/0jUuNMI68R1qVNSGQ5
	 dQQAYGyyyVjxAyuVCEn25Xv6WYMYQGNSQ7MmB3BAamn8/4hJbWdqKH3pzv18B2JQMcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xb5fEd4tdqQOwrY0QBQZ5qH3vluwrj4PLVkeUjBpgk8=;
	b=oLIfHVL6eA/Mi1uKRyjnJIoiv4rnmJUhizZSHNEjE0HJ0QVG1PJ/AtEbUzoriVADiZBX
	 6Blx0DGecPgaakIk5Za1MyMYhAcQAdK7eFxzd3wuTTazcpMfJfMTzT646pZw4v+IcMZgX
	 CCGElszvdxt2e5WUrT36gHlkIHAnnPPKc6+Z5FYPgDeAJQKo1ObXC5jr3jLe3BJ4sTuQq
	 PNiHSlGo7J7ofYKOo/UMarfO86SrzRSMsLtQefwoL2agdybE8PsYlwqY0pqMxkSCf6q4E
	 Fk2nKzEx1vP6FQDK6iQfu3KoZqy+ZPz+dd+BBXIcbTX//d5hOt6P+IqRdsPtBrrv4JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pIc8odVX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E2C606A331;
	Thu, 19 Nov 2026 02:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pIc8odVX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405841F000C4;
	Thu, 19 Nov 2026 02:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055537;
	bh=Xb5fEd4tdqQOwrY0QBQZ5qH3vluwrj4PLVkeUjBpgk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pIc8odVXm90Bxvbvrk5IjyRfIOxJa7rpIGiOdI4m2Qlpg93W7zJDCLNhmOl00WCFb
	 ysVA4g6jA33Oeo8CGos1NeHrGWlI7GJNUlBaoATazX1UdcpaA2X9KQhhpW7F0Fg6f6
	 FXznRBFXbUWLPvZnrvTb6fRMbaDffhQwWMDjhi08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1666/2214] RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
Date: Wed, 18 Nov 2026 15:55:42 +0100
Message-ID: <20261118150118.506276012@linuxfoundation.org>
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
index fb3f3c2abd13a..13c52ccea7319 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1763,6 +1763,7 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 	spin_lock_irqsave(&srq->lock, flags);
 	while (wr) {
 		/* Transcribe each ib_recv_wr to qplib_swqe */
+		wqe.flags = 0;
 		wqe.num_sge = wr->num_sge;
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
-- 
2.53.0



