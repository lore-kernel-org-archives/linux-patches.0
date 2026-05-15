Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA98622FF22;
	Fri, 15 May 2026 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860621; cv=none; b=epQyCh54FaFcv2cgzYbLoRUYHn/+3JBibBRgWIby+o2X8nVxE2UHLL8eB4EyT9S7cxpzuVipgN6KPln0+NnM9C7sLkhJCF74WyRhjOQims5cI79GZoUU0efhk2GbqoV/SrCUQaAzX1ETLoJG01relXZK5mj5LS0yeys65VipJOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860621; c=relaxed/simple;
	bh=i8aQQkssfVhiGJKdHYlYS9dJLxBL0iWSLJk+Rolo2uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQNXUTAlHwGGAzzyUtVvXTui0uUTPo5pH1cfjr9N3ZZVvo7kBjOneDsI3igzBeaousI8u2wZ2brqCuWW0zfBk1QjRcU75i+y9Mt3FD9ZmzCvoXP4acKsN4lWH4Y0LIdQAYUAgR2r7H1yHTp6MXTd2f02lO3+VL8zAQEuXRUjmPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+N1r9Kh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+N1r9Kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41594C2BCB0;
	Fri, 15 May 2026 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860621;
	bh=i8aQQkssfVhiGJKdHYlYS9dJLxBL0iWSLJk+Rolo2uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+N1r9KhI3XDy1pH6hm5L98egeB0Ee6NaBzZkTgL3sP/sXb03WYcdORbG1EA+XhJH
	 PHjVa6ud1a+ZLGKh9GfHQaKIhwbUY69TLu8QeGM4WR6hfZGpd3Ju2hSa+PwDugwWwn
	 Vk2pARA5cxMQ36WyqYiNNCMYxdobC0IRNY+izRpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Bin Lan <lanbincn@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/474] padata: Remove comment for reorder_work
Date: Fri, 15 May 2026 17:42:05 +0200
Message-ID: <20260515154715.404755700@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 82a0302e7167d0b7c6cde56613db3748f8dd806d ]

Remove comment for reorder_work which no longer exists.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 71203f68c774 ("padata: Fix pd UAF once and for all")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/padata.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 9ca779d7e310e..6f07e12a43819 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -90,7 +90,6 @@ struct padata_cpumask {
  * @processed: Number of already processed objects.
  * @cpu: Next CPU to be processed.
  * @cpumask: The cpumasks in use for parallel and serial workers.
- * @reorder_work: work struct for reordering.
  */
 struct parallel_data {
 	struct padata_shell		*ps;
-- 
2.53.0



