Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038954;
	b=d4TDOgmfS7tOXlv0MyBzoWUUxZrEDKK86bFpM9BKbVgq+dvye6UQGO5GnTCRhrl/TWzN
	 dR6ws1QaT2yyxdAectFzs10Tz+bVHZHNFxCRQbIXgzYd3IRdCfW0Bg1sfLaGD/hdb3qzK
	 L0sTKzCAgthaE+P8rNbuE+5fLDffGmYlPxiL3DxLpi4cDvRMtlOI25drsQzJWPyvxyz9K
	 5trikSazBSqCkGFs9mjG+PlUU3f4XM3nMypE3ywco0s5FusKam/VUE/4o2RgpEjQlhDAG
	 SK7jMYloRcarH6sbv5jCTU4t313rRA1YcGw1ul1oCNVNfkELcKcS9ku1Ykefu+7Qn5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X8+10U4zf7uLztOKMPDqwUQvB+f8HiOXMbZwcq6pwRM=;
	b=HvfH0dM38OEcJKIWrVlkpqcEpf3a1vi3HbxpGUQbEQv6hfsz+6QzTLOXDlFVOpXSAvJH
	 6GsIGdwAwJUm0ZB1UcFvm0tTNDd8NMiSKPQt/Q/RkE23YQgN81RoP0tkPkwifnPy1CoUU
	 Cs0kGj/4WNdoett5nRyGpEo3obAnGfAiiKwbEx2lc9G6NsCBX5XxyHxOfKjDjktm9z4sS
	 JIjI0DYmAtBrjHTxcNY0ZY4zysdl97FaWIV0ryStEqV5EspHa4bw5anWOBOeovLcifNWu
	 frUJYPe/kXan2XSxYobueXAjHXOta52z0QRtpmCISigE7CSpZQBpMVT8OskZFNp8Bdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DwoWX4jZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AEC606A320;
	Wed, 18 Nov 2026 21:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DwoWX4jZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E6A1F000C4;
	Wed, 18 Nov 2026 21:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038953;
	bh=X8+10U4zf7uLztOKMPDqwUQvB+f8HiOXMbZwcq6pwRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DwoWX4jZ7qAzcM5JjcgvJFMYxvTZ6zk0oAVRLMyLSDYh6ecC8ub+/Tks6a/+TYHuW
	 y2DpJ0CcvbIhJVYGobdp8YeqKc3QvNOCjlTi9VsoSYNBXYaxxyJ7ow09r+2+tgWUya
	 983Th0Kk58agM+ehJuO3aKO3VgXMMIOrCTiGxI2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1928/3318] fbdev: kyro: Release WC setup on registration failure
Date: Wed, 18 Nov 2026 15:42:30 +0100
Message-ID: <20261118150419.872801619@linuxfoundation.org>
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
index 06bdacf0211a1..986127294e937 100644
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



