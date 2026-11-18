Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030451;
	b=YaiUcrAGnepkqE5O+8poXqhnjIRnuSeEV61L9irAXctPLASMwM+8aYZu76vZnTMpzOlD
	 wF99gV5f2Br16Wzvt3URVYJqMKPTgR8KBZUzhbNBEHTJbfc/N9+3fqH6SxGOQ19OPO7Cn
	 xxPfqc42vHTQjZP5bOO0yFiIunOqW8EEY4viBv1bRvkFZodGrbQwgDb1YQQL282sHRnrS
	 eAshNQYppkFEpX/0iXkGNR7Z8Qc6e9dHLV7m+FFWRe3H3ViJTIth6O5w+9pIH9VBfu8MR
	 J9fs/HWwVln9ljz6Z4MdFMNMZ11+QsVquFXvgIwXIxTfAS5By7qWeFpkvvBNBqsOnvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6y+BiKjSWiUP4MZAAlBFBJN/ZV+i/jXsZTjnG/RW7rk=;
	b=mo6J4ALTjDliss2oKXlcwCYQEzeWisMTUY7fV6iiHQceozb1CZ71SYcx5pJFq28lFcaX
	 vXOylzHNushYJCqFfB7+YxsryXIOySI3m6QEx9zTmQj9OGL6wQAbHa8wJdO67WW64aSxB
	 AT2lv0djSW/l8Ihc7e91rDIRLnlf/VCzx1Bh7TzzdwWgvlzX2w54vyKmqyU/DyDZBu/Vu
	 PbC5VupgbaDBMS8fRu0FSsU45IYjLPBgbe9/+s8be8W4XI5JIqU/MQLmNBlxkjAS89/kA
	 9IoKazey+OWhNEVEw6JgjGs6Gek55dO5DSlcKcU6F6FfcPoYQl8zRISDmqi2m67u4ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j/jarDIj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A02606B10B;
	Wed, 18 Nov 2026 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j/jarDIj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DE91F000C5;
	Wed, 18 Nov 2026 19:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030451;
	bh=6y+BiKjSWiUP4MZAAlBFBJN/ZV+i/jXsZTjnG/RW7rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/jarDIjHRhwkM+Dg+D8nXtgjYvSWtD5BbF6qADshBTK9AgWT249r8aRlecGwenMh
	 ZkhlZOPzAfReXH/9h+H7vB2nTBfBb58OJsByVwHLqc54HwfuDNoG/A6ao4vGblwQh7
	 O3/I+yagySNbTdd4XaJcHUldB5lOT760KrPBA/2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0709/1756] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
Date: Wed, 18 Nov 2026 15:47:16 +0100
Message-ID: <20261118150037.608167154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit e95d076bc1fca7cc36fc8f2f0e9687f79fd314bd ]

The SDMA state reference and completion cover the software cleanup
tasklet, but not the hardware cleanup tasklet, err_halt_worker, or
flush_worker. Queued instances can therefore access an SDMA engine after
per_sdma is released.

After the state machine has stopped, cancel err_halt_worker first
because it can publish the hardware cleanup tasklet. Then kill that
tasklet and drain the remaining flush work.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260928134148.977-1-getshell@seu.edu.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index b67d23b1f2862..3e54b3b390b3f 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -1583,6 +1583,9 @@ void sdma_exit(struct hfi1_devdata *dd)
 		 * it is not running.
 		 */
 		sdma_finalput(&sde->state);
+		cancel_work_sync(&sde->err_halt_worker);
+		tasklet_kill(&sde->sdma_hw_clean_up_task);
+		cancel_work_sync(&sde->flush_worker);
 	}
 }
 
-- 
2.53.0



