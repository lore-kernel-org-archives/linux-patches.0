Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5801D0F58;
	Wed,  2 Oct 2024 14:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880053; cv=none; b=OSSPW2kPwZNjMp0Ac272Anq2KGrB2QGThvnwUb4xqh7mRZntsCrzjpfpzWjscrmfxqJAirXzYS6WKfTGzRTT1PcryXcxKQ+SignKq5q9Ul7kQrRchDMkd4diLI8H6enIq7uJqryj1jSmSNS0r2qoIKCvUpVadjwwTaSxGi5HC44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880053; c=relaxed/simple;
	bh=JgwZtXbYKQuM+ewMeQOYsD4qPvXE/5CjetsQQxtnTEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVYK1HH7z07Zzz5xkTCx8/7uP7paA6pBsUu8GuBYZg+drfoTkIWkkUL4U1jpyCwWvkQbl2O1e8jGUFUmbVmoIhJ9c0hWZ0KYaoKCT8freA5Rd444NlomVo1wFyLk1HUPXRShdj1BCfU+J5pRSqzIhOF8ReFlkOdtFJuxnHR15g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiMgnSPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiMgnSPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC3FC4CEC2;
	Wed,  2 Oct 2024 14:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880052;
	bh=JgwZtXbYKQuM+ewMeQOYsD4qPvXE/5CjetsQQxtnTEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiMgnSPgUi1XanzR0CWHON7oazZaJOlCI8f2MzBNaFld12Z6uTgu5rK4lD6ZB6bCb
	 4sMgye1Wu+jxUjt+wgxagT97kypllxPM+RLrH2IQgn4O+BAQC86YcIk8aEM7zdbTMP
	 nabZZaJ6h5Yb0BQ6pvGdklV5ll9SgtpW7Abebph8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@maxima.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 326/538] RDMA/irdma: fix error message in irdma_modify_qp_roce()
Date: Wed,  2 Oct 2024 14:59:25 +0200
Message-ID: <20241002125805.297791387@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vitaliy Shevtsov <v.shevtsov@maxima.ru>

[ Upstream commit 9f0eafe86ea0a589676209d0cff1a1ed49a037d3 ]

Use a correct field max_dest_rd_atomic instead of max_rd_atomic for the
error output.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@maxima.ru>
Link: https://lore.kernel.org/stable/20240916165817.14691-1-v.shevtsov%40maxima.ru
Link: https://patch.msgid.link/20240916165817.14691-1-v.shevtsov@maxima.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index ca3e89909ecf4..38cecb28d322e 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1347,7 +1347,7 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		if (attr->max_dest_rd_atomic > dev->hw_attrs.max_hw_ird) {
 			ibdev_err(&iwdev->ibdev,
 				  "rd_atomic = %d, above max_hw_ird=%d\n",
-				   attr->max_rd_atomic,
+				   attr->max_dest_rd_atomic,
 				   dev->hw_attrs.max_hw_ird);
 			return -EINVAL;
 		}
-- 
2.43.0



