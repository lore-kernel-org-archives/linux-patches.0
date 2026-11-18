Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021387;
	b=FdRC60OfucCmpVzPJB//ktgV5BWNoG5UbJ8lf9fh2c4HfMQ6Vk8r1j2V4ekhx1u8g/BC
	 mftJykiujJ7eKOP9rTlAjX2Ho65zSMan++2pVVKaqCDUNsnJELyJAk1tc9fLETokGbsoQ
	 inHhzYYhCDAY/ReODtd9GjSFNlsssN0AQH0oJVeLaX/mNCZvj1xZLBPQGXX3I4NnRhwqP
	 p+kYYoFa0AK2GTNkou+c9yblo+d31bWU5zdmktZR+MRtXKekPR4hpOKTkIZx8y8yIuog5
	 0Sv7LAJcVVMY5dMdugft+Cd2GrbKU7aGvORP6aaPi9XvcS6+N45a2c/2W9v2Z26HCfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=teUeSOOw1lHKyIJ9BCNod2mIlH/loLx1VxrGydLw7LU=;
	b=sua0sKIU5S4tdojzhLzYUYykbWsCzhHT5r7r8hc7CFHt5TgchNl7dfLgvZwYdIN1dtbI
	 5PcjBmoK86zlkxRcKE41rBPYZU83QKKmYQbCCSxKdydBR0eu4X6a2K4PfxhlptHij+vK1
	 M/svetYQH/sPPWw4fm5ejEKsLjtMzXVbola1wo3TSC0K9fUTdmgdSDiC7shl+BJHIRKwI
	 8zOVX4CfVM5acWo1MBMeGk0LiRHpW8ANFAe0A3tCdvLrLdPeCZdj8h9KdNy88UMDaFwsT
	 Q/UMW1ShFLV/2ed+8eEyGUAmKE6pNDlCeTIkuZTo3xfhLVqz9PaYqWS4L2DwFO4zWuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=InoNCRwF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1833060A2600;
	Wed, 18 Nov 2026 17:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=InoNCRwF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259A41F000C4;
	Wed, 18 Nov 2026 17:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021386;
	bh=teUeSOOw1lHKyIJ9BCNod2mIlH/loLx1VxrGydLw7LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InoNCRwFoIKPwyWN5fLUHp7+zgfeTg9vvsS4ZqXqSl8GBNaJuVX3j1VInKjRxUx22
	 GJh33wfOtHa9YWWb1V3Vf4PVkPKbAmEMuG3ZQXXKDO1S/9jrIpR3uP1i8hO63dxPqf
	 hGDkTAllFo4+D4cUqz4DqORe5OciDTrYa8/zF7+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2290/2651] ksmbd: disconnect on invalid encryption transform flags
Date: Wed, 18 Nov 2026 15:58:50 +0100
Message-ID: <20261118150407.713797638@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4f6cf8df4ae9f..74b4e332317b7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -12644,6 +12644,12 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 		return -ECONNABORTED;
 	}
 
+	if (tr_hdr->Flags != cpu_to_le16(TRANSFORM_FLAG_ENCRYPTED)) {
+		pr_err_ratelimited("Invalid transform flags 0x%04x\n",
+				   le16_to_cpu(tr_hdr->Flags));
+		return -ECONNABORTED;
+	}
+
 	buf_data_size = pdu_length - sizeof(struct smb2_transform_hdr);
 	original_msg_size = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	if (buf_data_size < sizeof(struct smb2_compression_hdr) ||
-- 
2.53.0



