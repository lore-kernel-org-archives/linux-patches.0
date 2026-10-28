Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217366;
	b=bjH4Ugr3rGNC3q4K0WTyOAQ2m0zn7HlpBEeuAGLG3vHarD/R1zgAP5V2kyrCLrgth6yZ
	 iSu8q6X/HUmfpO0hpH3Uh+piXoKNcGkZrj2jkxVaMrjYq84pit3Hl0D6yr+xyXLvTgDzj
	 8IkReCC+PbiDRh9cj9iZ1C9z2wTJuQaXqKuh66AeXz+xmgxEvveSnMFGRnu6waZeL2Sf9
	 aQitPwhVJHA7xC+T4Wk1XYsQ2/dxFGoMzDsap4DgTF1sKDRTm4Z0Xe3J4ysE9CfEn2Oq5
	 iwK9ccNVi+GczJIpejZnngsN0Nl5wVGIL5lwmeltYeRfjLUa5jUdrlSBQxC1+hhWNkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fezGMMHkUJ0c5ry5NRRLZdVCXziTP+1DxoF5Fhdba+A=;
	b=QA62hfaCYrM0dfcsAte4Q6BFfGEaX04K9c9eHMSW/z7yXTMDWnKPI6PtxKtnZTyrn2G/
	 y5rJdr2z3L8P5MyhQxC/6ukRsgyoDTEMXo4Y9cFrsWIhthnzPopWrOSuuAjKVpRK3QWt9
	 vfNApgbh90pXovXiwq2p+zLCEYv+d1TDiHxE860khqpCasqO2GAa8AhZOBrdiiBybe4YH
	 9o77eu4WRxtPJQK9HvkYaCC1YbuB4RLCkPJbwM2OzW5Di7EGFyS0yIiXu+BP17JfKeIkd
	 l0Q7HddDLTTjoY8Mm276iqpmR69sHdxZxwdCd7PTcMrOnJ0XujiRkcqn/Zol0N3d4VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWdPEyLt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826BE606A31A;
	Wed, 28 Oct 2026 19:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWdPEyLt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BB91F01825;
	Wed, 28 Oct 2026 19:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217366;
	bh=fezGMMHkUJ0c5ry5NRRLZdVCXziTP+1DxoF5Fhdba+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWdPEyLteWhufpAX1emKcD1bP5BZM5IjZybbZKQeWwViEmc061Ov+NqnBqZVItIOw
	 1/fXZKHIYp7wmkW/Rf0xZrCMal/t8w/WrSwf4cdkafD84qOcRMWX5K9fW6n+8X2vf+
	 Dyb5NyWA/WFAxBumCQMXJGw2bUiyXPhruQZAIWM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Thomas Zimmermann <tzimmermann@suse.de>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1877/1887] fbdev: Use /* */ comment in initializer macro
Date: Wed, 28 Oct 2026 18:06:13 +0100
Message-ID: <20261028170542.169314060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit cf683e8870bd4be0fd6b98639286700a35088660 ]

Use /* */ in initializer macro to avoid out-commenting the comma
at the end of the line.

Reported-by: Christian König <ckoenig.leichtzumerken@gmail.com>
Closes: https://lore.kernel.org/dri-devel/20230530150253.22758-1-tzimmermann@suse.de/T/#m356cda2679c17d7a01f30ce2b5282cd9046ea6d4
Fixes: f1061fa641b8 ("fbdev: Add initializer macros for struct fb_ops")
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230614131253.10208-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fb.h b/include/linux/fb.h
index 2435aeddf47fa..10844193fb9d8 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -621,7 +621,7 @@ extern void cfb_imageblit(struct fb_info *info, const struct fb_image *image);
 	.fb_imageblit	= cfb_imageblit
 
 #define __FB_DEFAULT_IO_OPS_MMAP \
-	.fb_mmap	= NULL // default implementation
+	.fb_mmap	= NULL /* default implementation */
 
 #define FB_DEFAULT_IO_OPS \
 	__FB_DEFAULT_IO_OPS_RDWR, \
@@ -654,7 +654,7 @@ extern ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
 	.fb_imageblit	= sys_imageblit
 
 #define __FB_DEFAULT_SYS_OPS_MMAP \
-	.fb_mmap	= NULL // default implementation
+	.fb_mmap	= NULL /* default implementation */
 
 #define FB_DEFAULT_SYS_OPS \
 	__FB_DEFAULT_SYS_OPS_RDWR, \
-- 
2.53.0



