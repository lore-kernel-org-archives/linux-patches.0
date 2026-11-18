Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019727;
	b=4ISgaLD/BYWd8uwyhDkHbXtkRtlFIvNnntEcZwr5/jPArWvRCAl0WR3U+9KDLp0sYjCz
	 Njge9Vox1w4ktfqefbxEqC08idDGiKhejXoEWvUF9QY91sEmqjBC9vYoM4Dz9Ipgmc3EO
	 w7lukey/TUqHZH3E9heuQlth7SLSvjdo/EiV60RSVG5A6vIcf4FbKyNq5g7jQKEZudbA0
	 GfEXV0qS0kdYYamaI1oq4iu03eHmxQR+xKzDOxIbXmDifgSpr9srclRCDkfQz3UW62/Pb
	 RrO5mzfu9MiErtjOJn5KdH0zbrIqU0KC35mfZloE5fqFiO62Io4QUjqkzJGXcUQBA3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nPyp3qzkXHRm1xtb5zy1TJ8IBaITmPAnf/BtNAfPXo8=;
	b=payJayivZKRlK66keqS215qUNn+j0W2KrsyUeFTf7s1Rx3dbq+klSKrCwh3CPi4lHb86
	 NprikKEkLWHEtFbD3mesFhI6YyFnVxlqDzskr527fLBZyQB67AVjx/6DQ1/5YAvmsrcIH
	 iiGQUFWQgtcX/dOzrwiEqAYDRUhno4h6h630tHEuWijltrKCjF+rGpj0g5Oe5lD3GoFEP
	 UXX2QY8Uo8PNqccTLyTBuV218Myf2/CrGcCwgjvp37uFHygQMf7VSqm5bJUuYA2wf0RsC
	 6Y8aLuBnsPmNmEnCER97nQS7j1nb/DRiKLx/PLXTJTtCoUINtSXAHLmpyKZSt8uIOdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wx/eVnHR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9069F606A31C;
	Wed, 18 Nov 2026 16:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wx/eVnHR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF45E1F000C4;
	Wed, 18 Nov 2026 16:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019727;
	bh=nPyp3qzkXHRm1xtb5zy1TJ8IBaITmPAnf/BtNAfPXo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wx/eVnHRRvheaLKV57bSaS/tJxO9uDG1wP36BapBDwQ5YhvKMP6OHwMlvBLmyirRa
	 9HqJNy/znc83r8fj89ePgHb0UeQlCdQMCac0zaUXST15hLH+kNgVxdgaKsl/hW1fzs
	 SHce+nWy7hWy0q8G1Ea+ZupjYqXXy3qivS2yG0hw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1697/2651] fbdev: gxt4500: Release WC setup on probe failure
Date: Wed, 18 Nov 2026 15:48:57 +0100
Message-ID: <20261118150348.755538178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 1ee0a1efa18e0..906b8a0dea774 100644
--- a/drivers/video/fbdev/gxt4500.c
+++ b/drivers/video/fbdev/gxt4500.c
@@ -719,6 +719,7 @@ static int gxt4500_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  err_free_cmap:
 	fb_dealloc_cmap(&info->cmap);
  err_unmap_all:
+	arch_phys_wc_del(par->wc_cookie);
 	iounmap(info->screen_base);
  err_unmap_regs:
 	iounmap(par->regs);
-- 
2.53.0



