Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585842;
	b=RNmmbDAxHFqYDI3ztVVQnSR0hvVdlui5BjmIbkDtwQ8CSKxBADCURFyhJiJk6glqO+WA
	 bq0qrNMaQS/F+3ZljAocwq70z62V4qVQhk8+ZutcSxs5hE4AVSFUk1SToEPeTUZ8OWwOH
	 D2nwx5DJhRbg4KC1mBkF9IcgDSD+JQ4POH/KgNm5EheIBLykMtq7f89EiujoO32s/pHaE
	 7h9ljkG8dtPmMwO98CWdvIIAT7tQDiXWTgd6Q2XXSXNHxh/0xuVpypL22xIjmJRJEL4/I
	 RIYcUOIB1jP4y8gN9KJ9H6iix4tlNGsRpXl7IeoYAhV7CcB/VqwrEGa51IxfwhcHYyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGOEr7YbwnDJJGg6p3WxwyKCJPvkJCrMgbCoDhtmEHU=;
	b=gb2fvS61ehHprcSYOVMOLoX2X8aYSbbk3XYFV6rmOZQDqI+zzLgt9TsN0lrroCdS4fDb
	 yiG/6N1ufLwIvxenBxS32/fPgCnZUmU+D1k/s3EwzqBgosSnKQfSn7v4fZL/jgX+n886D
	 Kw9NV/PmGQ7RnrC4Ra/sAsfddwmQUOyuPX8ZWPz3UAByLOKoNnIJpsfeUc2sNY6qBOgtR
	 N9OcgFUWH97Vjo5iQLQWYg6NsDPAcK3YbIyokrj3VOUflfw/zciWDD3837tAOW2QRoPVo
	 5WHJlteKCWWsBH8VtdTKwBEJ/Wht5sVbOzUKHXYCk2WlqDdavg/Dz+pYJ5HqI1zh1ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A31VDn6Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F48606BA88;
	Fri, 13 Nov 2026 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A31VDn6Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6A01F000C5;
	Fri, 13 Nov 2026 16:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585842;
	bh=qGOEr7YbwnDJJGg6p3WxwyKCJPvkJCrMgbCoDhtmEHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A31VDn6ZajujNkNFvkyRxsQtPjo5d0bNCFhgk4LfxesaH5KYK+3gD+jMw4G9biG3F
	 baGUmgw4PqaCSFf5vgv+knLCPd54zAX2QhBTO5beir2KTkw0ehjsKpDDEzz2n0Re6D
	 d+XJ1QgxTOJaRU3bt4oAd1QqYSXxq7/FVTiBFV38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 421/507] nvmet: bound the traddr and trsvcid configfs writes
Date: Fri, 13 Nov 2026 10:52:05 -0500
Message-ID: <20261113153811.018390312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit cf399d4abbeddc317f8160a79fefb4016c469862 ]

nvmet_addr_traddr_store() and nvmet_addr_trsvcid_store() reject a write
only when count is larger than NVMF_TRADDR_SIZE (256) respectively
NVMF_TRSVCID_SIZE (32).  A write of exactly that many characters is
accepted, and the following

	sscanf(page, "%s\n", port->disc_addr.traddr)

has no field width.  configfs terminates the buffer at page[count], so
the scan writes 256 characters plus the trailing NUL, i.e. 257 bytes,
into traddr[256].  The extra byte lands in the following tsas field of
the discovery log entry, silently clearing the first TSAS byte (the
RDMA queue type, or the TLS section type for TCP).  trsvcid has the
same off-by-one with a 32-byte write; there the extra byte lands in
the reserved bytes that follow trsvcid.

Limit the scans to one byte less than the destination arrays.  The
count checks can stay as they are so that a normal newline-terminated
write is still accepted.

Fixes: 9ba2a5cb8896 ("nvmet: filter newlines from user input")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 83b86180c50f8..61107bcfc895e 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -150,7 +150,7 @@ static ssize_t nvmet_addr_traddr_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.traddr) != 1)
+	if (sscanf(page, "%255s", port->disc_addr.traddr) != 1)
 		return -EINVAL;
 	return count;
 }
@@ -242,7 +242,7 @@ static ssize_t nvmet_addr_trsvcid_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.trsvcid) != 1)
+	if (sscanf(page, "%31s", port->disc_addr.trsvcid) != 1)
 		return -EINVAL;
 	return count;
 }
-- 
2.53.0



