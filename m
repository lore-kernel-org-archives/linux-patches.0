Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044320;
	b=tv7HoO50epI0c66/r4AbudXC+o1CXvQSbgNuutnMnM+KCzU1CBg1T4tizm/01SqlomaM
	 SvKD2JOt0WtiVCV3UJJC82mq2fMudiGIgdzGUd9BbUlqB9A+vvZ0x/6ctPF9oQFYCZs9+
	 Ww2DeR9sXbaGKfr6aP5kEQFvvbGpAxQSKNqxj52+zf+mc0klS905VBeW6yhYQXfqSOlbC
	 dbL7/Uyh9GDkET749juxgo3siJuKDtgJorah6+Cm1AnwUFW8FbbACs8h9IV7O0I4s09DT
	 2BLB0ttrTEdtNeurAKvWZtr6kdDXl8MBMT8qIiLD5UO5aDC3lVbx9DHTLyHtGCpueXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+N1AMsNrK0xkm+DKTwPfyzC0tisutrSqE3/VlcWKb34=;
	b=VclnOc+92UlR7RpPsTEK3LM1MEC/Qi0C4jNcN9Xp1tlI5CO2RUj9Hpc7AhjUUsU6aWFJ
	 82Po33THyB//3nWqaLpsIlY/Y512muuTyg3NnHFlyO9dm8kQ76b9F+xddaXPOeCoIG5Qi
	 2Or9fwI5T/TxmUvnPFrxaNnD3k1xiGWuFXTn1mCtpDxxar6TY7XrJfOoANSQlZsxHewpT
	 6T+D3vVupCF0Nrvh3UrZNkE8B/FK8Q4k3YPcYLDCKq3ebvuvQ5FUFwqIqVswMSTmlrYUz
	 CfYeNRkFwbXMlbg/u2LXN05LVz0/aziFdUzcinZWS22Kg7rhP89SDbZ5VG9SjRKnyGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtUS3wBa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0292D606A325;
	Wed, 18 Nov 2026 23:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtUS3wBa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552B31F000C4;
	Wed, 18 Nov 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044319;
	bh=+N1AMsNrK0xkm+DKTwPfyzC0tisutrSqE3/VlcWKb34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtUS3wBaOfrP38nJr7k8qMSVvSlpPzhe3EgMWBDBAI4ZCbE8g+wwam7e78sEkliRJ
	 kaOJXt0pBwQTARXhmvOy5hpJs0D1NUj4ZOBwu5Vp/ESqHCa+oIilsPDTHgKCQLN9kI
	 JT8pmO2ldmLcnX8+iBFUtq2L8VgnIzsKkdilCsBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 0518/2857] ksmbd: use u8 for SMB2 oplock level values
Date: Wed, 18 Nov 2026 15:25:52 +0100
Message-ID: <20261118150220.120053318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
@@ -8345,7 +8345,7 @@ static void smb20_oplock_break_ack(struc
 	__le32 status = STATUS_SUCCESS;
 	int ret;
 	u64 volatile_id, persistent_id;
-	char req_oplevel = 0, rsp_oplevel = 0;
+	u8 req_oplevel = 0, rsp_oplevel = 0;
 
 	WORK_BUFFERS(work, req, rsp);
 


