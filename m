Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3861BE85E;
	Tue,  2 Jul 2024 17:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941404; cv=none; b=snaNt/rfhqmoBafqxZIczwFg0upBUF09BlVu5dTOHpbsOiVmiF6VVWbhny4dK4dBBRMp5yKk47+dRUwjbHHP3pX7rKFlMqTfrF0yAD5fTkcEBe7cmTDTrYg21inQmefN6fGmi6aN0GjEmHUecXbDv8GiwQefh94vK3ojY0kgymI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941404; c=relaxed/simple;
	bh=vx7Iw0okpU50weN6kX7XVou4+93mdRXBmSbSgip6tHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlIFFQ3rsRaGrrquIsGzg3Cgirf5G3fXPQrVkW2qY2eVEzaN7LCcqAH6o5Pb4EFc01soUZ6g1Zx3qt/repaXdLzIZuPemIvy6Wy+EbNCroLeiZKkk01Fh+peaixIlGHGWP33KgE6F26RLsK3wAVSf9C615UiwOCswsMubKhAbsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AY7LsmT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AY7LsmT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E81CC116B1;
	Tue,  2 Jul 2024 17:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941403;
	bh=vx7Iw0okpU50weN6kX7XVou4+93mdRXBmSbSgip6tHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AY7LsmT3C6vrSiUHyUfyuE3/JxYbSL/EgE6FjO0e2r1GHDJRBG+iamtAIWmHmEq4W
	 iQxNv24uzLmq2jH3ThRgwtcyQm8Mnfikqg4ON48XiHVKNiwyUT1p7jiBcwr2wImTVs
	 PIgpL1WWT9kCUs7bPvGcPvn5fo3dtGD9dlsLyqLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/128] nvme: fixup comment for nvme RDMA Provider Type
Date: Tue,  2 Jul 2024 19:04:14 +0200
Message-ID: <20240702170228.236943299@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e6fb36b71b59d..15086715632e0 100644
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



