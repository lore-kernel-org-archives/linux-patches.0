Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039704;
	b=A8AQV2Zp6aXby3YxjvhdrSWmSjw4zhFgOYq0ns7+t17EGasL1as8OI+q4O97PgCpzf3u
	 VKQW5iGjDvEBlx6ErWUHNq5MJCk6eQS1X/2OW2MQs8gzjol9okA8XIL+qYWNCtuygnoIP
	 C/3TcdQtC1rSOFIZRJxGiZWefLg8dcUjImfcpstkNhQF5IUGajJtQwKQ0CrDijZr/lb64
	 /GA3J2g4o/Yeq4+xMnOs3vylWg2uvAj7FgjZI89PK8jsf99sY47h6tv4bKZ29VICEZ7sQ
	 yoOqSFEUNQCj9gce0NJ+kAhi4gQWkhCYq3ZvRgP0bT2m2CMMsRya4qdCwWH06BE4nGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+UYWMKMgDBKg9nTqCLeE59LevM60s/lkJQMlnN4lNj4=;
	b=w86uHdKxaP9NTB0vwC2T54LUNJvIM677pAg9dQ3xL6ncy9BZ33vc3ogEPUt+WRs17UFi
	 TFV15ZcL0SbNY9oZZtUYFl99CF+zucyWt5WfQz7u9F9j2Pn8QFih1d/W+rCLZCg2Fz2Qv
	 i0z+AZp2it9LIvg2qnwKdUNGMzOzMCkP3R5IMxSnv/QKh52N6Vj/wl4NzZdMZgPWCvXmP
	 E5du1mdYRNttYlAuTuKdlWmkt4r3HjvlRG8OqGKQjYtIaFX3ciTbkD7oDGL/5k/+sAWEL
	 p6bVHqBM0M7t2wGx2aaSwrBU+INT/WpRf3wtIrpI/MAKsXfNO8oiPYBKU5cm7ypT6Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J25gQCy3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3918F606A31C;
	Wed, 18 Nov 2026 22:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J25gQCy3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C3B1F000C4;
	Wed, 18 Nov 2026 22:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039704;
	bh=+UYWMKMgDBKg9nTqCLeE59LevM60s/lkJQMlnN4lNj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J25gQCy3KY+TSV3WhTFPmOXDSfse0xG/WaQYSLa9CWshCPSBcFY5qX8fnAw7LdwPT
	 bd09zZnAb5muPnI6GW8aUL/yyfW/3sBZ2qx804SzM3rtXJIRMvQTcAeGIePdpKaaMV
	 PN2LCzeYbdRXm1eUB6xEMpoK+wki3c8NpGhigaig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2196/3318] ALSA: control: Fix virtual master creation reference in kernel-doc
Date: Wed, 18 Nov 2026 15:46:58 +0100
Message-ID: <20261118150427.822265168@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit a347cc458d97ecd8adb5462b91559682a70aced6 ]

The snd_ctl_add_follower() comment refers to
snd_ctl_create_virtual_master(), but virtual master controls are created
with snd_ctl_make_virtual_master(). Correct the helper name.

Fixes: 79c7cdd5441f ("ALSA: Add kernel-doc comments to vmaster stuff")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260912100548.86134-1-kmehltretter@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/control.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/sound/control.h b/include/sound/control.h
index 9a4f4f7138da8..f4e230a5dbd4b 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -243,7 +243,7 @@ int _snd_ctl_add_follower(struct snd_kcontrol *master,
  * @follower: follower element to add
  *
  * Add a virtual follower control to the given master element created via
- * snd_ctl_create_virtual_master() beforehand.
+ * snd_ctl_make_virtual_master() beforehand.
  *
  * All followers must be the same type (returning the same information
  * via info callback).  The function doesn't check it, so it's your
-- 
2.53.0



