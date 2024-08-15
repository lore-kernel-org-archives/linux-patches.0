Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5812C1A705B;
	Thu, 15 Aug 2024 14:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731953; cv=none; b=U4JLqjZxQzMi50gIg3N8QyKKPz+x7hS4lNP5z6WcTi86hxV+hi95EPFrtJ2V8zHLaiYuLZvCRhZQaSB0j+Ms6wjdZ62CG21TA/9IibJxQ9V49FDY1lniaZ9tNzgP+zH6TXMV9WjbNC+CJn9lTMC/KBjUd9HmO+Jfq7Q/1iwj3ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731953; c=relaxed/simple;
	bh=cXBLtfNXdW0r/vDtdplKfqtCS5B0zcl9syTv/XChKIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwCjanykbAETxVICrZYgJfcGErRNBA3GLeSlTIrR7RxYqlECvdidy9xRBq9SZLh5NbGLnhQIYamx5SB22ze7qvjxjJXHxjkwaDbRLu4ahbw/IwmCjKb4LbN3YKR4bppvrJ1pxjBFX+RLQ4IsMTsYK5bAsRVzxDY4EdudMSaUbu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZF8QkOD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZF8QkOD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DD2C32786;
	Thu, 15 Aug 2024 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731953;
	bh=cXBLtfNXdW0r/vDtdplKfqtCS5B0zcl9syTv/XChKIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZF8QkOD23lIKaKGY/gvL38yWuzRvjsZg5eewefEu4YQ0SDPlQ8dIUGEk0wCDKgBGs
	 GSc+d82+ex58LsZSmqykxnUEx6CNMCQY0YjbLdsqeQEJWVBMCLY9GvNH3csnukZbpE
	 2ngLL5/wAdYYL6aRqwc4iFi6OlQ5RZmRQbdRJYeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/352] x86/xen: Convert comma to semicolon
Date: Thu, 15 Aug 2024 15:21:35 +0200
Message-ID: <20240815131920.349608250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 349d271416c61f82b853336509b1d0dc04c1fcbb ]

Replace a comma between expression statements by a semicolon.

Fixes: 8310b77b48c5 ("Xen/gnttab: handle p2m update errors on a per-slot basis")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20240702031010.1411875-1-nichen@iscas.ac.cn
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/p2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index e809f14468464..bfa972f7e8745 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -736,7 +736,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 		 * immediate unmapping.
 		 */
 		map_ops[i].status = GNTST_general_error;
-		unmap[0].host_addr = map_ops[i].host_addr,
+		unmap[0].host_addr = map_ops[i].host_addr;
 		unmap[0].handle = map_ops[i].handle;
 		map_ops[i].handle = ~0;
 		if (map_ops[i].flags & GNTMAP_device_map)
@@ -746,7 +746,7 @@ int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
 
 		if (kmap_ops) {
 			kmap_ops[i].status = GNTST_general_error;
-			unmap[1].host_addr = kmap_ops[i].host_addr,
+			unmap[1].host_addr = kmap_ops[i].host_addr;
 			unmap[1].handle = kmap_ops[i].handle;
 			kmap_ops[i].handle = ~0;
 			if (kmap_ops[i].flags & GNTMAP_device_map)
-- 
2.43.0



