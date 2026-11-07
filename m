Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062340;
	b=PGjbOPhnCXEBK1/wQ4fIz3k4O9AjchomsrPVEJbdu/HD2C4qyq1swiyRLtVTD4ghUrIY
	 jdtEWXmRS0bwV9vP/H4C4m66YIfaUq9q8FR/0QuCzU8DV9DkLqVGLPcBvytxG5UYU6oeX
	 khbn0LMyAVsD/UCO21zxXRR1yfkcfnVszV8BbG2+Ch9AWJofthoiLCPv0q85OWgauRVyI
	 QQhRNcM8PAPpkMoXSF7Hw3Y/TiRk6cXoKmwZEpaJv294rr+Lre1zUoW6+FsNo7SiCHPq8
	 LRhvtvhZu0GklkC1Fh/ZCKIZvZxspyKtkHRRgoeYntxOWWdmQz0zXO+AJUlTlAPczdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=p9zkG5iFAwPpcYUOo7993val68ubUrqNClIl9mwpiDA=;
	b=YL1gNBjrq72N3HwNQfQFtqBU4buHO3NBoDVCnPAWDOt6jziJCPaXP7Syq1FYfoRHmxla
	 PMoIbpJfDFa2d6jxYBfMEYNqt2FhCitwdx7sH3LU1vTzMGe2MrhPytYXdyp7mJfphuJh0
	 K075Bhm+Tc9vjXsHyVPuOPxmrED0v4L3FHew4V+nt7kWkl/QQ5iIQAsmX4b/n53/vxm7w
	 i/hMh3s48QEPVJTNJ/rrBe6MdMHy29e509piRIia/i/t+6PgBMjFnVF3NcoL7JdXBFN4u
	 GVkwdNpPRgKRPcmFRgNXGw8oIIkA8GL+sQMzKNrfu2u0mvFZo70kp43Csu7HWgbiKLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cj9pO1C5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ABA606D825;
	Sat,  7 Nov 2026 14:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cj9pO1C5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65F91F0089F;
	Sat,  7 Nov 2026 14:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062339;
	bh=p9zkG5iFAwPpcYUOo7993val68ubUrqNClIl9mwpiDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cj9pO1C58EvXG7UvyXXSyP+skRfP5QmOYTNbM/pv75/uxtEz2kKdj379ZUOppTLBk
	 hD2iS9y2dBCHkc9btdXjngZRMSC8KT0mWwUYGZ33pkNImAItNv78lrGcO5m/iM5YhT
	 omCcWH79Lbuz6Uube1rC+vxtNn0IgweFcui1nRLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1268/1536] nvmet: free the bvec on file namespace range errors
Date: Sat,  7 Nov 2026 08:54:44 -0500
Message-ID: <20261107135033.388947908@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



