Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056195;
	b=KpuI3aJFZB3BzacQWo3Ib+UQk31Eb3Rvvwz6jXG0TNA4afaYB8dUSJ0RFZZD7PvNTErA
	 PtmSTnwOTaz20MjHQQr5pph9bBxZKQBI0Isx6qZ6aAbL0AENd2MnDwxFs2VdAz65hnhJL
	 94OZhnJRBPS9UI4G8Eiz4Cf037OrKIWBZ218ApNwi2CjrZW24PCujvbkpMnSgSAoiPrzQ
	 LSXg3e/PWjGyVvci7r6xKou+GHusLbK25aknJhlKZN+q0Kkxkus3Q6IodzDo7zPdhUkGy
	 /Q9szyXMlS32DP4Nxg4uceUUp0VOYdHnVMaWCN8urIPDpJPYaJXcpQrkMoFmOtrgOMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ydh36IqmxvbYzkNMCh+ioSCN/S2Vt6uHFWhcIjUK2Sw=;
	b=O8xd7cgcQdF/ZPl/8CUVUb7O4qXfe7xkhyIIBrWS1pOSAgqY8QaSAejzWM/crodyxF3F
	 5y6jpPy+9YMLm3442vU0cNPdrmtzqgj22ta5iMSlS7oDU+dsHQ3KJF9oVBMpaCFofcwhc
	 DSGzk7NP3R76ENxdh1FFfKMbFrom5XT2FHUm5HqjnqRgLqyTpcxp6aLciU+2r/g9ww9Ll
	 ueJ0DNR9egyAv489w/s+B1IdYNH+4pZn5RS0NV57NXEKdOgNYkj1n15NP7W76Ckgz2x3W
	 q9KL5ZqUsDEndV53OEgpZ5Im7YJLwvLa5/arGXknfMF/8N7jcl8LD3Xee75dV+KRlRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1cicohj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4008606A320;
	Thu, 19 Nov 2026 02:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1cicohj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCB21F000C4;
	Thu, 19 Nov 2026 02:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056194;
	bh=ydh36IqmxvbYzkNMCh+ioSCN/S2Vt6uHFWhcIjUK2Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1cicohj/65YYysdPom48LqseBae62sxexk4aI0aJ7KO7CyZ+057iIsxuvTM8dRA6
	 iQYhuNxfFU2XkRSrUu/mFN5HAV4kv3Rz/lx5ElIR7MZ3LWSQCYoYwOWblcoJkyd2DD
	 3QSUqT7I5N7vvcyJxhxQT5d5Jq90mB+rhpLFoZB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1861/2214] fbdev: gxt4500: Release WC setup on probe failure
Date: Wed, 18 Nov 2026 15:58:57 +0100
Message-ID: <20261118150125.785921903@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit b71e0bb7ad40c005b167e9b48be3af5a3fa51974 ]

gxt4500_probe() adds a write-combining range before allocating the cmap
and registering the framebuffer. If a later step fails, the range is
not released. Add the missing cleanup before unmapping the framebuffer,
matching the successful remove path.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 38fc4d45fae5 ("gxt4500: Use arch_phys_wc_* for framebuffer")
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/gxt4500.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/gxt4500.c b/drivers/video/fbdev/gxt4500.c
index e5475ae1e1587..a9124e1dcbde4 100644
--- a/drivers/video/fbdev/gxt4500.c
+++ b/drivers/video/fbdev/gxt4500.c
@@ -717,6 +717,7 @@ static int gxt4500_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  err_free_cmap:
 	fb_dealloc_cmap(&info->cmap);
  err_unmap_all:
+	arch_phys_wc_del(par->wc_cookie);
 	iounmap(info->screen_base);
  err_unmap_regs:
 	iounmap(par->regs);
-- 
2.53.0



