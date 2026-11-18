Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050320;
	b=BOvAf2sKfh7qG/odcUKXPNh6TcsWFFf76ELYaAG3A3yUe0cPPiiw/qp1vCxf184R50HC
	 8x1+q5bLJKzPRFmy3jgmbGaaCRbZz735Io3qcOYYfuOtPsJZuvF3LEIoWAmzSrSS/M9V7
	 iRQUWTEKbCHN59mEHn1wG06zoYKG7v1nOyXo8Q+qRZhJDluAtpwe8prmst2MvaETJH/b+
	 l0rMxwK5/g7I50esucw+ogecQ4J6M09HFs6ABBzcUJkuo/sr//1RszmkSX6Fsk4tdKyUX
	 ypOYBuaoqn6S1ILs+LuZDNefd74RfH9QL122crsPoVkwgfWw0wTBpwAamtF7qKXak/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sJySJXKkn9Njurt2XK7qEeVNh7L5d/ps0XtNMOL5zGM=;
	b=vprvU3l5QXnFr1FiKPoCiJesM8yxgD6ToftyZ4qb26z2I7PaaSY4deX055NepJF6SM0U
	 3wJnzV8Iouit8dOjemFlpWBd88FXdUx2QN885dLrJJLl2cEAfuVDkVWZJUzQWSP7gwHer
	 1bOfs0A6jxq3yqVWWqxCpEtpw34mI1CXLyrmHdaj7a/lrv9cFmx/4NfzGdBCOfTgDzfnc
	 KM7VPoUmOeuI7jrCaCoSBTRIOLr9ep1WSosj7Jprr4BKaxhcExPZYmPM1XyQatYLuEOYj
	 XFh8Kk/bwyHi0sGWRt76dkKfYi2TO9gZHnsdi+L1tMNKk426ZzC/mLWjRjA6GWYYCTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5bDCWN4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D3F606A32F;
	Thu, 19 Nov 2026 01:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5bDCWN4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A241F000C5;
	Thu, 19 Nov 2026 01:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050319;
	bh=sJySJXKkn9Njurt2XK7qEeVNh7L5d/ps0XtNMOL5zGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5bDCWN4Pi5Q6Ae5dyWae0O17iFlmbVX2GLlme9klbjlx64ZP5ovJXFkqBK90yxDi
	 iQOTQM3V3pKY9VN1IrIRWVUpfV/Wu5BhDKa/Uh6qZeIKDYaF+nE2/d7y8O0cOyyNdg
	 e2q6lJkqu09QfYQBuWAub/55b56N8vGvlpann46Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammed Alquraini <mohammed.saad.alquraini@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2664/2857] ksmbd: reject foreign RPC pipe handles on IPC$ read and write
Date: Wed, 18 Nov 2026 16:01:38 +0100
Message-ID: <20261118150337.498468170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 7a54dc3bf0165..8956e548b7f70 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6463,6 +6463,16 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 
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
@@ -6773,6 +6783,16 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
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



