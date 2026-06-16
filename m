Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A293D13777E;
	Tue, 16 Jun 2026 18:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635398; cv=none; b=Uw8rsd5FW6M9K16hbgIFub79jrdx13UI5Fk+BlH2zOQdLQXttaVyW5k6ynPRvhNmTy6yMmTJ8uzqQm1Zn+694a/wrpEQ6HxasFWhAaqje2SDefComJN/Xr8tlVYORsYc6psZgCP1fd9biMlvnXaM2Qu8KbNh19gb7ox2RKJ4a/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635398; c=relaxed/simple;
	bh=4ovZBpYAqPHm5dJa5bwpHc0ZH5KzLDfZGD/lK9o971w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tasDQuqtd2pceLwKHbkEqsQ+2uKqBQFzXOYusbE7xAK85NYRS3MAf3jM8kmWKW6bD5Kz6qsqxveoPwrY/VghbXBnlfKjDUUDFIGZhDnIuPfnvCjd+MmF8iC+8y1DWcoroECKg1+OvCM3Mrven/y1ha64OWqUrGc+bwTq9kiDuZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOpbXaAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOpbXaAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34811F00A3F;
	Tue, 16 Jun 2026 18:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635397;
	bh=H1+IjKp4yB2xsXMb1oP6U0LYFUZ1F3KU36kfSSqKJIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOpbXaAVwp91ry+nZP3ey0IEgfjL3mbJu3WNcxCcyQ9YBnKdRm63qGE8qmCHSFgtk
	 zcF4x94RIHo00cDlCloRj4CRR+6a2QCPsdnn/J5FjjaHWbTJ6jJZMs4CHGGA/WP0WT
	 ol4rZXq0tbhiSjNTOdTFdomtPKd2MYUShH7zBfek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/342] Revert "RDMA/rxe: Fix double free in rxe_srq_from_init"
Date: Tue, 16 Jun 2026 20:25:37 +0530
Message-ID: <20260616145050.166211616@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

This reverts commit 22b8c23a3b92d023614bb00896fe364b2c1a31d3, which
was commit 0beefd0e15d962f497aad750b2d5e9c3570b66d1 upstream.  The
backported version did not move but duplicated the problematic
assignment, so it did not fix the bug.  A proper backport will follow.

Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_srq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 9d9baca2694999..41b0d1e11bafdb 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -116,9 +116,6 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		}
 	}
 
-	srq->rq.queue = q;
-	init->attr.max_wr = srq->rq.max_wr;
-
 	return 0;
 }
 
-- 
2.53.0



