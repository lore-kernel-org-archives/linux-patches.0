Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051270;
	b=SPgqU0O3XAdg9lZ1rMqQ3tv3KZpxNyGn7pDd/tmhEdadSHFzcZCerWyGCZKf5RblpjJc
	 JsmojljiqaT4yKClkzof8NTjm99hOjjjgyfh2+o7bi205cwHWcqHXSSNKJ3K2LlKfhyu7
	 xqZjEgcwJ2VMQJQ3+wcqElKLrtLvufQkJ7xvueG6k01LImn12HFi1ZYzsIxpwZj6bVCkU
	 RphHRQog+I0EbdOe2i5WyI2FGGBRfHq+dc2BwnLOdvDNRVEtLpj2ttN4Twgpn13bF+/mq
	 4GYjPQncNpIvfj1nGKIqgVxOVLcukNynmOOzGF6CK28fznpFarskEZvZwc3HsiV/Hng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nzH2hHCx/Q+eYaDD8OoPVItME3jqvsVeywrkhZKxpNw=;
	b=BBTKa9IRfDQdrvqWgkaRLvHAdXsXSGJCc22qgYQjj36u3UNZKuKmmS4GdKZYfzMfgjup
	 pr/vcluz4S19V16PN+nFDSbGUc+ZdHjV+Z5Kgz/5aKvdwoO0SbpMUTyZzqiFxeaZZaULt
	 JUEISxSlRdx2g0a8+rE77UyRj4RS7Qz9MPOmUVOCXkX0XIrpcqxGRWVdD/yjF39dmhanm
	 qinDdDDv//bagPMZfio5CtPI6CNmVAtLqW8jS3aBI4J3e7bpkF6xDLdVdN95j8q+3rAe/
	 j07o2/zr1tygFkgS9+WrmMgGQRKP/7VAMyIeZihsCHeN0YFsSibxR8Z7/t+KqBaP0UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOphn1kH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54048606A320;
	Thu, 19 Nov 2026 01:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOphn1kH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCC41F000C4;
	Thu, 19 Nov 2026 01:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051270;
	bh=nzH2hHCx/Q+eYaDD8OoPVItME3jqvsVeywrkhZKxpNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOphn1kHq98ulwaIorSIFB5cOOjCGM+xBRUm7h9fUx2QHhJ1+EoZnKA3wMwxK0k8E
	 nv+COLrQ5b48XnudubG5mIJbikRSNKoXkjoLnhbfeNhJgwPqY84KILiPBv0w7nHSry
	 68Qm6sw7SScyUuBy+7p9AJq5MsidWaXas0nZ+Bi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0149/2214] ALSA: hda/conexant: Add NULL check for dc_mode_path
Date: Wed, 18 Nov 2026 15:30:25 +0100
Message-ID: <20261118150016.121719115@linuxfoundation.org>
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

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 273806f38ce95c95c288a03d3de1e423cd3e5543 ]

snd_hda_add_new_path() returns NULL when no path exists between the
given NIDs, but olpc_xo_update_mic_pins() passes dc_mode_path
straight to snd_hda_activate_path() which dereferences it without
checking. Add the missing NULL guards, same as the local path
variable already has in the same function.

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260729070935.548050-2-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 0a2ebb8789bb3..44b1d5c3ff993 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -467,7 +467,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 	if (!spec->dc_enable) {
 		/* disable DC bias path and pin for port F */
 		update_mic_pin(codec, 0x1e, 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, false, false);
 
 		/* update port B (ext mic) and C (int mic) */
 		/* OLPC defers mic widget control until when capture is
@@ -503,7 +504,8 @@ static void olpc_xo_update_mic_pins(struct hda_codec *codec)
 		update_mic_pin(codec, 0x1b, 0);
 		/* enable DC bias path and pin */
 		update_mic_pin(codec, 0x1e, spec->recording ? PIN_IN : 0);
-		snd_hda_activate_path(codec, spec->dc_mode_path, true, false);
+		if (spec->dc_mode_path)
+			snd_hda_activate_path(codec, spec->dc_mode_path, true, false);
 	}
 }
 
-- 
2.53.0



