Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518872C80
	for <patches@lists.linux.dev>; Sun, 30 Jan 2022 19:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=6JCRszUXCuHkWzFCeUDmfWFeE8dA8Y++bCAg/sv5fgM=; b=QA0Eo4Vc8aruhtBHUOjuqPrwd9
	N9UKhLv8lJCOxIPI8/XYa4azFIF0ccqJ8PV83rSxGf+WUK8JrY2VrTNRFljCG/ncr1PGmehq6SRuB
	VSvuFR7bFdXFhXcT2f786K7OLItdnLtbmOYy9PxB0bS54iHsaPGNnYy6sFa2ThSI+IrhX7LodlKTO
	wqe4lSBCWZ7GLn8jE2o/+IiLZG720SaxWVHsT6iNg1fOtlPX33IaKztWlrOFlEWOTsx7FoTJFpRJu
	XrZJiYiyztcrdhgVhpg6JdKmE29dH9JyOY0GUWeBtueRGA7ezWspIzs0CZgfkelGkOdBbsRvdkfZe
	0m9Ti9eQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nEFn0-007IEV-FQ; Sun, 30 Jan 2022 19:23:06 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH] xen: update missing ioctl magic numers documentation
Date: Sun, 30 Jan 2022 11:23:05 -0800
Message-Id: <20220130192305.14523-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing ioctl "magic numbers" for various Xen interfaces
(xenbus_dev.h, gntalloc.h, gntdev.h, and privcmd.h).

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org
---
 Documentation/userspace-api/ioctl/ioctl-number.rst |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20220128.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20220128/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -115,6 +115,7 @@ Code  Seq#    Include File
 'B'   00-1F  linux/cciss_ioctl.h                                     conflict!
 'B'   00-0F  include/linux/pmu.h                                     conflict!
 'B'   C0-FF  advanced bbus                                           <mailto:maassen@uni-freiburg.de>
+'B'   00-0F  xen/xenbus_dev.h                                        conflict!
 'C'   all    linux/soundcard.h                                       conflict!
 'C'   01-2F  linux/capi.h                                            conflict!
 'C'   F0-FF  drivers/net/wan/cosa.h                                  conflict!
@@ -134,6 +135,7 @@ Code  Seq#    Include File
 'F'   80-8F  linux/arcfb.h                                           conflict!
 'F'   DD     video/sstfb.h                                           conflict!
 'G'   00-3F  drivers/misc/sgi-gru/grulib.h                           conflict!
+'E'   00-0F  xen/gntalloc.h, xen/gntdev.h                            conflict!
 'H'   00-7F  linux/hiddev.h                                          conflict!
 'H'   00-0F  linux/hidraw.h                                          conflict!
 'H'   01     linux/mei.h                                             conflict!
@@ -176,6 +178,7 @@ Code  Seq#    Include File
 'P'   60-6F  sound/sscape_ioctl.h                                    conflict!
 'P'   00-0F  drivers/usb/class/usblp.c                               conflict!
 'P'   01-09  drivers/misc/pci_endpoint_test.c                        conflict!
+'P'   00-0F  xen/privcmd.h                                           conflict!
 'Q'   all    linux/soundcard.h
 'R'   00-1F  linux/random.h                                          conflict!
 'R'   01     linux/rfkill.h                                          conflict!
