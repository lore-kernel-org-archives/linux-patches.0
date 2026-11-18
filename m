Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019733;
	b=cn4JkffRZlQMF/pt3AgwoJKKeyCEaN9TuCuSeyW1TvfrC3pMgOMCyCUxaayKUBp/t/T2
	 GhtC2XE62kO2kVRIPmOH6z6S9JrrqdJ8dgXLS5uCEOPK6rQJosyYjKJqNKhMm4Sm2k9vH
	 nyXkpD5ee5OtgkW1KVTJUsFoJRWe3fmW9/NA0npwIqO2pKem+ZeoSeb5ceRC8+pVr+Irl
	 GMJCK8NJkQCbGvPaNH/u/dFnCujZ9jIi5Rw/uvzuQEkvlViLS9eIt93BWjSuDmjwDT8XZ
	 NKa2U+y9Af83ncxh98NT2WTb4wX3vHBhijTNp0c4DZjTXZZL6Wq1sDxIzgKOr/npf6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lSIiUBELbaqlNMREEm7TWlbT9PzwaVOIXeRcKvgTADw=;
	b=0b5cjTfPH3BsmNY/+Y+kbE/imhyyl+htTLbWxE6p+mF6RLgxkSMZe4lXWlpLfteVe74b
	 LdP+fZLUIL+IEVJYFhlpmBa1I68toJqH/khgB6lChLicE8I4AgNjXEj+hha8iVko9Bvvv
	 7TtY1HbEzOJnhHc00YmR7JbSg8stE9YnGKS8nU3yQFsJb7lw7OzpTYmiY8SP5IjZzWdZX
	 U/wHBWQj0JDH03jVphKmi1bqQfnyZa44DjnZ/nDOsgVPTJopzUhQJCJn4FGB882ZtRW0Q
	 +e3dICmE2do3yy2g3i6orX8vNuP0rs2srl44YRfeF1vk7TuxwCgOInt7EasyTGQxI7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JXOA3PBl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4BB606A31C;
	Wed, 18 Nov 2026 16:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JXOA3PBl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BE71F000C5;
	Wed, 18 Nov 2026 16:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019732;
	bh=lSIiUBELbaqlNMREEm7TWlbT9PzwaVOIXeRcKvgTADw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXOA3PBlR+z8kr2Pk3+XwzhmkihF4V8DZFiVZIegDJSSBYNCqEYZU96l+OQOAI1b8
	 rIYVxBoN5TvENYV664IX41yhG0p0RbMwxWO+FzCXrbqXTo0yCElPwwGx8k6phjoOc1
	 cpWxRH0NdkFtDYbl++gI1oQjI0W/a1B4Ykld2TCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Miro=20Krop=C3=A1=C4=8Dek?= <miro.kropacek@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1699/2651] fbdev: atafb: avoid cast when assigning buffer address pointer
Date: Wed, 18 Nov 2026 15:48:59 +0100
Message-ID: <20261118150348.818919583@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 111a4137edd2c4caad413efa5ebb8a37067c172c ]

The sparse tool complains that the "cast removes the address space
'__iomem' of expression".
Avoid the cast by using the screen_buffer pointer instead of the
screen_base pointer from the union.

Fixes: d463633d63e6 ("fbdev: atafb: Add support for SuperVidel's SuperBlitter")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609261313.kgFtkz2t-lkp@intel.com/
Cc: Miro Kropáček <miro.kropacek@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/atafb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/atafb.c b/drivers/video/fbdev/atafb.c
index 5c3e5861543a2..c32576cb17202 100644
--- a/drivers/video/fbdev/atafb.c
+++ b/drivers/video/fbdev/atafb.c
@@ -2454,7 +2454,7 @@ static void svblit_fillrect(struct fb_info *info,
 		((u32 *)info->pseudo_palette)[rect->color] : rect->color;
 
 	/* draw the first line with the CPU ... */
-	line = (u8 *)info->screen_base + rect->dy * pitch +
+	line = info->screen_buffer + rect->dy * pitch +
 	       rect->dx * bytespp;
 	switch (bytespp) {
 	case 1:
-- 
2.53.0



