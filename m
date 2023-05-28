Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61375569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE912C433EF;
	Sun, 28 May 2023 19:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302097;
	bh=9L5Ir1Wn7U3eOzQ0K8V/W044w0ZJ1OI3WyI6PgNi+LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypIM3a4rrjJIQYY68PedNaTLx4DVTftRVM/xca9TQbvCmKAYFAAz1+npXb/i0faKZ
	 DmBb3uh+lgslP+WZh3j4EHzh5UNWaVErVTqbmZxW/1nsOPvfW2IGqaO4HD385Qoa97
	 pz8GKIHhX2YqA6/26AGMDA4gU3Ef4x6uj9fUtVHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zev Weiss <zev@bewilderbeest.net>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	stable@kernel.org
Subject: [PATCH 5.4 132/161] gpio: mockup: Fix mode of debugfs files
Date: Sun, 28 May 2023 20:10:56 +0100
Message-Id: <20230528190841.179954275@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
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
@@ -339,7 +339,7 @@ static void gpio_mockup_debugfs_setup(st
 		priv->offset = i;
 		priv->desc = &gc->gpiodev->descs[i];
 
-		debugfs_create_file(name, 0200, chip->dbg_dir, priv,
+		debugfs_create_file(name, 0600, chip->dbg_dir, priv,
 				    &gpio_mockup_debugfs_ops);
 	}
 


