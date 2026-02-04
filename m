Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F375B3D994;
	Wed,  4 Feb 2026 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217940; cv=none; b=FjEq/jRBuEhbuhxOQcpGiSesiTVlUwN6rGyAg5Pw9mENNKkjwntE72k7NiJ0n+9fIbD2I0jUFUFffAXdchFY3TxiVdHjXIUi9jXippVcl7PgIKQCy2nk/hKSAMdBKbAkGbYEKuwEVZddBkcD0YRQG39Huei9GHgo5kIxsRukFf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217940; c=relaxed/simple;
	bh=IFB41WINYqLPRSO7R5J3CO1hgcZ89owjw4l15TaNKlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjyC14QiEiDswNX73ELYwvCwjeYgzZvKwWQ11pJzuE5QSdJ0T2Sl0G7t84MMiKhfCIoB1zQ7/ZaSU3otPch04iBzm/bvzD6aM1tpuuW/ODDu2HRJy2bE3dTYUqpD3umU1Hk2W6zk6KtRLE6ye0djySzSNEnHIwOBLc0mUsicwig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlwNOpM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlwNOpM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652E9C19424;
	Wed,  4 Feb 2026 15:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217939;
	bh=IFB41WINYqLPRSO7R5J3CO1hgcZ89owjw4l15TaNKlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlwNOpM89vj++oOrni3cdFW/s37jk2SgJ0rqjGybtXjsp6QVriVIJK9K9kQi7ZUXp
	 +X7ioALhPLNEhQPKRuvBGmtc2lymCSADIUNu7rDsuFB2ARk+77paWTK1cva7t4vlbK
	 gx+Fh7iko40TsVmmdnnGR90eIt9SUeFV6irQLvRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/280] spi: sprd-adi: switch to use spi_alloc_host()
Date: Wed,  4 Feb 2026 15:38:25 +0100
Message-ID: <20260204143914.347798113@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0a3d087d09a8f52c02d0014bad63be99c53c4812 ]

Switch to use modern name function spi_alloc_host().

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://msgid.link/r/20231128093031.3707034-2-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 383d4f5cffcc ("spi: spi-sprd-adi: Fix double free in probe error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd-adi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index 24f1358e7e8ba..441cde971f7b8 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -529,7 +529,7 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	pdev->id = of_alias_get_id(np, "spi");
 	num_chipselect = of_get_child_count(np);
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(struct sprd_adi));
+	ctlr = spi_alloc_host(&pdev->dev, sizeof(struct sprd_adi));
 	if (!ctlr)
 		return -ENOMEM;
 
-- 
2.51.0



