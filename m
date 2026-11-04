Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829697;
	b=rkMZM6DmHaz4/lnY2qvLn7zJiQWwXjH1DZRwBJPw6Be8/2K/fCW2smHNMbLpIWrcGybj
	 n6SwBgTwH0kqSnkqRXovT8a4fEVPyS+eZjRGtJp3iG+xrMiLyi/GcFHRoD/4k6d8+U8PQ
	 /C9YMuZwV8TtKxxO/B7ZlHBKOcPd7quPiCD8lAXagdXg8HvHoeoYgskgNmbL+D7xWmqsm
	 n8mrJvWR0fPXe19n88NutJ+lEZgwuda02eAyXmHSXaGv69bTbA1KEsAAKgytB6ska4A/u
	 y90HS7LiegvuKJAg0wY0jm4UJP5B24Z7xpyoBWtotw2z4MkDRpaECnxs8y2hqyFFAyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ujy5fQG0uffISfv02eweb0dF6nn9TqASB4TJy11+aKA=;
	b=zd/e6ZkLWtaRXOa806QXSvamAsFZAg2eJqOlVkBzmrnWT/FClUruVrImQ40bQc+zs3xT
	 DjAXMd+iGtG1qfGmMIAc4P00P/UzHKGSHqMDmZgMX5DvBxhi8JYzkmwFbBeOmnD64aBZl
	 SeFNdfbJ64IaIaPdSg6x9ZDE3AddzXQSVh1cpVMPKjwBpRiQ6OrM0MzgKhnHjsKeeaRb6
	 T0lsi5rjtu67VGtPG4iF3k+r21nmrc37ymymgVb3UBE46NCirMXYKiZvCD/Fn+0xsh94S
	 2ocuxnjAfAW9LgFkscxVRB5C4dgIqS/6NaOADHNyB41AcesR1I3lB6SmUsFMiNl/2XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2FcS3vy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04CA606BA30;
	Wed,  4 Nov 2026 22:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2FcS3vy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8021E1F000C1;
	Wed,  4 Nov 2026 22:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829696;
	bh=Ujy5fQG0uffISfv02eweb0dF6nn9TqASB4TJy11+aKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2FcS3vyXbFrf6U7xzGaKCk1ubZBVunfmNGpaVKUkii4gpuTcwXsTfiVLF8bE8qQJ
	 wJ2gezd781K7R6zmmuuE5l6yo0FjSPs9YZRqg2erNy08TJK+6ATj8PqBuZpVs39uW/
	 NF97ZoDkA8QjcUeF5/nutKrMQKzKvqomZv3qhtDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0286/1005] mfd: ipaq-micro: Fix out-of-bounds stack read in ipaq_micro_str
Date: Wed,  4 Nov 2026 16:00:19 -0500
Message-ID: <20261104211051.909945814@linuxfoundation.org>
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
index 4b757d8472825..5146a6eb0e5a6 100644
--- a/drivers/mfd/ipaq-micro.c
+++ b/drivers/mfd/ipaq-micro.c
@@ -221,7 +221,7 @@ static void ipaq_micro_eeprom_read(struct ipaq_micro *micro,
 
 static char *ipaq_micro_str(u8 *wchar, u8 len)
 {
-	char retstr[256];
+	char retstr[256] = { 0 };
 	u8 i;
 
 	for (i = 0; i < len / 2; i++)
-- 
2.53.0



