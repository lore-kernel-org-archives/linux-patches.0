Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F941D173F;
	Wed,  6 Nov 2024 12:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895665; cv=none; b=X1ME3w59GEwgDePoBFezbCjr2jdRRHAu7haNjcwPWjfJa04K1mC9ijSKkof+7ElBmFOpGEdQYq24L4sW74MVMXMrQX4OljrQkmmksW9IokOb7C+riSM5Xy0SE3S3cbNPkOueuL4O88zFQdaRZttxb7QFoA9xUp4Nk7WzADUNZFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895665; c=relaxed/simple;
	bh=2uIztKdyxXvUSkdytC4h6jnEOeGdTLWNTgXWdi+OzT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIH/V/Y7pYy5amHS/37rk8d6TQIe7X4NEAek3nKXykIZaNAxJEwYM2NCs1UybE5rOaB/2JCpjUi0ZipO/2wr54eDHWKcFl5Q+4jGihs4QLtJFP5GZwoucHQDBN5IlHOgb1k0utjHQY3ximlK4AGGR2fsDrbNvGb4Nh8lLrBLGj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5bp+0Du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5bp+0Du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D327C4CECD;
	Wed,  6 Nov 2024 12:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895665;
	bh=2uIztKdyxXvUSkdytC4h6jnEOeGdTLWNTgXWdi+OzT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5bp+0Du3tbRvvCEnjeSGWAksLRLdc0TrBbXSJkpABRx9hXp7/drbm74jylqL7DUh
	 ic+v3HGupoFaiB2lZ3xLaYBTOJLWdKJMAHFe6XAFxdVu8/mdWp7NoOmQ1vBoXza/z0
	 j31ADENc18b2ld5UL5hZ9A8a1kvSUQnBL6G7Mbyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 295/350] RDMA/bnxt_re: Return more meaningful error
Date: Wed,  6 Nov 2024 13:03:43 +0100
Message-ID: <20241106120328.103901032@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8b3b5fdc19bbb..092cc11428f56 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -234,7 +234,7 @@ int bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 		/* failed with status */
 		dev_err(&rcfw->pdev->dev, "QPLIB: cmdq[%#x]=%#x status %#x",
 			cookie, opcode, evnt->status);
-		rc = -EFAULT;
+		rc = -EIO;
 	}
 
 	return rc;
-- 
2.43.0



