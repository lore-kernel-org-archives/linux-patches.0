Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055532;
	b=DVOiYnBpbwko+rw4AQ+LrZOswHl6+Pr1nFlYz2+37cG/qBWIbSL2gpasb7SDUPFZyKmg
	 OAf0wBrpDKmv4vUyGezirJ0cEKVBPjWbRwQgnBzgrqYVcUCUxPefOjaUE/aTO5799GXQ5
	 l0Hof45M4EDOx5EBUTYRWy0xrodwI5ZPnzuj7XfOCT74N26YJTipdgAFwNIWjcOQ247Cm
	 6343Oco3wUyoY/oDzqP6vB6ktP4OnatiKbwiko5Ol9Y60a31KZVCci9Fm7lx/Bde2581n
	 I9jb6Qq63SZnvZ9fiG9397FSmXJQhFaMsjesSOTvVj0nmffx2B26LRbHcS8LbtuAIqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LxOMkGWW8W+IElETf/CgD7sKD8t1s3TJAjOjxPpzJME=;
	b=Z+4tXA+fW/dY/wjvOr8L1wp9Jzoplr0y/c5HXe13qgstIi9A5ScFTEhkmDGavVMUhEvr
	 zMcMrtwnJj071HXlKTb6nn0/F3TkzcN71xaMQX5wgsPFiqFU4eG637Pv/iF3V4mJLi1ou
	 bBfi91nL/EgMjQ0HC3bXiqL2TkExG18d42G3ITpZD3gtff5IutRqUE4FxFLjdB3nSx1vw
	 Xvqpf1RCqH14HKEF2bAd6+DFgEUn+peA/C6/KW+Ssm9uL+emoSKTZhWguxhjL7o4AUH9v
	 VNNY4DLqIUpxBlW+A+TYDlRgRMjvi3roxHW0XO0eidRv8bruL0xfAPrRWaqx3vSPKCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PY1qL5km;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606C7606A32A;
	Thu, 19 Nov 2026 02:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PY1qL5km
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92ED1F000C4;
	Thu, 19 Nov 2026 02:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055532;
	bh=LxOMkGWW8W+IElETf/CgD7sKD8t1s3TJAjOjxPpzJME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PY1qL5kmPcmgFynTuFJMeL+tAAIx8JQVQX0sJBlSj64oIZXxAOMewvuyA049ata92
	 6mA7jBYaMzffxA8jiCwKwKhbpniZKsVTiIB543rCDwqVnq/9rYDA18Ku1SfBLWTtm5
	 Y2DC93VgJpW3dr+xBqlbF4FfB0bF89s7NwXa8W/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1665/2214] RDMA/bnxt_re: Detect wrong sge_len passed for inline
Date: Wed, 18 Nov 2026 15:55:41 +0100
Message-ID: <20261118150118.469242024@linuxfoundation.org>
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

[ Upstream commit 81551ece0864c346080d241719d458c93f0e7fc9 ]

Avoid handling wrong sge_len by adding extra check
to see if the passed length is more than the inline
size supported.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 3b821b6913253..fb3f3c2abd13a 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2512,8 +2512,9 @@ static int bnxt_re_copy_inline_data(struct bnxt_re_dev *rdev,
 				wr->sg_list[i].addr;
 		sge_len = wr->sg_list[i].length;
 
-		if ((sge_len + wqe->inline_len) >
-		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH) {
+		if (sge_len > BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH ||
+		    ((sge_len + wqe->inline_len) >
+		    BNXT_QPLIB_SWQE_MAX_INLINE_LENGTH)) {
 			ibdev_err(&rdev->ibdev,
 				  "Inline data size requested > supported value");
 			return -EINVAL;
-- 
2.53.0



