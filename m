Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038784;
	b=OJFmnF09hL3XsOBnVeJN/0VdZ00u/d/YVbpXCC2uERE6Se+yp006YwJP90pS+3BNRUj4
	 Ghg4HGoTzHNEH8XEkQl27cLwfrJ9fARXcFHaTli3QMddU6aVvtBoiCuY4ie8EdouB/Jbw
	 q0M8fRzRfqHwnV7FDzAFxzwhaGGpX2LlJGvYZUkdLp2h2TDbCc1WFllXOZ2wkH6bfmW6k
	 mHQ8VUwzEXH8ybdPSJmjbSTBOyQzSWbNdm4GIpthjl3dIusHh4+bwPK0E6p25YQPRea11
	 TbmOPy6EAOWn8G31orN3kEb0gPUcm6HktBpfMIqPXZhkLN6A2eZVNVA+C7+A1WjQgVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n1O2V7Y9rJM2mq6q8FgWHEHu7OiDenkKm7JcbSVvAps=;
	b=wWJbWZhNZDpERUaBnxIUpuaqTZVlSgtCys9CwKH8HXsQaviHHbI2DwZRZdcHZ6WbEqEj
	 AnyYHVmyisZxxnbJlB5VpR9YY3ZDA2LPKNzCVtwSFcpnIBt5ihJsB45YVnVUtVzejdrAP
	 adoaWT/zeFmseZV8fOx5qftgPF0pkir4DzoUoWjHfQh5mePtMvKxVE1ZYrVu1P290WDuu
	 yvw3Ii1VnEJMXEuM5QOLREM82iRj0ZStlKfiRlFclIZ1019MQ5THwPdZzT3LTMmCjeomg
	 mT8/eXe5+TkTqVIcV9F4i6/ttvUDKpehBe7shRPVB13rUaXJQu3niCwQuuBBMNTuRsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UOy/9+e3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA735606A320;
	Wed, 18 Nov 2026 21:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UOy/9+e3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9E81F000C4;
	Wed, 18 Nov 2026 21:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038784;
	bh=n1O2V7Y9rJM2mq6q8FgWHEHu7OiDenkKm7JcbSVvAps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UOy/9+e329AM3Eno7pPSdDWgZo6JuFghhnkK9okqDxcHyjei7LWLa7URsG4bDxBeO
	 ARFc3vsKcgNumkhxr7toGIHcdI4jp+MDyBJ8gMMMV27wf1FNMIqL7SBQRNwgvdqjol
	 Hz3rIoPHBhPuMhqD88a9xCU3lKksluXtPiLf/nq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1865/3318] ksmbd: enforce the read-only share flag when creating a stream
Date: Wed, 18 Nov 2026 15:41:27 +0100
Message-ID: <20261118150417.878058321@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 09139429fab3a5114c18d7c15fb161511d4d66c9 ]

When a share is read-only, smb2_open() rejects opens that would create
or truncate a file. Creating a named stream on an existing file with
streams_xattr sets neither O_CREAT nor O_TRUNC, so it passes this check,
and smb2_set_stream_name_xattr() then creates the stream. On a Time
Machine share, opening a missing AFP_AfpInfo stream also writes one. A
user who can write a file at the filesystem level can therefore add
streams to it through a read-only share.

Do not create a stream or synthesize AFP_AfpInfo when the share is not
writable. Existing streams still open normally, and a missing stream
opened with FILE_OPEN still returns STATUS_OBJECT_NAME_NOT_FOUND.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: eaff8e924f60 ("ksmbd: synthesize empty AFP_AfpInfo xattr on first probe")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: omitted the writable check for the AFP_AfpInfo special case ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 984e194d83f85..146a911718ee0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2546,6 +2546,9 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 		return -EBADF;
 	}
 
+	if (!test_tree_conn_flag(fp->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE))
+		return -EACCES;
+
 	rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name, NULL, 0, 0, false);
 	if (rc < 0)
 		pr_err("Failed to store XATTR stream name :%d\n", rc);
-- 
2.53.0



