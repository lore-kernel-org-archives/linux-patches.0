Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830932;
	b=k2rO4pgclCjnVhzBbpv9taSobX2iYtrACD88cAKjK4JVXkPZ3jH6J0cFaJe/yVqtISFa
	 gZd9RcKywgzKxjVTQmKJNaKQ0kQvfAkdiX5tffAe0KiU6syvRytNBfv/yK9a93O1+o0gm
	 ZZPYlsBWUC9Eu0F5MQv5A7p+DNSAzSe0K1JFbBNScci0ZLTSOhqsfGioUU5S+bUSPwU8e
	 eIOeK4DPCgCXAJ00Uw6XDD4hU/hGYi6HX2ku9SJ2uxB/XashGI3TSiG/gi6B/V3lGWhB6
	 QJDJ4xDwzX8abHEKPCDUI87GjKQbwU0HOcs32RuFDB3NvSSvFaliPJjUQNlYvPA/8PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qLSkPsag8TRQuC0d93gdf2P12j6NNldC9Qsqvq46X80=;
	b=hcb/hCMI+yvz8qPpdo3YRqilI9R+tg/t0wHJkfj7rmhnWu6n5Z3oQtB2MRYlvfcNPPbn
	 qRWgf7Sxj9Cu85khFQoBseTNJSNDzpDated3mTGY6sC3puPV8pNnGD6V/cw63Vnl2VBdb
	 iaes/WNflI3x/JrBAA5eb+ItL3U6BocQD7Fu12g4aXe34iDxV8OOYRamotCcZFtdxqwvW
	 4xQv5tboK7ZdgrWv9HpObnugmJ6kXSopyyUEi32OkpNa+XN+1eUNmgt4yxsIdjv9aR9fJ
	 zAmm2UYNokcI5zffhx7fW45uEoX75XmrjaXVTd0jwqZDv2OfQcemELT1yDgHSZ4K6lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sl5KqRwQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A785606A850;
	Wed,  4 Nov 2026 22:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sl5KqRwQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1E61F000C1;
	Wed,  4 Nov 2026 22:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830932;
	bh=qLSkPsag8TRQuC0d93gdf2P12j6NNldC9Qsqvq46X80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sl5KqRwQDQJukfvTS5mz8kwi517DYtENp/RtGkc56HUTSc/mCpNNLe/1RuH+JqVV7
	 tI7pTgk5LjsGWuIHK5owmZ1elv9vxH2O5mHlC7UJ9CLFpb6s2bEDBW1+w3Qxbr7Lrb
	 9szrkHb8iC1JKWh4AkQN/FJXGft2ErQWcmFCtDmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0409/1005] ksmbd: return buffer too small for short security queries
Date: Wed,  4 Nov 2026 16:02:22 -0500
Message-ID: <20261104211055.534047366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 2103add92a02505bdd536ba6fce7f64a427222a2 ]

SMB2 QUERY_INFO security requests with an output buffer too small for
the self-relative security descriptor header can fall through descriptor
construction and be reported as STATUS_INVALID_INFO_CLASS.

After validating the file handle, reject buffers shorter than struct
smb_ntsd with STATUS_BUFFER_TOO_SMALL before building the descriptor.

This fixes smb2.getinfo.qsec_buffercheck.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b17296c7b64ee..0de707a77faa0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5907,6 +5907,12 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	if (!fp)
 		return -ENOENT;
 
+	if (le32_to_cpu(req->OutputBufferLength) < sizeof(struct smb_ntsd)) {
+		rsp->hdr.Status = STATUS_BUFFER_TOO_SMALL;
+		ksmbd_fd_put(work, fp);
+		return -ENOSPC;
+	}
+
 	idmap = file_mnt_idmap(fp->filp);
 	inode = file_inode(fp->filp);
 	ksmbd_acls_fattr(&fattr, idmap, inode);
-- 
2.53.0



