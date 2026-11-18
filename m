Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035026;
	b=JYlyQA4blYS0R3XAcjL7Q/wI3SrZ1CVbj+xXOPwc62MzJf1DMtxP5N9HZUiEMAnMbkZX
	 DMVGJsGAN3SOCGtFE5dpVl4+9nyDYieJJXvKt0yri5T0uixCyMGKbWNq1LnotX54fT4eU
	 6MmDRvKqkJpEFqYX+dnhy9wSNOkKGnWdKHCF9/ksPs1kf/Oxn3L8okS2vGT4T8knCJG9z
	 06uDq5lHCBu14F6tctjAYnIqtYs/wKSYzfj9U/hJH+B+UxIaF+h/WRqz636IsQvgHkllI
	 qebEtlCJeKFFkC/6ke+TO14C7BVhShl9tD/rOB0buwwpHGa9HEr4KnpoAzlWvc6ndVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=InrDf3b6Hd4AOAbqGm7YtkSsfRPD3igLJ7YDip4e9Zo=;
	b=LjoHoH8D4Qrm4qf/QznFGkRAofauGKjRJVIZLHcARIPV3xsoxqXrT9cXVKakoDKgJFft
	 qGih3CinoMLwfxoUiDcYjl6iMVcqecTHZf773ij1g6XDMqBcf439CMLxy2ZkHMEH1QPde
	 MSyvNbMaP/1nFsSZJCuJ6IZvNHjOwbiuFOQ0Tafp2gZi0ErUp38PfuYNh76y2stcit0SH
	 4Dk4o/rnoVGwG5k8lmwIQA7NLlr94pugSUmdBrSvVg/RyZDT96JFUleE/a1mIgNVyUhNd
	 qr/NBcZHUz0lVg2QOiLOAYlV/8z1LmpaSOiy88A3ekxq669EGx9Bc7dOOBvZQc8fykA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHownsY3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E24C606A31C;
	Wed, 18 Nov 2026 20:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHownsY3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F118A1F000C4;
	Wed, 18 Nov 2026 20:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035026;
	bh=InrDf3b6Hd4AOAbqGm7YtkSsfRPD3igLJ7YDip4e9Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHownsY34t8eAq4Kj2JUrk2EYOt8OG/7JKJ9eNd/WelHdRBUYgPn07bsEJj6fp9e1
	 +DlryrIAe+8wVHovw6Lt5x0PIVvHGW51xjHu2b0R+qi1XOUD2LQdsMfzRusuWZofA3
	 Xwx27FSkNlbbrnlFPwWvE9B6RrsN1zb9uf18riQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.6 0577/3318] ksmbd: use u8 for SMB2 oplock level values
Date: Wed, 18 Nov 2026 15:19:59 +0100
Message-ID: <20261118150334.804068382@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

commit f622fedabbb58c8006ee21373968ae07bf8a9467 upstream.

The SMB2 oplock level is an unsigned 8-bit wire value, but
smb20_oplock_break_ack() stores it in a plain char. On architectures where
plain char is signed, the value 0xff becomes -1 and cannot compare equal to
SMB2_OPLOCK_LEVEL_LEASE (0xff). The acknowledgment is consequently rejected
with STATUS_INVALID_OPLOCK_PROTOCOL instead of the intended
STATUS_INVALID_PARAMETER.

Use u8 for the request and response oplock-level variables. This preserves
all wire values in their original representation.

Fixes: 80a56d4a826c ("ksmbd: align SMB2 oplock break ack handling")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8802,7 +8802,7 @@ static void smb20_oplock_break_ack(struc
 	__le32 status = STATUS_SUCCESS;
 	int ret;
 	u64 volatile_id, persistent_id;
-	char req_oplevel = 0, rsp_oplevel = 0;
+	u8 req_oplevel = 0, rsp_oplevel = 0;
 
 	WORK_BUFFERS(work, req, rsp);
 


