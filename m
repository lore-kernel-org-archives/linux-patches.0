Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057955;
	b=C2UqFCg2vNPVVfDRFYoPUiQEws2f9k/YTmw+rNP6u++THP3HfU4rzd18sXYp0V5pxGG6
	 olckD7AC8Rg2wos+dz4MlltqUPz0uP6clWrBNYVsOQWnc7Z+VYLbU6wnhXLNYGCefX0Sr
	 l6Rw6jn9Qm0EL3z2nD5HtwDe/TdViQzEm7Y4f3OvxjNC6BT7xqzAuu/oFvwIKyBwL6jXn
	 dKlqredP2b5mqbRfRKerfDAQn3aseq4yDNoJ5JxsrP8Wb2cq2+0qILdHMuDZHwL5ErDmk
	 zasWgwFd+HXj5bVtVAiBT7ALV26gImS6EzQaRekTXs1LVYghAlXpVEFJ2IiVMJY9VEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IKRqS1qNwAjBqUmInKDj95KYU6Mo3JvI4rWN37HPQ0I=;
	b=zfJgz5MLb7rOZyc++LaWad0yGfud7MAK/ebcIrh25NHP2IzpsUj4MI55Ghlf6PYluZHx
	 OTGAcaO8MHk5dIPff+jBSovGt28ULNOWThf+tku2WIkwIUlgeYOAt8KNZ3gLeDXVWYa7e
	 tloq3HFj/ggphjUYpLFwge2CNhs0Ww/DSzY9O3eiuHtaU18ZR6K+MCzCxCns9v17KVxZb
	 Z6o6IKvMmSb9mkV4oyH9hooTAtdpj/pkG7EqoAOyCZWYOoLiWSJss9PZT+iyuuZbqWnTu
	 4/0qbziO4yjrtceD4aiAIAf8jmZ4IQEdisOc1xYSnIw/Ryl7yxgDz913l974M5+EGyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hop9jVv5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928CF606A320;
	Thu, 19 Nov 2026 03:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hop9jVv5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95FA1F000C4;
	Thu, 19 Nov 2026 03:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057955;
	bh=IKRqS1qNwAjBqUmInKDj95KYU6Mo3JvI4rWN37HPQ0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hop9jVv5pDBWfJxRtCNeyHf+ThBmqWa3Vj7k9+ZgdlXwzy0ymR7iwnnPZgCQazUvs
	 EBqjNlcxL1aUPIzGPUFEeigVwYZ+cjUgXkAQrQ+6s6dGqNMeVSaVTVuP/LSjiAM/cU
	 P6laC9shluAadf+7Ep3j3IfKLWCoorbEOet5qkzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 0307/1848] HID: core: Fix out-of-bounds left shift by 32 in s32ton()
Date: Wed, 18 Nov 2026 15:39:05 +0100
Message-ID: <20261118145925.052884174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1360,8 +1360,8 @@ static u32 s32ton(__s32 value, unsigned
 	if (!value || !n)
 		return 0;
 
-	if (n > 32)
-		n = 32;
+	if (n >= 32)
+		return (u32) value;
 
 	a = value >> (n - 1);
 	if (a && a != -1)


