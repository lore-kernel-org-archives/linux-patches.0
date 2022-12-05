Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F82F15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84E3C433D7;
	Mon,  5 Dec 2022 19:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267628;
	bh=RaN0rz4QkZYvnSrfkoyhWbOXmcWVT/v6ZH0psLftSJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5+mfDazqZkmfYa1yocuHVg4wGPWY5/9Y3rogJkCx3qmoImJf/Mkvtr0UQifrNKWw
	 iJUf6tEtutJFLfVg/c88i07cMBTh3+zX/nQp+5OdZU+X/4s5ceZyuaDL+sG2tEVWBn
	 O9lrz4uj3tRbRiLfM6CF6yvZG1bpqSnb/JpNBP0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulrich Hecht <uli+cip@fpond.eu>
Subject: [PATCH 4.9 56/62] Revert "fbdev: fb_pm2fb: Avoid potential divide by zero error"
Date: Mon,  5 Dec 2022 20:09:53 +0100
Message-Id: <20221205190800.194717678@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ulrich Hecht <uli+cip@fpond.eu>

This reverts commit 6577e903a9e193ad70f2db92eba57c4f335afd1a. It's a
duplicate of a commit that is already in this tree
(0f1174f4972ea9fad6becf8881d71adca8e9ca91).

Signed-off-by: Ulrich Hecht <uli+cip@fpond.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/pm2fb.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -619,11 +619,6 @@ static int pm2fb_check_var(struct fb_var
 		return -EINVAL;
 	}
 
-	if (!var->pixclock) {
-		DPRINTK("pixclock is zero\n");
-		return -EINVAL;
-	}
-
 	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));


