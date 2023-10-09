Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745A41A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbstCRzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EBAC433C7;
	Mon,  9 Oct 2023 13:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857735;
	bh=uRXb6Ro5oNGT9PW7Dg8bqrRXDaPgQkJcixIsKAIyvBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbstCRzdanNhDHGJQ6IquDwHCqx7fCdhnR7m6y5JSO9Vswh9ljwwFDEkFRdb3by4Q
	 O/N4Zi6j25m9eQs19zPrrlsMJtKNLXFhjSGDrWuMI2HGtKgzYgA1pUeTIOqevSZPg3
	 3/uwPFMkD/ViE0Hvv+Y+pIXRi0bgWhQtmxRkHc+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH 6.1 140/162] RDMA/core: Require admin capabilities to set system parameters
Date: Mon,  9 Oct 2023 15:02:01 +0200
Message-ID: <20231009130126.771357469@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

commit c38d23a54445f9a8aa6831fafc9af0496ba02f9e upstream.

Like any other set command, require admin permissions to do it.

Cc: stable@vger.kernel.org
Fixes: 2b34c5580226 ("RDMA/core: Add command to set ib_core device net namspace sharing mode")
Link: https://lore.kernel.org/r/75d329fdd7381b52cbdf87910bef16c9965abb1f.1696443438.git.leon@kernel.org
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/nldev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -2501,6 +2501,7 @@ static const struct rdma_nl_cbs nldev_cb
 	},
 	[RDMA_NLDEV_CMD_SYS_SET] = {
 		.doit = nldev_set_sys_set_doit,
+		.flags = RDMA_NL_ADMIN_PERM,
 	},
 	[RDMA_NLDEV_CMD_STAT_SET] = {
 		.doit = nldev_stat_set_doit,


