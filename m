Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027998;
	b=MDfOropHy67P1w3I+A5MGqtaBHgTIZBbYklpbK+OB3I2ubEVFyU1U+0HHkCUz/1doRNP
	 WNGPWw0IJmXwEadEYz8H4LQq8NXXSgU6Tj2pKxaMRNd0pEcr0QekfCqqH50FSBE98LJep
	 KQcQCiRtF/S498pBsT/v7UupUdLw5CytTJaPl6ciePd5xnC94gq5W9MC7krOnFbZHoqsM
	 JUJNrMqVQap0bSAoJ3dUyFfG/4tPpnxbfsgbcicD3IvIGknXCz/Zk+lkU2R7/mGR9NkFT
	 7V0LmRisnBmWF5/BOkhhNrF9SaIlTWl1SL6qFAKmeduYUZ6jH9nE6jVybnkJulv/ksA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A6plR+S+otyPaYsnPvOxTfHyczIDfU/4gILuE+t5oWk=;
	b=LZES+SFSGDaTm2oNKfdN5jJR6+nWSVuDRL8N5MiPSDYzqpFmcY7v2E1pcs6I4vXT/rXW
	 46qXvAKOSCq54zG0BQlIEXp8Gabue9sWwg6Z+xMqN1gG5vqktF7wKvYhSY0g+OsTTrv29
	 6qN+iiHn3zkDeWa0i9d0hdBxqAfjCwwqIrs8gezncLIkcMToAzA7odggzc60Ge+Q1cGX4
	 miiBFaThUikJQynujan84FyAXtO6XRcgix1fpJmvDJcpKKE+qaSEGKPYM6lCwzkxTYfLm
	 SvVcxyKLqPmF88Nxp6COcSyN+8ihpPIpFYl5y1/pyCuHJp2rZpCX0lvWPXaOuQLvTXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5tM6Cb0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDFA606A31C;
	Wed, 18 Nov 2026 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5tM6Cb0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53ED91F000C4;
	Wed, 18 Nov 2026 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027997;
	bh=A6plR+S+otyPaYsnPvOxTfHyczIDfU/4gILuE+t5oWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5tM6Cb0txS8Ik0vhhdtH5SFZDThFeIxHy/VH9C7OsbRVC6ndrq4cJE3LFlqiN2/P
	 o0d777W81VQ9L7Qfx9Vws835zLbFplKi10D3l9swwJVa6u/LxCabKSHG/YEaXzdsQm
	 3MMw/u/qhH7vBEAtFhu1VEeNRtrKsZ2RWCeHbnBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1987/2151] ALSA: pcmtest: Honor the enable parameter
Date: Wed, 18 Nov 2026 16:02:02 +0100
Message-ID: <20261118150234.109789033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 5a016267ed8a4..b63df0623c73f 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -763,6 +763,9 @@ static int __init mod_init(void)
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



