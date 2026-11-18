Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021413;
	b=g59uSXBXxNLHh1iceyf4fjGLmsEZitAvV247F5V01m9QweeHASt7FpVvwbhL6nPUBTTu
	 2W85gbERhFrurbJPTJUes+ix0q/byNC/56eTmQ/UpcnXR7V7Li6eLQE4yhmAGj82x76Aq
	 VPSeZ3VWjA129jYk+vmPpuFVGd51yG7Fs1E+mLJmM1FBkj6unXsqBL4dzYh2mDdMbAOWG
	 ZiaYWrFwwIQ0mYKAnkcEWMO08CIiLMVivBPBrw2MZ7Z6vDINfH2UuBcsPr4y2vhq2Z+T0
	 4ZVSCEWzyKjFsQ9e6qiJ1/We0kdhmRm4kpWHm5/aiAI64DxPFIJv6JWi2Tzd6IsB8UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bnn6i8bA/dEWNya5FQLe0BXGMb1NxciG/OoglV8I7QQ=;
	b=bZL2PxGElhsbvUBu6IZjVfDlCBZuVsffFnF6aiSsuhwd5PIUUZKim3oLPfmmd/EtD7iA
	 2rlUt8VpJIIoym93WQaGsfsWhb/EEvF4zZkB9bTFRpruglaYoLXwEWxVOFQNRor4E/Fou
	 ob3DUyuCKD7qbA1z+Gl5dfb4VqzaYPhnpbJmOcZLfcAdaAZdr7WerVGUoDmjoaY3Wq7Wf
	 0EOOP/EUFL4kJlttKPu33gW0gZAw0aP6DIhAfiNzJDRaQE/Y8rDb/gGGLVFuXO8TJNCk7
	 cQwgsrp2Ry+3gVjzjPNhIkmi0zi+oyV3sUrkggft09djuNA8q0V9n3t3WzLkEOYV7nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VUqRVb26;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C83C606A31C;
	Wed, 18 Nov 2026 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VUqRVb26
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F101F000C4;
	Wed, 18 Nov 2026 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021413;
	bh=bnn6i8bA/dEWNya5FQLe0BXGMb1NxciG/OoglV8I7QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUqRVb26sB8vTwbF2Ha5QIV8bxGQYZ290rnlYwu0n1CbWvhCYDAsvw6hrWltspJmo
	 tUm5NxTJOHRkQyIc9AqdJ/rV8GBmTtk0ol26+2u4iB0K31d9BoBG8p5fjRwyOfNbTb
	 m9iQY/Fp/oKfJvxQYDf6maFT09MX0YyhTOTlMMbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2298/2651] ksmbd: reject foreign RPC pipe handles on IPC$ read and write
Date: Wed, 18 Nov 2026 15:58:58 +0100
Message-ID: <20261118150407.960220530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>

[ Upstream commit da25995071e5e0f3aa9a41160b00b2f833127b3e ]

RPC pipe handles on IPC$ are allocated from a single server-global IDA,
and ksmbd.mountd looks a pipe up by handle alone, with no session
information.  smb2_read_pipe() and smb2_write_pipe() take the handle
straight from the client request (VolatileFileId) and pass it to the
daemon without checking that the requesting session opened it.  An
authenticated user can therefore issue an SMB2 READ or WRITE on IPC$
with another session's handle and receive that session's in-flight
DCERPC response, or write attacker-chosen bytes into its pipe stream.
A tree connect to IPC$, which every RPC client already has, is the only
requirement.

Validate ownership before the transfer, the way the sibling pipe paths
already do: under sess->rpc_lock, ksmbd_session_rpc_method() returns 0
for a handle the session did not open.  smb2_get_info_file_pipe() and
the FSCTL_PIPE_TRANSCEIVE ioctl already reject such handles; read and
write were the remaining gap.  Reject them with STATUS_FILE_CLOSED, as
the ioctl path does.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Assisted-by: LLM
Signed-off-by: Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 81c8bc5033cdf..8bd0800a48f7e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8949,6 +8949,16 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 
 	id = req->VolatileFileId;
 
+	lockdep_assert_not_held(&work->sess->rpc_lock);
+	down_read(&work->sess->rpc_lock);
+	if (!ksmbd_session_rpc_method(work->sess, id)) {
+		up_read(&work->sess->rpc_lock);
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		smb2_set_err_rsp(work);
+		return -ENOENT;
+	}
+	up_read(&work->sess->rpc_lock);
+
 	rpc_resp = ksmbd_rpc_read(work->sess, id);
 	if (rpc_resp) {
 		void *aux_payload_buf;
@@ -9579,6 +9589,16 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 		goto out;
 	}
 
+	lockdep_assert_not_held(&work->sess->rpc_lock);
+	down_read(&work->sess->rpc_lock);
+	if (!ksmbd_session_rpc_method(work->sess, id)) {
+		up_read(&work->sess->rpc_lock);
+		rsp->hdr.Status = STATUS_FILE_CLOSED;
+		smb2_set_err_rsp(work);
+		return -ENOENT;
+	}
+	up_read(&work->sess->rpc_lock);
+
 	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
 			   data_offset);
 
-- 
2.53.0



