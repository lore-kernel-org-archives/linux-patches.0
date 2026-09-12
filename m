Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1952D0C75;
	Sat, 12 Sep 2026 12:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215908; cv=none; b=aaRsNTTs6r7o8NbsB06e2Vi65cAmpZKlBZjvaiMS7Me3eyeVGYyTFF0Sr1YPrTtCY4fHj8vj5zQZGOcaMOP3QH6t2llh8SPdVDMIT9HxIAP74PZnlkLDTI8HoFl+3ICJajZFZQC1lwsAggLS0tzQeGNZ9HIJUhQNIPJatr26jF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215908; c=relaxed/simple;
	bh=jFrNqrliX4IKESBUlQz0+Caxh4Knlq/lrqAS6xT7YSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mf81gU6hAjmlCdmWRHGPlBP/e5OyjMaEYWLOxesXcztDEYfcbAtrXFnKta+DqVlu1qsVbwNJKJVlvvffa+kCq1rlScgLcK7aEPsbEa9mm+7aatxvRWksbAtU1UwVUApVzkvSBZTJBAZzcn5wNObaR+XNfjykgucpwClGNISjsTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHAkwJCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHAkwJCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3E91F000FF;
	Sat, 12 Sep 2026 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215907;
	bh=RhikNMtAssg7aBA82tfEmtEUyQPl3R6ZIUDgoW9b6rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHAkwJCDGg3QWKZflmEPQvkE2tv67dp6w7y2Scx/XK0pzKefSltIKTiM+/MYnmK8D
	 lIlvn+99HcyZqWIfdWbcz1CHybDgOqAm7w8Ot/WSwo1kdbvEuPrhFon71UZXHqjt/u
	 4isa8XR21VgH2Mjs5cltDR0Kus0capmDBbnUNEHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0628/1376] RDMA/restrack: Fix typos in the comments
Date: Sat, 12 Sep 2026 08:50:54 +0200
Message-ID: <20260912065621.541589241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit d43358cda7c4696e08880aaa58a7df82e471fa7c ]

Fix couple of occurrences of the misspelled word "reource"
in the comments with the correct spelling "resource".

Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20251113105457.879903-1-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 709ba0e5311b ("RDMA/core: Fix use after free in ib_query_qp()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/restrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 3313410014cd5..a587b6e92d081 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -173,7 +173,7 @@ void rdma_restrack_new(struct rdma_restrack_entry *res,
 EXPORT_SYMBOL(rdma_restrack_new);
 
 /**
- * rdma_restrack_add() - add object to the reource tracking database
+ * rdma_restrack_add() - add object to the resource tracking database
  * @res:  resource entry
  */
 void rdma_restrack_add(struct rdma_restrack_entry *res)
@@ -275,7 +275,7 @@ int rdma_restrack_put(struct rdma_restrack_entry *res)
 EXPORT_SYMBOL(rdma_restrack_put);
 
 /**
- * rdma_restrack_del() - delete object from the reource tracking database
+ * rdma_restrack_del() - delete object from the resource tracking database
  * @res:  resource entry
  */
 void rdma_restrack_del(struct rdma_restrack_entry *res)
-- 
2.53.0



