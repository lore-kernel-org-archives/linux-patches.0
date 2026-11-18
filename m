Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042244;
	b=BSJm/FW3mxd4+rHD2YP3cUOqSn2lx3kEx3Fc9SdaRctrH7l4I1/rJaDG45D/9Kh8ghUV
	 Z1D9XfDGu8rznScKs/CMqy0OwOX00EJ7fS8OvZAYRxAhfOOsZDyjom5ENO+COqlzSFpm5
	 SGInorUW8vy2axnb0RYmjRKYvigTZyb74V6jNxJtvEuqG7khdzgtLXMTR9h/DM7eqBf8a
	 wGywUrQZG1Yg9ok1wImloEFQq5BJoBFlIwYgu30sM63I2KczEkFzRqumqkZRJUI9BTDBm
	 MRyk4iiEoJ799UtFNtgepQlJKGbeBwb7yUg3Elra+eKjcsuxQ2qgnSLGublg/AL7Qjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZcHUjEWi8BjTmMDSXdTy/v7J++YEpo/TBYnEhMIt82o=;
	b=5pJIPKbTxFSuhj8b1cs3TZ6iKTqdED1Al803H6ACnZi05NDOCkSgiltO3JUd7KDVVtk8
	 KZQPUI8juiQuY+K9bLve87tk31NGq7fL+paVGBrTB5pfx3EgI+OnHgm97C+ZhKhN9mCj6
	 FgQiGMUTX1qPm6bGCRBmYMyz7G1gXGpf2PSj513OuEAySD5WsRvG8aMNQ9+iR6Vk3gbGY
	 GcORI2Td2VK1hpDEQVr1WQh1k5RlnuxHWI30WdLtYRVpTGZO9x1q8TA1qBpMG1ewvclF0
	 0cs4VeKaKPXYcaN4trTKuAyFUH9+jP5NmoqhqrhseoRjjzpHRLL1tHfdnhztEoKApjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kcGszHpK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F93B606A320;
	Wed, 18 Nov 2026 22:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kcGszHpK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817421F000C4;
	Wed, 18 Nov 2026 22:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042244;
	bh=ZcHUjEWi8BjTmMDSXdTy/v7J++YEpo/TBYnEhMIt82o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcGszHpKxYop74XwKhhUGDnpNZOKGSOz2jUZwVV8Bbcnbrd+e8QX8ZmAfAe9F9OXZ
	 zOzgU9XGpr9t/RLjtO3ixZL9OvpYrhvd4ykZH4Trp7uQSzBWoIh46a43INjUBv+pGD
	 IF/aLRffUTVlPqbDQa6zDameQiv2VX2thi/DvlHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3100/3318] ksmbd: reject foreign RPC pipe handles on IPC$ read and write
Date: Wed, 18 Nov 2026 16:02:02 +0100
Message-ID: <20261118150453.006375978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
index 24cc713276ac7..1c96df8000123 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6918,6 +6918,16 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 
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
@@ -7228,6 +7238,16 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
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



