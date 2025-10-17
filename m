Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3712E1F08;
	Fri, 17 Oct 2025 15:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713690; cv=none; b=Qf4uu/50nni1Kn8mxRD268KdJHn1AhyiCVrTqrIGTakhypPypsQtwEOFRjrASJoTA0lqcN3Tlr0tFyQ9vRkP1Tsz+alXK5uRksjKqOpPTQjxHKy2cNgSJXBFQCJdUESmEXC20BLdi/l5dPYpvC4Dxq2PkchRQMM3XO4Dqg82Zu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713690; c=relaxed/simple;
	bh=OGp2OfnRaFvRRnxNjX/WbWkUK8F2MBZ/KhCrNteqz+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0FNVkDxZLqW3nIB/EKjcMLo2cj7dPN+1sIseR6odsrHpYbyUvjeoB8YOl/zBvR5A5X02l4jOIYIaFw0prDYLLNTj0sceqCPT9vl6ek7Z5uOoKnqPnfBrxnynslAhGGP0wqNJIvQXiR2vtW4fcL3FckjBJUWePMznWC+eKl3Rqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZnYK4ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZnYK4ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72265C4CEF9;
	Fri, 17 Oct 2025 15:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713689;
	bh=OGp2OfnRaFvRRnxNjX/WbWkUK8F2MBZ/KhCrNteqz+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZnYK4adiuhMS5kbOBBS58QPWEYnoUd+fPAHv1S7jhgQW0VAbNZ5wLIEaYwd1yL0Y
	 vdqzwn4ETOzdloED3KUUMqTBt49syZmP5YsDm3+PCrSWfqa+Jm3I6/aiNSYC7pwWjH
	 mOAzA2M6QS1b1+Co5o3eGgee7nPAf3gxLNVqH1cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harini T <harini.t@amd.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/201] mailbox: zynqmp-ipi: Remove redundant mbox_controller_unregister() call
Date: Fri, 17 Oct 2025 16:51:43 +0200
Message-ID: <20251017145136.292391748@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harini T <harini.t@amd.com>

[ Upstream commit 341867f730d3d3bb54491ee64e8b1a0c446656e7 ]

The controller is registered using the device-managed function
'devm_mbox_controller_register()'. As documented in mailbox.c, this
ensures the devres framework automatically calls
mbox_controller_unregister() when device_unregister() is invoked, making
the explicit call unnecessary.

Remove redundant mbox_controller_unregister() call as
device_unregister() handles controller cleanup.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Harini T <harini.t@amd.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index e4fcac97dbfaa..06529dc0daf3f 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -617,7 +617,6 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 	for (; i >= 0; i--) {
 		ipi_mbox = &pdata->ipi_mboxes[i];
 		if (ipi_mbox->dev.parent) {
-			mbox_controller_unregister(&ipi_mbox->mbox);
 			if (device_is_registered(&ipi_mbox->dev))
 				device_unregister(&ipi_mbox->dev);
 		}
-- 
2.51.0



