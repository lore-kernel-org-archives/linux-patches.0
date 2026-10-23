Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774202;
	b=E1YH7HAC1F2eoHVaSJH/nZDJcrxfaEbv0IQwEufc0UPpV4/CLRcTP1Kz3rwWXOLOPRlL
	 kKw3zTJAYk+HdVYO9v6d6rK648njDixL3WSTgsExQ+NSYQtw4ox2FKA8J7ORcJ6j5s2NT
	 QZ5981vsiW7bNWuzOBOmlagUx5elDPB0UQI3NTGoqCFfgZ4yElhVEOks/4Wf0w6QB63z2
	 unmzTmIrYbsr42rrcqM3q39BinddWshRjjMVd3AF/0Jv8bfdpiZd9HZ0IECMP92Glza7o
	 ACou834s1xZN6OzRCvmB0LJkfnh0r6fzBH1kSCr/EnBNWzRgSKuf8xKE28eQN0sz8nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1tG5zVtPhGkhbioZ2LzzsS/s3Da+dqUbo56ULbJyBME=;
	b=2iclU1sZh4eOUSVS1g61kH/S4LydVuQwrlItD9BmOhneN8Aaw6+eBrKjk7oVJupREp9u
	 D5pMzmgRIpSGRCzVulCIdqD6ftX+gDlWl4wNae0a5bbXsgb/IXdk8hGUHpfEESMJtN0WF
	 m2G5absZjny9DRVKvPoabm3iy0tcF+LJEQCo4US5DU12gsSSFcx1mWSf0K62FEwCDhH0K
	 lMeTvwSLdlkZvMGy4lbEg1JVJX/VX67TTfbUYoj37JhCNuw+Z8gXDuJBE3h/zgeF01ppT
	 24im+V/wChVYnZ1B0AQitKgSdi3H8pCuyNX0sfvif0CCPxhbSknXzZ2lj9ZF8q75/qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gelka5NC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E540360A3812;
	Fri, 23 Oct 2026 16:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gelka5NC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3438A1F01825;
	Fri, 23 Oct 2026 16:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774201;
	bh=1tG5zVtPhGkhbioZ2LzzsS/s3Da+dqUbo56ULbJyBME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gelka5NCrvhcdk3d9KVYt4oHadXewkytBSe2h90ONtGWpnGrH1F0mJCwLd/q9ei3M
	 LpZY1P/yPDh4Gr5PzkpjbrF1j1HGjN+ihaQcwbxQsSCRBlvbbKAfG9vx7KVM66U18A
	 cSOrbbUoq1ZXbkIDwv4/sIkSYNOJMDPLXtSWdW0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 155/193] ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION
Date: Fri, 23 Oct 2026 18:37:12 +0200
Message-ID: <20261023163717.877105563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
@@ -5766,6 +5766,7 @@ static int smb2_get_info_filesystem(stru
 		info->FreeSpaceStopFiltering = 0;
 		info->DefaultQuotaThreshold = cpu_to_le64(SMB2_NO_FID);
 		info->DefaultQuotaLimit = cpu_to_le64(SMB2_NO_FID);
+		info->FileSystemControlFlags = 0;
 		info->Padding = 0;
 		rsp->OutputBufferLength = cpu_to_le32(48);
 		fixed_len = 48;


