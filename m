Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053459;
	b=n8Ygbyx2uWTrbd1drKa75POdqnHl2mgFqPrBWcHGm403qec3rrecaQ5KAe1yZ6JHUtsa
	 G/HvMLgUbtBHZkV5TREOCUzFzkWQr1NWACzelEILduS1FOW9Y1p/OSATTRmZIgGnZ0ek5
	 NPM1x1GbjQd18dt8gLNAHJ3QuDTZBvIQrYC0TvJE0H+GxcJWyToI/n9b763HuP6GlaJhS
	 kEV/ad5KGQ0wew3E7y8aqUl0xo72qimEEpu1BbAMvFSW06KRiBn/G0sAsfnZuEy/ptKft
	 ydAXe8L6eVqKiTD0LRETCqbuwtu1oSI876WwJ68y2PSGOmUXPdUdXeqimrC+MuNNGzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RPrSookcv4ClBCCepSTWmDCqpD/eSYQMFm6hp6w7x3E=;
	b=O8OuKm13XST4o1NKJLHDDINBX7gKbsEjx73tQ2BKUP+Zg1wanx07mEZKp9a8pGpKLbpq
	 XRuTGQ2gIpFa7I7Fcd3NvWf2mwjRQ47MES8d5D4TcZ8mOWgwXBadBJqLSEOCOeCiNtx4h
	 Dx3SO7XFBMK7GiYaO+Y1IFRJQfcc0C4G/eNwB5qK8SPCgNZYD14IGmYMl8lEWgzApqDYK
	 9Md4+o8h6kjR5dK9AG0/dyJqPALMUbM/GM7YtCwrU37FC6VgPJcBizzfKThWuIE8VaLZ5
	 yeRtcrUcDu0JuW4G1m+x3YGaRtd8KJHclpGScBrAqHHmyorGJ2Q1aP3udOfIQoWkRlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=htFbXmIZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B413B606A31C;
	Thu, 19 Nov 2026 01:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=htFbXmIZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BB01F000C4;
	Thu, 19 Nov 2026 01:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053459;
	bh=RPrSookcv4ClBCCepSTWmDCqpD/eSYQMFm6hp6w7x3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htFbXmIZjLMIJxFTkrFmD8BJXG8s5u/i2/KuMOB2DMIGQQWlLVNmNEvlwsd1shhRL
	 3UsuvkunMZHoO48k0Mpnl705ChUsQp/trtq/KJ49CS9Gw6IMcYEruCi8nYVLYx5nne
	 XVqJL9Qd27HYEEPCbXgs1u4T9ycU+PFEqp4EDcBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0926/2214] nvmet: bound the traddr and trsvcid configfs writes
Date: Wed, 18 Nov 2026 15:43:22 +0100
Message-ID: <20261118150049.409082781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 110d33900a001..7a7b9410161e9 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -141,7 +141,7 @@ static ssize_t nvmet_addr_traddr_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.traddr) != 1)
+	if (sscanf(page, "%255s", port->disc_addr.traddr) != 1)
 		return -EINVAL;
 	return count;
 }
@@ -215,7 +215,7 @@ static ssize_t nvmet_addr_trsvcid_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.trsvcid) != 1)
+	if (sscanf(page, "%31s", port->disc_addr.trsvcid) != 1)
 		return -EINVAL;
 	return count;
 }
-- 
2.53.0



