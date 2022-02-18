Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADED48A4
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 18:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=AZEADM8IK5yfcItVy/AZkXq/eoM28jmc3QuPDjTirFs=; b=c/fDBc+IA9+hJZoEuvwfGV6ayi
	pFDxUjS9AwOKG838mbwpoH2WbU2fVNP8VVol1MpU14G8Yz2nXyXJ3+cqloYaQVhLQClmiw3zr6jh1
	SkUMFFH5B1Qx5IrncjAAyuUhCCuRqwDBsjD9y3aVRfEcb3RDxqLp1CDaPlGLE3KHYDcEKBPTUX4+8
	+nKixIV5BNil5rb94olbpD0NcG+/32LvG7Z6xunWv6Aym6KE7I755Oid/WxVKmAqSRvuL+y523IHw
	KBYgimqSVKtodZAMDGkrlZzS5J3hWRGfHhobn8We0YgvoCYYGR8W70svYRx6uzRvdX+QerrTA/m8N
	p0fFTT/w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nL7yn-00FV82-1z; Fri, 18 Feb 2022 18:27:41 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: akpm@linux-foundation.org,
	keescook@chromium.org,
	yzaikin@google.com,
	sfr@canb.auug.org.au
Cc: patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH] MAINTAINERS: add sysctl-next git tree
Date: Fri, 18 Feb 2022 10:27:36 -0800
Message-Id: <20220218182736.3694508-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Add a git tree for sysctls as there's been quite a bit of
work lately to remove all the syctls out of kernel/sysctl.c
and move to their respective places, so coordination has been
needed to avoid conflicts. This tree will also help soak
these changes on linux-next prior to getting to Linus.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

Collecting Reviews/Acks, I can throw this into the sysctl-next tree.

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bd86ed9fbc79..08bce45710e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15564,6 +15564,7 @@ M:	Iurii Zaikin <yzaikin@google.com>
 L:	linux-kernel@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git sysctl-next
 F:	fs/proc/proc_sysctl.c
 F:	include/linux/sysctl.h
 F:	kernel/sysctl-test.c
-- 
2.34.1

