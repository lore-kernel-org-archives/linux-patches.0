Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214819;
	b=UPlXkXJ5xlsxWfD7uRcbnAqOQfsBldVBmPWUIwIGhz271qdvbDEqtANFathqMnpP0XTN
	 1Am9cz8n38k2LdLte7PXih/CJOHUcgvlilQ1PY7iRAqTM07rPGteNB1YW/vyy+gOWJSiv
	 rWG0TMGkcecGsuEYrfGhbBsFYl/UgxjSPA5tL2LmgXduC50XNurkXJnsDBtu2d5hp1oDW
	 Qyv//hEpJEofQVQahd7Qz1OxpfSwtuDIdht4gj9D0FIs0br8MqJnXkrpfxpqyoT/QalCJ
	 eu4dvTBGPmLzKSHfDnWSAbjM2QtlJgF8BcvX7FGivbhgfnj0rMgDuthIPMuAG0kUUCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dS4p4GbuweobJUJAdnDLLkkkbyFsKmxXzUWnl7Ljeg4=;
	b=TYTsf9WIRmkOLtv8Pj3m0YbPDGChH9JEN7J/PNaMKInFjvdivLaaOwUol6uA5I0Utdoh
	 x5WeH/FLoxvkr33Ch3m7+Bf5uL7V0DQcJZwrDgqPfdCnJFCLKXRtRGFSi2NqF3iCQWz0H
	 mIOtJaEefUhu1njm+1Mg0IWT7OqJE7g0BqSOOfhn7n4rEGcQZJOGRbmkHAqwet3PXl+3D
	 Wroot4V+tgCkyNBf594rQY3/8w0fWs4wG0gnz07EmtV2p9H0pG9VRw0xMvx5pOiiNgzK5
	 5jve+1qxifsi6gxkFwv7tKFF/A9pmKPCkP5YWdUbl2f3HSKq0ZYzRzBe8JVQ1ti+yOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMBhKa3M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08800606AB09;
	Wed, 28 Oct 2026 19:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMBhKa3M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA081F01825;
	Wed, 28 Oct 2026 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214818;
	bh=dS4p4GbuweobJUJAdnDLLkkkbyFsKmxXzUWnl7Ljeg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMBhKa3MjysYRF+hAO5TCgPkisgsh22NF036lgAX75BVoSds+p/84HbFjv3OyX/GF
	 tfu+iJL/0NCXsOBlmdnM2Gsag5Xmrzyxqm+4cQLATx4pOv8gQ817hj8rZnqlBrABhw
	 UWETiLBNjDa/wUyrrnN3ie56OIQQkwrU8W7iomUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0991/1887] ksmbd: fix signededness bug in smb_direct_prepare_negotiation()
Date: Wed, 28 Oct 2026 17:51:27 +0100
Message-ID: <20261028170521.963936003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Carlini <nicholas@carlini.com>

[ Upstream commit 6b4f875aac344cdd52a1f34cc70ed2f874a65757 ]

smb_direct_prepare_negotiation() casts an unsigned __u32 value
from sp->max_recv_size and req->preferred_send_size to a signed
int before computing min_t(int, ...). A maliciously provided
preferred_send_size of 0x80000000 will return as smaller than
max_recv_size, and then be used to set the maximum allowed
alowed receive size for the next message.

By sending a second message with a large value (>1420 bytes)
the attacker can then achieve a heap buffer overflow.

This fix replaces min_t(int, ...) with min_t(u32)

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Nicholas Carlini <nicholas@carlini.com>
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Stefan Metzmacher <metze@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 1290c0fa7dd18..bcf0631ce10a6 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1967,9 +1967,9 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 		goto out;
 
 	req = (struct smb_direct_negotiate_req *)recvmsg->packet;
-	st->max_recv_size = min_t(int, st->max_recv_size,
+	st->max_recv_size = min_t(u32, st->max_recv_size,
 				  le32_to_cpu(req->preferred_send_size));
-	st->max_send_size = min_t(int, st->max_send_size,
+	st->max_send_size = min_t(u32, st->max_send_size,
 				  le32_to_cpu(req->max_receive_size));
 	st->max_fragmented_send_size =
 		le32_to_cpu(req->max_fragmented_size);
-- 
2.53.0



