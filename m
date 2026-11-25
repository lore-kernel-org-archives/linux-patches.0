Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622710;
	b=TeIa+P3GksjP59QD+0XrVfjBJzHMq5t0woqC6k9KJ0+dLn8/QL6IGmbQA7Q4hWQiImMo
	 W4LXSikylSQ2nIFlIPgSg+/3W77xvK36ihE4wMlXuIaGimUpyO4KP4VmfzpZp+HLOA7Nf
	 klwsy2RY8SqefdDlfZAJhS0ZKcr7AoS+1uhH8STZ6AHsLq/Sx9bpzd76hfjxC8VylMOFE
	 WcGM4G/0oACrgATmE+thfiTfHA3HYAGB78WeW8h2jVKDUqRel4fQFdtCOfnEWsD5V5cJJ
	 rux+E2EChURyHZn+XGoWd9mc+8NxSMsLqzElyHTq0Dpmzh8B3nYztOj3bXVmRpf1VwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gn5FLK96Tg0xHFxTKSEx9IEGVPSBcefOCptDKgKI0DQ=;
	b=XETze6+uHr7GBO/c3G89/aXvDFrBjVa6fWl/X/VMXZdX3th6MmT7cdlQRWONdamAk2UT
	 RFojNd1rl/y1LfV4xMdOV1pBFBvKEUbM5Ko8Suy2D9JJjO784b0R6JQN/w4gbiB4SviKg
	 HUEBI1RAmS7vIgf5kG91JotOflQlRIUF4Haxxt8iB46g2i9WH+nnqeSkKW6O6MmOGnGzn
	 MN/mFUYsqPbd+WEcCsZgb2fZyDlDQotTAqHidG/XPsYCHnl/or5S9Ef27lYUu4/VdXQYT
	 EmlkxHrKxKPBU5gFYR1ZTsdYQ7SCkFAlUH3I5beCshxo9ec6W7SG3/14L0nYgFQ1bGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ommg2TDJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B315606A31E;
	Wed, 25 Nov 2026 16:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ommg2TDJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EF71F000D2;
	Wed, 25 Nov 2026 16:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622709;
	bh=gn5FLK96Tg0xHFxTKSEx9IEGVPSBcefOCptDKgKI0DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ommg2TDJT7FCewAh5FBuxkglnIP1ZVKABq8po89QLb6q+5shSdeFnJypwmGo42uWF
	 o1wdevW4lbvUvuG6UM7ybWIn3rIN360CbkvdpciQmPRiE6vfY6U2IUWr0lVObqm/of
	 BTojE1P1kgxXeKuFIWWP4f9JVx1rhLwHpo2r0xKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 622/990] ksmbd: disconnect on invalid encryption transform flags
Date: Wed, 25 Nov 2026 15:33:09 +0100
Message-ID: <20261125143836.671261568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
[ sashal: Added a transform-flags check to smb3_decrypt_req() unchanged, but anchored it after the "Transform message is too small" check because the surrounding length-check code differs on this branch. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 53094243d456b..88f07ec22723a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9651,6 +9651,12 @@ int smb3_decrypt_req(struct ksmbd_work *work)
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



