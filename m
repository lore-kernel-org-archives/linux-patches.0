Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064791;
	b=Rx9luKLT21/wl7ECibZBn6Z4solmEYIF9yZz8qHYVQ3KtBUsJEfDk5fhNveZbFzm5A42
	 b3RZ2uzVZygDP2vMkuctTBuV5kQE8PvgNr9wOyxBh06eXnMqs6yH+ukMyh5GixoRrGIHx
	 cs4h7Z3m3rpjGWMIiJ63WMfhxHuRgpZ40ZFj9Ew1OEiY6+t4YcAWWf1PZiRzMifRK/s+w
	 mwdHjtEz4GQh69aKASTbxNCBzQJlAu8flSOIQ70mLMPKJqffnwu+uLMKZOVYuWKaQnviX
	 Cfms0Yz3NZEWyNTJHpZwvwf9gd5klxsZgGF4KQHY0iQvl2XQkwtm+Xib+Zc4Sh20B0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Q39eY6lez1KQ0/idhKFUyXh0k0bE7vypemnifrbtWKI=;
	b=TqV+2tDHQGN/eLoMmz+sZJMf/vkGORRAGn44OsIPLwZdEuhSP+/V9PHe3E23KPklkbB+
	 NAIEEeWLlAPp/l9atEzFJUJADx5igYtwlhAr4KlsqFeGdtHhL/ROqyZeTAD5jTSNNflJr
	 Fnz5gqySH8uEmKsTprOfyuI6TutmjVhUPUF7POrlivt0WaPE65wT6x3xESLWKaO6GF8Hp
	 Ec5bGai9lG6uIQ7c1c0YoW2MNCb9Txe3ABHbD2zkXCMMpMclyFofv8bUY9X00E9mjePco
	 BD7ugGPb5OcBhErch9Qw3RGxR3liMgzRP2Aj/eSuapAPvMh2Ahuv9Im2VVpqtr/sR2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gZDctCd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E24606A9EF;
	Sat,  7 Nov 2026 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gZDctCd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BACD1F0089F;
	Sat,  7 Nov 2026 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064791;
	bh=Q39eY6lez1KQ0/idhKFUyXh0k0bE7vypemnifrbtWKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gZDctCdnzeHtSRzRwM+NM8cxKfxrpjEuuR81XhrsmTUGEhjWoSC5+y5BQf6hWB2v
	 hzXY7RfsBatZZ27HYd1QuPVlpkPOEb7SwHIqMPU8wHPeh/fYANAHoyrcef9LqfWFjM
	 nNCAVHE3QZ+fvWMl4BOCL6DxxYjgJFWiLqKNxbUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0710/1257] nvmet: free the bvec on file namespace range errors
Date: Sat,  7 Nov 2026 08:50:06 -0500
Message-ID: <20261107134958.864715082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0b22d183f9279..695963dd932ee 100644
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



