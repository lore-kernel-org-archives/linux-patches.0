Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045467;
	b=3mZMQqpWwwWSpAEQrPDhoLrIKj1Pr4fCbotoqO3Rb7kQ6mQnSQMoXZRA2To97/P+T+w8
	 A/W/6/ykI2KBi67Rb7bsk30mn29ujHVmp09kxzY0DQ9m6AX8RwDek4nBUJHt1Zpjb6Kbn
	 nnK5oSX32R0KiMbrUdcAbwNM5VAyFNyNqi1TFGlYUSm09mjn9GR0XrUuKgTyBriOYDG9k
	 lLAZeYQ3It4kvoUznJ7FstKFYwI+5Oj//ceQTKc4/EDmTqyJvgzkNTWN0bE7fTVx8Np14
	 bILX1BJtbWr1hEcLPR1wIUbluYDMoZwgr7W8f4y0FlpmDru4qXEsunlX1Ip0oeXzFBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q8sHc0tDJw0WTjxwPn6DDv6bon+Yrslglp8XwE2qR7E=;
	b=WWuHlIxeI/7RTZy+cWyZoe4rUN99ziLwtYeOuwk+bS6Ql/OVD9lbU3ivnj3sKxcgMzOS
	 wXyvvz/sRxgOsNTwVzsfQT3JZtG8tHr4R+XaUvfdU00mYzSL4tHVk/biiCek8KhiBV0et
	 dQtgimAg8WtvdLVwdEHMfv47eIQx2a20FlrYmLdGAjdVFJaYzDyHzfyrNzZWh26FRDuMb
	 pZwbGxBAEyZTJbEjFMmP39KO2T+1BQ2Qd65fPJZziCgyVHYK6HFS47ZTHwOnXN/60FC96
	 SdsJCTBRvnk9egsnVKJTe6ra8EOVm+56tF2q1lXvNWv7nyugLt05HsmXBhnACFG8ztg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mb2colyj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09A3606A31C;
	Wed, 18 Nov 2026 23:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mb2colyj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CD91F000C6;
	Wed, 18 Nov 2026 23:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045466;
	bh=q8sHc0tDJw0WTjxwPn6DDv6bon+Yrslglp8XwE2qR7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mb2colyjIrRr3h931TIkne4Dz+0VTPvvi7e/L2GU0oH8Lfaxr+85xHtnmZ0KmlVxN
	 extSNLsnistwoYNMlIG16uz6/BIsaQ9TNY0lvAOUNvgkXfOkc6+d4DkSXRPTSxm67k
	 hXsWzwMq9YIxIXkWDtNCBQ5ayhxJR9PfYwpVKLxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0931/2857] fbdev: ssd1307fb: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:32:45 +0100
Message-ID: <20261118150235.108555346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 81ae1f9a6c850efab3e5dec6b7c9aa5c587f92b7 ]

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently ssd1307fb_probe() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due
to an allocation failure) info->fbdefio_state is left NULL.

When the file is subsequently opened, fb_open() will dereference a NULL
pointer (calling fb_deferred_io_open()).

Fix this by checking for the error.

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/ssd1307fb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index 61f84abb5e0c9..13aa9e6bff5cf 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -771,7 +771,11 @@ static int ssd1307fb_probe(struct i2c_client *client)
 	info->fix.smem_start = __pa(vmem);
 	info->fix.smem_len = vmem_size;
 
-	fb_deferred_io_init(info);
+	ret = fb_deferred_io_init(info);
+	if (ret) {
+		dev_err(dev, "failed to init fb deferred io: %d\n", ret);
+		goto fb_defio_error;
+	}
 
 	i2c_set_clientdata(client, info);
 
-- 
2.53.0



