Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019730;
	b=PS5yyBbalJFHqU0Ods03iatkDXwQnWyAxUStoijfVw2jYms8Vai8+i0LXbOzk4hNU2hq
	 xj2wOJzGI4bUDed3Bu8gT/vj1CfbGkaErx2J4zZxvQqQFqSPtHe//JXGGvVtGBL89IJwB
	 fhqkQUlPOP0d3DomBB7Nh8dVFoVOlGZJhixM4oF4Q9d9E+oky14tEOuVC1GKVSJeYqPqH
	 S4WFT27yjrxyQ2dcBn1gJhOpQiyJ6Kap/tu2TeOHxRZUg70NBapgrU7cf55L0bCjHm8zC
	 zXoJluvxPJn2VTUMyvCPCNTuCa2PgAMUkunLo9Z2K5/SCWslCG5rU4Dw2/Wz3t4kiMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mdr3PvANSZL+/fY9KXBmxvX/jrlA670pAD8zQNoEfp0=;
	b=A84vWKeh4/qhIDtLUP+h3lNL1T+7Z9q6yoeEJ5dBjCclAGNCElcluhWa5b1LKhiPIDNi
	 ZtPKjb/yS0eBdA/uoxeHk30z3W+W7/7VaqoAoilxjrXDlMwjiK0/XgqUEEhUYq4cOsAXj
	 QYfE5RBUS2ZsslGl9KCHwl33VurEsZC6GrHxL/xOX2zG1GsDBJmsxCC6x6/jcN6ePBgrk
	 i1gaZl1HVstvjgq5DHNh7kPVEzbKq5OF4StZRBWJUrliSW/5tF/CEp/YI5IYrIw8p/KYs
	 S0jeLufsChKgIB0meIHIevuNT13gvHx05tMjBDqiwJEB1qgoI7KXPz+XNfLGOkxgiMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1a0obHt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EABD606A320;
	Wed, 18 Nov 2026 16:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1a0obHt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ED41F000C5;
	Wed, 18 Nov 2026 16:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019730;
	bh=Mdr3PvANSZL+/fY9KXBmxvX/jrlA670pAD8zQNoEfp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1a0obHtkHdZE2JDaAzvCJYsj1/vkYSt7OXCH1K1YbwUkQlAICpw8bZwCTvBVIuIp
	 so/7kpYNB/Lj4tzajexkUuKG/E54OBffEaHMqZ3wPS0slAjG7PuMX3gWXlhNmUrQDx
	 GBj1l5Eez9Hl6mvXXc3LbDH2yNZaJMKwVbyVDzvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Miro Kropacek <miro.kropacek@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1698/2651] fbdev: atafb: fix sparse warnings
Date: Wed, 18 Nov 2026 15:48:58 +0100
Message-ID: <20261118150348.786610784@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

[ Upstream commit ec4eb034cf8f38fe1ee1e9df07850953c0c2ec0e ]

Fix two sparse warnings:
- atafb.c:1092: sparse: Using plain integer as NULL pointer

Use NULL instead of 0 when assigning a pointer.

- atafb.c:2824: sparse: switch with no cases

FBCMD_GET_CURRENTPAR and and FBCMD_SET_CURRENTPAR seem to be
historic defines, which are not any longer in the kernel, and
as such the code isn't built any longer and may be dropped.

Fixes: d463633d63e6 ("fbdev: atafb: Add support for SuperVidel's SuperBlitter")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609261313.kgFtkz2t-lkp@intel.com/
Cc: Miro Kropacek <miro.kropacek@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/atafb.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/video/fbdev/atafb.c b/drivers/video/fbdev/atafb.c
index c3011b61a94b9..5c3e5861543a2 100644
--- a/drivers/video/fbdev/atafb.c
+++ b/drivers/video/fbdev/atafb.c
@@ -1089,7 +1089,7 @@ static int falcon_decode_var(struct fb_info *info, struct fb_var_screeninfo *var
 			/* Choose largest pixelclock <= wanted clock */
 			int i;
 			unsigned long pcl = ULONG_MAX;
-			pclock = 0;
+			pclock = NULL;
 			for (i = 1; i <= 4; i *= 2) {
 				if (f25.t * i >= var->pixclock &&
 				    f25.t * i < pcl) {
@@ -2818,29 +2818,6 @@ static void atafb_imageblit(struct fb_info *info, const struct fb_image *image)
 	}
 }
 
-static int
-atafb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
-{
-	switch (cmd) {
-#ifdef FBCMD_GET_CURRENTPAR
-	case FBCMD_GET_CURRENTPAR:
-		if (copy_to_user((void *)arg, &current_par,
-				 sizeof(struct atafb_par)))
-			return -EFAULT;
-		return 0;
-#endif
-#ifdef FBCMD_SET_CURRENTPAR
-	case FBCMD_SET_CURRENTPAR:
-		if (copy_from_user(&current_par, (void *)arg,
-				   sizeof(struct atafb_par)))
-			return -EFAULT;
-		ata_set_par(&current_par);
-		return 0;
-#endif
-	}
-	return -EINVAL;
-}
-
 /* (un)blank/poweroff
  * 0 = unblank
  * 1 = blank
@@ -2922,7 +2899,6 @@ static struct fb_ops atafb_ops = {
 	.fb_fillrect	= atafb_fillrect,
 	.fb_copyarea	= atafb_copyarea,
 	.fb_imageblit	= atafb_imageblit,
-	.fb_ioctl =	atafb_ioctl,
 	__FB_DEFAULT_IOMEM_OPS_MMAP,
 };
 
-- 
2.53.0



