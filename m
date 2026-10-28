Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210843;
	b=ruGFZAEyhb5w/5K8PqVVH8TkoMmE3VHTzefUz2tO4xPR5e6yJJA7TyfDY64qL1cHys0k
	 KsCW1PjvwAIIjHTu/t4h5shVPHXNEPNAIhnzqrCX1jhmds//0MSl8Lyhb2M2xMwiAPtt7
	 +CyoueR5veKk89R6hiCqCoQh/aEEzHk/D9TYZcFTlw07izin4OEbu/wAydD69Ordg/MhK
	 sqQjjJKjxSy9qrQ3xNHjTDLxqokRD5fw8AKbcL7kI8Odi6sYaVJEQJXVkPUnJWj82Y26B
	 HbayYL3+zqPJ8tbka4mZLDxx374WdosDcWTbNmItkKDNtTuF1SLnMhx5dsCihWjEgqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6p46i9P9hpwIeJ0dYgf4cB0tBtYTOnW01GoFp6+cXOU=;
	b=WfAJVEmpzid+avZo0sgia9+6tR956u+mHoOHsNMtp/9op37Zr2OTvg+N9rWjC2hWyyX7
	 wb8VKgeITUzRBbKvhfaLMBjJO9EvVLB5eITSK64LCVkpjAMz3BvmwIFrY0yBFAYCvH9pI
	 8H29pnoi/rpCX9ojAdnIUIg2v13gqFAgdGyo55cUGTZE+TUtojW5glAeUxiS1iWFLWp/6
	 Az0WjrwOi22zY6PNF/HjvSCwih9uZAx2P1w9yeWtkmWSl5Ndh9JYakFmQ39YEW9Sj6afj
	 Ecx6pldXcBIXe3EEOwqVjQ2jvurkaKH6aCgHH5tnlHltjAXcKbQT+SRs1MqSDXgi+PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9Ud9tDh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA872606A324;
	Wed, 28 Oct 2026 18:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R9Ud9tDh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169FB1F01825;
	Wed, 28 Oct 2026 18:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210842;
	bh=6p46i9P9hpwIeJ0dYgf4cB0tBtYTOnW01GoFp6+cXOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9Ud9tDhnQNmxuDS9NT3J3dK1ty9orIYqZcSldteMUnT8qKInwvzfeEfPNFmbY42r
	 oaXP2H69zg4Dhei1OvZBngPwMD0aN3eV9v2RhW11PQzNdWQ2hRhW+hdZCq6kp1H5pG
	 RiaLeD7+psloVQTbEqobNh5AHYGJjKL+VVZqr6aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/571] smb/client: pass cifs_open_info_data to SMB2_open()
Date: Wed, 28 Oct 2026 17:54:38 +0100
Message-ID: <20261028170011.126747102@linuxfoundation.org>
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

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 1f551e407bb49dce0bbd34ed6a499dad69e18020 ]

Let SMB2_open() fill the smb2_file_all_info embedded in cifs_open_info_data
directly. This removes the temporary smb2_file_all_info copy in
smb2_open_file().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>

[5.15 dependency adaptation]
The cifs_open_info_data wrapper is absent from this stable tree. Keep the
existing SMB2_open() argument type and callers, and use the file_info
alias directly for the supplied smb2_file_all_info buffer. Drop the
upstream caller and prototype changes instead of importing newer open
and symlink handling APIs into fs/cifs.

Move the existing success trace after smb2_parse_contexts(), retaining
the six-argument trace interface in 5.15. Together with the file_info
alias, this provides the merge context needed by 566820af017e ("smb:
client: close handle after create-context parsing failure"). No functions
are added, and the handle-close fix remains in the target commit.

[ sashal: Reduced backport -- upstream 1f551e407bb49 touches 4 file(s), this
  backport carries 1. Not backported here:
  fs/smb/client/link.c
  fs/smb/client/smb2file.c
  fs/smb/client/smb2pdu.c
  fs/smb/client/smb2proto.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 566820af017e ("smb: client: close handle after create-context parsing failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2pdu.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 11fe130a30cbe..8ed13e21a8480 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2966,6 +2966,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
+	struct smb2_file_all_info *file_info = buf;
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
@@ -3008,10 +3009,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			tcon->need_reconnect = true;
 		}
 		goto creat_exit;
-	} else
-		trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid,
-				     ses->Suid, oparms->create_options,
-				     oparms->desired_access);
+	}
 
 	atomic_inc(&tcon->num_remote_opens);
 	oparms->fid->persistent_fid = rsp->PersistentFileId;
@@ -3021,21 +3019,24 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	if (buf) {
-		buf->CreationTime = rsp->CreationTime;
-		buf->LastAccessTime = rsp->LastAccessTime;
-		buf->LastWriteTime = rsp->LastWriteTime;
-		buf->ChangeTime = rsp->ChangeTime;
-		buf->AllocationSize = rsp->AllocationSize;
-		buf->EndOfFile = rsp->EndofFile;
-		buf->Attributes = rsp->FileAttributes;
-		buf->NumberOfLinks = cpu_to_le32(1);
-		buf->DeletePending = 0;
+	if (file_info) {
+		file_info->CreationTime = rsp->CreationTime;
+		file_info->LastAccessTime = rsp->LastAccessTime;
+		file_info->LastWriteTime = rsp->LastWriteTime;
+		file_info->ChangeTime = rsp->ChangeTime;
+		file_info->AllocationSize = rsp->AllocationSize;
+		file_info->EndOfFile = rsp->EndofFile;
+		file_info->Attributes = rsp->FileAttributes;
+		file_info->NumberOfLinks = cpu_to_le32(1);
+		file_info->DeletePending = 0;
 	}
 
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
-				 oparms->fid->lease_key, oplock, buf, posix);
+				 oparms->fid->lease_key, oplock, file_info, posix);
+
+	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
+			     oparms->create_options, oparms->desired_access);
 creat_exit:
 	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
-- 
2.53.0



