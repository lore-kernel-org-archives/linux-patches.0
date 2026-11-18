Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032842;
	b=sEe11S6TtTokfbzJejIPg6rQZJUnA8qQRF262OzMI65ycWE45LChvAySDWL2twbwLZ0B
	 KwEMk57CgVbRWauWhNc4mqFNjxgfOuBU+78XQVcsxyh+ErXPH/x71t6KrL5qPUYunKMrH
	 Nj9zfh5M2cWAUqgSM2SBsdrscRBYQmZmPdB0fsIkmnlOCDF3/wFK8TZdq4L3rLLVAed1j
	 Up4DWx3cuZ2d8IxFY3rAfEhogVRYimCUMxx1wROst94hh3EGFVvWN+LM1XkwMaqqJHR7o
	 OJG0QMX4J/pLvIZ2/sDq/rS1jd7st+P4DM6yGsAWNtIMLlJpqZ7mNFucgNutVhxn8oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1LLjBFsLlZJtTYxtADnmOjNKjE2I1mG1cL2e7szgSE8=;
	b=MFMf1vN/b4tZI18GoAX9VPS2gSvR5SEEvIS8lUOe0Q/tCe83dAOg6/09mVyXtwgOeGIH
	 QgX+grPtjj0fsz2B77WW+dqvbKf2rNHkWgkP4YofSdcwtNTR7XbTShhYnK0d9MIbseK6a
	 +iIZqb4fadcUHGMKZ9McZD4OQ4hi5F5jw4Y+WUU/5ZcaM4P8ZQlOS5itcnxVwuD0r51mt
	 cS+VMdRxw4YAdqDcc44gfkXSpQFCY2SSHzyx7L6TteyT1rFf0ElPspbvQswJ0yHJZWjY8
	 ECycihzGrjMqb2aeBfMxex64FjFt1ipbGfu91UmDnYNcHfMb/iuXUMAGyrCjQBvBnUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbJlooie;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0EA60A380A;
	Wed, 18 Nov 2026 20:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hbJlooie
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E971F000C6;
	Wed, 18 Nov 2026 20:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032841;
	bh=1LLjBFsLlZJtTYxtADnmOjNKjE2I1mG1cL2e7szgSE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hbJlooieVOPN5eZP3uVI2lM9h1lr5i6TNYJWcClPxgYo4FRiRz1Nj7tK7Nm2BhBaf
	 r8LrA3hr7zGBTD1y0teglDO0sZUmCc9Gfd++/eiI0gjLYn+D8CrxLJhMGQwOuAXHc6
	 7wI1pWeWYc5GrTR2O5kdY1cgPeqzs7VKTullUqxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1553/1756] ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
Date: Wed, 18 Nov 2026 16:01:20 +0100
Message-ID: <20261118150110.942507689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit bbde9d5bdd2d7cf94707b2a8bb466f2e074f9db2 ]

mm has recently moved to a strict model which requires any driver which
clears VMA_MAYWRITE_BIT to be mapping non-mm-managed memory
(VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT), failing any such mmap() with an
error and a kernel warning - see "mm/vma: only allow mmap to clear
VMA_MAYWRITE_BIT if not mm-managed".

However, simultaneous to this, commit 71c610aeb177 ("ALSA: us122l: Prevent
write upgrades for read mappings") updated us122l to clear
VMA_MAYWRITE_BIT without marking the region with either VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT.

vm_insert_pages() and friends set this automatically, however this driver
maps its pre-allocated pages from a fault handler, so never calls these.

Simply set the flag in usb_stream_hwdep_mmap() to resolve the issue.  This
correctly marks the mapping as one whose pages core mm does not manage,
which has no meaningful impact for this driver beyond preventing the
mmap() from failing.

Link: https://lore.kernel.org/20261023-fix-us122l-mixedmap-v1-1-e7bdd053850f@kernel.org
Fixes: 71c610aeb177 ("ALSA: us122l: Prevent write upgrades for read mappings")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: David Carlier <devnexen@gmail.com>
Closes: https://lore.kernel.org/20261018025905.201296-1-devnexen@gmail.com
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: Kazuki Hanai <hnkz.64@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/us122l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 8880051927044..1c36db0af160d 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -228,7 +228,7 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
 	}
 
 	area->vm_ops = &usb_stream_hwdep_vm_ops;
-	vm_flags_set(area, VM_DONTDUMP);
+	vm_flags_set(area, VM_MIXEDMAP | VM_DONTDUMP);
 	if (!read)
 		vm_flags_set(area, VM_DONTEXPAND);
 	area->vm_private_data = us122l;
-- 
2.53.0



