Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044620;
	b=WcblgURIctqq6LmA1tk5T0ni5AfmMIBNl1wrKT9g/tVrJRMSRcMxqvGQMkW19f9TlQep
	 8Oxbu3aYv96glQcGiZYx0isazMQKpa8gFAszUizPiqLV7liin5Ij5Xl0DA1NM725/ThF6
	 6ZKI9OZWjeOkDWu30SlRFlbgymcmBXjMARLPLPtVFkPNSXy89UXeChyNFptMUxCMNOwM0
	 CsEXJNaa8IfnSxfB2Qacpl0ESCFmaMGPokKkGk0TkbqFdtcukf35cwyBAKFAXdlHLAQBL
	 eDs4SNaC5ylnW8SQuPAguLkgWuYqMApgJVvc2LCWfB8D7E/TfrsYi1a3cKXRRoeN5oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JqAXSOc6ZrzkGaQe7j023f85/2Dsn4lC2OCzgQkKEgM=;
	b=ro4j9AvUFH53wadaIpgxvc/WP/yVvl5z4ij+IaMepAfrOciv6UcDREGXabnsVHU3IuWK
	 AgFL8tHbLwtGqWMKepb4QsvkMOF8F6Qb218Kj+hCbdxfze5IasRwbx2uUVMEYDxbyDgRe
	 3Eg+M9YnAdYFLD74zBl8iuFvn0KZm40y3ubfsHcFuu0ZUkHGxcegXlib/48nQOKGSMSOB
	 1LuM8EefjGqBR0eKIoLpgCfQK0ReHIk3QGM5GmK4zUH1DN5W5nn0d5TDx7W7UrpyIRv7K
	 2QeCSPCW5o5THmKm3FXJv8V5syb2fXUDsyoKNPpqlXfdOeIT7/4Wd42PfNSPPyB1iFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dA3+PF8L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B035606A337;
	Wed, 18 Nov 2026 23:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dA3+PF8L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF271F000CA;
	Wed, 18 Nov 2026 23:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044620;
	bh=JqAXSOc6ZrzkGaQe7j023f85/2Dsn4lC2OCzgQkKEgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dA3+PF8L8rR18tylCQSIqIQ8MbQkiPw/GKoNBoC84kEsJIvviGApLCOUsD5mSSE+l
	 edaZ1Nx0fBXRiFXUCNQvh4cU36wz2D0cu5SvD/jTakgbBpZb7xwWcQdZzbMsnDkXd7
	 v6diken9CURy6utgoRUY0sY6Nku0sIG32mFm+VRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 0633/2857] HID: core: Fix out-of-bounds left shift by 32 in s32ton()
Date: Wed, 18 Nov 2026 15:27:47 +0100
Message-ID: <20261118150224.294543677@linuxfoundation.org>
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

From: Alan Stern <stern@rowland.harvard.edu>

commit 5fe63b415c636c7f4f6848a8e53bdd4bbf0c300d upstream.

Syzbot reported an out-of-bounds shift (32-bit integer shifted left by
32) in the s32ton() routine in the HID core.  This routine converts a
signed 32-bit integer to a signed n-bit integer, and it caps the value
of n at 32.  But when n == 32 there's no need to do anything; it can
simply return the input value.  This will avoid calculating (1 << n)
when n is 32, which was the cause of the invalid shift.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 69c02ffde6ed ("HID: core: clamp report_size in s32ton() to avoid undefined shift")
Reported-by: syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/6ac9cbd8.a150a118.27e199.0025.GAE@google.com/
Tested-by: syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/dfa0aa1c-e55e-4316-8307-f72a07383634@rowland.harvard.edu
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1368,8 +1368,8 @@ static u32 s32ton(__s32 value, unsigned
 	if (!value || !n)
 		return 0;
 
-	if (n > 32)
-		n = 32;
+	if (n >= 32)
+		return (u32) value;
 
 	a = value >> (n - 1);
 


