Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833591E89C;
	Tue, 27 May 2025 17:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366435; cv=none; b=mwKuOFfD5QqSGRs0WCD0Va+tf4u5ztqZpbbbTM3xhEqcYXbie5/9+RxJbob/+wqFpWi6jNC1Fo17xK8YdpmT7uLI+TKZST3WOyCcZ0ZAKVs5xJWYSlhojPOyRI0e8/n4BAuod0M+ENp+GA10MC0clSL43Zk9+Z/3+O+9KasplhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366435; c=relaxed/simple;
	bh=sUVA90KfWUOuKByz2/+MHsc55n0TCJr67LVgC5uI7Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdlRbHpgH8hzV9BxdBUP3Cclwz6dK4q/vsIO7qlH0sdrlNGynAX7JoKRLgoSUYep8vfonkg2LgsYFXw6w2TDTCAQLn40+9WjWqc9miJaySPVtmJ3CMC4e7c51cLzpQBvfSdHXTLSUcOnayC84bZzMQGwFXBzu1+aoL1t1QvFaxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVC+Iass; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVC+Iass"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14464C4CEE9;
	Tue, 27 May 2025 17:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366435;
	bh=sUVA90KfWUOuKByz2/+MHsc55n0TCJr67LVgC5uI7Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVC+Iassowj9sSn9G4BwfzlkRZQPwPIAhcibb1TJUdhPcQcSahaCMiLWIZkKY7c1V
	 x84Ud4KyaeI7t767TJUmTND2dYlkwrW9j1CdY1ay688JcOJFSOE8YwlA5nUs+K28IE
	 4yIwpGSYapfJtFKu/OpliTwBBdmZ3RLpNOkFRulM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 067/783] fbdev: fsl-diu-fb: add missing device_remove_file()
Date: Tue, 27 May 2025 18:17:44 +0200
Message-ID: <20250527162515.851281497@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 5ac8201c35337..b71d15794ce8b 100644
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



