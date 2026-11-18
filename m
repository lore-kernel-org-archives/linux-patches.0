Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028502;
	b=Mz+9Oq4+wzHbZwJ+7i9V9hkWTGzM7tTSZ2JSczDPwf8+geAtQXDLWlshlXqviRDPDaUc
	 qihHgFAWaMzHzcdXf8IUqlRR8SXn7C8ee+PP05N4SKsdni9DmbSew0dwCKAHK5i2B3z9a
	 SfRV88wVyyeeZFBYJZe/eu4JWwJSU6H6dPD1GsTx2zoDCQfyl2WHg5hR3iQvN3kXYOx5B
	 /5qEf9n4LPhlk764vVjLzwSqUMnW2AaxiEM5hhdtBFwtWW/f4RqWU1I0qvUJBPqfuo/w9
	 JU6agNyGkzKqEyGem4kgjID2Paq3skNmQv4D5B5zdoPsJdUF4tYEUXaQmAPvlvrNh0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KJpL6VaaJ9PyWlHb1VVTDLLXuwy1VqCq+JJlSCcxbDU=;
	b=V8nPMG0YFNUXtGHKreJS8K3FlO6yNiajnhzDpvpI9npFpB0WExOucvSgrS2ol289sNFH
	 WjsJVObTwbHPiNkRql3Vi02uRXrcXw633GrY235fxzzzI79XeiLWLmH/bbT5YXgoJyjEm
	 z49VyadhcO6Dz2o4TlwRTQMAkrHQHDnmOGhVvAPcoHOWSQjzUIWL6I/FANDoE8asV7eIy
	 y+0adzMdajygP/FDrIREjq+KwggW2tYOxwHle3iK0nn68pj5JUlk0J6YHu0eFOioBZ2UY
	 jatZqs09YdCDqr8nzeKnFBEQOZZug4Hkr+NCJ8YvDv6l1nxIZKPihONg8QxzhkIToHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EN0ZYuCe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267D9606A336;
	Wed, 18 Nov 2026 19:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EN0ZYuCe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807051F000C5;
	Wed, 18 Nov 2026 19:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028502;
	bh=KJpL6VaaJ9PyWlHb1VVTDLLXuwy1VqCq+JJlSCcxbDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EN0ZYuCefRv6LbNIah+ha431uqmepwVi/UiwxUGaJ1SNvphqM1haJsi0Kv8ncHQuX
	 Qymh82JozBXEmpel3WHIaE2fR5uUCPemyFF+7xWyWMlYQWe/LKAVskZxcENDbskYsJ
	 GqRc6dhOeRPXs/3ZRVNXC3R0W5KK5BIxHrDkJMq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0005/1756] ksmbd: revert fsids on durable reconnect and replay failure
Date: Wed, 18 Nov 2026 15:35:32 +0100
Message-ID: <20261118150008.196325630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: omitted the durable reconnect error-path hunk in smb2_open() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f7e3d7986c4ca..1af013ae66f94 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3129,7 +3129,7 @@ int smb2_open(struct ksmbd_work *work)
 
 			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
 			if (rc)
-				goto err_out2;
+				goto err_out1;
 
 			goto reconnected_fp;
 		}
-- 
2.53.0



