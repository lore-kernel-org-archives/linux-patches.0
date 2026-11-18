Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022495;
	b=ptQXei0U81lkZI8VzENfbItgwT7lLIVsL2Lm/1i7kBYrZ0uy8eZIIVWI8TfBHn/YEk5C
	 FJ5jeWjIjZ3miyNezk5GLWIgq8+zrswGfTRTXj7W7D7KduklR+2g3t4pdAmRg2Nj49x0o
	 e9CT848YAwiwmJgrXm4breULOePM5kVr56JNcG0e+fuY7xD7enVsYUJfqDSnWnSbgYwGc
	 prXHmjuboJikh5s9EFAUY46nWOzEK3pCIoy9UqlGOL667NbToUSH/tY/Y69H2DOS6e9T2
	 UfZ3xLKlQHQv39h7Sxbchn1DA8MM7JAZ7H8Vt1s2MP6K8l8TKGwH2dBK1/IiHxjqr/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C/T3H1tUa3wfIxUHUzC08jvpq3Rwxg4oQ21vgIFOxhk=;
	b=aKB8SAaAS3Phl1cyHcDYnH8boBC+38hMXUdISNbXmQpy+mqG0ey8HvNmdIuy0gkafLYS
	 Itar9rVcPFVr4SPO5ANQeLXsLlA4pcJ27vqkFSJENPp9NxL9+SxBPQSaHEvTq+F6YVwBD
	 dSM3OKUOCSSVZKZEwEEgaRfEg6sL8yaZQ6alykeXwBgqt5AOnQdrggb4orPkfdLLL+d0l
	 H4C3Cx5ON9t82U/Q+H1z0hxqSWe4fxTDUcYuNegKLYkQ70P6Cg0CMjbTz0W55Mu0Tn7zW
	 A+kd8CHBK+aUohXPFmByeFUrOGRs8XxQlj628Ea1YIVKAUMFEsy3vnVMQiFjS4JSrxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WiVMR1b7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAD6606A320;
	Wed, 18 Nov 2026 17:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WiVMR1b7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528B31F000C4;
	Wed, 18 Nov 2026 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022494;
	bh=C/T3H1tUa3wfIxUHUzC08jvpq3Rwxg4oQ21vgIFOxhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WiVMR1b7KXiHFYFu41ksxCAxYAW8/DEEKOtbhtJEO/+H4hoAvFxJCbHl5ESH/lLXn
	 NBSAKw94Me4GTZfFJUTJXOvf5up58yu8GREDHTW+i858StsePQSMHn5992CpKOFkzQ
	 J7t5S8tdrRtBJFEnyFjo36Fr+95CsLwpGRq0KH1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0006/2151] ksmbd: revert fsids on durable reconnect and replay failure
Date: Wed, 18 Nov 2026 15:29:01 +0100
Message-ID: <20261118150121.870824436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 539223f18026448f67d33d09719c355b91db7fd0 ]

On a durable handle reconnect or a request replay, smb2_open() switches
to the SMB user's fsids before calling ksmbd_vfs_getattr(). If that call
fails, the code jumps to err_out2 and skips ksmbd_revert_fsids() at
err_out1. The user's credentials then stay installed on the shared ksmbd
worker. Later work on that worker, including other users' requests, runs
with the first user's fsuid, fsgid and supplementary groups.
ksmbd_free_work_struct() also warns, because work->saved_cred is still
set.

Jump to err_out1 instead. No path is held at this point, so skipping the
path_put() at err_out is correct.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Fixes: bb8bf7eb13b5 ("ksmbd: add SMB3 request replay support")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: omitted the hunk for the absent dh_info.replay branch ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ec4c54c9c6dc9..6ad50aab3dfcb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3125,7 +3125,7 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
 			if (rc)
-				goto err_out2;
+				goto err_out1;
 
 			goto reconnected_fp;
 		}
-- 
2.53.0



