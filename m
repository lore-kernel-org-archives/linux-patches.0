Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217060;
	b=exJo5UfkcuCJcaNagqtIfWvUjMEAZpSpntEnZMZXMEvqwDpTvPEjew48LBNJl8RT45yK
	 QKH6zsj4xUCGW3GOWbpgCZJ5M+Aqe0FCFSYUV+a+vfRep+5XdJjiiCuXKuBVsyV+N3GoB
	 9YNh6wK7su2qyogskWA8/NoghA07ezJk1D9rVnlLh8FzIQ/obB0WXSoVbbXckklOjuZFf
	 i80d1uR9C0LdDbtf4dmAkk/guNJAkDS3rqiMu+qwnuUMF4lwsgMaE3c88dttAKU0f/nuh
	 Ar7zn3cDSNyBRLI+kn+xuJA8yuw4BOSU5av4DT7j14H5Sm6pRSJAnpZ11pKf/RelITA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kq56YByI2NQSdpY/GTCavZlaVxGyJWG+c4JjWz4oRYw=;
	b=DhxNKndLPVdG6KqVPCN3Vo7aHBoeNdlRBc6wMpJCTDiIRBcp0sg9bohAZkBCDeOMBnDX
	 IMA2URfC8AfWIUdtdkCjkOTaikBYurajdNNHmKLq4uLyxc+YzuQ/yep6fCfgMfhQWoNCY
	 ie4L6QT8oR4ZVKKPAM9V64qaD8QkrUNZ/WRob+3iPt0e1DZJ7C1FJEbL0QmmJKHfTsa7j
	 +9p5FAUHYYFXpyVH9qxXRycaaObZhbhCBxck99x6Y3s5pVEuiuln01rbeuDIGFGHTU0ou
	 +2QIBIwvLTXs88sMvLzVS7ZUcTJ8Y4Soztdx739UuQYDs7bzO9zVVRenD1YOVI9OueA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t4aK/JrV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E245F606A31E;
	Wed, 28 Oct 2026 19:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t4aK/JrV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5661F01825;
	Wed, 28 Oct 2026 19:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217059;
	bh=kq56YByI2NQSdpY/GTCavZlaVxGyJWG+c4JjWz4oRYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4aK/JrVkY5iAivhO3dPDQycczghybrFpnElNDOrU1dQyQVR9B9o2lmDvUSu23/8f
	 QonABj8HlSqku5l37EASkAX1oBuHW+ovvTs2UnoRH+QEoHx0BTKtHs+6STq7EAkCpN
	 jI6S2Kquivqa8Ygl2Hg1OTN64bJTLDD2QgFwJrTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 1773/1887] ksmbd: zero the FS_OBJECT_ID_INFORMATION buffer before filling it in
Date: Wed, 28 Oct 2026 18:04:29 +0100
Message-ID: <20261028170539.798425049@linuxfoundation.org>
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

From: Aleksandr Khromov <haa@amicon.ru>

commit 399aa12450a61a5c73dc77e73f069ece9687c95d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5267,6 +5267,7 @@ static int smb2_get_info_filesystem(stru
 		struct object_id_info *info;
 
 		info = (struct object_id_info *)(rsp->Buffer);
+		memset(info, 0, sizeof(*info));
 
 		if (!uuid_is_null(&path.mnt->mnt_sb->s_uuid))
 			memcpy(info->objid, path.mnt->mnt_sb->s_uuid.b,


