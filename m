Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D888E1CAA60;
	Wed, 19 Mar 2025 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395200; cv=none; b=iZNxeRToaX+kwSrl0G97J5Oymlev3vLRuxoGVBsI6GynCrb0NhCFZdyxB3q6ZhHGKPuUOh+90+BXG9KDAm98y1rjbKEOwxmg0bmQSE3WA87bOgTydJLP99lKpK2X/+pEOfjlvtkOJopw5U4rblaVRM22Gi71zIkEBBJWvfMy+h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395200; c=relaxed/simple;
	bh=wHdNVTFuI3ovRj+CGEI27YB4eFTvl9K2c/9DVBHR0Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtlbEfeGy7qnpfLFk0DAPqDszskta3KjNyztJBbXEnJpqDq6k3q9SLrd0UQjU5jCeMXnCTSdLxivZnoQPjWTLWJui2TzEs8eyMyqsJkLEKrLZZIYeIObEkayr5bHIKBBPAzOIVNZU9JFMIUPMidGUPTRZ7GJJAa0nCCyt4oLQgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YY8VOz8x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YY8VOz8x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5B9C4CEE4;
	Wed, 19 Mar 2025 14:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395200;
	bh=wHdNVTFuI3ovRj+CGEI27YB4eFTvl9K2c/9DVBHR0Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YY8VOz8xE0H/IJr8jJ3+h8AODO2qLtjIdm2/yHbIWOLra5EqpqRy0LrjK/IdJLnel
	 mutF+URhni2SsLCF5LExmWPLoj6cRjcmnnC3wcGJ+xtKyF90ibtNggCN0cCFBuOlzd
	 XHCki6PwPCfuybQHr+/OhBFqIYDdD5IsZuHNzDes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/166] Xen/swiotlb: mark xen_swiotlb_fixup() __init
Date: Wed, 19 Mar 2025 07:30:34 -0700
Message-ID: <20250319143021.717900248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b6e54ab3b6f3b..0b3bd9a7575e5 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -112,7 +112,7 @@ static int is_xen_swiotlb_buffer(struct device *dev, dma_addr_t dma_addr)
 }
 
 #ifdef CONFIG_X86
-int xen_swiotlb_fixup(void *buf, unsigned long nslabs)
+int __init xen_swiotlb_fixup(void *buf, unsigned long nslabs)
 {
 	int rc;
 	unsigned int order = get_order(IO_TLB_SEGSIZE << IO_TLB_SHIFT);
-- 
2.39.5



