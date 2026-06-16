Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929603CC324;
	Tue, 16 Jun 2026 18:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633327; cv=none; b=WVqaolt1SGoB8Vo8lKIpHOWKNajZCoTkFxjOb87v+bF+mS0nVGBtnnPHLGF6CpEGVE42T33zr55XVJSBSj2ojtmET/vNm6u0tRe5mJsZ2ftszwgBA2fo8n7EPgLWAVKMPtxefSFv5QHSO/0rmF8JuuAcygVi8l/V79vRYF2JjZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633327; c=relaxed/simple;
	bh=uU9CvBtowkFTaK199SYoFHmbBEFLxq8nqtk2HAbYXwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3olRKr0EDIjAm1sta+DC1lim6o8uuZbRhce32ueuiuB8a6CnaXoJ+qTfo+DVq58nAn6cvvStDDz9ZS7+QhvMqOoMCZu6G2jCnOFHZZRTyj3snuBfM/Pdukoy8kJ/W6I2BxR1PREDBnMeUOKUT+BxLOtBIzIz3zBNLEph4PNNP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWyqGlkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWyqGlkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7A51F000E9;
	Tue, 16 Jun 2026 18:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633326;
	bh=0VmmRiUa3qXRw5gkhTBbC/HGHpuitfC56AVXKig7UmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWyqGlkCzvShuuWVdj4q2/xM1iHuN3wr2L8JWXcoELrQeqrx7zhixwvQ3EPz92ZCx
	 WkEVQUmELnhKeLy0GrsZF6zNtrl3qreuIN9Wt6iOJtNvA1zAX2LvdeLtmtbR+hvv4B
	 tSltQ1My5QWbP+KcT6uQ3G6pxDkmlTsACKA3HiSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/411] Revert "RDMA/rxe: Fix double free in rxe_srq_from_init"
Date: Tue, 16 Jun 2026 20:24:48 +0530
Message-ID: <20260616145102.940051446@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

This reverts commit af5956243018918130d52c9f671efdb40bab3366, which
was commit 0beefd0e15d962f497aad750b2d5e9c3570b66d1 upstream.  The
backported version did not move but duplicated the problematic
assignment, so it did not fix the bug.  A proper backport will follow.

Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_srq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 05ae3d183b21d1..eb1c4c3b3a7865 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -118,9 +118,6 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		}
 	}
 
-	srq->rq.queue = q;
-	init->attr.max_wr = srq->rq.max_wr;
-
 	return 0;
 }
 
-- 
2.53.0



