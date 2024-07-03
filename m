Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2B2174ED0;
	Wed,  3 Jul 2024 10:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003631; cv=none; b=EymxhqjBAGeItmjDyyFAqdjDG2sFBieH6PdiDCBcvBNU2KaTfvG0qKvWPBw9nfGHxaqzDKHYM+sNaQFgt1LyuyNV4ooP9IXTdQpe296gN0S2IPUefDAxrLPuGRZ8YGCUDNLRlLlJbcIsXOjETsO8qG79ObN8UdFUmd8swsWYor0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003631; c=relaxed/simple;
	bh=8KyS0Bv5CCi1kx1RrFPpYgGaErrgFQstUnA4Bbs+S8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkyZv0Vtp/pbseIp1vvmvf4BL0tSPjAbbogQiKwhLQjWNkIf/CAOO/6Nj9o1LdnLpYdcJpNRXwkoKWPVbuRmE4Wo7kD7CjdeZFAE4hTUzWOh4/8VeC1MXF1DUKtExkRtz3wnAQq/xeOzmC8FS3W3LJ6EZZP3Og/PEIyzpKWjam0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11rRbzrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11rRbzrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44610C2BD10;
	Wed,  3 Jul 2024 10:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003631;
	bh=8KyS0Bv5CCi1kx1RrFPpYgGaErrgFQstUnA4Bbs+S8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11rRbzrlxVG52xsd5YmTLNRt2efHRrVx3p1TPUAz9DMYJfqcAEiTjkLs05UBPn3L8
	 mBI9mKiuA+1T6JVWiC5tZyUokuPIuJUko0hcHUJJzWjCGd8aA6sqKunJipUAOf3ZZk
	 KucVb1IVSWaEMoCFBaP3z44puKulU0Y5UzWTJHfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/139] nvme: fixup comment for nvme RDMA Provider Type
Date: Wed,  3 Jul 2024 12:40:09 +0200
Message-ID: <20240703102834.670296009@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 818dbe9331be3..d8984b0c25be4 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -71,8 +71,8 @@ enum {
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



