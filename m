Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E523A2C80
	for <patches@lists.linux.dev>; Sun, 30 Jan 2022 19:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=A0VUqk6Uu5zpKHFm4isWfDeVPU3lINMy6Ho5GR6DJdw=; b=i/4aEZchvtYzjU2kwjtDdKrwls
	9/M/wbAS7k80Ku48OZQJlOoTemmWe1UIxt3/Khs4kn32EtYTol/p/qbPEwruwuKgTI+N79dfHVnTx
	bv3ANkHol4cq6LYBzyCqthQ3KyPo5zG+m6HN1GwrtYrWLi0n0WJTQ786XoTkzgVSt3OK7+o0bw++l
	/4JjdPftggSokWefTIJstam8BONF8bpzv4JRXIvd9bqvtbmbjK82mt/4T761qC3n5LjQ/zMp77IXr
	JJ8bkx52sYBdGKjh0SPiq4PhZVCgRKJr9Mo94GE3uhL0DC/GOx7pUVV7f7qUOLxSua6LrNxpXQ3YL
	TQnbfj1A==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nEFhC-007HdB-F2; Sun, 30 Jan 2022 19:17:06 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH] xen: xenbus_dev.h: delete incorrect file name
Date: Sun, 30 Jan 2022 11:17:05 -0800
Message-Id: <20220130191705.24971-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is better/preferred not to include file names in source files
because (a) they are not needed and (b) they can be incorrect,
so just delete this incorrect file name.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org
---
 include/xen/xenbus_dev.h |    1 -
 1 file changed, 1 deletion(-)

--- linux-next-20220128.orig/include/xen/xenbus_dev.h
+++ linux-next-20220128/include/xen/xenbus_dev.h
@@ -1,5 +1,4 @@
 /******************************************************************************
- * evtchn.h
  *
  * Interface to /dev/xen/xenbus_backend.
  *
