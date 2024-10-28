Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C0918E03A;
	Mon, 28 Oct 2024 06:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097188; cv=none; b=hZZlm13T4Keyfy2+FA/1AnHyTGeCBavkun3trlH/DxalozNO9zdP5iI0JOJFW1nkFM/jqTnl5COGvckHMvv+MCgL9zGiOpl26pseE3qH9IYtAQ8jM3Y0Gwh7q/GZzG3hUAOveNEPnThJwwAyjyR3U6f2dipcpPt2zWooTVFbeg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097188; c=relaxed/simple;
	bh=dAgyjiZOJBTsneEhY/y5/c4Gtd2YPr50qIg89Zgmi5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVWkDl5Mq3ATZsm6E/XFkM9NtvHHNaLtDyfm9ZFiXCc0iQkJAMus7Ai9O84t535j/4bFpTJlKKX70QNxbpPZWTq3UYZ+kLVEcXxuECr8pQRc2nw2GaRrur4LDkS0ZQlVTqbM9IkbQ8m3QZu3Gu11od62HjhKePOxlJruQVxHjyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1SVKqaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1SVKqaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4AAC4CECD;
	Mon, 28 Oct 2024 06:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097187;
	bh=dAgyjiZOJBTsneEhY/y5/c4Gtd2YPr50qIg89Zgmi5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1SVKqaYcvqcz18oS0mc+8uT1dP5HbNexjVM3crquviqbS4yjUMN/onEcaqCPIrI3
	 Z5KkWT8V8nqrhdtqHhzS96GBUzi1rw8SH/3C4iPYs6eTXO0heCkvRaFKjbu95iVA+S
	 kf/DhmKbIKNlu60bW83Uw855xHqiAwb7dIi3W4kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/137] RDMA/bnxt_re: Return more meaningful error
Date: Mon, 28 Oct 2024 07:24:18 +0100
Message-ID: <20241028062259.316057312@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 98647df0178df215b8239c5c365537283b2852a6 ]

When the HWRM command fails, driver currently returns -EFAULT(Bad
address). This does not look correct.

Modified to return -EIO(I/O error).

Fixes: cc1ec769b87c ("RDMA/bnxt_re: Fixing the Control path command and response handling")
Fixes: 65288a22ddd8 ("RDMA/bnxt_re: use shadow qd while posting non blocking rcfw command")
Link: https://patch.msgid.link/r/1728373302-19530-5-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 75e0c42f6f424..14c9af41faa67 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -249,7 +249,7 @@ int bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 		/* failed with status */
 		dev_err(&rcfw->pdev->dev, "cmdq[%#x]=%#x status %#x\n",
 			cookie, opcode, evnt->status);
-		rc = -EFAULT;
+		rc = -EIO;
 	}
 
 	return rc;
-- 
2.43.0



