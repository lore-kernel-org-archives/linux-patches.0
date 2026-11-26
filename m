Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705350;
	b=vY8d+RdtIT0UK9gzSROMrkfKmLtB8PWDFoXaO6fyYGTzpqdysBL8p6G3la3s/Nwl1utd
	 xf55nwQEmKBZtgfL1UnFGM2pwmKpOP+wc+r5AJhBLPbSYFURV9t05bb75w2oxMdJqyAR7
	 NfQUuRVpVK8/WY8aoQiAmnjZU2bkCWkSBfnSsL3icR/oX3IcSjk2gKxpgJllLc7On3acX
	 uQQLhNGSPVZ7junSdvKVy3zQYFrYlrkZ7T1j5aGACFVXiS7emOxz73dwj/L4d5g4QhIhw
	 DQ8voCzgyiqlnt2AO4OfUbNeBAex3ZrNzoLEnSNEh1l7YRRuYR4eP+HtrNsRJXbbgkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yZYWlu5xKu5YlveUUCfX7D+PkidxjVZq4U1YJxEinc8=;
	b=MVyJTYS8qVoSjUKtWeA+vEsqRHS/Bqsnn+IGkWK0/ALiCjA3OG5ARLD+R9hholuEJfU9
	 glQ9fqtq37/wEn60NpDj7PYFXwNC43k49ftbsMz4Nn5VNIGQ69RmosxxqS8DrWJbctvCJ
	 tkg8mwfyRWvRU1HR5nHWiYeBJ1Jpl+IsrcCT+4gUMXU6h8Mk/CNdaGsm5sWD5R6m2EihR
	 3gQrhSNyXVbR6VdIecOsQ8oYHWwRNdpINteWEUF0QGA4Hl4xi7XsU10IMnMA2UFz1ypBl
	 ljNi/WmIKFwoQCRFTtkHqSksO9c8KWbmAIAC8cAiDvhx5ONreIjvfwpgr1hqr01JD/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQ2HjASx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF43606A323;
	Thu, 26 Nov 2026 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQ2HjASx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0542B1F000C4;
	Thu, 26 Nov 2026 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705349;
	bh=yZYWlu5xKu5YlveUUCfX7D+PkidxjVZq4U1YJxEinc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQ2HjASx+POyocpUgblnAssEobvayA5wkLnSWGSeP6p4dpJS6TrXyPZGsAHQmzlsp
	 VBoCgfoqBhSd0Da74S26G/RVVHb6TbUAqQpyYQhxYAxTFBI42bqvsiYrme3LUGWum3
	 j63KvksxXXq5LPx2Fmky5cVS19ye4XJb3kbMB4UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/319] ALSA: aw2-alsa: select SND_PCM
Date: Thu, 26 Nov 2026 15:38:54 +0100
Message-ID: <20261126144010.493407593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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



