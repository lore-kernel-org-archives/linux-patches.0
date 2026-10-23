Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774199;
	b=S1kZ42433j4yBiKjoviNbvJ8gLMiFZyhu/aJp3WTC2xgaGp8teDeAh7FaIpnLRrLNoW6
	 IEdPQkldH9O8D/NUTxCe84C9ZWon3xpyukFW7nS0TQkV8si4C5A3xOyx6J6MxLVijyU09
	 smKpSSgPCcwwQVbGhech5xKZszcwgEJ5kBlUZSbBrnO+FiLm7jFE1DDMEunUv+dM5r9Js
	 eOpSrOOtkFjFgFiXRjFrsr3DriCx4vHt8zdRKGb1kE3khCNLwLVCpbn+5gbcnsLEg6XYo
	 TQxnk74B5DMGStcxNZRRXO4AoRokS2/2aO7nDnZ/thPQ8sLEkVPYAxX8j5tDXc3UONQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ZytVJIKXTQ7v1FGes5NrbpCzK+v2iIOls8M+EBYCYs=;
	b=z3LNJurlQN/s2AD+IO5XTXP04UQ80uo95GS4yJbedFDnGLNQepQvYEu9TBLRZnPnn32N
	 JToWBDag1DPzjgXVokefFY+zTrlJMEAE2WwnytaAyuGeuwgXxl+NGWpoBvXk2rpJ5ZgDl
	 /u7OJcPEtadcL56UzbRhePVnZkPOCbdHGZs4Sk6BSv5bpMSZhzP6U+9v8QrzfiUHaB/FX
	 o0legd28x+KVVm7gq4EaBRLJLcF0/UmRurNRXm9BW/+INQGRkGInVyP8FCgqP6V9B9vt0
	 Y4i2xKLrrzB6Lp2TalVthRfj+L8XFysIFopRQFdElEjO9IqExq1Ki3Zz/hT8+KRXVnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mahiVPVN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C19606A33B;
	Fri, 23 Oct 2026 16:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mahiVPVN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2402F1F031E2;
	Fri, 23 Oct 2026 16:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774198;
	bh=2ZytVJIKXTQ7v1FGes5NrbpCzK+v2iIOls8M+EBYCYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mahiVPVNTmBQLUspgNrsYbJ4H4jZ8toBS80ScI+qzlxb//9ZZWp3JxZxL9g7508jz
	 J0sFf/Im+E8EnS74K8hug5p5yWCx7dD/ft0qxOasl2p9a8vVeskaB24PxcmviK/KXv
	 5Gi5i0GV545KfBz6PoIu/JXbKtd9OcIq3qFs8txM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Khromov <haa@amicon.ru>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 154/193] ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION
Date: Fri, 23 Oct 2026 18:37:11 +0200
Message-ID: <20261023163717.854794983@linuxfoundation.org>
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
@@ -5788,6 +5788,9 @@ static int smb2_get_info_filesystem(stru
 			info->UserBlocksAvail = cpu_to_le64(stfs.f_bavail);
 			info->TotalFileNodes = cpu_to_le64(stfs.f_files);
 			info->FreeFileNodes = cpu_to_le64(stfs.f_ffree);
+			info->FileSysIdentifier =
+				cpu_to_le64((u64)(u32)stfs.f_fsid.val[1] << 32 |
+					    (u32)stfs.f_fsid.val[0]);
 			rsp->OutputBufferLength = cpu_to_le32(56);
 			fixed_len = 56;
 		}


