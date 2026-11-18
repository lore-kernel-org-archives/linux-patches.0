Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051104;
	b=oWh4BJhhpWrgYK8IE2ebtF7RUeJLMGmUA9ga3zyp1bPTql5R9ZSEcNHrKDg5ip+ncut7
	 aOF5YEWYit4ZfL0t5IOHD/8ZErvVTK2GehmENlYgMV9QmVZK/EcvtvrRQeMwLW4cocER5
	 M+Y2Ib6yU9PiueYzqserFSiF+WuYjfLA2+LpuGi03ROacEYa2X4Q7Fr9XfWiYZW0VQWZw
	 N/ehE3K1Ob84vwE+xh38txlWeiQ17PSZOdNIqcFJljBgoOwjNsK7walT2/guowQXcqOpU
	 FAS2iY4AxH3JzKTPpPwY02uZuHAXtJBjtYq41U2/XxIufktMZ1tl/HwMJ88piTBZUoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=quRQCDT8P7zs4i8ZThJVHhf+oN9+B0Ruj5LzsAgQUVY=;
	b=QAAd9IMrWqtfrqb19sIrDkH4wqEO9n9UPVMqzlPtUGlGue8YOHkk3mndtQoAq9eGImkU
	 Z+btgtwUCClXEenYY7afcryT+vF7TE0cTFjWNshXhQYDE7THO6aPBzxALMXAcS+Dl8In5
	 xFOLrI628/qJXD2KJhImun8KUNfWQ1y4eT20Nr61YHws8DoJ7u/82LDD+iQo+Dn0lZN3Y
	 5sG3BeMMUjyUqwMu3mF4NJFaTbpplA1ixE/NCYam83RiENJNNOEdIcpDPoAkAagFcuB8n
	 10xWeJhg7TRRIAiULhw4tKDUE6WLzHANHyxoKT+8o0Ub2hrVgvUkoFJm7M4twnc/ELw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=id7xwS5l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95361606A31C;
	Thu, 19 Nov 2026 01:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=id7xwS5l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ED41F000C4;
	Thu, 19 Nov 2026 01:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051104;
	bh=quRQCDT8P7zs4i8ZThJVHhf+oN9+B0Ruj5LzsAgQUVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=id7xwS5lV3Yr/Gwaj/db9bo83RDUP+b3M5IWonPvnqzJ0exZV6op+ngpj0mduYurU
	 tKDqCAaMD5G4H3ROrXACvW89lxr7ljqj0IsTzZlkkWuq0tV7YW+Bc75u8zjb1f1z0W
	 fg29c97rasH7lWkoOg4gFWCCrAQL+Uxx4x/STCM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0083/2214] remoteproc: core: cancel crash_handler work in rproc_add() error path
Date: Wed, 18 Nov 2026 15:29:19 +0100
Message-ID: <20261118150013.321678817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>

[ Upstream commit 0ec167625b4fea30b26da33c188e853ff25d5583 ]

Ensure crash_handler work is cancelled before tearing down rproc resources
to avoid accessing freed memory.

Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260623-rproc-attach-issue-v3-3-8e24310707ce@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index a41b793e994e4..0e12d45b551f5 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -2388,6 +2388,7 @@ int rproc_add(struct rproc *rproc)
 	return 0;
 
 rproc_remove_dev:
+	cancel_work_sync(&rproc->crash_handler);
 	rproc_delete_debug_dir(rproc);
 	device_del(dev);
 rproc_remove_cdev:
-- 
2.53.0



