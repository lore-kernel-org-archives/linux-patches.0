Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043532;
	b=tZZ0pB35sMMjWmT8M4SNHo/UHbVQEM0Q0Ii4ZPHW0WH4/PRNW6EmQlvtWmHi+2Jtyh7j
	 W42FgidCNGDGKJm2LCvc8mbmludgfW5PH+TKObpxJ9WEv8dqSPzPuMdkI2trf6qKRIT7J
	 O5AL0cGTlq+NBlDUJtXm/qu53g0J8GsdJfzDsW6MXreQBFXYnEyuFUmrcU3QQSGYZFolv
	 H0SYJiKg1t5C4zdvVq1L8x/1w5PWnxFa5T9Ov3fZ5Fxn77eVE/0GAwLJLPMsVm9/CDyJj
	 nDbVhc+XcWnxREsAlaXaWVoxTMXaTtTon7U7zO+EzXFu0UXX+dvQW8uISyXz7SmvM9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dsdu3GdSssOiKZ78lq7efP7jjmRNJyPBqsoRCHvUYWk=;
	b=HnyUDZ7fIHPY3/Tiu9P/AhR4+qVn7o9H+9Fp8XGTWymkAGoqR/OZled3ntFxnYxMTGt+
	 QaEdfPQTElNl0md+kuG0eOWIq31c68lJguSx1XY33CswtI66zMR2pMQEqdjPUFy78Wv8N
	 54OzOMQ2DnucczCx5kmAjlEja2yAlDbTvhmBE1acw9pSRhW2R5HSES5JAA9smps5yTqSI
	 IDa+s7e2IUbAwcAIRAMo70YT9z+blEgZ2z6YtVFR5iigiMeBYdPZyJudd9obehx9IfrS0
	 3IzrKbmimP78D3UzHr/ZzXhAHRThCzbIoso8I2rLglGr5ef74mgJNjVS0DKfPYYzqLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+A82I5b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8240606A320;
	Wed, 18 Nov 2026 23:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+A82I5b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD4F1F000C4;
	Wed, 18 Nov 2026 23:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043532;
	bh=dsdu3GdSssOiKZ78lq7efP7jjmRNJyPBqsoRCHvUYWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+A82I5b3ozIu3bt4nuhDbUh0RWMyGZx7HPY2Wk2RG1gyTYmhQzCA3hJ+MVFzj+fG
	 RWH9GHhkxUr6MVbJg2PEuggBNAOJBbwWLSADqnB0qOpPUJ6xxxbOcby3m8ghZkE2gJ
	 AqVLqge6+Tca/RmK1n0L8RXC1mId4DRkCx3lBwwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0245/2857] ksmbd: preserve access denied status for copychunk
Date: Wed, 18 Nov 2026 15:21:19 +0100
Message-ID: <20261118150210.268988660@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f7c0366e0a80bf8cd5eacc5479927abb50958b5e ]

The copychunk error mapping handles -EACCES in an independent if
statement. The following error chain therefore reaches its final else
clause and overwrites STATUS_ACCESS_DENIED with
STATUS_UNEXPECTED_IO_ERROR.

Join the -EACCES check to the remaining error chain so an access failure
is returned as STATUS_ACCESS_DENIED.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f5dc49cf06b90..65dbd33753b05 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7591,7 +7591,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
 	if (ret < 0) {
 		if (ret == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-		if (ret == -EAGAIN)
+		else if (ret == -EAGAIN)
 			rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
 		else if (ret == -EBADF)
 			rsp->hdr.Status = STATUS_INVALID_HANDLE;
-- 
2.53.0



