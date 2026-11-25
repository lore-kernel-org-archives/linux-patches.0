Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619456;
	b=2xlRvNcVC+cM6iRAorW0s94+5g7lKhGsjRL7+YacA8XMIPkWP8d02iNMGMcsLp5JPMB/
	 OuUO9S/PEzjuqI4a/b5WKN8C91rClOS7cL/4hxege0nWkV21BUPlH0zYk9HgwlitVzCtr
	 s+N5xp2mkqEbO1Leul1E1sOsHD8o3nAQzwjiINGcytUmAkiGLwgxkhuSYdiNVC05wbY6O
	 o1Jv4w37VvwfGIR0KrTQdx5VGm34sYkeIhiWLiL9c+IAi3xqFthMJu/KIT1iXkcQxKJhd
	 6XkigbKsBfB76AIhAe2uLophuCmE2rH0xRFAl3DV4aowvdxTcE2MZ9mPqmEydu3V7eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ic27A9N353avVMBaYWayr+hM2+uJQnNaQhwQpoYu3nk=;
	b=M9YfButPjrJdl4QQqAxp7vylqvK2VOfHR44vEtSNNpihQ/zTmDVNvZ2J1CaDcJy81X3A
	 TU1YCMdC2NABZzdByKxrh+G33YVJBA67BC0rlIgPDklIZKEieqNypvE6VcbSoPaag4N8r
	 8M34UENcdU0wW+QJEHBLg+WGLO7oL4xfMfYjjEBo1qQc+hqdlMGEiVyfvF+dmSELDyamQ
	 x8+SWbWZ37e9JT3LlPvRFDB0G214L+2QzcEg8wGKttLayTdEWDp9ykuFIcvcNgFMncX1e
	 sog1P00DgXxUyDqm51HPC1qdRaVTbOr1IlhsjcB0Aa3CNzVFwQKpPYZPiMcC+DMkCIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sr4xoLuB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3514D606A31E;
	Wed, 25 Nov 2026 15:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sr4xoLuB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C7D1F000CF;
	Wed, 25 Nov 2026 15:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619455;
	bh=Ic27A9N353avVMBaYWayr+hM2+uJQnNaQhwQpoYu3nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sr4xoLuBZsAzKeFeixNI3vdUW+FjtKHyneEU7lbd2jNFtBt6HFnRU8x8Q1e8SCG1W
	 STDroh/D0V7EWqoousFTRKsaD3cGKKvr1ehWNgu82BCT4Bwlm4JoVSUVk0T/GlDcc6
	 L7aJWUBzsTmqgzwSNHVzBRGcPHfA4YNDssL1ie5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0557/1005] ALSA: aw2-alsa: select SND_PCM
Date: Wed, 25 Nov 2026 15:31:35 +0100
Message-ID: <20261125143834.797547485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 6366f72b36679..9c192d51ff445 100644
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



