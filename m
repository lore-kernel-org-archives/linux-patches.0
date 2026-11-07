Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060997;
	b=BfkOAFkGew2UW6XpEd19pKTI5m7nMkc3SImvUMycYlpeJ6Sx6rybNJOkvObnqIRUfN1p
	 MPGqa83TEjsQ2q7qb2ORPpvgTjO2vV/YAXqju8rPN9XI8G92iDEmMXD9c0EZ7BYmBGGCc
	 v5y7wDrP2CVBYmnO9sw2STWhPUg8rItft2yy0MVwPB5t5NEjlTQwcQIScpTsO806w2FUW
	 rBMBeZow3/4iDaqaRsWhecAIKtuTp+tkyi0k1Lc1YvTVJLRBt6CQlnJkP4WhuRZdBUCop
	 gb6dleoegymy8sNOhKq1sHz6VszUYoZzVO16NuKzsqoNKty56cO0nKkPGXlQxnrOrlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7w7MNnWv22+cHYB2LljtpnZeBN10WcschuRMHwBzvog=;
	b=z+H08t3aNh7CFGQQVnQfei+QmSaoYM0yWmEV9Z67W59uJHlrdRaXM0XRwEpNjHYQB0Hx
	 3H0VLlKc74pdKWCFR3kKhGGr/Dr2LkFGwNVcVy4qeKg3yxx3kRelTvffq1PuayGVt5AXR
	 sA2QPumoZwcLol5pPY9xoChfLFyZbxX9XuONrPHJgrhLk2leBBzu3F/RbGfxMBNoa2iXk
	 LPPy1M2gJ6owI5aIEw8x9AIXrnRr771dcDBSmyZyq7r2R7aD5sTGU7/QuT9wVXbA1rHQw
	 CroyOnE5wTyhnQg4RXFIAxxS4fWSp2IcHy0S2HtC0JDIlEorf8Od7wdMfRut6WYm0Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A33Io6dg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15E5606EE8D;
	Sat,  7 Nov 2026 14:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A33Io6dg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0868E1F008BF;
	Sat,  7 Nov 2026 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060993;
	bh=7w7MNnWv22+cHYB2LljtpnZeBN10WcschuRMHwBzvog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A33Io6dgmCIQtSkfgLN8j0Z5X5i7ZcroAj4JanqA0u1pXXdg/oYa6rGqqZA2jo4ju
	 JBg24JWEMq/OE0T/dbiXm3Te5Gix0oRRXGs8zHm6Lrf9BGaJJDD5YUNmIxqIeXPly5
	 sETJ2yBQUK5il3Hqs9Y7xlb3lUz/WjlSljLKSOdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0341/1536] ksmbd: reject SMB3.1.1 binding with mismatched cipher
Date: Sat,  7 Nov 2026 08:39:17 -0500
Message-ID: <20261107135007.260719643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 89eea430e9155..5ec635d840cad 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1756,6 +1756,21 @@ int smb2_sess_setup(struct ksmbd_work *work)
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



