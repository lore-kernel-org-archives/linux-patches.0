Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052699;
	b=D1h/sJ5e3YOabHJFr9pucdW9UWmt+lRV8VoVAdc2GGZd615bOv6DqXgDBjaMEWc4XY5m
	 FHALtPrl8lgIPhpl8CeuoUhRvEeqXoj4msNY9q6NzSPnjcoijBC3bDRhekHUYqMp7ikEb
	 8o2kgL593zYkgKwjE6DScIJXsCMMUuc9XLY0fvu5nDeecR7nhPeB6TKheurNbIvmcoG33
	 E+vsgi92ydPJoG+JydMBFsRDbtg/VK0PbJuYNu7n3QIDSUeUI2EDVyH2fAweIxqhWdqAD
	 7V9dnZZqGUcapwC0XRNX//Yw8MuzV6Z7Czff1Ij6G3TJOoeZyvkNIHNkzj9lovapOtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oXx04cTkE/dJyB9mnsXWQg5XIUH47SzUo3Shq33idcU=;
	b=yRuoBNSnbvwy3bidTZLOSv6f5poyd1/5K3bTa9qh7OWMY9NjDfT1TL/E4Goe1vDe3/1l
	 FryhkZlvThRzfYLzgO5HoNn1QanK0khIAg1+DVhdg9auasB1glyNKjUxjbXBT4agsFpMT
	 OiQeaXcoCCPSg6cWCHtn3Cj5rvR5YjT75erwLngYlbULVecpMhZoPfZrUWA2AyQn4aLb6
	 M3WzoyAwgZk0G14GYaP1fo87F5sQJrWN247eZkgGkjH3UdzdSf4do+jJ0gh2OcvvEp0v1
	 fgw4Wr6Px3mwvM2veyclkDYLaEytnVOBMR+ILnU8OLyRXneNAmVqC1kdnwoOQBLkS/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QqMXW8Ka;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC90F606A32F;
	Thu, 19 Nov 2026 01:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QqMXW8Ka
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C7E1F000C4;
	Thu, 19 Nov 2026 01:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052699;
	bh=oXx04cTkE/dJyB9mnsXWQg5XIUH47SzUo3Shq33idcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqMXW8Ka+0QYZ1uviPcmrT3OVdtZng6ITNHa9p0MSvhMQhnsckrGLLVGpziMSExz6
	 4tfvuO0zCp4nayisdzRtYT21RQ7NcoOWlmENgihZvukxkJkXxGy6x9z4QQ1G8zOqz1
	 F0s17qALvWKRfu4xyl2AdSUN1djuomTYXbQNImR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0630/2214] nvmet: free the bvec on file namespace range errors
Date: Wed, 18 Nov 2026 15:38:26 +0100
Message-ID: <20261118150036.563987176@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f576a959e36c9..dd5337b08d7f0 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -140,8 +140,8 @@ static bool nvmet_file_execute_io(struct nvmet_req *req, int ki_flags)
 
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



