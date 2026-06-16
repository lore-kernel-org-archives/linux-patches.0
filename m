Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D6B478E26;
	Tue, 16 Jun 2026 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630669; cv=none; b=aRbTw3JdPXP7lG2jiLlrlMVtpN1a3hftC8WGn9oYhLin+0u60xjizmhpoVYojh/PRBcFkNqmSggoe6R8GD4NGvZKIrH4MXr4+Q1SVgxomCzTIuo/GQyZ9RfueTg983Y3podiRr3vuTgPWkDSeDHaedAnaZeiIf9bQrk7E7d914c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630669; c=relaxed/simple;
	bh=jv9QqnvL2zGmbAWQgOUFgJmLqK2AJ911nWLDBfVc9pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtE48gZ2nMcx1agoLfIKj8zq77S9Dom7a1b2YErGyLXy6DxblR6g2uCAAW4B4uDkuSRnhTQYMTAbJ2FoZODONTp7Rq0cYtekXih+OeM/gXhaHUDhs9Le0FBxyZFuyAQgIAHz6VIVRTdX8oTtTL+EvQx1X075DYc18hO2hB3vG2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PI2+kcml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PI2+kcml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29C41F000E9;
	Tue, 16 Jun 2026 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630667;
	bh=SzIGnI6/zyUQNzUcec+oEH24BkiNtRMpZtaswPfcMUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PI2+kcmlIKQsnvISI1glKyIeQ3obcFl2agVJamMXKU3VOAgK7W6G43dQHQK8ROglf
	 O+SIga3YsYgxWe8YHEBYtqcUqlQF7KcSIc+rYNSv+8W6cXB4cUSDmfJeG5NKTuOWkj
	 JhFBjk/ToGN8vgQH6R83RKCTrGApybgdZhR/W2tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/522] Revert "RDMA/rxe: Fix double free in rxe_srq_from_init"
Date: Tue, 16 Jun 2026 20:23:41 +0530
Message-ID: <20260616145129.304548397@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <benh@debian.org>

This reverts commit d286f0d4e3ad3caf5f0e673cdad7bf89bf37d947, which
was commit 0beefd0e15d962f497aad750b2d5e9c3570b66d1 upstream.  The
backported version did not move but duplicated the problematic
assignment, so it did not fix the bug.  A proper backport will follow.

Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_srq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_srq.c b/drivers/infiniband/sw/rxe/rxe_srq.c
index 115ff5428f6cfb..02b39498c370d2 100644
--- a/drivers/infiniband/sw/rxe/rxe_srq.c
+++ b/drivers/infiniband/sw/rxe/rxe_srq.c
@@ -87,9 +87,6 @@ int rxe_srq_from_init(struct rxe_dev *rxe, struct rxe_srq *srq,
 		}
 	}
 
-	srq->rq.queue = q;
-	init->attr.max_wr = srq->rq.max_wr;
-
 	return 0;
 }
 
-- 
2.53.0



