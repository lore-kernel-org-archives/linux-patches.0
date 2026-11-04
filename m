Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831842;
	b=zUgxvAak5a5Atfu/dV9OVdepPlj+SSr8LY70v/VIlewC8oNPz+KB/q0nL90u0FfHRSLx
	 Wq1CUMYENIz3gBS7DbwH9ZhF2kbuGAa2mPyV7gSQvpax7SbzilCfmrnm0n5SBP4ywxutZ
	 0EYyqEzxnDxRw/CMjdBYRhOwW6SpBrq8Wm+WU4c+bJqRKNe5izlqxwHortsiCYptW7fns
	 QRi8k6K55U8lRTxR8pau0FpVxe1LLMFigOKUsYC8vA/7NJCaCY2XCoBibGT/iEIQkAz/3
	 m2ryjH6hVsfcSPpqDpUxnJQGZ7QadYME27qF3lhSw4Yj/X9OeiFQ9ZQw0pzA9Q1x9Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kEvxlMu6IzgejWQPet3UbVnjxpwm/xjynPbmvDCfogk=;
	b=D1Q2r5BHFqcWOW9ZEkT3FrltFudxSPxcI3jUx+OYUHbck5ZtEXh+f1ESyCGEBiE8pqwa
	 VoUsafT93MWD8ZWPzwBlqH/b4koxgWZ/jvZjUtvrwXhizkvRwXWKUSqoDvDlZ7SsGKtPk
	 8SeEI0zcEXK9ACH7MPk2gmtLMxN9UrNsP/9rsQ7ssvf0iLSTlcqr/lu8gNq7c4NV8trs3
	 zSvFJ+tQzx5meyNHYOJ9qa8YY8uiVWiaQEUz6vzyN9cIbPxI+lS+rjhIaXdTxpWnO8MQC
	 m+8DL+2fvTliIn9g4VnDjyHCKnUMKAIC7YDb8eo2msJgZ/0cyaz9DAxBOflvVzDnmag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gFMoPFTw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F49606A842;
	Wed,  4 Nov 2026 22:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gFMoPFTw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BD51F000C1;
	Wed,  4 Nov 2026 22:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831841;
	bh=kEvxlMu6IzgejWQPet3UbVnjxpwm/xjynPbmvDCfogk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFMoPFTwfB2OG/keqBTKDCk8/GIsZtg2VfN5GIhfldRUiL8Zpa5nupE6HdK4z59N1
	 pdxz5+64zooiS3vEUM6GOOht5snl/iwq85WICL6tdH/NZpNzEHoCjquT7We6+tPxhs
	 c2ES+7qlHB//Nf8TYRCTvz+r5EGQRyX5VrlQZoCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 0948/1005] HID: core: Fix out-of-bounds left shift by 32 in s32ton()
Date: Wed,  4 Nov 2026 16:11:21 -0500
Message-ID: <20261104211109.664724975@linuxfoundation.org>
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
@@ -71,8 +71,8 @@ static u32 s32ton(__s32 value, unsigned
 	if (!value || !n)
 		return 0;
 
-	if (n > 32)
-		n = 32;
+	if (n >= 32)
+		return (u32) value;
 
 	a = value >> (n - 1);
 	if (a && a != -1)


