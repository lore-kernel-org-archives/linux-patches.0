Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5906F26AC8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHMa8iq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDA0C433C8;
	Wed, 15 Nov 2023 19:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077332;
	bh=kc9yp/7Et9KYb4E3jsCtSfgypeyW3eV6b1NlDcUxNJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHMa8iq7MPVyAn1r9xoXFd++I6U3djySbsFOn+pxgMZ3PgjzhRZFo1sbEItkJZnf0
	 PNPeq6By8BPLvSFouyiQY8jLr4N91ujMMpMLM37YsGaVZrqNQNHcmCclUIwU+BTqZH
	 71COiJSX2GCB9jLWzr/mRmvR042muhk/sFKlgOg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/603] hte: tegra: Fix missing error code in tegra_hte_test_probe()
Date: Wed, 15 Nov 2023 14:12:35 -0500
Message-ID: <20231115191627.805562037@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit b7c3ca3553d1de5e86c85636828e186d30cd0628 ]

The value of 'ret' is zero when of_hte_req_count() fails to get number
of entitties to timestamp. And returning success(zero) on this failure
path is incorrect.

Fixes: 9a75a7cd03c9 ("hte: Add Tegra HTE test driver")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194-test.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hte/hte-tegra194-test.c b/drivers/hte/hte-tegra194-test.c
index ba37a5efbf820..ab2edff018eb6 100644
--- a/drivers/hte/hte-tegra194-test.c
+++ b/drivers/hte/hte-tegra194-test.c
@@ -153,8 +153,10 @@ static int tegra_hte_test_probe(struct platform_device *pdev)
 	}
 
 	cnt = of_hte_req_count(hte.pdev);
-	if (cnt < 0)
+	if (cnt < 0) {
+		ret = cnt;
 		goto free_irq;
+	}
 
 	dev_info(&pdev->dev, "Total requested lines:%d\n", cnt);
 
-- 
2.42.0



