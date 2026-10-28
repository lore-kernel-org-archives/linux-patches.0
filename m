Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211930;
	b=MUa4aLZMEGpYpZ3jG/JXi6LxzoviQcY9035lrTlPzLsMsR7Ky8fUuWWnWSqewFBKzwqU
	 a4XUc7Wm8BSTEL1x3jUQU240uV4phkMHlHLlVf5KHW9Eu1bnA756858xlenXC9USQ0OkY
	 EW2Xk1k8IpSIshk8DtZmDO0afkC38qGJdooGb05kJABKkydqGeQLw4VYtvbYluJiohrfJ
	 KDfz6hHzKH/EEg2sGLwjil2PB2jw+ndDst/DbUYmGZElPajXcm0PVKn/jwjcdkx0/+r3w
	 AsXimr7BFwfDmzxBOAwky37edVMnm35ix9SNiSN9mXRBoBb5kZRBaMPrscGlllzXy2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FMSlvDdPGgA1wI63b9Gjx3PA1vLBrevNt7evqRrD/zA=;
	b=kfnmtD//4YzKY2nsxSEbgPoDVeeb6dc71WxbMrXPBINheWWl50y8lI74RgAje//fyMYP
	 mdnpvNXd9qmX6hwXO/XWUDtx9CqfCr3WbL7d18p4PWXi1gIdASX6+qYMp/JGd0E0jzWwh
	 OUzzKGaZnk6zeEuPFU0mX4upM7YVVJN8XkVlR86SlM8ePBryEpXUz8oW3FwfnY+xkUdOR
	 nO3fjp1335u8qRyyKdOpdjdDsQs8EwXhVxLh0GH6DfRQXoLQrfsSvx0G/oouPQfmmoba/
	 zl+6X4Slkc7NnCnCJaTJ2moxN2MXb4b1u56RNzEJifqH/Fv4vakk6bcOi+Pepm2Tbwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQU2ZyaI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6CE606A31A;
	Wed, 28 Oct 2026 18:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQU2ZyaI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A911F01825;
	Wed, 28 Oct 2026 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211929;
	bh=FMSlvDdPGgA1wI63b9Gjx3PA1vLBrevNt7evqRrD/zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQU2ZyaIEkVNdOwkrBHMkGKvaq0cBrAxREQcwfx0xDDVTWCwoPeK4w7SJuI6Uzhq/
	 W5NQcFZwTn8+XPdj4Z0lyEq/dC3XqObBWgmj9MK79OmYnSHhZO94hE4+54f6H7S/o5
	 Y3g2EqNg1THstzCmv9+NFiiGjfF0umNDrAMsVSFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 549/571] ksmbd: zero the FS_OBJECT_ID_INFORMATION buffer before filling it in
Date: Wed, 28 Oct 2026 18:01:36 +0100
Message-ID: <20261028170021.063919378@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Aleksandr Khromov <haa@amicon.ru>

[ Upstream commit 399aa12450a61a5c73dc77e73f069ece9687c95d ]

smb2_get_info_filesystem() reports 64 bytes for FS_OBJECT_ID_INFORMATION,
that is the whole of struct object_id_info, but writes only 46 of them:

 - objid[] is 16 bytes, and when the volume UUID is not available only
   sizeof(stfs.f_fsid) (8) bytes are copied into it;
 - extended_info.version_string[] is STRING_LENGTH (28) bytes, and only
   strlen("1.1.0") (5) bytes are copied into it.

The response buffer is zeroed on allocation (kvzalloc() in
smb2_allocate_rsp_buf()), so for a standalone request the remaining 31
bytes are zero.  In a compound request they need not be.  The offset of
the next response is advanced by the length pinned for the previous one,
so if a preceding command wrote its reply into the buffer and then
failed, smb2_set_err_rsp() pins only the short error response and the
next reply lands inside the area that has already been written.  Only
the header is cleared there:

	memset((char *)rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);

The client then receives up to 31 bytes of a response it was not meant
to see, including one that failed with an access denied error.

Clear the structure before filling it in.  As a side effect
version_string is now NUL terminated.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Suggested-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 6e3acd0a5687a..cdc1e7fb7cfa1 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5196,6 +5196,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 		struct object_id_info *info;
 
 		info = (struct object_id_info *)(rsp->Buffer);
+		memset(info, 0, sizeof(*info));
 
 		if (!user_guest(sess->user))
 			memcpy(info->objid, user_passkey(sess->user), 16);
-- 
2.53.0



