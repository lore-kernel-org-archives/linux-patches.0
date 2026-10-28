Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216018;
	b=DgXKD147wXYUqePaYA2MN+pQzfSo7iaEtzTxpELWek3hWyoLJrdT5ylH3DlQjphLYayo
	 jmvWcaZthRheEGX5o/0eLBaTMgm5oq8+CYVS5u9C/G2FXCn2GABzAZ6xOefZ3M60OyADb
	 Fy77y7XgMZszD6YmTXC9eRPZtADwYxxHfSX+tre6NR+M64sG248REHJmYhaH79M1+XJG+
	 DyiSSrLOJ5AOXUuG0s+e5wpIYjau67CWF6NGAO2rmzhPiCIkqigJ3ZK8RlLG5To6BV629
	 pLH7G9iILOMQHrWF5DyJZ+ChDljoZ90YmE1yFrxb25eMYTI48w/bqetitu0cgmZdXWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7AN4FJcoeOa1utu3Ij48L5IAh0WXavqLFdM1H8VOCGU=;
	b=xnC/h36ua8w3OXEAbt117L0oMa9N/gg3iAWgnclw6Za825PGYbeNNssHn/HVjXYrC6hq
	 TGHA1+A7+5neOpVynXI41mGgG1zIAAiRpapioHBXXkWq7PcxX6a1KDWBX1e1IK/BPk1EA
	 1ZwFmZUK+8n/QuityiHbx/0yOylO/ZO8L0SbYsMdU20AKhH+9EEzy2vvUIIl3WX682bO9
	 ynz6rsOat+zyPBaOTkVTCaFb0KZwYrp8Jwj4m4dyeSMBIZBsuXL1y4TDNEU3aBrrWXZhy
	 nUXOOqBACrYwjnbvPk+jEZmscz8msP3MF9stUatNHXdPm4V3hmVdUYog0ohbfTz6eiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fUbLn0wQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAA5606A31E;
	Wed, 28 Oct 2026 19:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fUbLn0wQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0111F01825;
	Wed, 28 Oct 2026 19:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216017;
	bh=7AN4FJcoeOa1utu3Ij48L5IAh0WXavqLFdM1H8VOCGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fUbLn0wQeWNafKIUhyCWa42cpjHeDr4vrjzTnUHKd71bXIofKgJ2cjh4eblxHjGc7
	 551ebbN6nKziQkRALN5v5kMmf23XwUET+TmSCK/MnwhTTe+RhUg/a3K407jK9JtASf
	 zj6BvIw8QYmfmiVapR6NcZ6sh7quS507Q6DLPYf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sui Jingfeng <suijingfeng@loongson.cn>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1410/1887] fbdev: Dont re-validate info->state in fb_ops implementations
Date: Wed, 28 Oct 2026 17:58:26 +0100
Message-ID: <20261028170531.545306070@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 453bd91302f16ddb8a2f5eb3df9fda3206dbacef ]

The file-op entry points fb_read() and fb_write() verify that
info->state has been set to FBINFO_STATE_RUNNING. Remove the same
test from the implementations of struct fb_ops.{fb_read,fb_write}.

v2:
	* also remove test from ivtvfb, braodsheetfb, hecubafb and
	  metronomefb (Geert)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Sui Jingfeng <suijingfeng@loongson.cn>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Helge Deller <deller@gmx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230428122452.4856-17-tzimmermann@suse.de
Stable-dep-of: 9ad709afdfa3 ("fbdev: ssd1307fb: defer I2C transfers from damage callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtvfb.c        | 3 ---
 drivers/video/fbdev/broadsheetfb.c     | 3 ---
 drivers/video/fbdev/core/fb_sys_fops.c | 6 ------
 drivers/video/fbdev/hecubafb.c         | 3 ---
 drivers/video/fbdev/metronomefb.c      | 3 ---
 drivers/video/fbdev/sm712fb.c          | 6 ------
 6 files changed, 24 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index a642becdc0d73..23e6cc5172d7f 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -378,9 +378,6 @@ static ssize_t ivtvfb_write(struct fb_info *info, const char __user *buf,
 	unsigned long dma_size;
 	u16 lead = 0, tail = 0;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
 	total_size = info->screen_size;
 
 	if (total_size == 0)
diff --git a/drivers/video/fbdev/broadsheetfb.c b/drivers/video/fbdev/broadsheetfb.c
index 49296ea9926c3..c694ab918978f 100644
--- a/drivers/video/fbdev/broadsheetfb.c
+++ b/drivers/video/fbdev/broadsheetfb.c
@@ -1013,9 +1013,6 @@ static ssize_t broadsheetfb_write(struct fb_info *info, const char __user *buf,
 	int err = 0;
 	unsigned long total_size;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
 	total_size = info->fix.smem_len;
 
 	if (p > total_size)
diff --git a/drivers/video/fbdev/core/fb_sys_fops.c b/drivers/video/fbdev/core/fb_sys_fops.c
index ff275d7f3eaf1..facf47a69483c 100644
--- a/drivers/video/fbdev/core/fb_sys_fops.c
+++ b/drivers/video/fbdev/core/fb_sys_fops.c
@@ -21,9 +21,6 @@ ssize_t fb_sys_read(struct fb_info *info, char __user *buf, size_t count,
 	int err = 0;
 	unsigned long total_size;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
 	total_size = info->screen_size;
 
 	if (total_size == 0)
@@ -61,9 +58,6 @@ ssize_t fb_sys_write(struct fb_info *info, const char __user *buf,
 	int err = 0;
 	unsigned long total_size;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
 	total_size = info->screen_size;
 
 	if (total_size == 0)
diff --git a/drivers/video/fbdev/hecubafb.c b/drivers/video/fbdev/hecubafb.c
index 962a155a5b3d0..f6be62ed42c5a 100644
--- a/drivers/video/fbdev/hecubafb.c
+++ b/drivers/video/fbdev/hecubafb.c
@@ -163,9 +163,6 @@ static ssize_t hecubafb_write(struct fb_info *info, const char __user *buf,
 	int err = 0;
 	unsigned long total_size;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
 	total_size = info->fix.smem_len;
 
 	if (p > total_size)
diff --git a/drivers/video/fbdev/metronomefb.c b/drivers/video/fbdev/metronomefb.c
index dcfbcb7523ad1..17307c00d46f0 100644
--- a/drivers/video/fbdev/metronomefb.c
+++ b/drivers/video/fbdev/metronomefb.c
@@ -523,9 +523,6 @@ static ssize_t metronomefb_write(struct fb_info *info, const char __user *buf,
 	int err = 0;
 	unsigned long total_size;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
 	total_size = info->fix.smem_len;
 
 	if (p > total_size)
diff --git a/drivers/video/fbdev/sm712fb.c b/drivers/video/fbdev/sm712fb.c
index 3baf33635e65f..b1bccb5f83e09 100644
--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1031,9 +1031,6 @@ static ssize_t smtcfb_read(struct fb_info *info, char __user *buf,
 	if (!info || !info->screen_base)
 		return -ENODEV;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
 	total_size = info->screen_size;
 
 	if (total_size == 0)
@@ -1097,9 +1094,6 @@ static ssize_t smtcfb_write(struct fb_info *info, const char __user *buf,
 	if (!info || !info->screen_base)
 		return -ENODEV;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
-
 	total_size = info->screen_size;
 
 	if (total_size == 0)
-- 
2.53.0



