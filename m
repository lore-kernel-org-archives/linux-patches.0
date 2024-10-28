Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68E58837;
	Mon, 28 Oct 2024 06:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098243; cv=none; b=WaNrjQDqYMExWULJoFf6iVO4N+MEe47j7Og1sBuvw7nUa1empN2adJ8UFIbhnvzKPfbeaVDp08oJCdURrdvBQw/SRsH25Ju4tL5UZVO1NXdMrSWAI4roIB038mI4K4QSuM9DhH6TMRc3todjvOD6hK7nh6L0Qo9YC3j8w0zbNG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098243; c=relaxed/simple;
	bh=UuNVwSe8M0zAxTUW1c/LzZErDzg9g/5U8RrYXbz9Tok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h32MzrUOrPxAjFVspQwnfOcjUK5bpvSYLXz8VedrsExJngqQJDdNPmaSMSBn+D0E1RbTdw9FRHkwSeXiWp+HQQ6woFNrBb3ZirLx9r+kftVqlvY0rJ3pYtuvjiwF7rznwZqnCKTkViDrXcNiS0+2akUa/QTm8YYibvzCVzfMCvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czhMt+mF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czhMt+mF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8087CC4CEC3;
	Mon, 28 Oct 2024 06:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098242;
	bh=UuNVwSe8M0zAxTUW1c/LzZErDzg9g/5U8RrYXbz9Tok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czhMt+mFBjdT2sdJ8oDWoLJAont78imTfw1D1nTTsjecU2FOfr+b/weqGTWOx9Rro
	 dHIzo9xGb0MAXgVACuunvCXR3eyNVDdUEof2KP1BEdts5Mocntiaj1lTtBcK/uHcGt
	 1Rz6YjWTvAdadJ9cexUUOKUkMGWk/HNYm7I2W9v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 105/261] bpf, vsock: Drop static vsock_bpf_prot initialization
Date: Mon, 28 Oct 2024 07:24:07 +0100
Message-ID: <20241028062314.662139213@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 19039f279797efbe044cae41ee216c5fe481fc33 ]

vsock_bpf_prot is set up at runtime. Remove the superfluous init.

No functional change intended.

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20241013-vsock-fixes-for-redir-v2-4-d6577bbfe742@rbox.co
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/vsock_bpf.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
index c42c5cc18f324..4aa6e74ec2957 100644
--- a/net/vmw_vsock/vsock_bpf.c
+++ b/net/vmw_vsock/vsock_bpf.c
@@ -114,14 +114,6 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	return copied;
 }
 
-/* Copy of original proto with updated sock_map methods */
-static struct proto vsock_bpf_prot = {
-	.close = sock_map_close,
-	.recvmsg = vsock_bpf_recvmsg,
-	.sock_is_readable = sk_msg_is_readable,
-	.unhash = sock_map_unhash,
-};
-
 static void vsock_bpf_rebuild_protos(struct proto *prot, const struct proto *base)
 {
 	*prot        = *base;
-- 
2.43.0



