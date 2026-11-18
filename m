Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058507;
	b=4rXPWXHZCUKzLIAycdnYWR1yMDkxFj6yWMfO7dq4nRT1wmiogCPTHVbAqcbGO6qXJcwq
	 qxUTz9VgNhPzj+iQP5PfGm8k2AAOP2ptaODHD8USB7dboxgKPdeByFLLGKdxUoiQ48OEL
	 tUyzBbBJVmQhip05YgP8+QQ08WeOCu2v+9ZIfzj0VLlKFwDUiv4yx8edg19wzXTGoFft1
	 RPjcgynLPXlqltUt2skw67UFI0BRb8uRKYqkWV61f/yHF/PdbE8WES6O3QM4yghcUsRLn
	 HMXJ8urkCXyaMu7SIF84/0pSopzb9UKJD5D5MTv7z2cmBa0RsGiMM5ge24wre7ntB8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AtwNA8deHsd4YcI8I3rvUxs6n9VyERSc2IMZ1T6wA8w=;
	b=pdd4C673YmioBdwmodsFldZSPXOnVL7eBrEUzpVB3YRsFesTO3vM/OE3/G6qjxKs+aj5
	 Cvc8zlY9jokmLO3SIYi1SIMpU7GbG25ckpEusnFjzDrPovgRPq7spUmgOVaDyOAxpd8N7
	 FwbWBBFUMc8Z1tW2mUL/tPvokS+27u+ghRSW5gwqqF7lKmN37j0MxKPR0VJSKXjsl+PxD
	 Y+M0OVnMjdL2pDYN55HFPnmUarwEgb3ZE9DEN7j7F6fu3QQrXP8IXPC94E2Nnn8TA2NSH
	 n2wgGdxCcOoyJXkBB7ZXm54KnJmzvhEbQg9MIx9k2p8GoIOeEomIjKdlif3cNNUactg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXkoGLgb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A83C606A325;
	Thu, 19 Nov 2026 03:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXkoGLgb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484F81F000C4;
	Thu, 19 Nov 2026 03:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058506;
	bh=AtwNA8deHsd4YcI8I3rvUxs6n9VyERSc2IMZ1T6wA8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXkoGLgby78QfxDUjXigMwQxVmynlYg8q2OuIOz9whZUTQESaCvENVZ2U7HN9466u
	 NE3RVJ/CV4XgHFRGPSlMVBP9bEc+2bgbHJusi0Q3X2a04bzJjUS9klYUhBawGh7sKv
	 2AllvQOL+OMqZyG0w2+877taqaEoUviJJFXbgK5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0510/1848] nvmet: free the bvec on file namespace range errors
Date: Wed, 18 Nov 2026 15:42:28 +0100
Message-ID: <20261118145936.092320560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 9d820d55b3cb4859c7cf42a74dc78f6154f97398 ]

nvmet_file_execute_rw() allocates the bvec before
nvmet_file_execute_io() checks whether the request fits in the backing
file. If the request extends beyond the file, nvmet_file_execute_io()
calls nvmet_req_complete() to return an error. This skips
nvmet_file_io_done(), so the allocated memory is never freed. Repeated
requests can exhaust memory.

Use nvmet_file_io_done() to free the bvec before returning the range
error to the client.

Fixes: 50a909db36f2 ("nvmet: use IOCB_NOWAIT for file-ns buffered I/O")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 9d1acc4a52538..7e7c226bc117c 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -159,8 +159,8 @@ static bool nvmet_file_execute_io(struct nvmet_req *req, int ki_flags)
 
 	pos = le64_to_cpu(req->cmd->rw.slba) << req->ns->blksize_shift;
 	if (unlikely(pos + req->transfer_len > req->ns->size)) {
-		nvmet_req_complete(req, errno_to_nvme_status(req, -ENOSPC));
-		return true;
+		ret = -ENOSPC;
+		goto complete;
 	}
 
 	memset(&req->f.iocb, 0, sizeof(struct kiocb));
-- 
2.53.0



