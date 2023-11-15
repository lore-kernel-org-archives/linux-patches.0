Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F4B28374
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ch9a+Iin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97C7C433C7;
	Wed, 15 Nov 2023 19:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076329;
	bh=xGdWC6oJhrdbp+6fwAZox5cqTC6l/SBtVCeRvO31CE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ch9a+IinJMn2gAPJ7FTWFhAI115UusBcnXs8Qf3t3kNAUALzrt2Zn/jNg9Zuvm3Om
	 1C2SvlZOnejBa8KlwaJoZhX/BcBodwQZrXn2N9yQfpfWmtaKdJzw2DtFEEWB9Lt/ii
	 XGzjQog4RKm9hbVnxzty0SQ/6M5SXiie/D+ORHlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 197/550] hte: tegra: Fix missing error code in tegra_hte_test_probe()
Date: Wed, 15 Nov 2023 14:13:01 -0500
Message-ID: <20231115191614.428745264@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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



