Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064698;
	b=SkVvMpVgEw+j9AORbCesH+xnCmpMU3Vyg9c8zZZY6Z6QsI1hMbbRYHswec1k8+jlT6Hz
	 3qxqAPMkHClPwTBghm1LHEBvrHM1TYH3OaPWV1th9oTMvoY6x46QO08DCd6sM3kFvrh2u
	 0NiGdOt6hZ2An2IsXkZiGSQwXDJWo8DkX+JWPhY04TFTGYDjj8j0yPntOxDyQibff4J54
	 gfOXqbOrFlmdA1SebWxTlRuvlJ9NuWt5AATT9o+l8NqsuVthFLyWJiWlc6v6UDdjj7l1i
	 z6/b+SW00azBHk/WngGYWtcmUf25SMqhCCBt27I4zcYPevxMSglZBbCq6yOy98PHUXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LftDHFS5KoXkz09GH9nmkzOTF7OQemvzX52lDVY4N9E=;
	b=PTKnVugeNh10kfSj3shKv5f4YsLOskxKZO6bvZa4dMBNIrCOANGC6KKG2yNloxzMxVsX
	 rYmeibwBL0eHcXK+t/vXmE6ydNPoRwk4hyFdeyu13+X4/CuDSwKAk9673CCSHFRaAJ0CN
	 y0yrNBeTOABVHw39fjCuQxAb0mZcYo9d0jHYzRFUuQWJ3QlrIx15VCpJv1VKXiSAH9KOX
	 3zGXIsU3pBee2FpIfVYh/zbH6+Jh+pRaD+dvX0opcFgJXL8qEVVbScBZKoR1MKI/rslXL
	 d1xnt6ycaBhS0hRXEHFNbBB3Tyc4SfjlwSehBGKtk0F5yfW1z24jZ/9XAfB1eiq9oyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4uKx1cp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26105606B8A6;
	Sat,  7 Nov 2026 15:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b4uKx1cp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F071F0089F;
	Sat,  7 Nov 2026 15:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064697;
	bh=LftDHFS5KoXkz09GH9nmkzOTF7OQemvzX52lDVY4N9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4uKx1cpsPGRRdnq9npUtu6j34B63IWYKS8F1ZKSi0mh04K/NqcXC65jNUJxbW9L/
	 F+cv9F1GwEYO6TjFd09IYzx/4leY7Jcy2bpCKDAzZ268lAd8KCoKAjNqSGv9UW+4jA
	 w2JBGSBRcVZfrvbvJzcCxVuwnRBRYQf4r1mgD6/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0688/1257] fbdev: kyro: Release WC setup on registration failure
Date: Sat,  7 Nov 2026 08:49:44 -0500
Message-ID: <20261107134958.269058095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit d3bc005a62945aec57059201092b12b7c955e5a7 ]

If register_framebuffer() fails, kyrofb_probe() frees the framebuffer
without releasing its write-combining range. Release the range before
freeing the framebuffer. Earlier failures still skip this cleanup.

The missing cleanup already exists in the initial Git import, before
the conversion from mtrr_add() to arch_phys_wc_add().

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index c237389888229..94d6af54e6c46 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -765,7 +765,7 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fb_memset_io(info->screen_base, 0, size);
 
 	if (register_framebuffer(info) < 0)
-		goto out_free_fb;
+		goto out_free_wc;
 
 	fb_info(info, "%s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
 		info->fix.id,
@@ -776,6 +776,8 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+out_free_wc:
+	arch_phys_wc_del(currentpar->wc_cookie);
 out_free_fb:
 	framebuffer_release(info);
 
-- 
2.53.0



