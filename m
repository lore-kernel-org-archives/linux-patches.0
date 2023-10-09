Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB01DF59
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfB/YzYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D79C433CA;
	Mon,  9 Oct 2023 13:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859200;
	bh=h5xpjg718yNJa0PpC+STGoIM7LISFSLbHCXT58R7o24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfB/YzYxdAi47IelykHhRtfyHHzGHHBch/uAW3oMMCXGBad+VMjc+f8PT51R6kVxX
	 5dj+8EncBUsoAUjB9BgXDMWJatEpyju8KOJsq3XiYjtEl4URZyYUJ4+rYVoL3a5dmd
	 5x0oaJVioA4Cf+KfDO8FFKqGF03Q65zP2SLu071o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH 5.10 214/226] RDMA/core: Require admin capabilities to set system parameters
Date: Mon,  9 Oct 2023 15:02:55 +0200
Message-ID: <20231009130132.136549950@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2148,6 +2148,7 @@ static const struct rdma_nl_cbs nldev_cb
 	},
 	[RDMA_NLDEV_CMD_SYS_SET] = {
 		.doit = nldev_set_sys_set_doit,
+		.flags = RDMA_NL_ADMIN_PERM,
 	},
 	[RDMA_NLDEV_CMD_STAT_SET] = {
 		.doit = nldev_stat_set_doit,


