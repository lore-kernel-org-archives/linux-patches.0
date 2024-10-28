Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56B118DF7D;
	Mon, 28 Oct 2024 06:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098020; cv=none; b=fnsrDfLQMSNB/6poZlxCxYNndjt+95ymGkXg63EyjzT4F5I4/LnFemyUS66VcPDglMZ+UMLHlLF5An7AJOrt5ob2RrViAlXe+6ICvbWL++ONTtDJumCO7WNZidoXzb+sJO7vFiQe0OfvGQXHyT0libimeRMebhqFzVXrK9NKIF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098020; c=relaxed/simple;
	bh=GXXh1N0JmRg0qxpfZ7D7vUuK/mfSuebfBHuWSklQapE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0fpfo3R6RRZYROVYytt3qAIADkI6SiCANQLhi0fBL4ktGfTKcplRGZpOYUaDj1PXHuPGv/vQV+pjSTZKybZIEy1bosvJgZJFiBZiUR7mXNHclTmxkuDcrngHcNoZsjKam/lBoihjMBd/h1srAONPvS0PMaL+blkbZu7DvmTB3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvoAp3ul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvoAp3ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D4CC4CEC3;
	Mon, 28 Oct 2024 06:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098020;
	bh=GXXh1N0JmRg0qxpfZ7D7vUuK/mfSuebfBHuWSklQapE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvoAp3ulMRI0cb+0l/gw/42IRf6QsQBa3BesNvVVIG8JsT6dP0ctI2kO2TNwsyhpy
	 4N4MdoWU5SRpqU3o7C2Z2kUwzYcEoH2++/eIg/NKYiqDiDxdrBtajD7XlpLuFYzvau
	 5/caEDiHb2umtNMbAxwe+pnxoPOXqbLvPHTBNp6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 042/261] RDMA/bnxt_re: Return more meaningful error
Date: Mon, 28 Oct 2024 07:23:04 +0100
Message-ID: <20241028062313.062974215@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



