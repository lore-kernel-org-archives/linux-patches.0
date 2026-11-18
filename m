Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031560;
	b=p+sKQany/ByRC4parCpFdxcBWhS7GNZ86Msnzs4edLEC54as9QvONzmcbzp2wCMyJS2u
	 Lt5YV7p+VOC551v95T/5M98j6glVlMLlCvo6fz+8FBCKP12tF/KX3/RCUbFC84za/pYcv
	 AxG0IPYS3myZ8m6l8zvu5kEbjsU9+8KOajkd4dXW/CYaMay9DGcJxxoeSowrGGZhUFyf1
	 rNMUCvjRvLtXI+J423pB8M0w7LprSO8ptmaJEe7vblgMJ8hUmHWvWTx7grcVytobmnl8P
	 rgE4+h56Y4A/fxzaO1wi8sSCEJVR5QCfXXSjOzSj32MGXC20PmMbIKvW9JBIzSVHWSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q8tY4wx93vydB8h/QxwoKe2yt0rIfN6o/hhiKt2UTO0=;
	b=Hfu+W7q8WKMtdpbPueuMBFZIEiCW2gmI6A+6YzHZwoFyZsHqCw7MoGRYmIUChFBXBTEt
	 zsIpb8R2k3vrlyFWI+V9qlzIRyO/4bia6bJHlAWI0RQmy91girEVdNtRyDi+lDzy+VeHi
	 g5lYiCZd3EiXGiFCvox8v8rMmjqdogwSxr2gtxjapb3stNx4ETmBSbjFzna1JoPp858et
	 PonOCeeC6BBVfSunNfL8F6HZXOsnKmJqOL6mmSMo0tpm1cPmTRkZ8pMjaX+mv9LB8V7LM
	 RG9Arhgtlz4a9WTSjWAuFZNziyox8CXedoCZDg+Z7bNJq2JJdCBC5MsCZ+QtY1W6cvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zS5JnCsL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C0D606A31C;
	Wed, 18 Nov 2026 19:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zS5JnCsL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233B91F000C4;
	Wed, 18 Nov 2026 19:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031560;
	bh=Q8tY4wx93vydB8h/QxwoKe2yt0rIfN6o/hhiKt2UTO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zS5JnCsLX+gx3b0bDEmKOGuspkIYh7s88dB++lEtWZFUTAxnQr3W04n2NmTk5zOLW
	 5p/fPyhyaXiN3j0o/4O4MU1hdWlnyi5bY1NHzfFlZaGRipqE6VY+4QJghNiqSG1GF5
	 jZ88t1mlF2yQ1ay+WAZBUWKbTN1KRQZ8LMslxnno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1099/1756] fbdev: gxt4500: Release WC setup on probe failure
Date: Wed, 18 Nov 2026 15:53:46 +0100
Message-ID: <20261118150053.950837266@linuxfoundation.org>
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
index 15a82c6b609ea..138f5efbf4f40 100644
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



