Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775064;
	b=btRi8uRZsBXtHrhfAZDBuK/A+X3WvhOLVdP14BEnfbBQESD/k5PgTeODF6LUG2iiZsJ0
	 Lg2andVd9rmh2B9tcH6W2+nCV8pdEqHRQZgHZGZZQM76eALESR6vjxwTvGZXJkgzI2b5Z
	 Jr7cmQmHy5S1OQHm4Be+KrfteIzly22KO+PDe/mjoOOPjNYf/WLibZAgzhRneMGQGyk69
	 N6gR/jXOD0Ycw3pGBuxurhOm6X0VPd1wAMsbGsHHT1cbXhOy+jTtn4bi3/jbCNh1HXvKk
	 uJolF0TiMjWj0qwDeMGL6Oup02Qvm7sg26iojO4A4dcIC26TPIYJR7/HPYXdNLrWeYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1oUvgxK/su3z/KYEFzn/CLbvBZruGmcEY9sNJGQE3qk=;
	b=lSJMt2mWBQE+I4JL/r4biY2kwf2j/gjfcnL/2rv5ZbrrJAXiMbVdQJL8KlsVwGoha/c7
	 oUolHNVvpfU/gYnIfceaqMr4l3KfpK4rcIDmfkJQdEmMa25trnWMEak0F7IRgLiJ8N1nw
	 WdmuioEC8+mxJRXJ1TbUeHEtNv2Se7dU4eS2q0xy7VLSkEGAte4Bi9ylgnXRaPAEjVqgL
	 pOg2x7apLUHpDtazaHdRQuM6bT/UpIllmWbsn6J/fhCoDCjy44prumb+PBgSWLCFjY3X0
	 ObILe8yYQHxC6SV2Ot8RH06hBArmdvG2QFv1mUnBAy/q3yktAmVtVQ2W1sheKOF8rxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PbeCGav;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1C2606A31A;
	Fri, 23 Oct 2026 17:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2PbeCGav
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEB51F01825;
	Fri, 23 Oct 2026 17:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775064;
	bh=1oUvgxK/su3z/KYEFzn/CLbvBZruGmcEY9sNJGQE3qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2PbeCGav+cFUEymFdxwlDSUMG3j2AJbH1wX2IQSneTnii9ACvWGGm4rQecSJthzcF
	 XgWes8grAta7u/Kjdn6ooZ27YnaUsAM9FX+WSWTKbqZaIXTFNKRxg226iFzjzfm2Qt
	 b6HsCOZASHjeBcFuxbQ3yXIL+eqfD004eiV8tab8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 218/242] ksmbd: zero the FS_OBJECT_ID_INFORMATION buffer before filling it in
Date: Fri, 23 Oct 2026 18:41:00 +0200
Message-ID: <20261023163718.971386606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6715,6 +6715,7 @@ static int smb2_get_info_filesystem(stru
 		struct object_id_info *info;
 
 		info = (struct object_id_info *)(rsp->Buffer);
+		memset(info, 0, sizeof(*info));
 
 		if (path.mnt->mnt_sb->s_uuid_len == 16)
 			memcpy(info->objid, path.mnt->mnt_sb->s_uuid.b,


