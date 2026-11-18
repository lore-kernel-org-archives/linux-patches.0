Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042521;
	b=A++y5GaM4RkIFAYfzdCmIgkVwEk/xdk4aoOL5qeO6EszoPUUqJXdrm/wIhkS/8HgiUFQ
	 v2EHgEpbPJKGnaDrrVJc9NirlMziezdfGMPKfhsQprr8KEYJ6gwTwucCrTlR1P6+2A/Gl
	 nocB08MTkjzehtKVyJB0qxdvHRe1zpl7cdSLEa39fSJsBXEvQ7Ad8Cqox2zYkU07gtvSp
	 9ZFRLdOm6RXTYgGwkRTSBWW3tChDT18E/LFr+SPSLR8uCWJr0WoeyolVV5z1bd8HFlrJO
	 kNtz9IJ8jPvrdu3fn7WEmf+qc3s5pxkata8+j/tz55NBFrdcOKZuzVvkygZjWVJI4wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fJLVH4TrJQrNFXQ+t6tmAzO/C450BvBWJwbrt2kOhx0=;
	b=tczfkycrFtGQrGgLs15tPJGLYGv5cquxbG0FOmxFy2b2C3IVmLKHH1FE+R/ly8poVqyP
	 iy/nIJjdQgxbdBG/tkS1F0GCSZLJga5e7f+T/b3tNlJ8Kbv79aounX0vaOWKKRMcjojAR
	 R82QSRxWsRUUqpGkiX2QI2xiWIikVtHvQhDXRJ2yOgC4Mr5PXRDVuNlsuzIEUycdjMfb6
	 GqoxlEvQIupnnSFoAOBfE+RPUh1vl6cmLjmVIRVYZJpUjdW6m63enlcdazSAPJ8saRiZg
	 wBXQVq1XfOwMDbVURrrGMNYEEUAB70ytyUlNmlvv+Bcd30dspzRbrD3HukWWOArXwvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nX5fB8Jj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1265D606A325;
	Wed, 18 Nov 2026 22:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nX5fB8Jj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0601F000C4;
	Wed, 18 Nov 2026 22:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042520;
	bh=fJLVH4TrJQrNFXQ+t6tmAzO/C450BvBWJwbrt2kOhx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nX5fB8Jj5hrrOBHBYPybzmun4m2fzxhMyXTdZB94RkjeunIAfZo0OkEynP/0C7G0Q
	 +azugITDMnBBbbU/sa0HuO36Baa1adwx+atFVyCrHpYeKHHpXPNUy5wqm7Tvn6EtQV
	 G/ea1Ar+f1AkytKtAHw9m5+4saJqA9pvlHRB5dLA=
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
Subject: [PATCH 6.6 3160/3318] ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
Date: Wed, 18 Nov 2026 16:03:02 +0100
Message-ID: <20261118150454.658197749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



