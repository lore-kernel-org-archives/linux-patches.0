Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C34418E74D;
	Mon, 28 Oct 2024 06:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097535; cv=none; b=Az+M4r83cCPeWRdyMNu/5FPh8yG6l+coQOonlwSiyM1oxGiFlA2D/z/PRkypvz2akhlu7uVQOSjKppUpXW0eRuOLpUTouCfM1oqye22UIjWubGmlC8VlxribbzQL1r+EapEWi6Djn+q6DzqoNtPfkSdiLDCiZEbAg19OMvnVKUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097535; c=relaxed/simple;
	bh=1MyaD+0ZlNM6qnhtXDPiWbiMyx3l0Fv70FWcXJKim34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDsiEImj2n9LsQp2j4HwQKW1poSeab9lt3wQeTQ+RLu1Y9HXGwair7MX0FF2JA9Jzd76t0pgiGskh9YU9FC2fcl5gFx2bqT5IKA5tzOzmVuQg4gvGSHvGZPPHrVo98zEzx4/UEBdEW+t6IBrWqpH5MeBCtSXEgvVWmujM9NwjFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNC6zNLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNC6zNLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD282C4CEC3;
	Mon, 28 Oct 2024 06:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097535;
	bh=1MyaD+0ZlNM6qnhtXDPiWbiMyx3l0Fv70FWcXJKim34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNC6zNLBRDUBV+5AYEU64WE/fCw+W24tK377W+3IXIS3IPr3qFE8HZ5b4sDN0N0k+
	 csn+wzK8HcrdEpvdXTaY+DDjW8w3ziZeXdnnC2vG89MNduOizCLy/OYPIy/y7gqgIF
	 gye1oY3MJYl2AITTkHbmzglZBj/LEom2ZpoVmDyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/208] RDMA/bnxt_re: Return more meaningful error
Date: Mon, 28 Oct 2024 07:23:36 +0100
Message-ID: <20241028062307.546868335@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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
index 3ffaef0c26519..7294221b3316c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -525,7 +525,7 @@ static int __bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 		/* failed with status */
 		dev_err(&rcfw->pdev->dev, "cmdq[%#x]=%#x status %#x\n",
 			cookie, opcode, evnt->status);
-		rc = -EFAULT;
+		rc = -EIO;
 	}
 
 	return rc;
-- 
2.43.0



