Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FB98462;
	Tue, 26 Aug 2025 13:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214067; cv=none; b=ibDohHSFoQy+x/Paev3i/fJKJKi1r2Z0kMIP8GSVamhr6r2MFKI0VLsjFV/r2AGXDpgcG4KCuBVGAWz54zOoEh+DdjDzYvx4ubNCC+NYfQZTe6tgVPpd+LQo8EiwDlznVzF6lUKa+Qx99Aq58h0P698bo2Skm3csAM7gTC/bC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214067; c=relaxed/simple;
	bh=2416IFVnRAJRYWExfk40aZdaS0gWQT+/A65kki6Debc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwL1pd6g7RuugoGT5AiMzMlRZTv1BtxWe+wSOZ3JhHJDjbVl1OCtuZDkA0WL5Q7RsCDPtv5+c0wqCF/Sii9zCHJn8yfR6pVH/dR0fG0fU7QDDB/GTadiV0qjl5AHpNbImnZPQ3ZcwnPK5mWZrFyCUC0nrBNBLQKA5XlZM8wzUTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyDcCEmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyDcCEmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8379C4CEF1;
	Tue, 26 Aug 2025 13:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214067;
	bh=2416IFVnRAJRYWExfk40aZdaS0gWQT+/A65kki6Debc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyDcCEmR5G2Oty/z9RiYyNLzVAFo3JgI66+6ma4xa5zn9JGhhtx5XF7amTmXggCaL
	 VPDVT05v9rDRW92+sIq4bBZjb06/6YdRT94DXPZpsPsQ0soxJ46/SUyZQdLMnlCbHJ
	 ZiaQ7XefehSFrz3V+9MXzn84B+tzCW5f9MZyKn1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 553/587] RDMA/bnxt_re: Fix to do SRQ armena by default
Date: Tue, 26 Aug 2025 13:11:42 +0200
Message-ID: <20250826111007.090002803@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit 6296f9a5293ada28558f2867ac54c487e1e2b9f2 ]

Whenever SRQ is created, make sure SRQ arm enable is always
set. Driver is always ready to receive SRQ ASYNC event.

Additional note -
There is no need to do srq arm enable conditionally.
See bnxt_qplib_armen_db in bnxt_qplib_create_cq().

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Link: https://patch.msgid.link/20250805101000.233310-2-kalesh-anakkur.purayil@broadcom.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index 68ea4ed0b171..8dc707f98fff 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -685,8 +685,7 @@ int bnxt_qplib_create_srq(struct bnxt_qplib_res *res,
 	srq->dbinfo.db = srq->dpi->dbr;
 	srq->dbinfo.max_slot = 1;
 	srq->dbinfo.priv_db = res->dpi_tbl.priv_db;
-	if (srq->threshold)
-		bnxt_qplib_armen_db(&srq->dbinfo, DBC_DBC_TYPE_SRQ_ARMENA);
+	bnxt_qplib_armen_db(&srq->dbinfo, DBC_DBC_TYPE_SRQ_ARMENA);
 	srq->arm_req = false;
 
 	return 0;
-- 
2.50.1



