Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216196;
	b=v4WIb1JEha/J/vQRA7eJJAXRz9xIalQA78krYVJLCaETlV4D11alMgyrF6oSFpgsZJrc
	 3Y6Q45Zefk2vcfectsD4aUx/jYqCdSOENGxI1wNvt+F/QmYG88vw6Iy50yR12XIaXQelK
	 RQ3AZTaFXpT12oXDz0CyldwAYgxnncxMb9Ns6z8nbvWF0+I9ASRZG8pPVDhv5oSIuLE/5
	 VVb1fOrB3z46vFsisREi0pvQ1XrjkLmlB0OIj5eAptArDtlqDhT9WemSZgSxIXst7m5+C
	 fScDy4yKDB9gh2Xe5tMuHtHGM0hO8XuxwmoMzbVZNeu+yEwYM2NRLVRCS7CXiCRAFtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=URmBfxLR3TENreINK1wMfuDlhkrA20Vg+esWz1VHmHs=;
	b=L6lRLMHI+6NU2Fy+dS0+XDAUba+rvuowwV8Tv1Qvmr+w9jft+tG/Ap0FyC/1+gdrA36X
	 qRfJipNcbKxZV83PFwUKs3+603KT3IkAO1cPqN6NNbDKuwteQyoSQRtszPuWyfGGWoHrb
	 /mBgOWyNC2KWezaJGhrFWmn1lJ8LO/8IYd/yYlcOQ2XEuhJ++cZvZxY77mnOwEh9zoEeH
	 O/KFWEXwt8nvbI+ps2UG5ArAdOEta+wrCtw7YZKy+ioi5Y4B0mmWr4WvzDD+1dY60dav+
	 j9/b59n4aLa+VKpTdivK64JQWJnrqjWemmgvqKMb0SZGXOYcUkj3YPvO3cmLEc5aAqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m9zhgqyN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3915606A31A;
	Wed, 28 Oct 2026 19:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m9zhgqyN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A3A1F01828;
	Wed, 28 Oct 2026 19:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216196;
	bh=URmBfxLR3TENreINK1wMfuDlhkrA20Vg+esWz1VHmHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9zhgqyNPXKbSjBum25G7KlHjkA8JK0rpiPxGoq6TjsFAYbcNFghMRQjawsdUqw3d
	 j75cfnAfzsgDLDyyExH8uLLjv409GXaW6cNbJuCc9qZDI4XmWdAl32dmWUXeV36PZN
	 l44QmRLd4HoWXF1gIxOj4oQ0v2OksjDTcoNwJEFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1475/1887] ksmbd: zero pipe read compound padding
Date: Wed, 28 Oct 2026 17:59:31 +0100
Message-ID: <20261028170533.020311620@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 73f860489e3be2245598d1819226304fc5b87291 ]

Compound response handling extends the last response iov to an eight-byte
boundary.

smb2_read_pipe() allocates only the payload size, so the alignment padding
can expose up to seven bytes of uninitialized kernel heap memory.

Allocate the aligned size and clear the unused tail before pinning the
response buffer.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: Cheryl Babcock <cheryl@renat.io>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7112d013b3529..24506691be74e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6371,13 +6371,18 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 		}
 
 		aux_payload_buf =
-			kvmalloc(rpc_resp->payload_sz, GFP_KERNEL);
+			kvmalloc(ALIGN(rpc_resp->payload_sz, 8),
+				 GFP_KERNEL);
 		if (!aux_payload_buf) {
 			err = -ENOMEM;
 			goto out;
 		}
 
 		memcpy(aux_payload_buf, rpc_resp->payload, rpc_resp->payload_sz);
+		if (rpc_resp->payload_sz & 7)
+			memset(aux_payload_buf + rpc_resp->payload_sz, 0,
+			       ALIGN(rpc_resp->payload_sz, 8) -
+			       rpc_resp->payload_sz);
 
 		nbytes = rpc_resp->payload_sz;
 		err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
-- 
2.53.0



