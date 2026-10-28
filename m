Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217054;
	b=eQNZzxNvaMPvakbByFjegkhiFM/onRpxgT8JsOtw71X4cJ7wblV234/oeG6Xyd8ANEkc
	 l8OoSdxAJ4tbXntsuq36d20PCYqszYfKl1lhhZKkFgGK3Ky3wQPYwUewbgh56JDivpxQJ
	 boah61+9OJ2PCgEcrr1nnOMIMq5kFEZT+gZNTn1KI4oFesyBaKa6f050tC8DGTmeHf9Lf
	 VDhpVhpdan6LFi6MNMkTLZotDPEBpWTXHzzC1JBMRl69VgrrLPQ8E8JB4xmq+elBFSN1+
	 3KhLTOYzkg2IzFmCMpHP+Jn16HvzbF5r3wiZwa69HvBAJSFh/7vKGYftei08w64+4cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3SEYIrxCJ+s8uRjAQet3royIRN7gXTH/W3RK6c6JeVU=;
	b=JpSV/Zc60OWXyOjJIxX87NyywfHumxvat+gYXhyLQCuxq8S1a2XgAf1VTPBy282+aYEq
	 NGmYcHm/XuCCPuAxtlsnlP4UQ0ninS/CJTLyKtYTyxS47xLxXXTVwY8v63H02zP3Zl8wm
	 f+f3zU72y3iQghYF8nF7EzDlmiA67T4B92Qk7zOxfKgev3qRShd0MzR9Em6y6B/B6/sbc
	 cI5k3petffn404Dnb9ZCGkzCAp1yHxqulyHrl+OFQpr9NA+OhNEC9ghTk0MwlyqMI8Kir
	 xHsgrBgLItc5pHHFuuyRVxZDyF5VAD1x5na3h5JXRtPF2/wf6CZsp690hS6BvuSzZaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qbPwuIKo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3218C606A322;
	Wed, 28 Oct 2026 19:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qbPwuIKo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819211F01825;
	Wed, 28 Oct 2026 19:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217054;
	bh=3SEYIrxCJ+s8uRjAQet3royIRN7gXTH/W3RK6c6JeVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qbPwuIKo5Lh6RcqsIY47mmWrmtDxSbu5TCWoaqjYV9HM2TC6drUIGBn9etmZZYkd+
	 PP1mqEpCebv5+cKTpAEU8RgZ93YrN43NVux8m0Ea0q1Q+mRhkapEpG+OpQ8qgNZOdK
	 syoxPFfdhZRgjWdQzq2ntlY46r21DX15Nmw7RTuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 1771/1887] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
Date: Wed, 28 Oct 2026 18:04:27 +0100
Message-ID: <20261028170539.755952888@linuxfoundation.org>
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
@@ -5342,6 +5342,9 @@ static int smb2_get_info_filesystem(stru
 			info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
 			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
 			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
+			info->FileSysIdentifier =
+				cpu_to_le64((u64)(u32)stfs.f_fsid.val[1] << 32 |
+					    (u32)stfs.f_fsid.val[0]);
 			rsp->OutputBufferLength = cpu_to_le32(56);
 		}
 		break;


