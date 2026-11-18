Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048896;
	b=V8WS1zZqzE2C+wbVLB0Hq1sVuiFe7ekLYCttw6lLk5/Mcz0TpNgIVEaGqGc/4ca5hKHq
	 +SHR8QuSZTzyJdyOc34TjMuzALkWbMUen032ZkYL26aH1krMARd1xEjM4qEPujNtaITn5
	 puvJqn1eUGe0noBwJaR2dzvmHgA07s47nVj9EkfFhq+TpQXz7P0PbWxrU1ADGfuR57x1k
	 MOrGgKj7j1V4nu8qBiQYdZaPcm07VV7NY987/iJXQQbT+jxK2ww9ZjNTiBizWun2+hIQR
	 lAkUuOFPOG8SA+ZHREhe9BcvoAYEnCIqXTng2mXUSQYMfprNKzREg9ZuLFu8u0DuNCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zW65OZGwOSXfRbPoR5wOn0qxyNXyQH/EIcOMu/5a9Rk=;
	b=oTHLPf+V+nZPKZoq8FK5DW2Ty3zenFahDge7VWuoQGMEmcYuEfnjJnRWx1Bg0qyPadfi
	 yLOfDM+hj/ZGoOa1k1K4orXu+U/1j9FZyWfhyqTD2pULotCpK8EFEC2evGFjlyY0bsnBl
	 m6WUfOQsPK6Hwu7M8kjKqqjWJ4ssGj1O7Kx5DEzUWQhv8ahqDXw/kbd5xL9uN0qBqs11i
	 ruXXolQ4Y5hOtcNLtnt/8Qex+NegHsAYtkfNJOFmlcIeBi50GolenJHMJXEv8nAV3S3ny
	 1RefVUos9RTCaBDM1eaATDp69eqyifhukfQlu4v8k+27gKd7eSghjnk/vdqzm2deNcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a/Qg7QD8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B206A606A320;
	Thu, 19 Nov 2026 00:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a/Qg7QD8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14241F000C4;
	Thu, 19 Nov 2026 00:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048896;
	bh=zW65OZGwOSXfRbPoR5wOn0qxyNXyQH/EIcOMu/5a9Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/Qg7QD8ZmR3hboSKWBSWeScygWwAvFkauBus4MqXuvqx8n1tzbk9k+wvUWgIU9aV
	 PX8YuVeO5zTM05m6BLkD7clDBmk3RthlY0WIZCvm94K+Vfvaecib6tTWOldCFuDCXe
	 7rvVhhZKQ8qbiF2PmzVq+/7xICzL+ir87dntcUA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lucas Costa <2000.costalucas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2157/2857] staging: sm750fb: free cmap on framebuffer release
Date: Wed, 18 Nov 2026 15:53:11 +0100
Message-ID: <20261118150319.058708648@linuxfoundation.org>
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

From: Lucas Costa <2000.costalucas@gmail.com>

[ Upstream commit b7c885194b81a0376d1fdb457eac40d21d6fb65f ]

The cmap is allocated by lynxfb_set_fbinfo() but never freed, so it is
leaked when the framebuffer is torn down.  This happens on every unbind,
and on the register_framebuffer() error path in
sm750fb_framebuffer_alloc().

Add a lynxfb_unset_fbinfo() cleanup counterpart to lynxfb_set_fbinfo()
which deallocates the cmap, and call it on teardown.  In the alloc error
path it is only called once lynxfb_set_fbinfo() has succeeded, so the
cmap is only freed when it was actually allocated.

Fixes: 81dee67e215b ("staging: sm750fb: add sm750 to staging")
Suggested-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Lucas Costa <2000.costalucas@gmail.com>
Link: https://patch.msgid.link/20260922142851.46724-1-2000.costalucas@gmail.com
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/sm750fb/sm750.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/sm750fb/sm750.c b/drivers/staging/sm750fb/sm750.c
index ad41ba284a3af..acbb475318d12 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -869,6 +869,11 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
 	return ret;
 }
 
+static void lynxfb_unset_fbinfo(struct fb_info *info)
+{
+	fb_dealloc_cmap(&info->cmap);
+}
+
 /*	chip specific g_option configuration routine */
 static void sm750fb_setup(struct sm750_dev *sm750_dev, char *src)
 {
@@ -955,6 +960,7 @@ static void sm750fb_framebuffer_release(struct sm750_dev *sm750_dev)
 	while (sm750_dev->fb_count) {
 		fb_info = sm750_dev->fbinfo[sm750_dev->fb_count - 1];
 		unregister_framebuffer(fb_info);
+		lynxfb_unset_fbinfo(fb_info);
 		framebuffer_release(fb_info);
 		sm750_dev->fb_count--;
 	}
@@ -981,12 +987,14 @@ static int sm750fb_framebuffer_alloc(struct sm750_dev *sm750_dev, int fbidx)
 
 	err = register_framebuffer(fb_info);
 	if (err < 0)
-		goto release_fb;
+		goto unset_fb;
 
 	sm750_dev->fb_count++;
 
 	return 0;
 
+unset_fb:
+	lynxfb_unset_fbinfo(fb_info);
 release_fb:
 	framebuffer_release(fb_info);
 	return err;
-- 
2.53.0



