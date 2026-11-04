Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830927;
	b=eLR8ZFnpty5Jfy6xiV2sSNh6vKj18KVOsbXd47S0strz1YAtm81nelHMM+ZJOSa3So95
	 xJ6p4iSxayQMXTdVseQ7EODxOf6NpF2iN7BzdwC/5kHyXPQV0ZxfjvVRQsEEkljI+XgRU
	 Gw4BQzKTcWYJYu4mXrjafa9yWbuBAUheJmA/Me0/yvPYq4VDbjt6vJH/7GYp8H/G085yQ
	 342OId7XcEeSXhnJHOo5NBjgflQtgD3SXRsjVBR4L/IQ+7Q3cqLDL7aFESxXBJPDsW8Ll
	 qX8LvKp1liysZZgkzqL1XBtBSCnsYLrETz+QvApn2gFbQ0mOLafiIgvJw9lRKkMz+/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nx8zxQigrCsKZsqVJB8tqbe7aV2YW9Gsj/g47LTue5E=;
	b=2ELGHDSjM4wYXEKTtvTyErcEzBbQJcWhhwRNkLnSW1gtzZTmTof2YHr1IvEcS+3aEZ9F
	 MsorEIq0dZioLeMJu1yHeWXbUycGRQmKr147Q9FWYUfDopQSs5T0hoKQX1JKG1PM2DxuI
	 OJCDd+Q1NzjYs8+W82QpdQSre71+sxcneD6JQ1BtcFiyJFzreokavem47zjn9vlN+JnhZ
	 3f5pSJpZ/zImQ9JFkgGHphT9UFlV1FjxApbEV1T3pBhAcN7hiIem9swRue18Gi9vg8rD8
	 ulb4+6yVOqEQAGE4GSw/kETyHzNh4TqdfJZ/2n0WAQrsuevB8nIyHJCRXDVcvQOHOjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RyZWjvsq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C257606A33B;
	Wed,  4 Nov 2026 22:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RyZWjvsq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119221F00A02;
	Wed,  4 Nov 2026 22:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830927;
	bh=nx8zxQigrCsKZsqVJB8tqbe7aV2YW9Gsj/g47LTue5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyZWjvsqKxP/wqBjqoapji9nIcJdI6zXe6AEGarPWjEvvrygqOhLymoFifA00nAxa
	 xVO5pMGVEvpJADMi0yavN/BC0IpiH4R3uFhQpoO5vudHfHOsuuEEpb+xDsw8UCjHq8
	 5o1+unmSHuMLXHH46f5X/9MrVXOcqV0O/KbhO9Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0407/1005] ksmbd: reject SMB3.1.1 binding with mismatched cipher
Date: Wed,  4 Nov 2026 16:02:20 -0500
Message-ID: <20261104211055.477906721@linuxfoundation.org>
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

[ Upstream commit 7019a11f79dc408f2b47b1027240e7f198784c9a ]

SMB3.1.1 multichannel connections belonging to the same session must use
the same negotiated encryption cipher.

ksmbd validates the dialect and client GUID during session binding, but
does not compare the cipher negotiated by the new connection with the
cipher used by the existing session channels. This allows a channel
negotiated with AES-128-CCM to bind to a session using AES-128-GCM.

Compare the new connection's cipher with an existing session channel and
return STATUS_INVALID_PARAMETER when they differ.

This fixes smb2.session.bind_negative_smb3encGtoCs.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a5f9876182313..eec5cb16bfe53 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1747,6 +1747,21 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
+		if (conn->dialect == SMB311_PROT_ID) {
+			struct channel *chann;
+			unsigned long index;
+
+			down_read(&sess->chann_lock);
+			xa_for_each(&sess->ksmbd_chann_list, index, chann) {
+				if (conn->cipher_type != chann->conn->cipher_type)
+					rc = -EINVAL;
+				break;
+			}
+			up_read(&sess->chann_lock);
+			if (rc)
+				goto out_err;
+		}
+
 		if (!(req->hdr.Flags & SMB2_FLAGS_SIGNED)) {
 			rc = -EINVAL;
 			goto out_err;
-- 
2.53.0



