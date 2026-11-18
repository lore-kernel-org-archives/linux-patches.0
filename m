Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060684;
	b=QBxRJNFjQVgyyR3bCsGmMsUcX+6aU8QFdYXUdpaD2v+K89K+QBChuzvoyIwJVvivRL+B
	 Kh7pUqXjkpPqbUUhd1HbMKskY3tkX/8Yp/lTBIffptkolxM+F9Fp6blJlTl1GshkgXiKr
	 imtSetLXe1xjZVfYJkhMaxZeH/9qxvcmwOD7wWkW9xzehKA2BGxTA4T0M3QU3Xt+n7Xuq
	 0pjYVcN4FI0O5sXYhrNduzR3oIlbtmQ55SIIWc8ew7fo0+SHqDS4Stjv3siQXHqMxVfRn
	 ja/lnU6Q6V9AR9jt5osXbNedLBoEsQ/EDx5yg1Vrx0PkwReeqHtiiY+JC698wcnzo+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kBX0Rrk01DBzPAJePr7Iu6j/C+mfn7WgcfZaV/iWDSM=;
	b=b1koPGLPehypj+HMYrCLoVXDmzhQ3sAcv9W8srnuXZQc7xjBBqyAqoSMkJejGwNURsGT
	 7FtUISnZRGp/QfoNRWsqewMiSZAJfrp47oFrqB/S4WUGKfzZN6j/T6oLXdLxCZ0GGSPuJ
	 FDsl7yK/qJYcREKrYVXYQtTuxXx9ZNlRH4aDh91tD1tKWJBnFNJX9fwZ8WwOr6ZCBVDVZ
	 lSzPsjM9ymKadMvn/r90HwfKkdnxcOkfvUQTpzIHIs+tnq+OZOffIe8JU74j9kdOmMyhM
	 0kq8zdSSm4LPpm6oIo5cndN4JHaMJOW9hkG+dphccQNp4xS8i9D4+AhUAqn2jfZ9eMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l+H/qn3c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D831606A326;
	Thu, 19 Nov 2026 03:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+H/qn3c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AE91F000C4;
	Thu, 19 Nov 2026 03:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060684;
	bh=kBX0Rrk01DBzPAJePr7Iu6j/C+mfn7WgcfZaV/iWDSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+H/qn3cI1L5SkihKhreYPPqy7kHqoyluvV1M3w9QKIurK5OxzKf7HJmINxgu/BP+
	 O7ogBEmnhv7B4bJQv4NVSI7I20sRgHNvPlTPUkyStEvra05i6TnyyFuHAto/iwrACs
	 QFMPl5RqEQhrU7ZNERiSCf2Ouvop0R3bYNbylwcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1245/1848] ALSA: control: Fix virtual master creation reference in kernel-doc
Date: Wed, 18 Nov 2026 15:54:43 +0100
Message-ID: <20261118150011.939738895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 41bd72ffd2322..055f8e619b21f 100644
--- a/include/sound/control.h
+++ b/include/sound/control.h
@@ -200,7 +200,7 @@ int _snd_ctl_add_follower(struct snd_kcontrol *master,
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



