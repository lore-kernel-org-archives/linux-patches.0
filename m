Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028677;
	b=2tZV46YaO8KGUHOMEbcyGQY0MfcVgEZ65v6lNDmuf4p9AEAU77jFsI4wtYktwdBQu+H5
	 ZjC5iybgTzlDkbDlolgbVNyy/P288ecVryUgofSswvcAR1D+hTjHKSvCqRa/aVm8iYf/7
	 /x7cDjQyD4BvaRqj6uM/A1DBHtQVNiorIIQLkBYYc9Bgwvxlkh12h1+eXf8P1Fbyohjq/
	 oy1gtkD5CHspFKVk/cdGNpXD+tAHUa8kUcpdBU4kGHlYH51WhFd7tpiWgoVd55DAd6fFf
	 tzikbAxensevb7fqchAwaJxYGyVSquijL3W4xoxAEmbQB/3F2BdghUUIDtjYzYCR2Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xeobXbjiGb56iM+knxrwEq20CeEbiyVo7hrlfTBXfxo=;
	b=kTOGP7jY7efXwt4bP1mvBnWlwoIHba9OassgEe0rMRwfLdIdEMQCU908OZRUGJXp4ivo
	 H4fYMtwV/djNxKOeeMT00uo9iFHUUr1SqLLQp9qnNg51fWFvtcryHgi2BxMWG9nZHevWt
	 NcqvJQf8hlY3UPgLrK2508pZpQ1XSbvaUbbyrCDDCwjFZVGW1pDEzrdOnH8FFagbPRfcH
	 0iljmgFhLZfhjfvp40HitTbdoPeF1LXi+KLFdB94Qf0dkyyZsy0JD7BzkC0xvypdnvujf
	 vgWxvCghYpi+Fq4bhWzP8Pxy2fGPrJ1ePVqGZ6pKepzZXHT7a/U/CMR5pso9ltheQ7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kYlTKnS8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CC8606A31C;
	Wed, 18 Nov 2026 19:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kYlTKnS8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A841F000C4;
	Wed, 18 Nov 2026 19:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028676;
	bh=xeobXbjiGb56iM+knxrwEq20CeEbiyVo7hrlfTBXfxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kYlTKnS8Mg6DTbkqNQEltD+nPHkIGFUJndUlmbgkJmMiCz2nKhJm5BpZQij7dFD4x
	 94ijgw5YRSEaymBD2dBHetRSv0jQK++kzvNM7PmNSaC5hUuGOfpXmEuSJCWe6oABLO
	 vTlSI8lLoNghZxtyYiMS6ay6A40xydyr0z0/qmP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0081/1756] fbdev: kyro: Release WC setup on registration failure
Date: Wed, 18 Nov 2026 15:36:48 +0100
Message-ID: <20261118150011.502831166@linuxfoundation.org>
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
index c387bdb1e515f..f5439f34e1336 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -761,7 +761,7 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fb_memset_io(info->screen_base, 0, size);
 
 	if (register_framebuffer(info) < 0)
-		goto out_free_fb;
+		goto out_free_wc;
 
 	fb_info(info, "%s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
 		info->fix.id,
@@ -772,6 +772,8 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+out_free_wc:
+	arch_phys_wc_del(currentpar->wc_cookie);
 out_free_fb:
 	framebuffer_release(info);
 
-- 
2.53.0



