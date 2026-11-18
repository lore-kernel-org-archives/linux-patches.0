Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024870;
	b=rhfNUHB9rDLe9NXtyvmEwXYWNo0cCrtmDM6Ewjt4TTLpwOdmlMTQKYNRTFHjnuAwjdbL
	 HFrTnagI6fm+13QgnBfhDIUpoLPoc/cFxZ7aEWsaMDdbUclIuXLOe2YEL2uGIIvgUOq5A
	 MeD9UUz2D1093DDYnFR0SguFpijfBMZcuQ5JonDd+Lc5TnatO61DW6xmlbc0r7wGU8rDs
	 cUT2Dqdco9NpJtS4FJngsRNmLXbkq5DrI0B9yQnnyZTi0pRLqW+NbgQ1q1nszNyCiz+tV
	 ZoSLSEpPo//kUAdejjO/fNE0D5zvfQPPWyjkGHTtO/OERI+XudLlYJrArHslhKmj1zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+aSshsD4xMg+sp0Xe+fn+VgfO7nxjPu6K3YSVgNc9F4=;
	b=pcEfb2BoO1rGro1bWCgf/86xLz0qa7xt9h3ykAY0t2+pYwSnBnj9wznG/4+GgFT43WPJ
	 6NWJdgwY1RT2G9tDjACBbBa/UgxIZNWH9LG8/f4V5b9JK4yicfHxK+kRuUbtlgrwe1ZLf
	 iot7Tm3KhAV6HGnite0UOdFHpKnb8yver2QDxjphQ9dxCn2xat0j0zZzKN/U+aX8gLn4h
	 GNlVcjl/XqIm/IwoHBSyiaHcoqbBXFK5Y0t0sHMc7YQR3onHHhFSY7RoNwyYKCoASTJmg
	 JicgWO70r3Zqrz34snfRrrE/RqMcISTRSWN/1kGT2jbDM8TBzTEy8EMwTr5OzBTmxlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CFKrL7mY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673D6606A320;
	Wed, 18 Nov 2026 18:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CFKrL7mY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E83C1F000C4;
	Wed, 18 Nov 2026 18:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024869;
	bh=+aSshsD4xMg+sp0Xe+fn+VgfO7nxjPu6K3YSVgNc9F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CFKrL7mYf0i1XNRn76I1C5s2TA9L3e6JMrYh13U+Pxaxc/VszTE6cNB4vESG8l2wd
	 oBjuYPXCISomg/EW5SOZMdIuVDQsuw61Vi9jjM6hl9GcynisuAocCOLSKLPhkcd/8y
	 +SLbNklK9ySzN14KVG6nVAKx9k4Rjk+qlSD+PR+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijit Gangurde <abhijit.gangurde@amd.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0879/2151] RDMA/ionic: Fix double removal of CMB mmap entries in create QP error path
Date: Wed, 18 Nov 2026 15:43:34 +0100
Message-ID: <20261118150154.317343774@linuxfoundation.org>
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

From: Abhijit Gangurde <abhijit.gangurde@amd.com>

[ Upstream commit 485effd117d0310a7f589defb4f442fa3bb52ae2 ]

The error unwind in ionic_create_qp() removes the SQ and RQ CMB mmap
entries explicitly, and then falls through to ionic_qp_rq_destroy() and
ionic_qp_sq_destroy(), whose ionic_qp_{rq,sq}_destroy_cmb() helpers
remove the very same entries a second time.

Drop the explicit removals and leave ionic_qp_{rq,sq}_destroy_cmb() as
the single owner on the ionic_destroy_qp() path.

Fixes: e8521822c733 ("RDMA/ionic: Register device ops for control path")
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
Link: https://patch.msgid.link/20260925093638.3032149-2-abhijit.gangurde@amd.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/ionic/ionic_controlpath.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 38d57bc2ba525..18494206d017d 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -2276,7 +2276,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 						    &resp.sq_cmb_offset);
 			if (!qp->mmap_sq_cmb) {
 				rc = -ENOMEM;
-				goto err_mmap_sq;
+				goto err_qp_cmd;
 			}
 
 			resp.sq_cmb = qp->sq_cmb;
@@ -2313,7 +2313,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 						    &resp.rq_cmb_offset);
 			if (!qp->mmap_rq_cmb) {
 				rc = -ENOMEM;
-				goto err_mmap_rq;
+				goto err_qp_cmd;
 			}
 
 			resp.rq_cmb = qp->rq_cmb;
@@ -2321,7 +2321,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 		rc = ib_copy_to_udata(udata, &resp, sizeof(resp));
 		if (rc)
-			goto err_resp;
+			goto err_qp_cmd;
 	}
 
 	ionic_pgtbl_unbuf(dev, &rq_buf);
@@ -2339,7 +2339,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 		else
 			rc = xa_err(entry);
 
-		goto err_resp;
+		goto err_qp_cmd;
 	}
 
 	if (qp->has_sq) {
@@ -2370,13 +2370,7 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
 
 	return 0;
 
-err_resp:
-	if (udata && (qp->rq_cmb & IONIC_CMB_ENABLE))
-		rdma_user_mmap_entry_remove(qp->mmap_rq_cmb);
-err_mmap_rq:
-	if (udata && (qp->sq_cmb & IONIC_CMB_ENABLE))
-		rdma_user_mmap_entry_remove(qp->mmap_sq_cmb);
-err_mmap_sq:
+err_qp_cmd:
 	ionic_destroy_qp_cmd(dev, qp->qpid);
 err_cmd:
 	ionic_pgtbl_unbuf(dev, &rq_buf);
-- 
2.53.0



