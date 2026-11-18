Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017794;
	b=z0Y6x/vNCZ2uRpbYy1tFtv9T53oDwga+JUz+hGGNVnMel2tlCgP+7SydjinMzBx6IkAr
	 Vvn8+XAaI3vGT7n0pUDIVkbNr40JnPBYMaWP3c4m6X7kVYoA3tOGI2PCyLRx/RTZ5WNZb
	 pvimK4JCX6y7Zcotut3Z1EuvPGtORR7SPKvF13rAAgRKvXk6XjRZwpWz4BAR9OhgcQgs5
	 ng0Las3vV/XZfEmMfveLi6j2edVHT+xs+xJPkqt89H7rvLTE/8lfl+ZjEM5q/GDtC30KE
	 eEPTE90k2U4LzONPwufbXDlb/fkp3Fackpq1v1hx2l92D7v5kU8fNrGXRuqpDqC/Bmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l3y1839qzrjJtanNTfRc5Fk4fLxbTySa6FHKsv87Nyg=;
	b=5d5SU2K+evLzePqplKV3vRDeTro+6Uax7fipoCoTxxfRSJgdd0Et+J2caZ98aTi8lAL0
	 SglhX2dp/NVvJ3yUqBmiDBaktDhsmHicnKUia7U4GZPPTFE+dCySrzq9zeOIha9K0k9+1
	 t5ggBeXDVbBmedr0IfVjux0wYGG1wEzLma1jkS4yvQYrAYoXaiEvc8N5mhFoV+LaPpA78
	 ke6WBBGyqg2ZZc9Qk9hXwnuXlOuKZzTDcnvsLPQKUOLZ0o5uSeXXClQkHq/61Y9lYzmNi
	 FLx9NPvvpQmpz5ToKVvfDM2B86JwrJZO16AIG/u/vaNWuMUVSeYHxbmN0E4G5C47CPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtVJc60I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42013606A31C;
	Wed, 18 Nov 2026 16:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtVJc60I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983A51F000C5;
	Wed, 18 Nov 2026 16:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017794;
	bh=l3y1839qzrjJtanNTfRc5Fk4fLxbTySa6FHKsv87Nyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtVJc60IoJgibWpQ29oVM84yWiMQXkFt5Fr0lLk127jSRyf0CfaMJdKGH/0/koV7/
	 AtY/52EGBctXXt5+r/vCA454347dF3iXJQQAv3l2gtLg+DGc7yGN24lFmQD4lt3v1H
	 FcF1dClnExZgZzAS/G0GnovGyrzRn11qQHL+EGMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1012/2651] RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
Date: Wed, 18 Nov 2026 15:37:32 +0100
Message-ID: <20261118150324.356786090@linuxfoundation.org>
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
index f81490fab0d10..22583d2d361d8 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2397,6 +2397,7 @@ int bnxt_re_post_srq_recv(struct ib_srq *ib_srq, const struct ib_recv_wr *wr,
 	spin_lock_irqsave(&srq->lock, flags);
 	while (wr) {
 		/* Transcribe each ib_recv_wr to qplib_swqe */
+		wqe.flags = 0;
 		wqe.num_sge = wr->num_sge;
 		bnxt_re_build_sgl(wr->sg_list, wqe.sg_list, wr->num_sge);
 		wqe.wr_id = wr->wr_id;
-- 
2.53.0



