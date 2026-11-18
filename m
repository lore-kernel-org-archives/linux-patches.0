Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035499;
	b=sBtffc/WMpPz18NW3H0DWwd0gDBLpm01fZrGfWFvoiAnxkIC/1K8VnUWn6eMll5qpBU2
	 z/kba1aoPZvrm6Cs8f7Djt8leuMzNTt+CCp4ujE1Obwt3U6IO8tjVwQ+4/IYy+UMcaOS7
	 2hgajuG6RBIAdYIoSvXm9OaHo2oRg8F7rkBH4wHDDs4z3UknulTmug8a1z/w6XQfisnYf
	 ro4CDpv5cQYOMpFmXoklk4XU4/hcLFrIPW4FjrTMFQUGNP8cOCQ9Wcd7p5BjpDQT0/XzX
	 X8NeGFsVgyFdyZN/EHlKBNbbmkWzVL44x6EruOilsCYSmIx47bS7VQ7D7PMjVVEqwcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G7rS780yVa6akNazfd+V0ryaT24ZVFBpW1dWm10kv/w=;
	b=2RXxESZWiPGP1NlX47li9L2naug8T57xNScVxpxLPCMR6BWRHylUJYRdH9UYaekkbv3P
	 gzfZUpjN0wSLJjtigaqC747fykRV4zcZlfzn7v8SRfQCM0MRH3uhSD0mSp4dXFpKgN2Xn
	 tA7RJPMQ7kaUq2ww3Uj5dazp7GonqggN1q1jkSae1GO7ScJ/H3gZpPtIndWY7t7KMatnG
	 MWr8gGztFj8d2TWbVu1OL64pSO67vwtmGor2eTvRYLTR8OAbv82JJd8F2TVA3XDOazarq
	 s0tUIKFXiBQ8DRNuiZzlyZUrIkJwZ9sUrfEp9/8FZCwj9xtbze1vcOk/11yg/usjYrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YaifzZhP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD0B606A31C;
	Wed, 18 Nov 2026 20:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YaifzZhP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC7C1F000C5;
	Wed, 18 Nov 2026 20:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035499;
	bh=G7rS780yVa6akNazfd+V0ryaT24ZVFBpW1dWm10kv/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YaifzZhPJlb1ZikCDl6MDSxXLJSaAT89jHLuYAKeUmltvQAmVgPj28J06aJrx0l40
	 4vJ9hMTCPfcRysT95OweDlWnOq7Mx7vvp/3xAfIkQaOWp2G7UbTfBkBvqt0BWCPRCD
	 wQckODs8ZfkqCOjc3GOW5Qu6/32mVa6nSEPADjSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+25a1d2907885b2182275@syzkaller.appspotmail.com,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 0725/3318] HID: core: Fix out-of-bounds left shift by 32 in s32ton()
Date: Wed, 18 Nov 2026 15:22:27 +0100
Message-ID: <20261118150340.257575645@linuxfoundation.org>
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
@@ -1366,8 +1366,8 @@ static u32 s32ton(__s32 value, unsigned
 	if (!value || !n)
 		return 0;
 
-	if (n > 32)
-		n = 32;
+	if (n >= 32)
+		return (u32) value;
 
 	a = value >> (n - 1);
 	if (a && a != -1)


