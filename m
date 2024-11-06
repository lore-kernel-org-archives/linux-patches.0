Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582B31DFE33;
	Wed,  6 Nov 2024 12:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896543; cv=none; b=VhGiqp4wGb6ioX+xjSyANUQwAoJML6QpfBadHgn7UmYNF4C36qcVUzS/ooK3kIwef/WEsOpfyo5242zJuJgNwZ5cILV3VxVE1nb8VoXKGMPNKN0J8Uf1o1DRg74Lb4K0TgA0WLd+8ABqGDOWAvrDTJFWCghFc3Ivh0HB/ADa1Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896543; c=relaxed/simple;
	bh=tYXuKPZxo7ykxr+v6GiTwiXIpHTUkGMp6RBGhn2QBVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3NVoiOWh5fIdGIAsI2y0naTva/i9wn8uza9Gc2NFwSqx5qnFuVwbkfshPFjg54XwdkXRQXhraRvnE9ncTDHaSECbtzuv3PYpX2rpAFf++f8zv+UA24g0euruvHeYaBxzx1BUNORTjk53mYy8aHOUJGTgQNUhPg5rkLHyQztZ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iad2uUO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iad2uUO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE581C4CED3;
	Wed,  6 Nov 2024 12:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896543;
	bh=tYXuKPZxo7ykxr+v6GiTwiXIpHTUkGMp6RBGhn2QBVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iad2uUO5IE2oBslFBi9tEg2tWeMqBvDVWKdOpSA5px3mreqwmB39X0pjRvHNcdKM7
	 m8LI+NGdMqHEg+Tu883wtfi0trK6963gbRAYLhVEcE4wTtMW6Pkb4fAcMVM3FyhiPd
	 OHrDqHqR14rAOgurqgNUN/p+e8kPTWFQdtWKrimM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 201/245] gpiolib: fix debugfs dangling chip separator
Date: Wed,  6 Nov 2024 13:04:14 +0100
Message-ID: <20241106120324.191615560@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 604888f8c3d01fddd9366161efc65cb3182831f1 ]

Add the missing newline after entries for recently removed gpio chips
so that the chip sections are separated by a newline as intended.

Fixes: e348544f7994 ("gpio: protect the list of GPIO devices with SRCU")
Cc: stable@vger.kernel.org	# 6.9
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20241028125000.24051-3-johan+linaro@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 1f522499c6fc5..337971080dfde 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -4879,7 +4879,7 @@ static int gpiolib_seq_show(struct seq_file *s, void *v)
 
 	gc = srcu_dereference(gdev->chip, &gdev->srcu);
 	if (!gc) {
-		seq_printf(s, "%s%s: (dangling chip)",
+		seq_printf(s, "%s%s: (dangling chip)\n",
 			   priv->newline ? "\n" : "",
 			   dev_name(&gdev->dev));
 		return 0;
-- 
2.43.0



