Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E83A199B7
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlYX5nkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3618CC433C8;
	Mon,  9 Oct 2023 13:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857953;
	bh=C/F6dpMEaAnoZSlCQEIyhqTJsPDc0kqa9lgVaCHY3UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlYX5nkrwK+ud+ht5CKkkMywicMgGj0A26Abq3S95zYng+eO8diTQQ8Xqot+A+EWq
	 IDBKbt/agfhB2sz5hVOWpq8XBYO0XkdiGDEVjt3isaIvuVllMcMrwjiP4BUfAPYGCG
	 8OHbciWdxOybEb9KF5a+HBhVBydvJ2o6XdrQeS64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Vadim Feodrenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/75] ptp: ocp: Fix error handling in ptp_ocp_device_init
Date: Mon,  9 Oct 2023 15:02:08 +0200
Message-ID: <20231009130112.843267006@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit caa0578c1d487d39e4bb947a1b4965417053b409 ]

When device_add() fails, ptp_ocp_dev_release() will be called
after put_device(). Therefore, it seems that the
ptp_ocp_dev_release() before put_device() is redundant.

Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the timecard.")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Vadim Feodrenko <vadim.fedorenko@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index e238ae8e94709..7a4a06148515a 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1292,7 +1292,6 @@ ptp_ocp_device_init(struct ptp_ocp *bp, struct pci_dev *pdev)
 	return 0;
 
 out:
-	ptp_ocp_dev_release(&bp->dev);
 	put_device(&bp->dev);
 	return err;
 }
-- 
2.40.1



