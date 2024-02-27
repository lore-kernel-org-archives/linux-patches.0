Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B798013DB83;
	Tue, 27 Feb 2024 13:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041192; cv=none; b=cBsDw1yjYiA9LjbZ9zD00hhI6MsmLJP7wdAL7/73sBRgarGARxEPabngHkE+vLv4cBUtdtO0cSz9eHCG47g2W7g5bDw5hoeYjIxLZn8K3B6gW2clgpyXkbgHaJrKPBtdbpeOcySsW5E/2GAiabiluMmiFDfa09a1Fzu7eHLk8QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041192; c=relaxed/simple;
	bh=r7+4NU2H1tAJeoA2TlNKU5tTHJqk6qmVke09AVuE7fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyiiba4Fsor7AksELOjw5gKQ+tY099PLifFp4cYIPTrZsFPSoOAZPf42BLoU8umHHtvbrhOHPGYzfx0bMilYRyyHi0mbwOmCTTpJXtzmPKtyCUp/E0WHDiRrb2S7FkljUe2d//WXeggGGR5qygsUZQJ66Xy9KrfBjuMnuVE+t5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQsRR3Jp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQsRR3Jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BEFC433F1;
	Tue, 27 Feb 2024 13:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041192;
	bh=r7+4NU2H1tAJeoA2TlNKU5tTHJqk6qmVke09AVuE7fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQsRR3Jpl3aS48fzAJMxNlkNydZH8C6oQlk4laIiJBhqwqL+ntEK04T7npo9awcsK
	 QhUSKm2efolFna1g3pP20qgcihTFetn116i3qo7UjOEHDzfxxLbCl55qAoZbmoIbyT
	 OlXgu1Hxz8LDzLOWryHUTAsp/LCniBoaBnE8+b1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 254/334] scsi: ufs: Uninitialized variable in ufshcd_devfreq_target()
Date: Tue, 27 Feb 2024 14:21:52 +0100
Message-ID: <20240227131639.116650181@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit f2dced9d1992824d677593072bc20eccf66ac5d5 ]

There is one goto where "sched_clk_scaling_suspend_work" is true but
"scale_up" is uninitialized.  It leads to a Smatch uninitialized variable
warning:

drivers/ufs/core/ufshcd.c:1589 ufshcd_devfreq_target() error: uninitialized symbol 'scale_up'.

Fixes: 1d969731b87f ("scsi: ufs: core: Only suspend clock scaling if scaling down")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/c787d37f-1107-4512-8991-bccf80e74a35@moroto.mountain
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e197b9828c3c3..d2d760143ca30 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1456,7 +1456,7 @@ static int ufshcd_devfreq_target(struct device *dev,
 	int ret = 0;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	ktime_t start;
-	bool scale_up, sched_clk_scaling_suspend_work = false;
+	bool scale_up = false, sched_clk_scaling_suspend_work = false;
 	struct list_head *clk_list = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
 	unsigned long irq_flags;
-- 
2.43.0



