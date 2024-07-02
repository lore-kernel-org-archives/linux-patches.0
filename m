Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB3415218A;
	Tue,  2 Jul 2024 17:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940960; cv=none; b=q9Dp27h/IGLTNiva9ppSKfd/JsHRdWFecaLud7mVx69OGZlD0tWbljZ1sF0pTpFy1E+HvUjQVLtM6TEwrsCdxBuXz+3rbq3geYVvVqvCuILiUYVdpECx6YiG9msz21lb2ZLJVMRhpUt+R0CaYLtIkavuwNg2qZLdpqBAW0iC0L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940960; c=relaxed/simple;
	bh=ByEzZoe4JIs4prGvnQk9bxNEgiwutoTJrd9l9VDq7rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxeinGTwwtot9tLpHcspD5VSKmMH+76h0Nm/ht+p/sKuj3jmAuO7NdizHQpFLpDoNtWOetLt8rA2LtsFsUYdW4+Y9BM+DKMqQmdP1zAXofWe+gLU5yYop1HzF+1qDpVI96RbnZbFA29xXia20OylT2DOH1ng7iuTQtwCd/fhNPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhSoyBdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhSoyBdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1800C116B1;
	Tue,  2 Jul 2024 17:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940960;
	bh=ByEzZoe4JIs4prGvnQk9bxNEgiwutoTJrd9l9VDq7rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhSoyBdPhYv+IBkyvuKoS54+j/NUh+0cZBsMBKIOzxmCEAmr1Qa47IhtilNrwfMg/
	 PFJy0kW5tGIVSwp9rMwyOP+grLazNs/QE6De51PYF5TV3eAyQtu6OTkFGdL9rp3yNU
	 87iuQM8lzhdl9QJCI7PMzDSDSK636W6UAikoe9Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/163] nvme: fixup comment for nvme RDMA Provider Type
Date: Tue,  2 Jul 2024 19:03:04 +0200
Message-ID: <20240702170235.713924191@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index 26dd3f859d9d7..b61038de139e5 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -90,8 +90,8 @@ enum {
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



