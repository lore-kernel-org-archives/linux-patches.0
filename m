Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215581;
	b=ZbZrn0kNKIXKUQbrY0KUJwi8V51jfbub/YJ7Zo69VCdtJP6pSEhdzyHLIaP0dApHPnXY
	 UsXIPzIm2JWC309DEU35tqiUkGFe109/V98PS595nzJagsZFjyG2KGZ4XJpVWpKzSIeI1
	 XFxrEKRWvzsFEsygkmFFU5SsmPMC7i4gEAmX8T0Y07lD1+umX5pWUgZcnh811xN7pxiiF
	 bG476xOcqdeet22v0CvS24g7oibqbR/D1d1p4ycHaJwjRZU850cJVQYPYckPBK36BdbHo
	 +zsXisZOh4vYwpWirYeP/mtImBo6ELLLpn+rnWxvYxIvo9iVuZJhrtRhxI/LwdBvpQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gmZaN4TXWmWPTZvfsqUZ71sGUn8QH/uVyfH7BiHW7X0=;
	b=nJLqlzFwrt8Va8KXQXBZdGflWw5TBxzCu3zs507cUc7bOirIHZcFWeARue3rGJ1RbTAT
	 gLA/SRjYELPZnFzXrNSHgtASpWInMym5kmDTyrXslOosIercgiOB7UA5FFmQCGldOAqTr
	 x5s/aiMS01bT5hW2qfnst9Vv0MQaHi0VME2pHQqu8aAxKwzboKonKbfHpVaSVoGEMQnlh
	 M7wpMySnF9wXKLKjZfksZVqFE30DyooaOTnwZhd+Ma0g50Qpa2Vwc+WENUTjMSwfc7kzn
	 x4IMdBsOJBknLYCcUwDd39yBcXCxODPFisY4+v9bOD2lQFu/RA/yWr20Qfr+hsibClQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dn0dhBhW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527F2606A31C;
	Wed, 28 Oct 2026 19:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dn0dhBhW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E971F01825;
	Wed, 28 Oct 2026 19:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215580;
	bh=gmZaN4TXWmWPTZvfsqUZ71sGUn8QH/uVyfH7BiHW7X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dn0dhBhWaUR7+pDWLuZhH7lQAXmGFYI8P34YbDwN59iAlUnLqbaxQ+ySWHLLNKWG+
	 lGx3/GELevablma5VBU+g4DCMXmmAcYwgE+Sm2waALmHxYun4ElN+TScPpO4t0+ESv
	 tWDC9UoxI+X+2vLgvWVolxsU2umo22IsmCu5iGjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1259/1887] RDMA/siw: Introduce siw_destroy_cep_sock
Date: Wed, 28 Oct 2026 17:55:55 +0100
Message-ID: <20261028170528.077526778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit d9a5b48681315a5881cea24bc8f384da02828e88 ]

Add one helper to simplify code a bit.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310091735.oG7bTvLR-lkp@intel.com/`
Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20231113115726.12762-17-guoqing.jiang@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: ea4f6f6c5357 ("RDMA/siw: Fix endpoint/socket association handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 19932fc8856d7..c4311413c64d4 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -370,6 +370,15 @@ static void siw_free_cm_id(struct siw_cep *cep)
 	cep->cm_id = NULL;
 }
 
+static void siw_destroy_cep_sock(struct siw_cep *cep)
+{
+	if (cep->sock) {
+		siw_socket_disassoc(cep->sock);
+		sock_release(cep->sock);
+		cep->sock = NULL;
+	}
+}
+
 /*
  * siw_qp_cm_drop()
  *
@@ -427,14 +436,7 @@ void siw_qp_cm_drop(struct siw_qp *qp, int schedule)
 		}
 		cep->state = SIW_EPSTATE_CLOSED;
 
-		if (cep->sock) {
-			siw_socket_disassoc(cep->sock);
-			/*
-			 * Immediately close socket
-			 */
-			sock_release(cep->sock);
-			cep->sock = NULL;
-		}
+		siw_destroy_cep_sock(cep);
 		if (cep->qp) {
 			cep->qp = NULL;
 			siw_qp_put(qp);
@@ -1698,9 +1700,7 @@ int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 error_unlock:
 	up_write(&qp->state_lock);
 error:
-	siw_socket_disassoc(cep->sock);
-	sock_release(cep->sock);
-	cep->sock = NULL;
+	siw_destroy_cep_sock(cep);
 
 	cep->state = SIW_EPSTATE_CLOSED;
 
@@ -1745,9 +1745,7 @@ int siw_reject(struct iw_cm_id *id, const void *pdata, u8 pd_len)
 		cep->mpa.hdr.params.bits |= MPA_RR_FLAG_REJECT; /* reject */
 		siw_send_mpareqrep(cep, pdata, pd_len);
 	}
-	siw_socket_disassoc(cep->sock);
-	sock_release(cep->sock);
-	cep->sock = NULL;
+	siw_destroy_cep_sock(cep);
 
 	cep->state = SIW_EPSTATE_CLOSED;
 
-- 
2.53.0



