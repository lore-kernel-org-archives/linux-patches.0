Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591315;
	b=IkQ1c5WHZMbtc8c40T9QRfZ2IKHW/duWbFYcFHC654Hoc76EZ3AzEiDSwptae00ETde0
	 0z6NMD2HpgzfOULVOohEH3dZ7EZHRzIlrOA3Stn/fGIwz4VD1rHR7K0Xzlym7+h0AFNnK
	 sQZ6FNw4ea4Uy2pWM36HtSI65+eXmsROPZGNetOpm+1QJggDs4o+5Or9VAiyDoiymB0xv
	 JkxjI3nkSzxlrlqtsPGEQgRuhsVlNBxP2a0OiaRbQsQpeuZujvzUEa28clhi7OTZXlcxC
	 IS7hmZTLb8lqX6AYwjs7TLHP/MIA/zU9reCiwaHUhjoKEBQTTkpxj+whfIbR22g1xyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5BlPksEorFS1x9nldFfil5cDDK3FOfDiV8U+dqHNYhU=;
	b=u9WSKuiVGeJnMUUz2HPBGIUPpKcEj4A5x27hv8vO46lB9TW4hV8VsXg63mnixqb9iUMZ
	 4cX+8pZur3P4ClaQTcJczG5iG3IEy39vDr3GxepTavVfpScGtWOxCOV6DFVKJed/ImH5d
	 7klRJ+C6TmDNkKh/MQ7aV7a8XjdfyiM36DzmbIdyd0UyROh/FUR2dULmW7/sjOsIWMpZI
	 /T6joj/JTQdlUJe0Q9TcqtldpsuwLFxVqC5b1muiedJPKMjQhdxDwgf/QyWgQV/TspWh0
	 8hK1HzMOHQzr1DdI/HagowCOBTDSdg7jpWo0pn6ZpfjVWxs9AnY2b9Qopz8XKt23n4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkVJt3aX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADDD60776D8;
	Fri, 13 Nov 2026 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hkVJt3aX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FBD1F000C4;
	Fri, 13 Nov 2026 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591314;
	bh=5BlPksEorFS1x9nldFfil5cDDK3FOfDiV8U+dqHNYhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkVJt3aX/Mtn9s6fk5EeYz69lTF7h7dDlsxrJMNr2XveitGPoHKS8QnHgHKzmGUm5
	 Tx401y90aBm6Gt4w1ZV1J/ppntf9Mv1Unq0xdXqsmyJfs8dET1xqLvNH08mPGye3zm
	 X93nEguVffRpVy2dy7LxnClyz7Zh869OdxgXgnSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 387/670] nvmet: bound the traddr and trsvcid configfs writes
Date: Fri, 13 Nov 2026 10:49:11 -0500
Message-ID: <20261113153824.877573457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3b066601fd358..0e12f800beb3f 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -148,7 +148,7 @@ static ssize_t nvmet_addr_traddr_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.traddr) != 1)
+	if (sscanf(page, "%255s", port->disc_addr.traddr) != 1)
 		return -EINVAL;
 	return count;
 }
@@ -240,7 +240,7 @@ static ssize_t nvmet_addr_trsvcid_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.trsvcid) != 1)
+	if (sscanf(page, "%31s", port->disc_addr.trsvcid) != 1)
 		return -EINVAL;
 	return count;
 }
-- 
2.53.0



