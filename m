Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045492;
	b=WxxA/6iP0//M2RSESf9jyV93Q9J6HcA7FRvrY13j/YWyNBua8Fcs/YvfBumKvsyZTlNi
	 NfnSEAP1XtbxNJ5rUacy1rAkVYiPvlSEdupGjEpMEE2yH8rJQIpsDsXB6KiBDvflwAdnw
	 No5bexG9ll+8Fckl4bDSVxO6lMk365kQ5szAEfoGOhYzdmmtVK5maDtnes0pBXbsmXjd6
	 ZQEKbkhCJfCaveSX/5HbFl0Qb0gV8BMT4MWQOmK8uYw1HZkb9HCbreMmQhfRnotHjDi3j
	 DWIsvZiOAlKNiW1O9vjtmKDT81adNv+l2eIsYmHwEiong03AjOni5FwDChC55W6QJcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6hDi5JqSlE3eRd42ww4W1ykZvw3TJ55/HJmLV/ezSic=;
	b=cXZD15e5dfgmMWqP30Mvvw+D6ql4v/LWWdWJy2Qta4CK7DNrzQuqzE0LffWwukj0dJ67
	 vfWvXeFLRTb/3EcsNtfnJdzw82rinmqozE2SWloTjfKJshSHZAlcqIsvSvCbiEMV9BkA/
	 TI+6qlPJEMXjr5jjtXjG/MgMnUYgzn+r1d6x+VQhi7mzbpVZcvFnSccXCsXGLa8KmTfN/
	 EezKdHbQr7/pLFtak7/wRNGVNT5CQrtPRt5eBlAGmXPGz6wkDtH0F9TSG2tlzf+FwSZ74
	 q0AVgTSAxaH6XdLvw3aIprAnEduUIN+NMRwZiWPKXIQiAB5SqxpDI1BPYNJB0/g8gLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iwe+8PJw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF99D606A332;
	Wed, 18 Nov 2026 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iwe+8PJw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454FC1F000C5;
	Wed, 18 Nov 2026 23:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045491;
	bh=6hDi5JqSlE3eRd42ww4W1ykZvw3TJ55/HJmLV/ezSic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iwe+8PJwFnhEXlAv/z/klgBmJtVpG/TiGXmzcNVqWfM/kVP70Z82X8Uvu886rWTyL
	 4KP4c/3f9114vVPtoHUiOzla+o6zjEcNPzvV5Fg9gkhS0vbJ8Qhtbjd+FsKvqdd/jh
	 NOXoN5JB0vuvnJsF/v+mM5HM3qLtqguV9k30BVok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0939/2857] nvmet: free the bvec on file namespace range errors
Date: Wed, 18 Nov 2026 15:32:53 +0100
Message-ID: <20261118150235.412543143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



