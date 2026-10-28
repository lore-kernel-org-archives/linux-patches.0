Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211932;
	b=wqd8orhKYALHXEq++rC7p3h1J0ShMHXIec4epWmuL0BzyfwLYTmgiknok1GFUJYunvG2
	 mZK8p6b9h5DiMf6dfBWKh3ZC7vp9BhbggNEperdG1FsAFcu7y+siWiMDP3UeCvglyWpU1
	 RWXipIk5UcmUzyfyswxx7Ug6Dz8fv6H6tmjOGCFWDfdRb8ERtyre3IF8pJqXxvfBvE6A+
	 Vb5XA2nkQtzTyTO6dpC5PyA5+fjnHxa6ZM2rP/10kHhaVfGNO4CRO0LA6/JBimBydP7Qz
	 U+mKmbAEf66vdwBtSRsAQfA2kwjA1oumxZx2dvfFOYiGFNEwOpHj8dE9CA/5xXbeO9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PRs41qjDfSoL9GPKCS57ZxNSnOva1gKaGhWR0lyzju4=;
	b=LRG2aBQNrPrQx7wkbabyBbkgDWBoduoIEID4cEkKOKcaK3JOZLhQPphxVXWftCl2vD4H
	 kHWJfDJGJEPZl6oGgNsg/HKYN42AKN+df+it26Uea0NOkdBAqZI+UKmHx+dC4v1QfAstV
	 ZGZX2tFh2UDBqGtUt+wH33L2ISuBakxqLymUQXyRtCWtc451uUIyKU2HMqIVo2NaXN6R+
	 XhMzqrLrqNIuv9k5Y0u++mdBc1we9bK68qJQj1bAjVQL7RRo+LuwxwPnTv2IpKLR0sQ6y
	 cmMR5+wArIF+5j1PdjNHWlTV7nlemgTC5gElyzH4V+I0L7Dqz6RIf75ARzVY191Bm4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClE2YcAI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B339606A31A;
	Wed, 28 Oct 2026 18:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClE2YcAI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5961F01825;
	Wed, 28 Oct 2026 18:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211932;
	bh=PRs41qjDfSoL9GPKCS57ZxNSnOva1gKaGhWR0lyzju4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClE2YcAIywRnj7BhmtIr2MN+vjuWFGWAFmvUiO9u49RV/ra9uFA9gsfQMjdsr+s2L
	 GPqfTy3P40iHsXhkCL1lz4yp9m+iv+JOyEYAsGnhnx+diMF47TvE78D/GQNZTzOEj5
	 xjFIcbtL5YBRL7wG2xU8RaEIAdUXbxC9IdvDHi0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 550/571] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
Date: Wed, 28 Oct 2026 18:01:37 +0100
Message-ID: <20261028170021.087541111@linuxfoundation.org>
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

[ Upstream commit db2267b27c054a6c2151ff7fbb67927e784f31d6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index cdc1e7fb7cfa1..88ce1b3d0f97d 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5270,6 +5270,9 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 			info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
 			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
 			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
+			info->FileSysIdentifier =
+				cpu_to_le64((u64)(u32)stfs.f_fsid.val[1] << 32 |
+					    (u32)stfs.f_fsid.val[0]);
 			rsp->OutputBufferLength = cpu_to_le32(56);
 		}
 		break;
-- 
2.53.0



