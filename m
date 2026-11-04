Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831349;
	b=rMPfmCWxOkWKTLSixYZ513S8h+D6NiSn+4FeLsqXLJqKEMX0W8AmuHHLtv6crqqF1olL
	 ENHa1+u0z/OzngpacdXv5auG2Z2uWOxyuSGCNoax3YNZtBrh3DyHzMRVv+HryhwdfioST
	 kSPqCgDYQC31mLKLNu8CaVgtJ2TLr08GRvaYGGB37vKko/lTsXnussP9c5hi31sQiQBTX
	 6aJn5+RR0odH/6FatWAAQFyeCxSPHzjsbeb6Yypwgiu1HV9M0ZIDEoOSk2B6J2rKcxvvL
	 LnZpZsGwIZH6IOyM8CmFzvis4KUq2koJAS6sVDJY2VCx7EOyykJBAAYvjcx5VyT87rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gwPXuwNJ2tL4Y+CK1e13ye9/JzI6+TY2X5L8WZN+iDg=;
	b=HNocNSTZKVV0sbuSkGgdpM4axsSDs+c2K7IYZKXvCIFd0GaU3PtZ56LePDYwjF8e+Bk1
	 gS5TrXTXW8/9U6XsGrZ5WWNvLx9rJeu6efY9MYIXhE3x9jGeQ+EEAw60wRadSVQWyNIk5
	 /POjz1zk7FAS/t7WlcVjX6++cxb/tZEyIfsWWkleRkCDFTpUbzfhwpGF67tAGMqoWIp5d
	 vIPX264Szbcp0p2K32+lOOe7ubxs7Kn48W4WB1o5jtoKfBTH0EHUrLz+wMCU6XxxSPpHo
	 fZHImNd7Higk79DXsbYvQgI0o27xL7Xf69/hhF357zCnwRtVCI9nuWVdE6l6o2bZo5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AViPAKLb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40675606D81B;
	Wed,  4 Nov 2026 22:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AViPAKLb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A421F00919;
	Wed,  4 Nov 2026 22:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831349;
	bh=gwPXuwNJ2tL4Y+CK1e13ye9/JzI6+TY2X5L8WZN+iDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AViPAKLb+3tTH3p05FwG5ewU65X+PGvfBJKSiAMlIiYDOpPVlzp+kJyN3h9+Yz0OE
	 Ozg8yQ9LA/rfOsft1TWy5J+LJ9felHGlfQnKA+wQjScEx1MA/HyCC494+xzBmQpUSb
	 yI3yEm4FB5Zn/8XRRag8HGp53V6786uFm0eEeDPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 0650/1005] ksmbd: use u8 for SMB2 oplock level values
Date: Wed,  4 Nov 2026 16:06:23 -0500
Message-ID: <20261104211101.929171742@linuxfoundation.org>
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
@@ -8871,7 +8871,7 @@ static void smb20_oplock_break_ack(struc
 	__le32 status = STATUS_SUCCESS;
 	int ret;
 	u64 volatile_id, persistent_id;
-	char req_oplevel = 0, rsp_oplevel = 0;
+	u8 req_oplevel = 0, rsp_oplevel = 0;
 
 	WORK_BUFFERS(work, req, rsp);
 


