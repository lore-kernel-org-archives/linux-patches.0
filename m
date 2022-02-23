Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFC37A
	for <patches@lists.linux.dev>; Wed, 23 Feb 2022 00:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=FmPtA1MFZVEzbbIV6thV2rAg0Vph8etTxNU5rLmnHRw=; b=Lc8fZJTnzqja/TuhCEC7dYhs+D
	MkHZks9EIAFuGGBx6dBvCX/pD/QHJJGiO0COy813Vs+3M3Jcp9jgBjOV/ytV27mb2Otr1wHvaG6cj
	faQOqOBthXHPq710TPCkyR4wCo6XLOV53Im20neaPEKfJgcYWVgHOTzhlS76XBcYR3am3nv3zDkb8
	iJn0WYsf0z55pGCKHHDSgjFFWCwOmfXlVW5RiAldX25tKkDDp5KKvr8vZ+7js5v4N9byp8ILgOTCx
	1ysX6qV6HNfzlasaOXgzn8R1c+wHfxuIG4ma4wn9Hx0als8fvdM5HlD4UvZsIHaQC730FfIFsfJ+B
	QT2+bMuQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nMfAl-00C0MU-Qd; Wed, 23 Feb 2022 00:06:23 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <i.zhbanov@omprussia.ru>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: aha152x: fix aha152x_setup() __setup handler return value
Date: Tue, 22 Feb 2022 16:06:23 -0800
Message-Id: <20220223000623.5920-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__setup() handlers should return 1 if the command line option is handled
and 0 if not (or maybe never return 0; doing so just pollutes init's
environment with strings that are not init arguments/parameters).

Return 1 from aha152x_setup() to indicate that the boot option has been
handled.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: "Juergen E. Fischer" <fischer@norbit.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
Builds but not tested -- no such hardware.

 drivers/scsi/aha152x.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-next-20220217.orig/drivers/scsi/aha152x.c
+++ linux-next-20220217/drivers/scsi/aha152x.c
@@ -3375,13 +3375,11 @@ static int __init aha152x_setup(char *st
 	setup[setup_count].synchronous = ints[0] >= 6 ? ints[6] : 1;
 	setup[setup_count].delay       = ints[0] >= 7 ? ints[7] : DELAY_DEFAULT;
 	setup[setup_count].ext_trans   = ints[0] >= 8 ? ints[8] : 0;
-	if (ints[0] > 8) {                                                /*}*/
+	if (ints[0] > 8)
 		printk(KERN_NOTICE "aha152x: usage: aha152x=<IOBASE>[,<IRQ>[,<SCSI ID>"
 		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>]]]]]]]\n");
-	} else {
+	else
 		setup_count++;
-		return 0;
-	}
 
 	return 1;
 }
