Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625470;
	b=E7cEIhMZgmdg7MeOhoIzIUJHEhWAzzcPcZyL/2M6OaW0nSfOXkV0MbOFWqKxi9g3pYZa
	 N/zttVHPxxKw0jmKp2VsrLVqyfsOCXbowceVnbrlHgteA0AFqGAmEGBg0Wk2khpMA0kE7
	 LZoPS8AafGOfm4PxXGlzd/a6o6wglqZBKHQ9cHXBSualYK/fyWdSONBQ/IZD3LV0UEDEG
	 p33bf4ByKTeZp13GGVPZzB9jGCil91yXYxtRJ6J2q4s1uddt/4HmKEQaih3HLtV5xenZn
	 kWaemLCoSJiSR+9a20U+xFo2MzuptyHI+KDsCSMfhYXHxeKBPsPUIe3uJAz52NtEW7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bgTIHSQLsz/9VyFloaAKJ+6Lrg3li5+QPK3hzsuXE/M=;
	b=CqBoAR5CijAWhtGHOUmNMD12BlW8H+4BpLm2rfpvgqLM9fyqEqvsWCJr9AtWvwWvHoU0
	 ekSLGS0ki2b8vdw2Mmm6MTTVyjitvop1k2KePW7B370/iaMkH5NBsyqK/oyayT7KGfRm3
	 SqU2N0WMywKAfG0cJOW2G6ZsKUUn2Yrz4NZP1mGmQlnDrydqhrm3lCyFNwCJP4i5jDZA3
	 Ei1driQnACTLNXgkogSzjgvRiKzR13llcjiwOAxxK8rLzXCDKHZE0keRQN2QBKtEzGC+g
	 KltXkJ+FmX0o6EUhxbLZKO/kdNViGRd3vaMcTsXxXl2L+eznwhiSQXOReVpCdLAtWvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xnYgSQHN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5753A606A31E;
	Wed, 25 Nov 2026 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xnYgSQHN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F441F000C6;
	Wed, 25 Nov 2026 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625470;
	bh=bgTIHSQLsz/9VyFloaAKJ+6Lrg3li5+QPK3hzsuXE/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnYgSQHNTqXkoWXlotz00qXymHGR9852Bs1mYX7ynHzbQbfSCHEldiQzQ7xBCpG+z
	 SgfJ0i60F7sJKzv+uVPm1b2iLrrVwVhPYhxF7SrV8neS5AH36Kw4KU78uFJa+T1+rY
	 ReoiNenByUyG8o0Z9j4Ft+epr6JHqk9mt/Bh5KSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 528/816] ksmbd: disconnect on invalid encryption transform flags
Date: Wed, 25 Nov 2026 15:34:36 +0100
Message-ID: <20261125143901.414495838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

[ Upstream commit 0882f124ae329eefb66b00e63b9043f24c006b0e ]

MS-SMB2 3.3.5.2.1.1 requires the Flags/EncryptionAlgorithm field in an
SMB2 transform header to be 0x0001. The server must disconnect the
connection when it has any other value.

smb3_decrypt_req() currently ignores this field. A client with the
session key can therefore send a correctly authenticated encrypted
request with invalid flags and have it processed. Check the field
before looking up the session key or decrypting the request. The caller
aborts the connection when this check fails.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Added the transform-header Flags check to smb3_decrypt_req() unchanged, but adjusted the surrounding context because this older code lacks original_msg_size and the compression-header size check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e65fe5858a51d..5492e7490a26b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9572,6 +9572,12 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 		return -ECONNABORTED;
 	}
 
+	if (tr_hdr->Flags != cpu_to_le16(TRANSFORM_FLAG_ENCRYPTED)) {
+		pr_err_ratelimited("Invalid transform flags 0x%04x\n",
+				   le16_to_cpu(tr_hdr->Flags));
+		return -ECONNABORTED;
+	}
+
 	if (buf_data_size < le32_to_cpu(tr_hdr->OriginalMessageSize)) {
 		pr_err("Transform message is broken\n");
 		return -ECONNABORTED;
-- 
2.53.0



