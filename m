Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F031D6DC5;
	Wed, 19 Mar 2025 14:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395062; cv=none; b=pzkvVUM9GjAh5b0ncAyxjk2qu0Y+0Popl18Up/P5LbQoO5COR8Vmi2lhMgeVRzF38SGCT72whQjZKTNihlThIhcMWPEGGiqppGZj/o/80An8h3aQekXLyOEFAjMp0/PQWlDPQbddd/xZyjtvxbLTpHTGwYpgR3Y1y0TuysqKHVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395062; c=relaxed/simple;
	bh=kornihFhtDv7UYG9yvfL/01eKb1GTRRTS+X3r8u6Ayw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLoTCKnw1pnRt1VyDjD1JerSyX6BczyCPjVeD0lbXVGo5jyjLtiu5D1s5V6DZM88YidHwRPR17dkUzIvr0+qfnQ/z+XWBXg6Hi1A59GjRBXra2+xUVPn88M2qwHIrrn/rdLhqdS7ZqrR2AY24tPkofUO1vNNz8dEyhjtqx1IvVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYrwXtao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYrwXtao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99105C4CEE8;
	Wed, 19 Mar 2025 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395062;
	bh=kornihFhtDv7UYG9yvfL/01eKb1GTRRTS+X3r8u6Ayw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYrwXtaoUKRqVmYCrKrnh9sLpS5cHaBMOuf331qe15waEqJpmSJuNTzCP/a6a5JVG
	 qAKVvkUydQsxYLX6JHNSbF5NQ9I9rU44+U00fy2J3PCfJZQaPtbvZA0ZePQUBdEmmC
	 7hYFAL/lykC6C3ilvNfGbozKZNB6stmPfbCXEsq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/231] Xen/swiotlb: mark xen_swiotlb_fixup() __init
Date: Wed, 19 Mar 2025 07:29:50 -0700
Message-ID: <20250319143029.237528234@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 75ad02318af2e4ae669e26a79f001bd5e1f97472 ]

It's sole user (pci_xen_swiotlb_init()) is __init, too.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>

Message-ID: <e1198286-99ec-41c1-b5ad-e04e285836c9@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 26c62e0d34e98..1f65795cf5d7a 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -113,7 +113,7 @@ static struct io_tlb_pool *xen_swiotlb_find_pool(struct device *dev,
 }
 
 #ifdef CONFIG_X86
-int xen_swiotlb_fixup(void *buf, unsigned long nslabs)
+int __init xen_swiotlb_fixup(void *buf, unsigned long nslabs)
 {
 	int rc;
 	unsigned int order = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT);
-- 
2.39.5



