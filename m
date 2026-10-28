Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207750;
	b=jVoQex/MhfxX7BRjxrZ5blvHGoyEHjD/JPWt9Od/0iq/djX3TlKOdgYBdtHxtiXhWMO1
	 YSRMxnOlYdvIdRu03DaffZ93AeFuV5YLev7uEhgmM9eoYl29XJdyCwi+LGUE9RJ0a1pxp
	 wR+VjOEFmI2RoX5WfHScxS/aY0AUOorv/dpiy3G/OnCGwcsvkN+pb4B28bkxDGgAS5QwJ
	 dwxai7ok4uVBw1y9jlvdo2a9iPOVg3vP26Rsk/6nm2+eiCpwbRe+fkIUACsICC+PezxYm
	 ndujCWkH2VDc92gUDJfTWFuk72fucWTcARAYIsxhW7CckeUNsKci3yHGCgO/7Q3fXyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V1IfkB/1qH3xlN+J/8ahALY17NG++TRD4vgjh1GRlSU=;
	b=X0jb/73tAaHPIEh64WHj3KRjW+yf7JSOf57tfVE9abBNwkZXXMH6Z9AaHY+C8ov/ybYW
	 2WOa/094A++euoDOuBJZywoaGkV7CBduxLDFafeGKbgxwadobHtu7c7I6CwUPXbqL5Zsb
	 /snzJ2PX8+a2GHsehPbzHunjdkoG0FwhSzT4dx/JcSsVVBV3pxOTe+q3UnvXgE3Uet+5m
	 vqZENsCkVbFBdf0K7OQxKAldMmzQBM1smi2Us1TUkiLC5PUd1Kwishypu/V9bOSSebdBz
	 PaaUtkcgXdA9v7hNFQ8irLcJvoa8Cpsp6aJ+NUxRo+oX/aw4/0dt5NeYiqBIiurUZ0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfiBg3vx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D63A606A31C;
	Wed, 28 Oct 2026 17:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfiBg3vx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7911F01825;
	Wed, 28 Oct 2026 17:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207749;
	bh=V1IfkB/1qH3xlN+J/8ahALY17NG++TRD4vgjh1GRlSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfiBg3vx7elmrUPxo7qWvzxniYGp4pxLNaTFAaVKp66g/kSdRuurLxCmox3UIyn+w
	 dAPxHVa14gEKcA0IvL9JckpC3MMVdUCHEsJH7FOLNaNAi3bhXtaHhjEF5jHizgZO4h
	 6BdSxwFyHd4mHsfYLPrEImspsGjJYCRU76Tmcz90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 124/247] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
Date: Wed, 28 Oct 2026 17:58:47 +0100
Message-ID: <20261028165950.339854580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
@@ -5774,6 +5774,9 @@ static int smb2_get_info_filesystem(stru
 			info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
 			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
 			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
+			info->FileSysIdentifier =
+				cpu_to_le64((u64)(u32)stfs.f_fsid.val[1] << 32 |
+					    (u32)stfs.f_fsid.val[0]);
 			rsp->OutputBufferLength = cpu_to_le32(56);
 			fixed_len = 56;
 		}


