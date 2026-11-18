Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046528;
	b=ZXB6q0EpK/9UvKGpINRd9Mb4a3vL/JBgz2kp+Jjo/Bb6Nw4EulZbXOvlJjO0B40CtX3L
	 YXVaawILawdwW6G62J091ZkbEwFqT88xealu+iaKc916RUi2TPzGWycJbi4PF59antviH
	 lLxj02NBwS8LlGcor0ZZDy9su/atc2IE2OgkFljPJK3sqTzKsz52ryysJSFeKUA5SmHvs
	 5YKGq+86J3OG+bla6DCejhLmPc5n7OSd+5XfBrYm9Hd6uGtFFYIUO1ekc24yL0Gr31nvV
	 xQheaqqvi+NFVfnfL+bQPYkErgIR2vO3pbCLW93SLuH6yNYaYw+5Lwbl3oyhXPoCUFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vkZxIz8F8dSatHa40gapsMm4NMfBx5poBEYHMWf34jc=;
	b=uHTI8rBakNFmLcaymQTOzHu7JCAfENdvGU4KnzOZP6vWgFSqohBM0wPy3vujNs+MEBIb
	 V7KCSDPtxjEUFznZMfOlZzSJzuRwQ7tWRDPWow2oIJdZrjpkQoX+m7oiMZ0rvgyLH/v1o
	 98gvNhh8R1dQvl+FtEmbHGYwG0TOtFtwY5PZbYnYslY+6tQVx1DFV2NdW1VHuo6eTovFZ
	 Mxp/7hcK2tLOZIaouLgdV6V2QytcVyO1NKaXLyr3D8WSoqd/94o71TpjVLTddLIb4h0Uu
	 SCdgudpnmw+r+qnhGlpy8srfOdxCTwmKC30ziJptoHHEhtEjXBJweT/KFIjT3tkn9nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4ZeyVFc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D4560A6F51;
	Thu, 19 Nov 2026 00:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h4ZeyVFc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9CA1F000CC;
	Thu, 19 Nov 2026 00:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046527;
	bh=vkZxIz8F8dSatHa40gapsMm4NMfBx5poBEYHMWf34jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4ZeyVFcBpajbfZATgKaeaZcUmpoCNF6DMdZ2vkPb1KBW6ajzEtKhyDqDhg15uIdx
	 W9tF7BkLWYVhoZDhPy8S/8wQFqX85QFL6v7OT4Yi/YUA0+yv5TmTPRW8oUKOc+JrDT
	 JH3B+FyLOp9+zhFYEZunkoZJfLIKZwuLvsSVbkK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1313/2857] nvmet: bound the traddr and trsvcid configfs writes
Date: Wed, 18 Nov 2026 15:39:07 +0100
Message-ID: <20261118150248.733217668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 88e6adc54dcbc..c966d1e3a1354 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -146,7 +146,7 @@ static ssize_t nvmet_addr_traddr_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.traddr) != 1)
+	if (sscanf(page, "%255s", port->disc_addr.traddr) != 1)
 		return -EINVAL;
 	return count;
 }
@@ -220,7 +220,7 @@ static ssize_t nvmet_addr_trsvcid_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.trsvcid) != 1)
+	if (sscanf(page, "%31s", port->disc_addr.trsvcid) != 1)
 		return -EINVAL;
 	return count;
 }
-- 
2.53.0



