Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D147017BED0;
	Sat, 17 Oct 2026 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253976; cv=none; b=S0/JJsQhM/yzVn7IyuWwFPBqxgMLEYIF5hLFDE/7TvqLNCFT0UBRSTpPgw1ZexRybYbYx22U40NP9T1HYJaOj3nEoHUAIVWV+l1CtMuTi+JcnAIzvPadD466V3CsdPQO+GExCkzBIQsRDzKT5TNkrS+hJiKacoJ/+uYIIlkBnSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253976; c=relaxed/simple;
	bh=tVPuz+1duU19UDM8qdubuuSRzNJIRlLqw76yP7b8tx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czT6ci9ncfRvrzvGXxQ3q1dhF21sTdknNqzdH/qWaEAwl2cc+RO5bgDiLsHkVgmWcc9e4M/sZIQ5AcXtl9oaRhX0NNi1ZDotTfHXaaj7vikBQkdaOhd1b68ITkFE8ug/zq4evx5Mq4jzjq/v81pwZ8hte8gvjiurlQGARubHQkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQa1sy2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQa1sy2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F3E1F000C4;
	Sat, 17 Oct 2026 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253975;
	bh=6oWJl6Uw/UKfchYHcdd5W9Yv2AT3SuLgcVRjyq4rL/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQa1sy2v9KxqAnKXGQwDZL/zcc+Oa5sqzRGwfij8XVZsN40tAHUlORa9LEc7nrBGt
	 p2NPrTVIw+ye9P0FoLvXvzmPyHKcs2nwD9CwEHm1yonPlVRC752TcNn9pbiNddI3lV
	 TCr+2gOCM7p39Va2dCzZI2AxP5JjbCYrWXp5xcLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/869] spi: ch341: switch to use devm_spi_alloc_host()
Date: Sat, 17 Oct 2026 17:52:17 +0200
Message-ID: <20261017160044.663238853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0191e98ae6e22bebae4e9a487ba70f90d2f8714c ]

Switch to use modern name function devm_spi_alloc_host().

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://patch.msgid.link/20240902125947.1368-4-yangyingliang@huaweicloud.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: abe572f630bc ("spi: ch341: fix devres lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ch341.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-ch341.c b/drivers/spi/spi-ch341.c
index 850b428b8f64f..ded0935662605 100644
--- a/drivers/spi/spi-ch341.c
+++ b/drivers/spi/spi-ch341.c
@@ -152,7 +152,7 @@ static int ch341_probe(struct usb_interface *intf,
 	if (ret)
 		return ret;
 
-	ctrl = devm_spi_alloc_master(&udev->dev, sizeof(struct ch341_spi_dev));
+	ctrl = devm_spi_alloc_host(&udev->dev, sizeof(struct ch341_spi_dev));
 	if (!ctrl)
 		return -ENOMEM;
 
-- 
2.53.0



