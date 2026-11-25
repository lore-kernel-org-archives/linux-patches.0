Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624968;
	b=2nbZjL7Ip98ra8cPAEhPzMZo9nKnpAPbEepzdxpBsEx3+nKcUYdDi/7n1HkB+5FhaJRN
	 5OS1TP8J4Fx4/PMnEugqfcDmc40YE/SAiLtjKwd1q+qIme2nIvUXtfya0m5aXKBthkvzo
	 vjIzhsOnXEFq/o/3pBRBE0yZYb+yy1cYYNNF8XUWv5RDVTmMVWvedPcTss4hICqvvP4qP
	 znpL+6bAuEBspdCoI/Y9tFGDmK7uA922tlX0H96ynPv+s9YtD20BsTrhwnicSZm5geUEl
	 l87tML6cbbBYp5uAi+kcJVtNnx5PV3HSDlxCFLkZrn52rvzz2ktYmE1t4YwkguzteNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TfDFY69S9o05OHDfRDLolt8MrjTEeyzGGRaD/0nFkIk=;
	b=IFqvePDBbIMhtolLbZkhCF7k7bTa/SGRh0/rRJxKvdGxU0tBhfWgmQUmRA0mQO6QfPYv
	 Mt8rzFcQg+vjyvSJlcvhaXMqHkBExJhDZUm/FoaquHw4aHpCc3i3Y/sXMesNhDrNMAqeP
	 vJTDswihuS5b7y2McRUorLKZRP+PlhoWHWEKpWyUQGhCmtOgISZAp6iFjkaCkZE59hOUO
	 qCnqMu867Gm8WmVHYiwA40zMiGQnReU8ZJYUE7siBSdbNC44I+pJN+0hO9Uq6UBfcYVR+
	 qwfJALNnHBgrcU007K8PS8EoJErdrOK4GzMwSZWOEJ7dyOy51KopktI5a/6uSOEcVMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LhcYxkmv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDB6606A31E;
	Wed, 25 Nov 2026 16:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LhcYxkmv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3F31F000C4;
	Wed, 25 Nov 2026 16:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624968;
	bh=TfDFY69S9o05OHDfRDLolt8MrjTEeyzGGRaD/0nFkIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhcYxkmvNEldtwYC3CkoktOH38YcYoMyQYas/+1yYwW5cL7JeV3IJO6o/WXiUHEU3
	 wApAPLYIVlI0ZyGFTl68756QREZn7grxYNoFfZoO3tDX/iYrZ89hGK4dB9g50ENqDU
	 5K+niRFp9yLiEF8vog285L3fdurOyJ21RbGgC+48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 361/816] ALSA: aw2-alsa: select SND_PCM
Date: Wed, 25 Nov 2026 15:31:49 +0100
Message-ID: <20261125143857.554158160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 787868c9e91b0..cb8af8b54b280 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -141,6 +141,7 @@ config SND_AU8830
 
 config SND_AW2
 	tristate "Emagic Audiowerk 2"
+	select SND_PCM
 	help
 	  Say Y here to include support for Emagic Audiowerk 2 soundcards.
 
-- 
2.53.0



