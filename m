Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827004;
	b=uwpIR333KQpgTJc2/uFoEIrMehxdKEoTQDLQaS3BCas/AjrhMieUNyvnO8tj9YVy+/Cw
	 cGlthoDnOBH/z5AZInKdASITCYroBO3UyJ4mVXdtrHjiV2OJGf4HdcOcZxmtou7YH5hfA
	 mDe9dkFHn9Cph7Xsk4ko1v5kJKAu/1bvKXXMnMHu0z1QMq2Ud+ymsaO3wqyENZXFdS1nC
	 0MufwoIRmokW4Hl+olOuprP/fau4W2U9LNMRcdZclKFtueb9jDrI6tandVRz1+GIpu5K3
	 j7uOM9gehRbbhP2qESs5+2oAJ5+KAvCzwtLZKNfixIabow5L6pGzx9+KNphLm8cNTnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BhAIueVk50V8F/Qc7DPWtY/K3l27aUJ7SeFQH96ul1w=;
	b=rCcc0HRP9y3O/yw0VJ/N/uDph9zkbB/sf8W9aGHLGb4VLuyIBlyzoF/RmctMb2G6Us7F
	 nQupqiXx/bccgZEufrmaHqVI9GCUrCi2nrysoNqilpzP5sbzHMA3cPNii7b9iDDjS/u84
	 tpwTrVdAQc4eb+l4awG7tqsiWhE2z97YAvKxAghoIa+B5bAHtz66I+BHC8SYACgx8WXWE
	 HuvjZBYgJooMPYmHWow5IddR1wvWqU1sXAtyj1OOHAVoDPWNxoSJhHpzvX4xtHZ2451my
	 8IF53g6U20xf4dzJcVt0RYRMaUGpNvQZ/PDk2qzd4diSP4Evde6mUD93CKP3de+pR5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOWtsE79;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22716074923;
	Wed,  4 Nov 2026 21:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VOWtsE79
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794161F000C1;
	Wed,  4 Nov 2026 21:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827003;
	bh=BhAIueVk50V8F/Qc7DPWtY/K3l27aUJ7SeFQH96ul1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOWtsE79h6caMNiOrS6FoPkgNtCKPOOMoEdSO09QjCH8GU5SmmOy+2xi0CrKW9hcb
	 z6calQPOzf/2itRdva8mMoeUepx8YsWfpR540BPAgaa1JVBXQFMNPN4zmeGphDOjA7
	 O5byxPCtnU6lbAy50B/DhrlEUNAUeEsFKkwsDI30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 134/547] ksmbd: use u8 for SMB2 oplock level values
Date: Wed,  4 Nov 2026 16:05:18 -0500
Message-ID: <20261104211041.981213288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -11488,7 +11488,7 @@ static void smb20_oplock_break_ack(struc
 	__le32 status = STATUS_SUCCESS;
 	int ret;
 	u64 volatile_id, persistent_id;
-	char req_oplevel = 0, rsp_oplevel = 0;
+	u8 req_oplevel = 0, rsp_oplevel = 0;
 
 	WORK_BUFFERS(work, req, rsp);
 


