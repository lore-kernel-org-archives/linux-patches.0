Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210130;
	b=xexA7a3hPPb7eBC4+zIdNHlbeTCm0PnNBsPwJR2D1OjXS7G0AeZtdE3oEeQ0g0gk2Zi4
	 WR0eTILHAmAaDw8bePAfP5VHr66GtSYIsYBoHpmG+cGpnQpEDoeXrwO2QhcWh8FtKE38t
	 XEe1SAsDEdAVdojHpKtc4CFd31Axl/f0xZ/jk6OQRaQ/Dvzq7HHMjLJpuaWrkg+CPkUyF
	 3EBIL7X7B5OyMpNNFgLrMA7gMNoFkOFY5ZdLXOKLPf4sup8eP/w5+XxMJ2kuI2bILEdHc
	 pcmf0OmCy7lr8au40YRxLJIP8DGbI/lG6iArUae06trWRNybmjI6uMWOHM8IlRE7poQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aE2x+bApNZvOFp6BhCnujGG5oo+/C1VU4fOmkBVJG78=;
	b=App7LseV72uvHQQbpCJrnmMwA9RmRSaht0iKNOs1QeprEn5wKT+4ayTwfAtdVYEojjeG
	 lzVPblpjIBeilDCEYq76cv2UJK+EsY7+9dTt/lPsvcFuEkJagqKFz7gnc9Ce9wAfJrjzM
	 hDPo6JsdFWMDCLuEj0UCiUcG+lxWxyl93Brr+EaZiNmytriUYixUKMnMviAmEe/cS8BeE
	 9oDxrYVJ3ewDBoVMuvTaxFac7IxmQxYdIs7QkdhLZg4HA/6i8Zc0GgCWfLFCV+6H71wHF
	 /40CpkPAXTeF8Qtaw+ifnqy3O4/BCFiTuy5UDtBpjdjC3pkqYeixkQEYHa/fUJs2Tyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xUuqDAB/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98827606A31A;
	Wed, 28 Oct 2026 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUuqDAB/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C131F01825;
	Wed, 28 Oct 2026 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210130;
	bh=aE2x+bApNZvOFp6BhCnujGG5oo+/C1VU4fOmkBVJG78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUuqDAB/hJ9XSXU+VLk2+1RNtqfKej8q/2aDLN/ZYEsUEHyonA/uw67BpDcPuKHUQ
	 s52We9gMrJ945UJTn4xssV2Fh8lUG7ko8+lfAXnwuYXgThzd2fgL3s6qc7x3O6Ptyk
	 gyPNVRmikNPvfL6d1fXaLNbKKXj/wXLVfCTM9BDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 086/168] ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION
Date: Wed, 28 Oct 2026 18:00:22 +0100
Message-ID: <20261028165945.124802468@linuxfoundation.org>
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

commit c0cd3fc6824122014da2b3b0cb7ddeaa2946ec8e upstream.

smb2_get_info_filesystem() reports 48 bytes for FS_CONTROL_INFORMATION,
that is the whole of struct smb2_fs_control_info, but never assigns
FileSystemControlFlags.  Those four bytes go to the client as they are
found in the response buffer.

The buffer is zeroed on allocation, so a standalone request leaks
nothing.  A compound request can leak: the offset of the next response
is advanced by the length pinned for the previous one, so a reply that
was written into the buffer and then dropped in favour of the short
error response of smb2_set_err_rsp() stays there, and the next reply is
laid over it with only the header cleared.

ksmbd does not implement quota tracking, so report no control flags.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5739,6 +5739,7 @@ static int smb2_get_info_filesystem(stru
 		info->FreeSpaceStopFiltering = 0;
 		info->DefaultQuotaThreshold = cpu_to_le64(SMB2_NO_FID);
 		info->DefaultQuotaLimit = cpu_to_le64(SMB2_NO_FID);
+		info->FileSystemControlFlags = 0;
 		info->Padding = 0;
 		rsp->OutputBufferLength = cpu_to_le32(48);
 		fixed_len = 48;


