Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4A822B8B5;
	Mon,  2 Jun 2025 14:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873237; cv=none; b=fBMyFh7F8RD7nLOrdCcQmC4j5nZvBa4h3jhbpfIol6oig2Fz63Nj3dUpfeQV4NBvHGdZQxPZ4CW5HD4flEKeduzGxCFQ5is4zkGYjmTlGkA7tQTLiwCO9sq8MAwMP2XOUwgp9FJ+UDLUVohQ2x9DWo6J9hKo6P4Z+DouyQdQsgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873237; c=relaxed/simple;
	bh=K1JExPrUPitp+n7gS6jNZvqcY/x5xKnbS5NK5Y6hOa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuiUdb0SqazbmJ+PSZbDBaEVXXnhnQnXp5SmPAm7HZhwwZmpvf03Hv6hV+2sTzAi5sBJHBzyKSRWYAx7lTIlzOE5zC6Sr2ZPL2LuRwCtbQqxieA7H0t4a+qgQ/DoHvPybkn9ZVQo3TZhjQeeTP2PO4C4yfqHeqhkWyNiOJuIIhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHs7ekJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHs7ekJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3743C4CEEB;
	Mon,  2 Jun 2025 14:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873237;
	bh=K1JExPrUPitp+n7gS6jNZvqcY/x5xKnbS5NK5Y6hOa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHs7ekJJAt0H320kUq1VvQeCRxt+4I/0uziKIwojrb09doYyxoFVGTYR1U/FU71RV
	 gp1N2VwqNREBOfK0lLx3RMe6udidmLd/Jdl707XKMrTODWwb1Vbp1BIugaUhRJ/7JW
	 91+qRnrHFr3f2T4PPR8Mlenn+ox29+1Qd8RDbtQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/444] fbdev: fsl-diu-fb: add missing device_remove_file()
Date: Mon,  2 Jun 2025 15:41:53 +0200
Message-ID: <20250602134342.917083501@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0bced82fa4940..8cf1268a4e554 100644
--- a/drivers/video/fbdev/fsl-diu-fb.c
+++ b/drivers/video/fbdev/fsl-diu-fb.c
@@ -1827,6 +1827,7 @@ static void fsl_diu_remove(struct platform_device *pdev)
 	int i;
 
 	data = dev_get_drvdata(&pdev->dev);
+	device_remove_file(&pdev->dev, &data->dev_attr);
 	disable_lcdc(&data->fsl_diu_info[0]);
 
 	free_irq(data->irq, data->diu_reg);
-- 
2.39.5



