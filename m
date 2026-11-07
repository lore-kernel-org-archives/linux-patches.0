Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061497;
	b=KUuiwia3P3lno2n632QcTRySmpcq71x0AS8lYGxbR9bS2pWou4cIExp6T7kY4C7SABfH
	 1yOZXCWPDEQ3QwMb1E850ufRjgbWyG020TlVKPw7/XcMnIvy4hs31wJgamCk6fHqcys59
	 EmoPuweoYkvtfYc+vqigtLR0jiSjheyw6sFUlvB1sF5xv0cIR+3YemF6Jj1JasRidjMkw
	 iN/8EuLGn8WMr3Hq5lHS+DApxIAelUbYqD0fHPpOyyudz0Uxjdj4A8siVAhL+6WWYsQ1C
	 Fwt0zClv3XBfNDqSNzB0ZPTdvHSQg3pvVur1MLSh0roiW5x1opW9Y+NeA5BzRNhMYWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dmj7EkTydoROsYEW9UcI6+tKN4fyAsaLZ2kXXkNrL14=;
	b=Gp8Q+qWKKMYcsWYVazaOzhkkj6vVcJGt7/Jp1vVWDEsHwl7zKiohJ+qwtip6qVTJNweC
	 IK6bvywkow8EjCFYLtt3ftHPYZMK75dGrcIMOKV2mnqENGyIKw2kX5ZwQKTqvAvGYG76J
	 5kXEFaBebLL5P3YLomhKoYG8YyhDVyFLnD2M29N/j6VxhLFSM3223C9/T4+KKflgTsWMS
	 DvXA2mkHTUkW26TN4x4V+ppFrvEq9HYUHj9F/JXE9UHhXW2+hzP3OdMxmaSspPhQqkAUL
	 sLU1KOmYHlz5Ca1Dh0mjZnwfgK3TQ0tqJ0PRw2JsTdmrfpOAZm4E95HNdRV1GSTdICg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XshxZt8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C191A606A331;
	Sat,  7 Nov 2026 14:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XshxZt8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B53C1F0089F;
	Sat,  7 Nov 2026 14:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061496;
	bh=dmj7EkTydoROsYEW9UcI6+tKN4fyAsaLZ2kXXkNrL14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XshxZt8EcN5IHI/JbNc2s/MzwSVyW/rMWAgQc1a1yZ7edOEI1hKi4aZ+yUu4+XW3
	 60eGAio0EF6g2Oz/DBErS15+vRnAFr21r4UaWWKSufTqmKkjkEQV9XDPvJGDSaNV2L
	 Kt7LAvOw3j8fHpPvh6qq60fRot+2amNQxzvytswA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 0592/1536] ksmbd: use u8 for SMB2 oplock level values
Date: Sat,  7 Nov 2026 08:43:28 -0500
Message-ID: <20261107135014.163591554@linuxfoundation.org>
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
@@ -8822,7 +8822,7 @@ static void smb20_oplock_break_ack(struc
 	__le32 status = STATUS_SUCCESS;
 	int ret;
 	u64 volatile_id, persistent_id;
-	char req_oplevel = 0, rsp_oplevel = 0;
+	u8 req_oplevel = 0, rsp_oplevel = 0;
 
 	WORK_BUFFERS(work, req, rsp);
 


