Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209116;
	b=SQWXEf/NDByhH1HH4rRKunkJZPVO+k9gExkQ2n8FEuJZmpZW3+WsEed1akogPv07fJTw
	 UvprH0UHBLKlLgbtjQlR8u4Nia5gbCYcw8PTt+Ep7kaZ9Hk9LnIUGYqFVYIrrnxN8FNTH
	 Xf9+7roXb6ntQNaPkyJGxURIAKR+/sH6QP1okwh7KIbIFdUIdAGjyd0Z9C4PRHf6a6fLg
	 3y+OHMUuP0dLIeioxHP2id0CAQhW2VusOEO4PKaqgffa/Kr7SsM8TXkjYj55RGr5tNmtU
	 qzqwGMxB2HAii2dSkLvmVu0PE/yk6Q7HkMBNOen3A0HSnUGL+b3tuD9x7N70TGM/4NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zQTLZITHFyP/YGf8mye0MJ332TTJLjRcWhTIV/rHJ8U=;
	b=1HKrKP+k1aiTu69VdjpnCYpwb9YlxgU75Zy7q3fccepW7cnPng3RPy90VYosPqHdXIVL
	 X1Ogv0VL4yuECZ8kBY9X9BiOdbBlJZRdlaf2IFI4+cDsTh/ULfwDrAupFx+xuIoohCmsc
	 HYxkaDF7Fb1polFqwuw6aQYgHw0x/51dM/ssLVI9Dz2DTIf4XeC2RbA/NKhILKzESrOdy
	 jxoC4bPWtXlKPgTq+SjbnMnSdxh383DZzEaFu44vD4GSE+g9v6nMsHr+BBP6lXb+9Q76j
	 cyZOn9qj+B0AFJcmjbuYub1G19bVXZd9ZZosDUaxPTOA+9+ahYmpOCBQ4CTlqKmkytw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f71YatKQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C989606A326;
	Wed, 28 Oct 2026 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f71YatKQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC491F01825;
	Wed, 28 Oct 2026 17:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209116;
	bh=zQTLZITHFyP/YGf8mye0MJ332TTJLjRcWhTIV/rHJ8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f71YatKQQDqfLRy5SxmZOjmvVSICG3egDCVjU7REZ/IdYXyNEvCdgEj4K3THfSREr
	 L1pwhUoYW0ko0ihJZoIqId6NjWpSoF9alyb7/V+O3bdSgQygEfU1ZCbRIPlEp0Hy4v
	 cs2/2wLCu0nOxZoZR+jUiPOYn7QVKRLLh31oXkW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 357/516] nvmet: use the local P2P device on metadata allocation failure
Date: Wed, 28 Oct 2026 17:58:29 +0100
Message-ID: <20261028170011.944750555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ddcfc51fc05c6..61e96097bfe9c 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1027,7 +1027,7 @@ static int nvmet_req_alloc_p2pmem_sgls(struct pci_dev *p2p_dev,
 
 	return 0;
 out_free_sg:
-	pci_p2pmem_free_sgl(req->p2p_dev, req->sg);
+	pci_p2pmem_free_sgl(p2p_dev, req->sg);
 out_err:
 	return -ENOMEM;
 }
-- 
2.53.0



