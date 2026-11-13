Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590507;
	b=Lk4v8WxZaarZmiXU/gSrpjL4Wctzphc2kmQ80qa2iG21xAuf6FTX+VFJi1dl13J2Pj/q
	 4OT2uvZcpadL0EzLWUVDcRVkNgQq/u8vTcoVfxtaeAiE8TBI9mtiGg5iw7ofvgleT8t8G
	 dIUAXlOlaBr9VgspkGnp5whRQU2W8uRt/qhi64MoajYcFRGEpmTCFJ+qtcWV3aucB4jtu
	 yxgnXxYm9/uNXRR+GuKTT/R6HzW3Gz2Jv88i5C7n9sfdsXZdeI4vRXDNn6ohtLQ+MaBNs
	 OzRf8n1VtLxW4gmKAA9YB8zl38TYOUywJrBLTYv/4Hm/UTuUiFoweK8RKe6N7ShcOxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l/B0NvMZvR5JMR9qA1zMTZNVG5LVfYPyimskamLYcyM=;
	b=kUVbH7ISEcU/6hZIIkkwlEFo2G0vexq32bRbQk1fjTg4diTL/cTFoRgQC7zevdtNZ6gU
	 QSTB2JJedzZsf2TOnmy/MfngeNv2kf3+rgeFGmG5Lib/wTShPbJ9mtRbegJ5PKyxHLPNS
	 JrfiGAdkSKPJlKe655v0/ESNOdsxUhf2cTCC1J1kJ7MSgxtpW935ap62bFKtyzUi8Sasb
	 +TXFDCnHSJ8n7VNEbHKv3IK6/rjwf6zafW3BzG9JYcFcyqWfZaxaKNpvsj+pv5PKGAtR2
	 poFSDZNREw2OD7SPzcwCcDedG18r//ZAHXyWKCPkhzi2by10cIi7Ha7ZZv5+dRidxdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0VyEvBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A607607320E;
	Fri, 13 Nov 2026 17:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0VyEvBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2709C1F000C4;
	Fri, 13 Nov 2026 17:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590507;
	bh=l/B0NvMZvR5JMR9qA1zMTZNVG5LVfYPyimskamLYcyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0VyEvBl8hwchPn4456etbs7NZlWWKgdNufAU7Z2/EXvQfb92scUTF0teqFkmctCw
	 73W8sl6BfH2CjinHE33zZKMsAHaAu77wVVVp9ZSgc0CCSbD10FgbXBfd+TFg2T4jdH
	 U6cnENuKuA0N9OqBJZ1VH2XP6Lu64T7kONGgsHgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 452/686] nvmet: bound the traddr and trsvcid configfs writes
Date: Fri, 13 Nov 2026 10:49:45 -0500
Message-ID: <20261113153836.191790629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e2032b58191c5..61b4e90f4e34d 100644
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



