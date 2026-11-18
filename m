Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055054;
	b=TFvhY+XxRv27qf8IlHrNA+qKDTQHOD9DtaNvgVYMOSXaJb0e92ZcR8qEgi0l1egaRX8o
	 Xf4q5qaYEWwX6jm6PJxYQNJ1ITjVh+d5qEY6iJDrDME8D9mwUG9GmHH35cVXlR0L+lRUD
	 FxwNirb0j2PBO1ercM8quaw+p+PTkjXrPfFJc+V4920J9WFELrcUmhaAxl+TYhjicBFDf
	 FtduoxDVaU96QdkjOaKj8hPT+lmDxhN+x/pEE7EDZ1kgg0ZWfBcYrNKM8VQyPwEk9tVra
	 PKpuf3O/O/dwi6uHniunpL7eYyaei8uJp0PavUguNfESx62iyEckUp4kQPwZpR7GoIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IedkeWax+CVbd8XUekMqYWAm2R1oFY/t2qlxHpyz9zI=;
	b=oiFAbnTVkFA+FZRk4uZTuYBhHVphy1CW6+mCnUXtrWXqZc1wEYcpnU5ZsQd/BI3kbw0C
	 9Gaa1FbZSspRVb6satyhOUawvMHOJDEnLY5V7JnCI4W+wxymrj8RGOPl08r0Fl1DFQybz
	 6VE2jsgjBX/gE6P9AxK715UkFZ+LlSHvnsPSRQzdA0X9G08R52HRwjiEJDy1opnF0v0uW
	 gKVL2OGKFtPUcpdSsrLobmfngkakBkrYoNrKELF/sI0SCaIFX+WLDPbyccRHMvAm3c9sW
	 9aJ/qhNC9JpoVQJxVnbEl2xILDKEPRQPALCC7B8l+SdJctMnw4m2eaareOrDKl1HSqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SxmgMEF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72198606A31C;
	Thu, 19 Nov 2026 02:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SxmgMEF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF521F000C4;
	Thu, 19 Nov 2026 02:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055054;
	bh=IedkeWax+CVbd8XUekMqYWAm2R1oFY/t2qlxHpyz9zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SxmgMEF3xDfPkaXCokWQhzlfw5d2UpPoZVW+mybs7von6eFWN6RPaaJexGmMgaPLo
	 PFdduO/Y+J6KZ6XwHmS1qqmknJwUGTuXIqpecWJ/SNgwnQV+hEcRXvkJHcn9LCqPPF
	 MruXxMzbhsbQbf8jklYPpkIKkBK30dIoIm31nC94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1493/2214] ALSA: control: Fix virtual master creation reference in kernel-doc
Date: Wed, 18 Nov 2026 15:52:49 +0100
Message-ID: <20261118150111.176053677@linuxfoundation.org>
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
index a1fc7e0a47d95..b35ee47f4a6ba 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -218,7 +218,7 @@ int _snd_ctl_add_follower(struct snd_kcontrol *master,
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



