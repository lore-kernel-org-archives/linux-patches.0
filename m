Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA063469F3;
	Tue, 26 Aug 2025 11:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207900; cv=none; b=SgiHRtKNvtJvX5GWxy1xe0bwnV3ZkhrIqlNQgUQJmvoY09KqlU6wUGD8EM1oXtLimEwzVAJgJgKGeokU1mz86Ok9kj1It0nHDt3MWgvb5L5JbwIQgUnY8AgYTbHE63WuDS0n5wv0NC+BXQSb30BikwZzIo+DRGF0fXk0+j2lcTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207900; c=relaxed/simple;
	bh=MWph2R+I/YfbRy4KKKlQXycAU1BUGs9nPJAWcUmNp+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ey4J8pWZudFve6xOhXP5iY/mJ402APXpB2Yyjnezx5JesJ6N8dGyVsuvHhEnrQ6WI2HCmhWDEyA6fcMkgMXBsFXD2X57PkUmXeRZuo5FHXPnINP2yvg+V62DO/URKfeRvrj93sVqa1ZIocn8nAeH/rGAudUIQjQRNdxhQvVeoOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXPDbjlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXPDbjlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEC1C4CEF1;
	Tue, 26 Aug 2025 11:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207900;
	bh=MWph2R+I/YfbRy4KKKlQXycAU1BUGs9nPJAWcUmNp+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXPDbjlAsI1i+Pw4YLzkSMzMfQpPp/TTihpzAmMMY0GyfOJrqdgKsZNLbUJTs4PC5
	 fXB73CTgkXf9gHHIrEA3eA3fSxPmV4Tw/qBK1x1GoqTjm8Fuz90MxiCbrhgP8yLim4
	 6LFbcleWGRuS4tE7lrdk/Re3GX/2mTzxSk4AAlss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 361/457] RDMA/bnxt_re: Fix to do SRQ armena by default
Date: Tue, 26 Aug 2025 13:10:45 +0200
Message-ID: <20250826110946.234631627@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index be34c605d516..eb82440cdded 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -705,8 +705,7 @@ int bnxt_qplib_create_srq(struct bnxt_qplib_res *res,
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



