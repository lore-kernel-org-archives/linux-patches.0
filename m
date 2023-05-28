Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EA6611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E64C433D2;
	Sun, 28 May 2023 19:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303292;
	bh=mM1rmZKpoy7KhA05mdac9DMTf1arAJfst4VxifA90cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsr1SR9vv/TGE563EyCGW9+VsWNqLF6bHlMPz53xTpjJ/AC+2CmRsOdSPuUtyS+CO
	 76EvtV66KGUJUz16uvPp9Z+NWqk2Zej6UWDMT5URuoe9DXtcEGJaPXUfLj2/SdQEYK
	 kjQPJLnpTkpWVO2fJpQgOUY4WuSx2lJLgDFsDzw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zev Weiss <zev@bewilderbeest.net>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	stable@kernel.org
Subject: [PATCH 5.15 20/69] gpio: mockup: Fix mode of debugfs files
Date: Sun, 28 May 2023 20:11:40 +0100
Message-Id: <20230528190829.101603049@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zev Weiss <zev@bewilderbeest.net>

commit 0a1bb16e0fe6650c3841e611de374bfd5578ad70 upstream.

This driver's debugfs files have had a read operation since commit
2a9e27408e12 ("gpio: mockup: rework debugfs interface"), but were
still being created with write-only mode bits.  Update them to
indicate that the files can also be read.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Fixes: 2a9e27408e12 ("gpio: mockup: rework debugfs interface")
Cc: stable@kernel.org # v5.1+
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mockup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -368,7 +368,7 @@ static void gpio_mockup_debugfs_setup(st
 		priv->offset = i;
 		priv->desc = gpiochip_get_desc(gc, i);
 
-		debugfs_create_file(name, 0200, chip->dbg_dir, priv,
+		debugfs_create_file(name, 0600, chip->dbg_dir, priv,
 				    &gpio_mockup_debugfs_ops);
 	}
 }


