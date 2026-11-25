Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622265;
	b=nl0snfo1ZN0tdtZLD0KwrX49nK8S8KA/YQ2aC21yTRKpeFfi2NkAJoTVvoAD/ZcH9Xfa
	 3nmrYOezL1Arf2X+7LFhRHTIfIPYIsU7RF37hJcZWqt9T8d1yYqShhNavggGoHLtYHKTS
	 ZUkKFYurvVsJTDom4wLymFPVNp9vcJPFyQqFxVNDmIPg2hXzG8cGdAtMCNke4432WbyAR
	 4qQ/uFuu7XGzJBtwbkYrJOB8/U16sgNHptW8mK34zQlaX4OcKG70pnPHkdFnVEzlcboVG
	 +zJs5I37FyGNCAXtT1X814ZMfYg8aSQJPsKUUn4sJTIafQmjV7xg6MkJYvKsLXdJe1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u7MzaZ0VCr8LpO+lYOKh5fKbu+NFNbREgGu7UhoWc9I=;
	b=gN2ReMA7xRcFLOSbHuoBWDIJa/zyJQneFONPwW2X14ouFhmExT/3tu+5gUhSxGswvIrm
	 uAGt3MP0v+tZfaAdYQQ4/CKcWtD+D1e4WJqCWeml8Uiw56doTXvnDfsE5eYFb8oe8fjp1
	 LKCikEBKLMMVMdlZnAJLvUny+SMrdnaHsIhPqSLpFgrStOjDW45hGoC3R03nKvGptedDN
	 3yZoAXr9l1FvONxd9Au9Po+lDqFBRQQDMuFBv405vvB9purVz8Za5/FhA6qGWogpZBYfm
	 iK4B0DA2fggzkQpxBZtK6rMAtyspmI/M4VqZZhUvRheU/jc9k/EE0aZ24lhYGQI0nAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="at/C8bou";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2793606A31E;
	Wed, 25 Nov 2026 15:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=at/C8bou
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF131F000D2;
	Wed, 25 Nov 2026 15:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622264;
	bh=u7MzaZ0VCr8LpO+lYOKh5fKbu+NFNbREgGu7UhoWc9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=at/C8boueQ0eSf88S6VAIw0q4X079yof6ZsEH26sA+9zd76qx0FDsQOGCc2KBMoTm
	 yo1W7k6zhZ6yKG1CI1Uc4Qh4AsAmeVegkyfQYpZCguxJ2trEttrnGoNd4uYEhwr8gt
	 JODBjZiXFxT94nMYnzMvIAe8aDcWOkIkVjTb5Kgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jude Gyimah <jude.gyimah87@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 481/990] ALSA: aw2-alsa: select SND_PCM
Date: Wed, 25 Nov 2026 15:30:48 +0100
Message-ID: <20261125143833.361625859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index e0996a9d90b03..776d778fa30ec 100644
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



