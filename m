Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213515;
	b=iAn1056adqBkhSFVeooBdA6NnmcXnJBWX26H+K8SV9oKQpOySKn9RtOg31V1RsBxIl4G
	 PtIO6lE1FuhaB6BTFv67/4ta1+uuLcJ5jz/L41FuXXCYi+z0WvHgT7hTCTbnvZiH6yk09
	 luGbpZb1jWhOBRxeMSxLlLGKbdtlvVWuvZnPV/dwlR85hKE1fMaQHlsI/QCBLZbYfWJet
	 ZVKdiJrBUOD5vmfvgfZBELsGxWbMHgMzr2g5EeEi54CuHO9qGB+qXdhUlMFg7gLPltF5I
	 5PZamHLrZiqzPBqh+WXYVLyYRU4fdcNyWX0lkI7iTJiBJ/NvPIfjyeITEI5IEfrc48A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ma7edD9xiDr+k+ce9LEthKIbt2i7AbUpTyIM3jGuWko=;
	b=jsJWB5SCLcsNG3U4ZU8WSR9S/X1LMH+edRMasu3PBfJroLF+LzI+JAqSTvQKxVOzm0Yw
	 ax75swuyAiaGxsh7bY8t/0y7id8RtMUZNz7xz4RlS3A7UmMpUiKBaPoWaTDuIMDo23E8A
	 xy1cvoFyNJ71laK+XQdQh1ZGbP7F65TFlUewwJJO+8aho3gvgVUD3/FO44pSVd43206o6
	 9JJg4GoNOxNyUtr9AOgosaRp8mGmxm930Lr3Bzcj0bBdllodL6xiGktRSPigviaclDN21
	 YjWN49WxG2VKRfhBentZXCBuKv7WC10mYck5A0kv9NFJT8pkHApJCIK3nQKVPuSKQlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqqbPyrA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CBC606A31A;
	Wed, 28 Oct 2026 18:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqqbPyrA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19F21F01825;
	Wed, 28 Oct 2026 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213515;
	bh=Ma7edD9xiDr+k+ce9LEthKIbt2i7AbUpTyIM3jGuWko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqqbPyrA+j8oueO5m1O3/YC8k+jhkbcTw+Zz3m+GzjxGSsuHwfrQ/eCwFiRKAtQw3
	 H0p6mGtP+NsfFX0n3C0aKlOhTRrrNT1LhulDpRD9NolrA85aoelF7a4o2eMtnoQdMB
	 xpPXrr24LggJ0B5ftaY6Dpg6jnMmmAtXgKBgel28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0490/1887] nvmet: use the local P2P device on metadata allocation failure
Date: Wed, 28 Oct 2026 17:43:06 +0100
Message-ID: <20261028170510.423163989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 4aa9c0f377a4de5e8fddce76b34ee4529639a1ff ]

nvmet_req_alloc_p2pmem_sgls() assigns req->p2p_dev only after the data
and metadata SGL allocations succeed. If the data allocation succeeds
but the metadata allocation fails, out_free_sg passes req->p2p_dev to
pci_p2pmem_free_sgl() before that assignment has taken place.

Pass the local p2p_dev argument instead, so cleanup uses the same PCI
device as the successful data allocation.

Fixes: bcd9a0797d73 ("nvmet: fix freeing unallocated p2pmem")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 72703cdbff2ab..e1bfab6c21e0f 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1053,7 +1053,7 @@ static int nvmet_req_alloc_p2pmem_sgls(struct pci_dev *p2p_dev,
 
 	return 0;
 out_free_sg:
-	pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
+	pci_p2pmem_free_sgl(p2p_dev, req->sg);
 out_err:
 	return -ENOMEM;
 }
-- 
2.53.0



