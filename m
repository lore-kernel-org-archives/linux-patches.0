Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210128;
	b=BSRbjfGMq4DyHOckU0jIFo/2KHMleswDLgvaEX65TVZaBOySsZRYbwghg3khMf1X/8x+
	 frel0Wr6oA+cHu4c/hxR2VTo+yKB709YET1yR/qTAKZ7K3IX4DUkRgnT8l6JTMUV4PEfB
	 R0WzjPKrrDplsVE5BAt/yi0ideCS2476kZ/0KbxI7PyD7y8GnSg/a67Vwd4IT6wI3zJfc
	 cRs7yts4TfMmJEm8HQiQxhGUfzfQsIEtN9p47ELQTUPcQtY0nb7C6nFZ7cGWe6+3zHAy6
	 mbrQvx4nK0KL2UJjgLf5Yb6GkujMULqbep3iq+H47z2Yp9/H4I6mMCYKz7hluW/lsiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lS24DY0TrasLCYSXWOoZ8tM53LxWteYCIv5rrYNSaCs=;
	b=L1OdUJ/GwI4lLtj3IrWWqlvWpFkLUpoOC6vTxUX5HhNZWd6lyEWTnOcZE7pbXWY2J4WG
	 ff4M2id2r4pFSvcr0OBGb+t8c5h9aDRn8X6QA95//5W1W5dYkaaGOlb/IUbwfUrdVSM19
	 XieCFhLwOMavemB3/aZ++lI4nIGhp+iAwl1ohzDpVZccg2UYKlu6i0ekgzOUvJixGnuD9
	 AJqJhWMGmDAl/n0bgTL9MSSVvAui1rNpCMT+MrrDIWMDSJtjvWiCg4fs0EO7I+J9lKFaR
	 ap4ostWjbG/DNfGw2bz6hEm8pgWMhOKLE4j2yZZosgwTk217vMpMAKE8SrOOQfvnoiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ir203C6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E9F606A31C;
	Wed, 28 Oct 2026 17:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ir203C6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EF21F01825;
	Wed, 28 Oct 2026 17:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210127;
	bh=lS24DY0TrasLCYSXWOoZ8tM53LxWteYCIv5rrYNSaCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ir203C6IvqSglN2yQQHJIy8886sJ5u1og4bIPjh4LyzZrh4tEhAlVlV6zHPgCj5uP
	 YuBVoVhf50BkCwA6OulHckSGyIES0gR5WExE/12M9ejRXI6600OeuP7Y+SaUxGPB+n
	 1Si9DlyUKeMA4MkI62vS2sMlcTNxJ010pGZHmRgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 085/168] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
Date: Wed, 28 Oct 2026 18:00:21 +0100
Message-ID: <20261028165945.100177300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Aleksandr Khromov <haa@amicon.ru>

commit db2267b27c054a6c2151ff7fbb67927e784f31d6 upstream.

smb2_get_info_filesystem() reports 56 bytes for FS_POSIX_INFORMATION,
that is the whole of FILE_SYSTEM_POSIX_INFO, but never assigns
FileSysIdentifier.  Those eight bytes go to the client as they are found
in the response buffer.

The buffer is zeroed on allocation, so a standalone request leaks
nothing.  A compound request can leak: the offset of the next response
is advanced by the length pinned for the previous one, so a reply that
was written into the buffer and then dropped in favour of the short
error response of smb2_set_err_rsp() stays there, and the next reply is
laid over it with only the header cleared.

Report the file system id statfs() returned, which is what the field is
for.  FileSysIdentifier is __le64 and f_fsid is a pair of ints, so
assemble the value first, val[0] as the low half, and convert it on the
way out.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5761,6 +5761,9 @@ static int smb2_get_info_filesystem(stru
 			info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
 			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
 			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
+			info->FileSysIdentifier =
+				cpu_to_le64((u64)(u32)stfs.f_fsid.val[1] << 32 |
+					    (u32)stfs.f_fsid.val[0]);
 			rsp->OutputBufferLength = cpu_to_le32(56);
 			fixed_len = 56;
 		}


