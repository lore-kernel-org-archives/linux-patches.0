Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048209;
	b=ezPj8kJK79Rb0FB09BbhMPIckHJ8O2uk3gQCC2c1YITyNu712D5b74eKkGZUdk0R60Kg
	 zI9N2Vr0JiCkICUu5yer2Oph/wf7JgeuzI1h3Zz0Q2kLSMlUQZl02fiHC6WrH0MkRTcLf
	 oZRQX734hwlEjvLsmP17rO55dfgJXKIidt+OCWWTb6K29810plNLKzLOF+lw2IhC2Xc3Y
	 rIKKzsk0B570O5DKcOneyAiazd1PPNIwHzJwIGMN0Mz/A5UNuG81jS1/3b60tjGn6X110
	 fyCyPycNXVvxnd/ktUAE7c6fv22HhUk9MzEYdB0uA4hKUZpGUX1JQlhw2dVU+kD8K5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NsihK2+L4oPefvxRnAlsT/ePrG3H+bfwFBg76h9KyLo=;
	b=fo7UF3EqX912uw+EBuAVsLiwD2KLodxMhe+GBmKY8Rme+5iyJj7B6aI2vfH+qoIbVc7Y
	 2/do98u7Vf1qxoye63Ir6Ta85qHYVymHqcbzqTEhcmc7CM4E18LEgqZh+XTpMLp4XeZoA
	 eId/rzVCJCWlWSbhhIhTU1R5VH9X2JWCWtzFFddnyuVfeX0nm5VKtacF6yxhpdnP+ENFo
	 9ngc2cq+ebLmb7YveVS2Mx6/AbAk2l95TVniJYNJhzH7jXtMfJ7+8m1ILLuQgUnvazU+i
	 EITRoO7w1ws1Cter95jHwVVABZ49CrcDQsai39TX1+a0jd+oLPGluBsI18lEGqU41UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MehrsnqK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B1E606A33A;
	Thu, 19 Nov 2026 00:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MehrsnqK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0758A1F000C5;
	Thu, 19 Nov 2026 00:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048208;
	bh=NsihK2+L4oPefvxRnAlsT/ePrG3H+bfwFBg76h9KyLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MehrsnqKvQxxMcKAHKFaMLpaZc0W8Jsxy/EY+p+4xxQV4ZXTXBfgtC9c5BUJZBBBV
	 cHI9CwrWdWgvfWIHz5hXaZIr5eJjQRXoGqIebBU1Eb6288yJx2nMVb7zyShNztMjLu
	 5fdWfqvPcN1juA1vEWdq1ZUWjwTC2flkzQtgaaUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1914/2857] ALSA: control: Fix virtual master creation reference in kernel-doc
Date: Wed, 18 Nov 2026 15:49:08 +0100
Message-ID: <20261118150310.132426558@linuxfoundation.org>
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
index 42e8dbb22d8e9..b0d4257d105c7 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -221,7 +221,7 @@ int _snd_ctl_add_follower(struct snd_kcontrol *master,
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



