Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053226;
	b=vjLLI1077dilPNEJUNo4Bnb3ylNMszud8BcPrCp57mk97bdp/QIwg4xlGqpULkGBN5Zs
	 ubJmQHEVsVyP7MLkXJQYXs1uBAAIAwvviDfX4wRNDB4KrYmUWj2x+SWojGQksFkUbDz9z
	 bASb8EbacboAPb9CC6VWcIKqpdCku2MxkOb1KZOcucn1jlzkOmQFszC36MnGWUC+7xcsq
	 OiWExuCCtZF06aAoUBh7kcYOQpEHoEHMzaT2eBJEzRuFgcSAzYQJ/vjVAqEsyDJQv+byN
	 bler8YCo+ANvd6x+Pvz4mb+c6BFi4HVqpLemTgYLflkxyFLUWeeNGy3qOhiyPot9PaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N0m4lQuJejM/CE0EZEhb6E0c76Jjm2D8ZPCOgusvGRs=;
	b=Xrc3n5gnWqgqKBfcRNPRgLG1sn6BwOjSe1fS7ijGQB4u5QrmoqnQvyerWErkpyC10USV
	 KiYb5wNAx5Cdnk0R2ruyzO2L8zFEWfSb3RthDnz/zCygV0sJ2FbNIfyoBKa2Rk4ASJrRC
	 +mvnDJnttB0fA5IPse4evRGb+zUw/JXIZ2rUHURSC5JkjYhLJ/opPsij465g8CKA7Ucvt
	 7eOzC6dfgVEh0Px0AJEpTE2ZHJIphU2IWKX2dDfu+YKMQRNAfBbffNceWfEMrZyKN3kkj
	 bPLnJeY74y8xskF8KM73zfhMOBu7eBW0hJ/MuPEha0i8ZVi26mtL8JT2bwN1OzdHatw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpJk5SXU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B402A606A31C;
	Thu, 19 Nov 2026 01:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpJk5SXU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110EF1F000C4;
	Thu, 19 Nov 2026 01:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053226;
	bh=N0m4lQuJejM/CE0EZEhb6E0c76Jjm2D8ZPCOgusvGRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpJk5SXUefKVVdzRjQJ78a5aD1C+T6RYnjlFemyydTj9CaiojEaOL8rj0GYIISpyS
	 jZT8/M8pLkanI1VWj6nUsP6+9E+c7F6JjJaQBvA1I9wTTK5raNn/Q6k5eu01yTcL0+
	 FfDw1sfhCbHFuJywj5lApO7LFg2Xc5/IWkD/nLe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0785/2214] NFSD: Complete a cld upcall when copying its reply fails
Date: Wed, 18 Nov 2026 15:41:01 +0100
Message-ID: <20261118150042.998752958@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 8cef2b0a01d28647facc57501a3df7ccd8d13ccd ]

cld_pipe_downcall() removes the matching upcall from cn_list before
copying the daemon's reply. When that copy_from_user() faults, the
downcall returns -EFAULT without completing the upcall, and a
retried write cannot reach it because its xid is no longer on the
list. __cld_pipe_upcall() waits on cu_done uninterruptibly, so the
nfsd thread that sent the upcall is stuck, and nfsd shutdown hangs
behind it. The pipe is mode 0600, so only a broken or hostile
nfsdcld can trigger the fault.

Record the fault in the upcall's pipe message and complete it, so
the waiter returns the error to its client tracking operation.

Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-3-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 0b3b23ae7820e..0b8ff8cdd5a1e 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -909,8 +909,11 @@ cld_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 	if (status == -EINPROGRESS)
 		return __cld_pipe_inprogress_downcall(cmsg, nn);
 
-	if (copy_from_user(&cup->cu_u.cu_msg_v2, src, mlen) != 0)
+	if (copy_from_user(&cup->cu_u.cu_msg_v2, src, mlen) != 0) {
+		cup->cu_pipe_msg.errno = -EFAULT;
+		complete(&cup->cu_done);
 		return -EFAULT;
+	}
 
 	complete(&cup->cu_done);
 	return mlen;
-- 
2.53.0



