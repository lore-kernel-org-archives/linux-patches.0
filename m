Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208489;
	b=PA9MLvGHyJdM4C7rxbXLMx0aoEAtgIwP7VT+eAJUsTuMxs0HMmHYNXjaOq7e0OMOgydI
	 IFssdLIC+ff6mTe/2jZ/0naqK3tOm24yw46tSYvosNVqRBGPemTRRD4OP6AIKC2Wfq7Ay
	 9S8kkaz3XPtTtl3LmrOZPDFcFeZ4glJMTi8aQ1eorCYbXl+Xw3wdWM3YGPmnzIWzEmUqr
	 vwz9Cxuy9y1+sqhX46gWv6KGwZiSE2gJI5aN+c8VmyGj9EgCXDacygCLlorJ3b5qzSSqa
	 +HoftNZGEe+SpVaD3IlIvxVR8ALO/d+v2QjsU+eucYQdFArIMt+LoXki9AgUL7WF/mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3wE15ETjKmAgJblepBgwaaoiL1cPtOFUFAZ4PE6K0Bc=;
	b=UHUezyeRbXBocRSkGpp59VSKNLuAedAZNK1B+sxSrEijFq2cUg69Z6mPOgDFNdTFvjm4
	 rU/imwGX8Qf9q6wyAMTFoK/VL8b8R52hg5tlKCvMGEksLo0IWuyIDGB/v8QA7om+zDzCR
	 dC7SK3+yMDXyg2II1pofDkML2CwyaXGY/aN3FqTJUDC3Zz5V+w9n/BoxtV1i1dN1wgqh5
	 tyy8fvhletDd3UNpPMrMl+xaPWdBrWbgV1e1UPEACMruFg8EDQaaSyOy9yAFVmc1A9O5A
	 u4DNemuWvC1k7IyDfCv/Op3FpiR41oUXupKqcVtsJnbQF6svuVMmvJfm8MRDNJTA1gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=poIaUkMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BFB606A31A;
	Wed, 28 Oct 2026 17:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=poIaUkMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B801F01825;
	Wed, 28 Oct 2026 17:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208488;
	bh=3wE15ETjKmAgJblepBgwaaoiL1cPtOFUFAZ4PE6K0Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=poIaUkMvQgIlTDpp8YG0LBcRcYzJZVYMg0gxB493en9U+Eqpa4RvdxGDgdwuZyr+l
	 jplk1bwG8OfP3dUzk6MFn4jpM8tpBQDsdlY0swN2u07JAMbdv+4w58el1XV0FaW1oJ
	 qFUjjkemsw4euOdNs330EOxt2POUJ3i6dXZ5FZH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/516] smb/client: pass cifs_open_info_data to SMB2_open()
Date: Wed, 28 Oct 2026 17:54:47 +0100
Message-ID: <20261028170006.709263810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 1f551e407bb49dce0bbd34ed6a499dad69e18020 ]

Let SMB2_open() fill the smb2_file_all_info embedded in cifs_open_info_data
directly. This removes the temporary smb2_file_all_info copy in
smb2_open_file().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>

[5.10 dependency adaptation]
This tree still uses fs/cifs and does not define cifs_open_info_data.
Keep the existing SMB2_open() argument type and the FILE_ALL_INFO
conversion in smb2_open_file(); drop the wrapper-type and caller changes.
Use the dependency's file_info pointer directly on the existing buffer
inside SMB2_open(), preserving the stable metadata-copy behavior.

Move the existing open_done trace after smb2_parse_contexts(), retaining
its six-argument stable signature. Together with the file_info argument,
this allows 566820af017e ("smb: client: close handle after create-context
parsing failure") to cherry-pick cleanly across the directory rename.
No functions are added, and the target's close-on-error fix remains for
the target commit.

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
 fs/cifs/smb2pdu.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 3c0c5e1cacbfc..56d24ae83d779 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2902,6 +2902,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	int resp_buftype = CIFS_NO_BUFFER;
 	int rc = 0;
 	int flags = 0;
+	struct smb2_file_all_info *file_info = buf;
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
@@ -2944,10 +2945,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
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
@@ -2957,18 +2955,21 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	if (buf) {
-		memcpy(buf, &rsp->CreationTime, 32);
-		buf->AllocationSize = rsp->AllocationSize;
-		buf->EndOfFile = rsp->EndofFile;
-		buf->Attributes = rsp->FileAttributes;
-		buf->NumberOfLinks = cpu_to_le32(1);
-		buf->DeletePending = 0;
+	if (file_info) {
+		memcpy(file_info, &rsp->CreationTime, 32);
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



