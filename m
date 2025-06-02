Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E324722D7B1;
	Mon,  2 Jun 2025 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875910; cv=none; b=oduanmNRPKpRASpI7/ouIkneO945BJ+LACMd6qdya4vnNib2IezjUJcIkIiYrm/kz8DL0Q8EcnORAF5PEBjfORvPcWNam/Y9WWNFA8d4OCzclj8lRuVpgxWA2u+EXW76OSMCsIvKym+1CFhOfQPgTwe+ObFwJ+iBrV2Z8q4gzlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875910; c=relaxed/simple;
	bh=ZFBYgt01kfQNj03TI7oktYMairHo9giHeiCnI8e6a8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRRjxYMFjwD5+IVACcnr5HYxX/sFxls86Bf+HJS9q44ucCOP6RaeEd2u07zTI8TUGqDVxwLqd55WaTNfkTkZL8ORjMBEc81BMccfivw1j21ErKkV9qQj3jXYaOk8VbGYip1a1js8lF1+S1ZCZlKZrMYsGjw1+U7+nHNrGYlOjo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HP5c/C+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HP5c/C+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54990C4CEEB;
	Mon,  2 Jun 2025 14:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875909;
	bh=ZFBYgt01kfQNj03TI7oktYMairHo9giHeiCnI8e6a8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HP5c/C+DZFgBihk8ePoee02hpq3/P8a3uQo2ZK95/EAQLg9vwJvYhiSfrhii2RmvG
	 PoyUtetfYNRKDJyAmsouyNun2NEeSWj1pboMCVzniVKwS/XC3F7gOiXoNOwVPpWxUN
	 Yh14a/dO6P8RFrZdmQDxG9lvoJYqUSNBuLkVx5mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/207] fbdev: fsl-diu-fb: add missing device_remove_file()
Date: Mon,  2 Jun 2025 15:46:24 +0200
Message-ID: <20250602134259.255178578@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ce3c5b0b8f4ef..53be4ab374cc3 100644
--- a/drivers/video/fbdev/fsl-diu-fb.c
+++ b/drivers/video/fbdev/fsl-diu-fb.c
@@ -1829,6 +1829,7 @@ static int fsl_diu_remove(struct platform_device *pdev)
 	int i;
 
 	data = dev_get_drvdata(&pdev->dev);
+	device_remove_file(&pdev->dev, &data->dev_attr);
 	disable_lcdc(&data->fsl_diu_info[0]);
 
 	free_irq(data->irq, data->diu_reg);
-- 
2.39.5



