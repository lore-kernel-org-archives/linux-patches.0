Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033658;
	b=Y+0tvnArnYM2a3SC8zIA3Qh0X4PM7RF7yQL3nY3HIyY6VJQmxKrAHd+eLOufmXZU3GV/
	 eD0hB5LGaUER0zbzqfbOoKMioBiWF/7nxBm621HjF5PNneeCx1phiNiIqaSGDFy76Wrg7
	 bJD9Tl2OEHJIhh+QlMbUNngX1IEFfbn9TmU0nM6IFVN1o4JAUlQOLLZD6QhJp7VqPuBp4
	 858JHd8eqvX6BtCbFFlmPua9B8iNcYkGl09QAEeKpiqLtI6NQ+Pg9v6RlNQF8XdpZHO1F
	 ghd9dajlLG7/wKRtoXC/h1aaLF0pb7ZviOYNcSZr6CbhuhpDvIddozzgVDQ9QJR+6yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IHGdj2WgFNvFzJzZmT7b7cak+O0T45b/pueYHZiJloY=;
	b=Moz29v9Pq8clQQWgay4TmByt7y3Iuavwlp6bZrxzYQQm0yYn8AG6oEZLND9uGQ5jBIOm
	 b2AInx0agqt+k+UE6hbOmrSS8Fg0JAJ65oSAcz53pDn7s9FrVFpOFCu1hw/rab1nbR9y6
	 nMqfsz9S0wPjQYk7Q4EbFp9xjHJroZcAFHQNVRKdonljuZBmhKiU3EMK3H1/1a9ilSzCq
	 CxQ1EpnOKTN1OtKx11Vo9oDSHrqeI+e+kYma568aTCWGSr4l18qwcE5hs85lFXyYZ8ReR
	 bD/cmEzeo8zTWy7HZSP/U41vVzRmy4zLK4JkbkHaWXOhafP0TMvET9Qtx2Y+ODZ7ghA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8czSalu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71409606A32A;
	Wed, 18 Nov 2026 20:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8czSalu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB11C1F000C4;
	Wed, 18 Nov 2026 20:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033658;
	bh=IHGdj2WgFNvFzJzZmT7b7cak+O0T45b/pueYHZiJloY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8czSaluA/Xcgh+PsgYk+zsolZ1twxqJgEYeZlqv+hkqOa2KEAE53NZW2E+xZOw2y
	 eiwA9ikMkd14bzS7DqJGVQHZ9BMdrkRPQ734kGSY9GI/6qbkgJfNV/j7DWpgfTou7Q
	 fjSTW0cTyXJeQYc3widP+oo2fiCYF4xPshw7EN2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0093/3318] usb_string_copy: Use kzalloc() to avoid leaking old data
Date: Wed, 18 Nov 2026 15:11:55 +0100
Message-ID: <20261118150316.951128778@linuxfoundation.org>
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

From: David Laight <david.laight.linux@gmail.com>

[ Upstream commit 057df423bf4747091cf942af57307627e941e1fb ]

If the string is read while being updated (which is why the copy is done
in place) and the new string is longer than the old one, then the reader
can read memory that isnt part of either string.

Use memcpy() to copy the known length string instead of strcpy.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
Link: https://patch.msgid.link/20260608095523.2606-37-david.laight.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 75392bf7bd34c..78fe6830a0ecb 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -125,11 +125,11 @@ static int usb_string_copy(const char *s, char **s_copy)
 	if (copy) {
 		str = copy;
 	} else {
-		str = kmalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
+		str = kzalloc(USB_MAX_STRING_WITH_NULL_LEN, GFP_KERNEL);
 		if (!str)
 			return -ENOMEM;
 	}
-	strcpy(str, s);
+	memcpy(str, s, ret + 1);
 	if (str[ret - 1] == '\n')
 		str[ret - 1] = '\0';
 	*s_copy = str;
-- 
2.53.0



