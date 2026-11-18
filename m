Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060188;
	b=DZ0t6ezJ5szz8DuXs4U4Fd68VtazBJm4QQrRI+OYcN5aUgtaVQAwW4VZqsAF/nIweZ/j
	 Ug5d7JhjYbe1VjARYxpm9oUJUjcFv1TTALzCq2UfjEP6yp6C99IQBPMnWLCV0a7QFGwvC
	 NDwPAnUNmdfEM/AYkRBMWYApmsTw5vfN51Kt4um3FNJMqRTSjBqvKENSnlE2oPDramZyQ
	 COgIK+DXQxE6fNhN0blhhTsWhL16u0i4UlnB7CbBlDkPJx0gqvzkkateMDrG6MiaW4dcF
	 O8CINUhwIfvsN54gUFsMZ0cCzb2iV7J16/0+shFx0YauLdrFbpcAL0raoNTz4W5RVcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DWdObXrWDU0V79SbggWS5DHtTwQgrdz0Oib7jsY7k6g=;
	b=jAmL3LVzOEDYz9S4y2rWRdfauGdhWqKviV/mgWVa3uP8ICgrxh90w750imlpONmueL9Y
	 oOqXaZKeh/UHcm9kQ46CRPwBExEeGcvPTZbrxn60Y6Vh27+D+WSKSbt9oZr5HxoszwV0T
	 boE3I1T9cj7hU6Uqgrg6PaY6OhhWDokNT3CkjBtqY03b/C5OdjAWj+AeJSNl9wTsJzAbm
	 YJ5oPESUZRKl3kqSTy8PGILQDtGth7JfBtxIREDCTAOau01rwLHZSBylO1LT9CxxN7Ydf
	 H2XFi7OQ/0WXJRL2Y2fsTj45g6VOIisoz1TqarOr3osqhqfJjpkMpdHC2UNVocefV/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rLyN7MtI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC63606A325;
	Thu, 19 Nov 2026 03:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rLyN7MtI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9E51F000C4;
	Thu, 19 Nov 2026 03:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060188;
	bh=DWdObXrWDU0V79SbggWS5DHtTwQgrdz0Oib7jsY7k6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rLyN7MtIOsB5dGUfXks+yzBHCgVzptPLq0v1rgZlCsb/F5RVkEDrjkqEeAQY3Ia8k
	 YIL5SzygbEAtj2QGyxF7Pqa974TjbN/HZtV/nCQfDRRs5oHnf61lmLdgw3wqyFRJAv
	 /KXieSllQPK2Q4p8/95v0yZ9PyMr7K+pJmCkc+sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1067/1848] fbdev: kyro: Release WC setup on registration failure
Date: Wed, 18 Nov 2026 15:51:45 +0100
Message-ID: <20261118150002.378813087@linuxfoundation.org>
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
index b298e9a1b4510..c9f8875e34d91 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -757,7 +757,7 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fb_memset(info->screen_base, 0, size);
 
 	if (register_framebuffer(info) < 0)
-		goto out_free_fb;
+		goto out_free_wc;
 
 	fb_info(info, "%s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
 		info->fix.id,
@@ -768,6 +768,8 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+out_free_wc:
+	arch_phys_wc_del(currentpar->wc_cookie);
 out_free_fb:
 	framebuffer_release(info);
 
-- 
2.53.0



