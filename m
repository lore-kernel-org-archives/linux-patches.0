Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322B61BE229;
	Tue,  2 Jul 2024 17:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940240; cv=none; b=JqmQMcxLjgiWfwAsSGAbMt6qJYxcVjttho5JXSiKglwlwnTLiLl3jBT4TyacpFWVshawck7akvtjm3mfPf3/dXJzYf85ajZ9J+5TiXwslfH7Oj7e3lk2pGp/b3Mk42qUQ7MK1oEsnRtE99wdnpwc8NRhJjHNxtGOrTL3WYh0Xgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940240; c=relaxed/simple;
	bh=38fLKdCSzsZ4gRwSz7M43Qq6hbZFTgab5AN3aG9iHS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsWT1dmmyEVY9joHsQq9f/gWC+l1rOYXipTOBAmdUXa45ry+/BQ8TDlnCJozR+Atz4E2vIfQ0Jcr5mW+k5UKhCpjDHZPQ8ZbnO/9f1lAAgVhkoZs5om8bM9Ym5n1a9F4Ghm9AuWSZFAUZMhRt4Thg16SFngzvjBb34G4QjreSQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VB3H2xTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VB3H2xTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9621FC116B1;
	Tue,  2 Jul 2024 17:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940240;
	bh=38fLKdCSzsZ4gRwSz7M43Qq6hbZFTgab5AN3aG9iHS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VB3H2xTRb1ZVqQoIJ4uvRvw8y8HEVHwfqa0il/oKMqQuBKu3FQuFaTUYKVk7qsav6
	 waDzmiDqjMElyabsTEAoX8Bjnk0KU/Mdx3yKsIJEwskHTw+X+1PwLHnoxMpT0rLn26
	 ca81JQo72BQYlrti5ECxRJTU7LvXTqyg1xP3SK80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 095/222] nvme: fixup comment for nvme RDMA Provider Type
Date: Tue,  2 Jul 2024 19:02:13 +0200
Message-ID: <20240702170247.602994609@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit f80a55fa90fa76d01e3fffaa5d0413e522ab9a00 ]

PRTYPE is the provider type, not the QP service type.

Fixes: eb793e2c9286 ("nvme.h: add NVMe over Fabrics definitions")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 4255732022953..69ac2abf8acfe 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -87,8 +87,8 @@ enum {
 	NVMF_RDMA_QPTYPE_DATAGRAM	= 2, /* Reliable Datagram */
 };
 
-/* RDMA QP Service Type codes for Discovery Log Page entry TSAS
- * RDMA_QPTYPE field
+/* RDMA Provider Type codes for Discovery Log Page entry TSAS
+ * RDMA_PRTYPE field
  */
 enum {
 	NVMF_RDMA_PRTYPE_NOT_SPECIFIED	= 1, /* No Provider Specified */
-- 
2.43.0



