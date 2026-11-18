Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038021;
	b=rbIU/9ABR8uOCTQtO/ckJkzyJmGbBpD/gwFdRqxCHvX2QSML31Bo7qHTfW5rEZWxqthd
	 PyMrn8dPVA8OaoutPerx+ZAmMN8Sb5AOJhlJsaMZUHlAUmwUx5EM7/Tl+rK9Aq03xc4Vx
	 Z2arwXZXro0hpcXEepATMpgCNhLdl4Z3F/Y1pHWJ5508lU684uZDNjlLJRCkmj+Zrhd4m
	 10m4ukUBR+Zsh+YHTtmtOt86huCVq0EHniTLZvwkrBTCTXi3FQIMkHIZYH35tTgpZI7+9
	 FHaVPF2qoETUKV4yGJrk21ztbmDVMbXAc1hWTM3euqbUAvmr4XXhik9mRtgmNyUoukA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EWSpg6/UXdoyEVQfNHx5ZPwJJgOGUtLlylX3/F7BAWA=;
	b=gjygbVuYs/RG6dh9YHClhbwWJZrgjJd0UoFQ1RDVBoobrGACKN5nETOi+rUaMzaQtGq5
	 zDebt2UHs3hY4c4wEQXEZAz4OzjpGnXZ/pRUpDJzEIg8QixGNSB50itq3rExx2yQ8Z4LG
	 tTvOAlXc7UGOtUw8TaIxHcm3wyXIMdtkcpPn0g9VR7JmtgB6nHQzYfPil557YvA+Cp87t
	 I0HAf7tqdOyZByP3AmV6UOsqUnVnakyEsmwbRSoP7L0eKeNaHtsiBEmgqz4Cf6Q+AR0Ed
	 0+XTBc16u2nn3td83w/43GUpG10bwfteEoOFeIzSIZyRRyzgWse9IQZ3y8zIr2VHBNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLDh65ma;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EBD606A32A;
	Wed, 18 Nov 2026 21:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLDh65ma
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C6D1F000C5;
	Wed, 18 Nov 2026 21:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038021;
	bh=EWSpg6/UXdoyEVQfNHx5ZPwJJgOGUtLlylX3/F7BAWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLDh65maE8PKU0HQvoLEuVItXaiE4wkNsOovhpo1Fj0f/MnB7QE6UvzGVjOdjIZE9
	 UFMPK9no8vx/Ng++UW0efPPAC/gl+KmNlOxQ4PLLjpjB92QY/SUJuuwEddrusDnrX5
	 KhPaK77tuuV2Jx9lCr2r1tjgo6vpDu9ei5aqb9F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1561/3318] nvmet: bound the traddr and trsvcid configfs writes
Date: Wed, 18 Nov 2026 15:36:23 +0100
Message-ID: <20261118150407.865755800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0310858e97173..7ef0464845ab5 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -147,7 +147,7 @@ static ssize_t nvmet_addr_traddr_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.traddr) != 1)
+	if (sscanf(page, "%255s", port->disc_addr.traddr) != 1)
 		return -EINVAL;
 	return count;
 }
@@ -221,7 +221,7 @@ static ssize_t nvmet_addr_trsvcid_store(struct config_item *item,
 	if (nvmet_is_port_enabled(port, __func__))
 		return -EACCES;
 
-	if (sscanf(page, "%s\n", port->disc_addr.trsvcid) != 1)
+	if (sscanf(page, "%31s", port->disc_addr.trsvcid) != 1)
 		return -EINVAL;
 	return count;
 }
-- 
2.53.0



