Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775061;
	b=UIFyB0ptAQWLI+w3DKV6MUlhkmqeWeipQ2VTQV9Gui/Wqn4hQYGws7bMYfIYJYzgKuss
	 3Kd4BVbV1MCYJ9G1ClHtL0aSKeJLZEPz/CV0ktOoVRG6JuLikCReG3RpJCGPCJbERDek3
	 G/3WBkhTthkuGUdJ568V0FG29jaioroF4iRyoKRjjDNeWEIAWUUqjd8H/44SSimgfUKuy
	 BrF2APKqrKyX5Zr9Qm3/mV29IS5d8o5/viP5ZdhYNZ3ruSz+UzHu3jYecXX3h/Hi9fNau
	 dnEsWKYbl0qH/Pveti0xQRVwQ8N8YdW1QEOMAq32hA59Nc/+Y/IGcoRYGDgH6bxoRxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C2dnYx9Yln+6vol4B2aZzRwDCSAjsQTczzt+FLx1ong=;
	b=Ytd57/uk3Ywgbq+Eslw6joSwc2ppN35cVXNFLwdJhuNjlDCg4IG4o9zgrahnh4vRNQUk
	 7gikiJg2kCT5hdZpQwLn3oQvr6tv+ZiTWOK2kWF3et7jzDrdtu73Appp1EefDjX+5VfQg
	 HHtzN+5gFpU0wPPqndaJ3CP4/Xqu7taWxPpnJD6wEj0tVBwzh21EglZbAPRfKFUmEXUvs
	 VyWE1la1p/nAja9aSiKSYGRQT6Te2TOWKs9RYmae5ixvgsRWVOL1PzVSGQJePxMqEc15s
	 EzJsYTODEuqHa3YzAWtLCBq8/A5JUe0SJl0G1OJUeTaVbXyyHBqRRSRtNad4wIF8I0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApCthcWi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D96606A31D;
	Fri, 23 Oct 2026 17:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ApCthcWi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31001F01825;
	Fri, 23 Oct 2026 17:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775061;
	bh=C2dnYx9Yln+6vol4B2aZzRwDCSAjsQTczzt+FLx1ong=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApCthcWiYUDq2FSSHCmp9TCKPrm7CuEv3iElaj6VBLUSQlpmjwG+x67TUQYqZQitq
	 BTno/rVixOdSY3hmW4RNNus92PyykiW9caS13HVr2bDvrH4NtDSlychNxvyEawpqau
	 fxv6jy1gQbAE/rshtEakx9pey2wcpJVKwPE3fDoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 217/242] ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION
Date: Fri, 23 Oct 2026 18:40:59 +0200
Message-ID: <20261023163718.944783931@linuxfoundation.org>
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
@@ -6769,6 +6769,7 @@ static int smb2_get_info_filesystem(stru
 		info->FreeSpaceStopFiltering = 0;
 		info->DefaultQuotaThreshold = cpu_to_le64(SMB2_NO_FID);
 		info->DefaultQuotaLimit = cpu_to_le64(SMB2_NO_FID);
+		info->FileSystemControlFlags = 0;
 		info->Padding = 0;
 		rsp->OutputBufferLength = cpu_to_le32(48);
 		fixed_len = 48;


