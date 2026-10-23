Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775059;
	b=W74gLfeTnNXqH+ztg1t7sYBG27Wh5MzkRvhwbsbkJYk3bb2CxjehUWV6J3aWcdITWkdC
	 0QU4no6SFQwhoNgXPV9ZVeahytds12D6pmLuj5uNIRYhvzJYMnQpVbS2cZjoCX+dxwC4/
	 B8CcikoIR5r0IFouYdyEdMmQ0e7b5oK0KFR9Zb6JZ297uwBVGuC2vzxLaUjhNvQdUexff
	 q6AOFjCPjNlAtVwo+BuBNIdB/hfbC0mYreRr2CGBQGu9xompHG+2Grf7fxZHg7Pr7zE9x
	 lVNHoRYYdG2Ajutv75Qb1YYmjg8baZr2m7UN2rsCG44XN0dMhGUcFixYF+V1X6UwtPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z4hvC1qR7v57GhfpO8VFSasE81pkI++DBhunhFcPQq0=;
	b=Vqy+X0GIjZRpJzL4In+EUxiJOafUgUsO0CAsfFpl5f2zQZYzJ9QqQc/lVngITySpbnSC
	 Uw8Cp7CAYIebfyOsLwlKEZEh4JxkRG4x42OLi/2xSdJcmwnCDLaTkhjlyzRRoxsjyFTl7
	 Jq2rBhUF4P5PjJK3Ig8cmrTYF+PvHa8GKVc6bST2Eq2KqrBMFoHC71GToIOounGby9fQZ
	 rfr0Ifu3neDeVjKq8bBcmOBMDI4fLufCva7b5TLkn3g/KPjLS7N006kcKW/S5sFCWxuas
	 fd4iAE1e6tdohRoGbwXEU+P6QZCZRciT+5W4q1XJQWmQwE34wrxNyO8xZi6dkHhmc+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RFOey9q2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9607606A31A;
	Fri, 23 Oct 2026 17:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RFOey9q2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CF01F01825;
	Fri, 23 Oct 2026 17:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775058;
	bh=z4hvC1qR7v57GhfpO8VFSasE81pkI++DBhunhFcPQq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFOey9q23VRf4umMCc5zWeiA0nSbxsT6+T/ZyTBdZNM2y9j7WDfmYnqaImJzXcKMD
	 YeIEiAsjcQ9tC5tbrZG/G0audm3spkszAzX1NQb5YcmB/bC8MfbtsigIZ0tIP70am6
	 qa5er5aRCzMsNlGguevBdbpERbvQd/LB+lIA3hyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 216/242] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
Date: Fri, 23 Oct 2026 18:40:58 +0200
Message-ID: <20261023163718.918444838@linuxfoundation.org>
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
@@ -6791,6 +6791,9 @@ static int smb2_get_info_filesystem(stru
 			info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
 			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
 			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
+			info->FileSysIdentifier =
+				cpu_to_le64((u64)(u32)stfs.f_fsid.val[1] << 32 |
+					    (u32)stfs.f_fsid.val[0]);
 			rsp->OutputBufferLength = cpu_to_le32(56);
 			fixed_len = 56;
 		}


