Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051045;
	b=i7NMJrHSkHL4+zG/wpgbJGh/C29faYtoKkgjgPKpm9BEPYb5iw7upIsYh5FRYMP9DJRo
	 +nikF5bJARBomZBNNYVNUAQnSSjOfaR33ewErqHdnhIU4WXcbONc2ffmdFqtyaBN+esim
	 9na0qpTpXBgOOiPkvQpuVV55iSAcCRA4/Zds4Kh/88kTUgdUNX2os6HVUTVvAi5kaMjPN
	 vI9nUBEb4lMJqM+TphyrdLPkty5zchOmT1ngb3A/8esE25F5D/YxzH/tzP3lwb22uYuR4
	 b8U1G/zcsM9+xIuZTDzOdUP68546eqQWVtUpwEopo1bUk6iQNIY8MenWQ1f8A++T4JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2JT/sl5FL6sMVufAFS/ZMJ+ATzd4SCGWVJyh+4trVRM=;
	b=oBkjtVGGd+uuMJ1jXe3E9GyY2eAHcHLr3jcoswOvDiRwkcXMgl4q/1vres+/belGPMdj
	 QQJPfw+XTCXQXUhHLzy9ojabTnAF/ti1DKH2ogJzAmED65A3gfGc5UaNbDanE9JOqv+Fw
	 O50OtKlSy1FHKHuaUd9BZ18JoqJgHn7YLy25BEqq8dnSXO4IAUdA6qRoO7YVPEZPD5Bsr
	 YehbqsrPNYELM5gIuPuW6DVeZc1bMcgL5x4w8mUOfYm6sN/MvAlTOs5UU2MLcrg5kw/0P
	 Bbbq8PUsbfJ0Q2oEymH70QbKRHvyvDNUfTAVJgEdC94T1865+cGL8TjAn997k0nR+2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tl+E4M5O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1E2606A31C;
	Thu, 19 Nov 2026 01:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tl+E4M5O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2FD1F000C4;
	Thu, 19 Nov 2026 01:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051045;
	bh=2JT/sl5FL6sMVufAFS/ZMJ+ATzd4SCGWVJyh+4trVRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tl+E4M5OKf1Y3Vi9yMM9xJGPl5FfNb4aSBGueI8Sp2S/TKYdA0IITcStVmRlJJMjf
	 FHhOSoQDW0NrjPTphehn745c2PQ1K9wWJcHk9a5Q3OL4Xuf+vwdPWK04ggjhvtR1ib
	 3z1DDKGDGkdPlgWayiiWWGqOap0nOZE8492O+wQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0068/2214] usb_string_copy: Use kzalloc() to avoid leaking old data
Date: Wed, 18 Nov 2026 15:29:04 +0100
Message-ID: <20261118150012.721661633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b2e1b3ac0487c..5fc740d329550 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -114,11 +114,11 @@ static int usb_string_copy(const char *s, char **s_copy)
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



