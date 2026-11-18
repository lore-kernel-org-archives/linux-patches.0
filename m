Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049927;
	b=Zd2TgPqhU8Sjrlzjqo6qy2YtVenGRBDbaF5vsLikkq/jlsEzxLkWrI1mE+w5mLedsj2H
	 9sQABupMf/53ueZoeEqjyKgNqJ1qMGEHux7sX7baUXFGJvRKLwumW5+Pj2wroGQfd+eug
	 n73+Q0xHSQifV9Ekkycg01+RQxo21EM3bBir2KkItMaALJ/z6McFNyJvT2Vr0LRsz19e/
	 Od8R31sQ+wjVqSm5LsV9Hetzh+/2JgWLj9+P0jNiReTjcjy5Hs6U4RnXpxs2I46haTJLH
	 hoX994WLMZf0zF+pVPQvbP8ibG8TK4hn/gYJpwgfL60KyHuDM/jO4cGTKunM9dRRLIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9TND4Ywy2EGoXZmJlRM3m/m1Pklmnw0d8tIVWS3Zkx0=;
	b=3wz0EdTgbNcpTymvHT4+zYdAiGSkygHitNRCMbUwyimpO5CCKDeRcJxDfdCUOdxKozCn
	 ERseZnWnKRt1lanlZSKWcOOwu665NUqBVclRK/gvwH+W0E4sC8v5Jsk6TTpUPrxqaHGnf
	 11HDLtuVU8Iq4/CylsAiPhcKM+l4HxFZbJib5IYJfMmln+EJbVaNbKUrgr1xkvNSp1860
	 mMAxmPvdEpLdFmvkg1NcHE+dnJc5A16mHxJfL17rtj6x5TTqRiYduPb41XEwKyfa9wceT
	 UXVCJMv3HqFCTY1kvkDBPL+orMq83MfLzv8NOQ+9bPJcwpntaPV5fKqqUlRicV8gAeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tJHG4Fhf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335AF606A31C;
	Thu, 19 Nov 2026 00:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tJHG4Fhf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860051F000C4;
	Thu, 19 Nov 2026 00:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049927;
	bh=9TND4Ywy2EGoXZmJlRM3m/m1Pklmnw0d8tIVWS3Zkx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJHG4FhfLglNJlPN64XtYJNbewxT0Q6iJ1e2IrHa/18ZDjxnjBsgHeki8wtqqQODP
	 FK9K0V3CK36TQJptc+DNG1xrqiU/esMe0FEBgRBvQOUKODoUGZ4pemrlHPTi60qe3k
	 sndx3VsKM46c4ByBv1tnqEqzRLIgaSV15Du5Bnc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngsung Ahn <ays511.kr@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2525/2857] RDMA/rxe: refuse to destroy a QP with type 2 MWs still bound
Date: Wed, 18 Nov 2026 15:59:19 +0100
Message-ID: <20261118150332.458182310@linuxfoundation.org>
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

From: Youngsung Ahn <ays511.kr@gmail.com>

[ Upstream commit 9e61a2ac6590e9c42d2eeef687749781334b300f ]

Binding a type 2 memory window takes a reference on the QP:
rxe_do_bind_mw() does rxe_get(qp) and stores it in mw->qp. That
reference is released only when the window is invalidated
(rxe_do_invalidate_mw() on IB_WR_LOCAL_INV) or the window itself is
destroyed (rxe_mw_cleanup()).

rxe_qp_chk_destroy() does not account for those references -- it only
refuses when qp->mcg_num is non-zero. So an unprivileged user can bind
a type 2 MW to a QP and then destroy the QP while the binding is still
live. __rxe_cleanup() cannot drop the QP refcount to zero (the MW still
holds a reference), hits its -ETIMEDOUT path, and frees the QP anyway;
mw->qp is left dangling. When the MW is later invalidated or
deallocated, rxe_mw_cleanup()/rxe_do_invalidate_mw() do rxe_put(mw->qp)
on the freed struct rxe_qp -- a use-after-free write (refcount_dec, and
complete()/list work if it reaches zero) reachable from userspace.
IB_WR_BIND_MW is a local operation, so no peer is required.

Track the number of type 2 MWs bound to a QP and refuse to destroy the
QP while that count is non-zero, returning -EBUSY exactly as the
existing multicast-attachment check does. The window must be
invalidated or deallocated, which drops the reference and the count,
before the QP can be destroyed.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Link: https://patch.msgid.link/20260930182223.2511145-1-ays511.kr@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mw.c    |  3 +++
 drivers/infiniband/sw/rxe/rxe_qp.c    | 10 ++++++++++
 drivers/infiniband/sw/rxe/rxe_verbs.h |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mw.c b/drivers/infiniband/sw/rxe/rxe_mw.c
index 9ed6647f156d5..b43c7ed7059b9 100644
--- a/drivers/infiniband/sw/rxe/rxe_mw.c
+++ b/drivers/infiniband/sw/rxe/rxe_mw.c
@@ -161,6 +161,7 @@ static void rxe_do_bind_mw(struct rxe_qp *qp, struct rxe_send_wqe *wqe,
 
 	if (mw->ibmw.type == IB_MW_TYPE_2) {
 		rxe_get(qp);
+		atomic_inc(&qp->mw_bind_num);
 		mw->qp = qp;
 	}
 }
@@ -239,6 +240,7 @@ static void rxe_do_invalidate_mw(struct rxe_mw *mw)
 	/* valid type 2 MW will always have a QP pointer */
 	qp = mw->qp;
 	mw->qp = NULL;
+	atomic_dec(&qp->mw_bind_num);
 	rxe_put(qp);
 
 	/* valid type 2 MW will always have an MR pointer */
@@ -327,6 +329,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem)
 		struct rxe_qp *qp = mw->qp;
 
 		mw->qp = NULL;
+		atomic_dec(&qp->mw_bind_num);
 		rxe_put(qp);
 	}
 
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index a468e9bdc7364..f4f72a30fae23 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -779,6 +779,16 @@ int rxe_qp_chk_destroy(struct rxe_qp *qp)
 		return -EBUSY;
 	}
 
+	/* An attempt to destroy a QP while it still holds references for
+	 * bound type 2 memory windows will fail immediately.  Otherwise the
+	 * QP is freed with those references outstanding and the windows are
+	 * left pointing at freed memory (use-after-free).
+	 */
+	if (atomic_read(&qp->mw_bind_num)) {
+		rxe_dbg_qp(qp, "Attempt to destroy while type 2 MWs are bound\n");
+		return -EBUSY;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 5f5cbfcb35695..3699eb3053965 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -233,6 +233,7 @@ struct rxe_qp {
 	struct rxe_av		alt_av;
 
 	atomic_t		mcg_num;
+	atomic_t		mw_bind_num;
 
 	struct sk_buff_head	req_pkts;
 	struct sk_buff_head	resp_pkts;
-- 
2.53.0



