Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043322;
	b=116T3ezpHmfoTwSAFuuSlRjce6dMYIm15hIFQwgQl3QBQxz/QqvfZpTb3R6oxc3XSret
	 4CnuvlWEi9IURkuEIU5w4Z33jNBg20c/upGQTkbSg2tJQWUHFzlZYlEMfaaypMUfnOgxZ
	 ru3qBj0GP/jTo98OcAHytI593QfAnHB1tq/ajZZewUO1LZph0dMs3IG3s/YlGsi/Rj/6O
	 yoxFc/Wro9EEWShDdKRJUNRImQ5Kn2kGAXjhQ56gSCm8EH9Qdg/pM/7hlZRn+9WjGIPLy
	 pWUJfMjBih6a9i4dTJ/ABYNT8DoVooiUjLKtAm3e36CzB8gOCS8KkHCkjoqRLsXovHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ELP6ekmXeCLGjRhIp1nWOl+e/9e9vj6VDXJgg6DCaTg=;
	b=deEFtPEoDzpkebrJ9FVaxhoqSkhiTv4bZwSULn5utme3nW1misWKdqRYx3e/15/ZagWA
	 WplGWOjv2eSF0JpNEx9rIRCjZJ8Wp50Zw9XKIh1ciINGFhjUIOrp1FgcjKvT30+vlEQ2u
	 i/b8LJhp4YE8inFI/8wuJCC7bM24e28inaJFMEs7liSHWSC1fCJbRhX5BVoYo66HU5c+m
	 7wptHLEsCpk4ZjOJu0r11Jh9U+BAN6pTny0ga+uvr6KdNaZ9TCMpl0sElwGSTKq9tCmbs
	 Hnv42SxKqbWwde3337bh18/HnD19mQSPnk5/Wsjs0ktSN3fxDO2Fr1k0gyO4JjlIMjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1m+W1EY2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F51606A320;
	Wed, 18 Nov 2026 23:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1m+W1EY2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82AC1F000C4;
	Wed, 18 Nov 2026 23:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043322;
	bh=ELP6ekmXeCLGjRhIp1nWOl+e/9e9vj6VDXJgg6DCaTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1m+W1EY257YaQvVirLENBvvYU2xSjL2+StCsddoW4vXB77godjIE/hC7zhXI6mOwF
	 Rzy/PWGpbvMArzSyLmUvsKjcOhGE20SHPePFxjbeYagOQ1VIQiSmMoyTtEn1kxCryM
	 iXQZjCU0MLULPJLTTKQtkJNxL3bzQDMl5Zn+pEVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0169/2857] mfd: ipaq-micro: Fix out-of-bounds stack read in ipaq_micro_str
Date: Wed, 18 Nov 2026 15:20:03 +0100
Message-ID: <20261118150207.437904256@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit da3a98c941753255418616d249e5b40db0927c26 ]

ipaq_micro_str() decodes a UTF-16LE string into an ASCII string.
It copies characters to a stack buffer retstr, but fails to
null-terminate it. When kstrdup() is called on retstr, it can read past
the buffer into uninitialized stack memory, potentially leaking stack
contents.

Fix this by initializing retstr to zero.

Reported-by: sashiko-bot@kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Link: https://patch.msgid.link/aintJF4X5tWDW-Ej@google.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ipaq-micro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ipaq-micro.c b/drivers/mfd/ipaq-micro.c
index 4cd5ecc722112..d1f3b2b7989f6 100644
--- a/drivers/mfd/ipaq-micro.c
+++ b/drivers/mfd/ipaq-micro.c
@@ -224,7 +224,7 @@ static void ipaq_micro_eeprom_read(struct ipaq_micro *micro,
 
 static char *ipaq_micro_str(u8 *wchar, u8 len)
 {
-	char retstr[256];
+	char retstr[256] = { 0 };
 	u8 i;
 
 	for (i = 0; i < len / 2; i++)
-- 
2.53.0



