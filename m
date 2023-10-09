Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110E21F95A
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/l54O9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E1AC433C7;
	Mon,  9 Oct 2023 13:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857645;
	bh=jGMpwF/lUuC8yLnFQA34N2TLKB3B5pYHrH5iHnkE3bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/l54O9Hs047GPSwu1b9sdXWthAVg3Lywq2AGz7chVMZc2A6vCIjtQeNJbNgqg/9k
	 0BTYp0JJIONd394nM3LULeNHWEWZOZDVlbQf1+y4yRtbkzE7hR1mF7CTrxOmGQOtoP
	 TffkTdb8hAeGX2Dqoim7NwURRxkrvxF1xyjwHgf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Vadim Feodrenko <vadim.fedorenko@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/162] ptp: ocp: Fix error handling in ptp_ocp_device_init
Date: Mon,  9 Oct 2023 15:01:33 +0200
Message-ID: <20231009130126.021283144@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a48d9b7d29217..8fee9b330b613 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -3532,7 +3532,6 @@ ptp_ocp_device_init(struct ptp_ocp *bp, struct pci_dev *pdev)
 	return 0;
 
 out:
-	ptp_ocp_dev_release(&bp->dev);
 	put_device(&bp->dev);
 	return err;
 }
-- 
2.40.1



