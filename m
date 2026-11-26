Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704481;
	b=DEcjawSawt71aXcJtBYuMjci91f71xSRWg5RZjFUNIOQm7Wi1494wjXX6KhJmU7jU3tc
	 yKG6YusXqETYaE5AQHm/yx62l7jHOkLyBs+ivdmk+oM3cF+xjOAjV+8G5nclOCpzsY3Os
	 4GPPxAWNu3HOHi2AopbtZcW2ofQZjfg7aVxmvgMzWj5J2p/PsaxQPRpR6SmXsj9QLg1QQ
	 Q5YS6/2W5Do3YvM4/+I9FAMYQOXn3p4zGoxuZj/bcgQcp+a2S/F/ByIzuUKGmy098wlzC
	 +dQr4/7LxeT/xTaCx8Qp95D0TKRl2HBZ03USs9UPDFBJndUIECh9AaQX9PMGS3JBtPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kloywYBphTk1HPJsMCMmC2CcKaK0aOzNN/hOWUmZPjU=;
	b=HJonPwGVeJ9gItRMTVoQbuSyq/atOCqvtZA1AGfzvu7WwVOKehFTqU6hX/TxvWltRQ39
	 PzL2Az9jHev4QTDyLHNabk8gN/9V5GC/mydqGjmQwkvcPp93t6ycApk3vpkjZdQrZw6ji
	 U12yfkY5IuVb6grIsnwzDxpYtS1EIKzpzF0v2C4xmdDwQUaHtdo8kPc852vl4fXifjNg/
	 sD6tFo73b9nnjBGRnUksKUkRw7GMbsHZKWJ1Ofi89eK4rrivGxRGIG9D7eK+kmdYYi3Ve
	 NJG0GfMtJ4mFi0rQIG2OB6h5NflfU1KCyO6+IGnLokxhyQADnwnAuTfJzIeMWNZyUcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lmc0Iahv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5A8606A326;
	Thu, 26 Nov 2026 14:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lmc0Iahv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961A71F000E1;
	Thu, 26 Nov 2026 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704480;
	bh=kloywYBphTk1HPJsMCMmC2CcKaK0aOzNN/hOWUmZPjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lmc0IahvgTy6UVaPcFdKlJFcVZk0brrnJ+T1a6kYbe1qS4cCLie76nrk8XEScVOqR
	 odmTnCTDEl9wQNLhLGaO6JiVk3tK2J45eIB6t2ZrfHKgnbBXVyHuQzOvmgsDQjVkxv
	 ziFWSlKTYkMAez7omu4ahdQp5aYtMnPhFn+x/gtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/265] ALSA: aw2-alsa: select SND_PCM
Date: Thu, 26 Nov 2026 15:37:48 +0100
Message-ID: <20261126143614.687110385@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Jude Gyimah <jude.gyimah87@gmail.com>

[ Upstream commit bca568589ad118a9b0bac086760baee2a41976a5 ]

Several stanzas in sound/pci/Kconfig select SND_PCM.
SND_AW2 selects nothing at all.

aw2-alsa calls snd_pcm_new, which sound/core/pcm.c provides under SND_PCM.

  aw2-alsa.c:(.text+0x554): undefined reference to `snd_pcm_new'

4 symbols are undefined in all.

The driver can be built into vmlinux while SND_PCM is a module, in which
case the symbols are not there at link time.

Select rather than depend on: SND_PCM has no prompt of its own and is only
ever enabled by a select, so a depends on would leave SND_AW2
unselectable.

Reproduced on v7.3, arm64, with CONFIG_SND_AW2=y and CONFIG_SND_PCM=m.

Found with kreach, a static check that compares what Kconfig allows
against the symbols the compiled objects actually reference.

Fixes: 98f2a97f207a ("[ALSA] Emagic Audiowerk 2 ALSA driver.")
Signed-off-by: Jude Gyimah <jude.gyimah87@gmail.com>
Link: https://patch.msgid.link/20261113064614.15045-1-jude.gyimah87@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index 41ce125971777..ad7ef4d12f85a 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -137,6 +137,7 @@ config SND_AU8830
 
 config SND_AW2
 	tristate "Emagic Audiowerk 2"
+	select SND_PCM
 	help
 	  Say Y here to include support for Emagic Audiowerk 2 soundcards.
 
-- 
2.53.0



