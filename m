Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD161B81DC;
	Mon,  2 Jun 2025 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875401; cv=none; b=HM8+9KaiTgyxUtdwpuuzy6XT+FRH8VdbRZDrMW1rp2hP6dW6eEz5gDscCnRqcVcT5y4K3YY/YipyWEepTB3HqhX1G2D9/DDEbR8lDG8Rk5FO7BK3MPVkK+DCvFC6StupFMwxLhBXqwHpzosZPNe/Cw/XwYu0NwpWqw7WTdAmzZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875401; c=relaxed/simple;
	bh=RmdtY+JQQtr39gkhUI1kjIsE/3XmQaIeJYd+0dY3omY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZRnmN0WBjyzhHznOsV7Y/85W2iVx/OeVa1HJLwn1VDjdpdMQPxEr6YG4m2Y3St15ZAclW0u1QQPLzh/3rcgcJlfa8niX/DkoNxQgjjNzqYlxkTWi3jM1V+hoOJRzTSQQEMW5uv6kVboWLttl4EABG3JIA/Z8Wnm+J5a3+XKGzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuDik9MQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuDik9MQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D316C4CEEB;
	Mon,  2 Jun 2025 14:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875399;
	bh=RmdtY+JQQtr39gkhUI1kjIsE/3XmQaIeJYd+0dY3omY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuDik9MQLHgYAiI6GHB5gsbpGHvGJ31GDv7drzSU8JyGcRJ/5Lc62tXw4e0zC8Hvh
	 wCbBufxbRwNpYUax5vNA4ayMNM7JyzG8kOskp5Lljo7fC6H7xNNGH4jgd5k9zbdSpd
	 yH8xetvn2ukXvHR86X9Q7J1rfKxSdpJLHRaTmf44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/270] fbdev: fsl-diu-fb: add missing device_remove_file()
Date: Mon,  2 Jun 2025 15:46:47 +0200
Message-ID: <20250602134312.211548376@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit 86d16cd12efa547ed43d16ba7a782c1251c80ea8 ]

Call device_remove_file() when driver remove.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/fsl-diu-fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/fsl-diu-fb.c b/drivers/video/fbdev/fsl-diu-fb.c
index 5d564e8670c52..6f2606932867d 100644
--- a/drivers/video/fbdev/fsl-diu-fb.c
+++ b/drivers/video/fbdev/fsl-diu-fb.c
@@ -1830,6 +1830,7 @@ static int fsl_diu_remove(struct platform_device *pdev)
 	int i;
 
 	data = dev_get_drvdata(&pdev->dev);
+	device_remove_file(&pdev->dev, &data->dev_attr);
 	disable_lcdc(&data->fsl_diu_info[0]);
 
 	free_irq(data->irq, data->diu_reg);
-- 
2.39.5



