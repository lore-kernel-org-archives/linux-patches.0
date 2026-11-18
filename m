Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036533;
	b=dg2vjroGxMIV99vbqQ86rNa2ufOo3bM/AlY8SK5+cCVyyMG5W3HYMRoI5gvbAhr42TQf
	 FY4imrm+p67XWRLYUw/zB2OBJVOXTyYrJiySSSVo54+AJ0KtTVzjo7lo0p49eGfBM380X
	 T8gir7kklqrPNVVAP4+2GyoFfjF90tr+hLz/74Aaca0nTsQ2gqRzYbg/NKyDu08fLmp8p
	 CDDk9pUdyo5aAgjJHC55EjhYI0yjhi2aGEKDdiuqn8cLw/IOAG9JuTPi69Fsxd+pvBiuf
	 neq+n1Gg3AttiSvD7ltfF0VwlyYrzcK8ZnGC9zYg5HlZ7KLGihCB+P2uJywaHQ2u1pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IDnbhErJtxlG71qS6TqMusg4cyUwFRYz1McgdJEwS2k=;
	b=hDh2VxzD9BUrGl047o8Y0HVkMQ2V4B0mSRL4FFCvbQqzDowdAeC+8X/a/66gmCTRCl9u
	 hcR51OkxZjg4FMTX2F3WvoZlNrUtBvfDGfLISSFmotQhmORBowqYWOuGSXACQ4BM1HjEy
	 0txUgx7lLyYFxdSYBPnejuw/hHGJTbP4zUz+B4zpulidDhmHX+bk3XxL+nvbWnjP6VRg0
	 vZfHBBWrZ7GsVxpKREU/DZTIZf+iA5nYq2txUOwMBfRXRUaUHR1KmQ1y26WEZ1X3fO76J
	 aAHi4bMu1DO2CE5qmJSXxNPjKfs3X63t24pXHsWbD3E0ulRmMbyF5C4+ABvHm2U5rhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFtsDuks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA846606A31C;
	Wed, 18 Nov 2026 21:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFtsDuks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300AC1F000C4;
	Wed, 18 Nov 2026 21:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036533;
	bh=IDnbhErJtxlG71qS6TqMusg4cyUwFRYz1McgdJEwS2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFtsDuksQ+N+MlVPShdLQW5Fobf3r/IzXwazKLp7TarlgMh3mWjgUZr9ZO8tPxynn
	 EmqEKFnNsdzFUIZEAqRxwwhrbRwBub8SOvenSdB8nmkxsYkbc72S24Jjm3gKjWhxMr
	 qPW4NlQmi+Pfv5fHOvtSluJ9caEHqPwONlfSel7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1093/3318] nvmet: free the bvec on file namespace range errors
Date: Wed, 18 Nov 2026 15:28:35 +0100
Message-ID: <20261118150352.768641365@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2d068439b129c..6e14700164724 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -133,8 +133,8 @@ static bool nvmet_file_execute_io(struct nvmet_req *req, int ki_flags)
 
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



