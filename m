Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051281;
	b=hl9ZqTJqBGwt+WIY9+/i9wjv/I8wjg4cXf2OVhtmfxDCXSHomuLjl6HunbVLUROW60J5
	 Pq68e7D0villaHTFLVHOGRkdz6qhtMuZ3XOM4pjCW3JzgIxFq2p6gu43NJiQnmWrwyLaa
	 H7FNa7BdT5J59Iv4b1iJmEQn8nOc7IskbSSQxpU6ON9opQEIZRvHtMwTeOaA/1zVgyjj+
	 0vuCqXdORzxdZchnUHQ0g3tG3WWy4ja/5IIa2o3M8YqsehbQNkI3N9wV4l1Ck15NreZ/p
	 QCqUim3iZpnUYRLCUJD4HgAPeNNIV1HjgB/sVUKePxCv5FpHuylPked6a7rPk29EnDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x6v9wE3KTqrFe2aJ31dYpyO2FK9Gblyz1dbQwoh3g5E=;
	b=KV2nkv7G9YE6FB1FrdsfyUzWzITF1kA+kGtJFD9JIpR4cN5mJRRaGwTrEEzs21mGPPYb
	 U2W4bhI+Sa4ysaQPIBKk06Lon/SjffNdpA0WqAAphynO3jPYFrXy/gn7arVZ//W+DtaE+
	 oa590za8xGKL9WqBbo53jCuzGia7hkkPX2GEmaJO9rRcjfzGOKbBjLbwpQkeFUN6BRL9z
	 SRGW8ec+tkGmY11Z9UleGLX8HaRcViYjWFz73lkFp1m0VfSJq8Bf6lZe4oQOIBD7Xux7/
	 cBgZZF+CaBDMKplbNDt101ZyEUcLkR7pvFGnsvqQi3qoh/V198ISvE5b0Div1w0UyqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FkTN1oxj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B7C606A320;
	Thu, 19 Nov 2026 01:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FkTN1oxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CA21F000C4;
	Thu, 19 Nov 2026 01:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051281;
	bh=x6v9wE3KTqrFe2aJ31dYpyO2FK9Gblyz1dbQwoh3g5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FkTN1oxjqCqO+ohB63ZrZ2cv1e9BGVLhjkftvcaKp0iC4FTIRvx9ius0sAa3RlRe5
	 XkwY2L5/buwXVfozQw8L9JmdhyQYG6flJO90cQcsl7yKA4LKG0lgx4kUwA2SCvE6WH
	 92Z2r87dT9Ri6V3+NLLT+p1eQKVzettbXuANy6pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0153/2214] mfd: ipaq-micro: Fix out-of-bounds stack read in ipaq_micro_str
Date: Wed, 18 Nov 2026 15:30:29 +0100
Message-ID: <20261118150016.270595401@linuxfoundation.org>
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



