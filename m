Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021864;
	b=3zq2lHvqtpQ1SVGVK7sigBOx6IgxVRKio+VDrpDB6DHnA8LrLydwzuqzdUY3TFSeqpvJ
	 y7eHKU21KHcZZsnGvyCSW15llmQM82lQxlrs6a5FfKGxvILxwqiMr0ucnFT5NiXDZ3fow
	 8vxv+qk3VWJYBnu1XcC/D86xJatT8iQFNoMlqwor3wGGgfWIt09tPfOHxckasyptXsvJe
	 yR9UNQQB1zl3CniQLzwrDvacuoRFxq40uVLGIYEg78U+q+yy1se9aXWv6SDGw+8BqlIpQ
	 IAvVK32kLYbp8iYV7ba9+F/1JPh7FKpL/YdFeHWYLCUdEkrgemapOw3oiSJwTP/ACIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=em4UAC44xFIFIDHwErtQLxFrudqoW5KUR6csTYDbSQk=;
	b=CD9CwMD/VAVqmr39zROyuamIlbXiapUxEF7M31FxK19wpRpYt1L4Ezo6Vo2MG00+H7wE
	 QY/72A1GfCujWmpjP20e3C1YvKlwCNV1SeXnN4rETHXtKpAK1sRGiTw00hzhnjG7VHvhx
	 cRrwX9VHa8lo/s9ylWHIEezzKfghfIqqlVkt+e9w1TSyEN1KmjfoquMjY1r7gyqzKB9Cn
	 RimOA5Ao6KmqeLujT4OW7Rcjs35dZNuG8fy2aZrw6Ra6T4ERwLFukGQAvRAfYwJbC5vg2
	 /CtreUlwBI6t4LqgG0FVgFT72A7FFFmY06oCew0tEmL78QxW8nSboS45gYoDcs4tcYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WyqgcXLk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB44606A31C;
	Wed, 18 Nov 2026 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WyqgcXLk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6421F000C4;
	Wed, 18 Nov 2026 17:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021864;
	bh=em4UAC44xFIFIDHwErtQLxFrudqoW5KUR6csTYDbSQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WyqgcXLkNx/UFAXmUB5mF/FgOUeEbPejM77jmQbH+h4NAAoz3v7knlbHGkSi+8Xbo
	 nwh7dUtRg5dMZekruvLnILVwM48ans4qUx87VOsOQRpNfsHJmruf5c82ONJP2on1wQ
	 xWKkcEEyH4byfkHyJCydLvIrtRyBrE1NmmlSwSsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2459/2651] ALSA: pcmtest: Honor the enable parameter
Date: Wed, 18 Nov 2026 16:01:39 +0100
Message-ID: <20261118150413.584834924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit fe3b45a0875a8b0944d2adee3ca62283d876edc0 ]

The enable module parameter is declared and documented as "Enable
pcmtest soundcard.", but nothing reads it. Loading the module with
enable=0 still creates the card.

Return -ENODEV from mod_init() when enable is false, as the pcsp driver
does.

Fixes: 315a3d57c64c ("ALSA: Implement the new Virtual PCM Test Driver")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261027012228.3797565-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index b3d5218e89db6..a42d9d818e4ad 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -717,6 +717,9 @@ static int __init mod_init(void)
 {
 	int err = 0;
 
+	if (!enable)
+		return -ENODEV;
+
 	buf_allocated = setup_patt_bufs();
 	if (!buf_allocated)
 		return -ENOMEM;
-- 
2.53.0



