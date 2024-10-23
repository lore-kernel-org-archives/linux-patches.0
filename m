Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A401CB325
	for <patches@lists.linux.dev>; Wed, 23 Oct 2024 16:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729701282; cv=none; b=BFAouzrySdQswrCXjBSNOXhaOY2couSoXW8kebbL3rPc2vyIllcY0FoOZGJUcweSAtcEYVFVA4FBZTAMw+pYrE77sJPEHYdm/a52B/xttW9iXyzlkpf2Gv5dBn1vDYjNPrEPm84i9TNfffMU2QioYFQ2mQ26gjSkAPl5Z1Ue3IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729701282; c=relaxed/simple;
	bh=0+GRtyF4jAP8in0U+K+l3Y0DqrvbvIVgqKkvBJS8Ew8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SQxWwmRZTI110wHlsa07X237gaVzt+mZ6hciXWYxI5xTVMXuXL+R4BRz+i0W5176r6JdYLyKX6C8HTJGTyUPTok2Ewi7mwrJssOwRNnOWfICC5fPydktkvb4ZI3EdWWP/9wxMRCBKTqYO+ywF7ALtRVUsEEw8z66hY80CucOzJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=XfRb6rEG; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="XfRb6rEG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1729701281; x=1761237281;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nDqb6BF1mwRkvgF/wNu5VXgzAts1AInB5+pDO89FKCI=;
  b=XfRb6rEGZP86DrvOrY4wdfupc1F88WBQcQ84hj+rjZnHtCF8h0fTE58H
   MZP9JkwLej4L7W7E58IGKjTSDREeZ8QJkRwTZt9QXFO/tSJKfShlonAn/
   GmXnSId7x0bqiVVFO72yHE+iV5BVSV2SsBKvGsv3q6vF4V0PooKAE6lwf
   A=;
X-IronPort-AV: E=Sophos;i="6.11,226,1725321600"; 
   d="scan'208";a="35795691"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2024 16:34:38 +0000
Received: from EX19MTAUEB001.ant.amazon.com [10.0.29.78:13920]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.17.75:2525] with esmtp (Farcaster)
 id 917fdc79-99c9-4188-b1bf-c100072fa936; Wed, 23 Oct 2024 16:34:37 +0000 (UTC)
X-Farcaster-Flow-ID: 917fdc79-99c9-4188-b1bf-c100072fa936
Received: from EX19D018UEA002.ant.amazon.com (10.252.134.225) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 23 Oct 2024 16:34:36 +0000
Received: from EX19MTAUEC002.ant.amazon.com (10.252.135.146) by
 EX19D018UEA002.ant.amazon.com (10.252.134.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 23 Oct 2024 16:34:35 +0000
Received: from email-imr-corp-prod-pdx-all-2c-c4413280.us-west-2.amazon.com
 (10.43.8.6) by mail-relay.amazon.com (10.252.135.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 23 Oct 2024 16:34:35 +0000
Received: from dev-dsk-aospan-1a-bf4470cd.us-east-1.amazon.com (dev-dsk-aospan-1a-bf4470cd.us-east-1.amazon.com [10.13.191.191])
	by email-imr-corp-prod-pdx-all-2c-c4413280.us-west-2.amazon.com (Postfix) with ESMTP id F1E5CA05AB;
	Wed, 23 Oct 2024 16:34:34 +0000 (UTC)
From: Abylay Ospan <aospan@amazon.com>
To: <patches@lists.linux.dev>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Abylay Ospan
	<aospan@amazon.com>
Subject: [PATCH] MAINTAINERS: add netup_unidvb maintainer
Date: Wed, 23 Oct 2024 16:34:25 +0000
Message-ID: <20241023163425.30492-1-aospan@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Adding/restoring maintainership for the following drivers:
F:     drivers/media/pci/netup_unidvb/*
F:     drivers/media/dvb-frontends/helene*
F:     drivers/media/dvb-frontends/horus3a*
F:     drivers/media/dvb-frontends/lnbh25*
F:     drivers/media/dvb-frontends/ascot2e*
F:     drivers/media/dvb-frontends/cxd2841er*

Signed-off-by: Abylay Ospan <aospan@amazon.com>
---
 MAINTAINERS | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e9659a5a7fb3..332ab5fd4b59 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14140,6 +14140,15 @@ S:	Maintained
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/platform/nxp/imx-pxp.[ch]
 
+MEDIA DRIVERS FOR ASCOT2E
+M:	Abylay Ospan <aospan@amazon.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+W:	https://linuxtv.org
+W:	http://netup.tv/
+T:	git git://linuxtv.org/media_tree.git
+F:	drivers/media/dvb-frontends/ascot2e*
+
 MEDIA DRIVERS FOR CXD2099AR CI CONTROLLERS
 M:	Jasmin Jessich <jasmin@anw.at>
 L:	linux-media@vger.kernel.org
@@ -14148,6 +14157,15 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/dvb-frontends/cxd2099*
 
+MEDIA DRIVERS FOR CXD2841ER
+M:	Abylay Ospan <aospan@amazon.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+W:	https://linuxtv.org
+W:	http://netup.tv/
+T:	git git://linuxtv.org/media_tree.git
+F:	drivers/media/dvb-frontends/cxd2841er*
+
 MEDIA DRIVERS FOR CXD2880
 M:	Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>
 L:	linux-media@vger.kernel.org
@@ -14192,6 +14210,33 @@ F:	drivers/media/platform/nxp/imx-mipi-csis.c
 F:	drivers/media/platform/nxp/imx7-media-csi.c
 F:	drivers/media/platform/nxp/imx8mq-mipi-csi2.c
 
+MEDIA DRIVERS FOR HELENE
+M:	Abylay Ospan <aospan@amazon.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+W:	https://linuxtv.org
+W:	http://netup.tv/
+T:	git git://linuxtv.org/media_tree.git
+F:	drivers/media/dvb-frontends/helene*
+
+MEDIA DRIVERS FOR HORUS3A
+M:	Abylay Ospan <aospan@amazon.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+W:	https://linuxtv.org
+W:	http://netup.tv/
+T:	git git://linuxtv.org/media_tree.git
+F:	drivers/media/dvb-frontends/horus3a*
+
+MEDIA DRIVERS FOR LNBH25
+M:	Abylay Ospan <aospan@amazon.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+W:	https://linuxtv.org
+W:	http://netup.tv/
+T:	git git://linuxtv.org/media_tree.git
+F:	drivers/media/dvb-frontends/lnbh25*
+
 MEDIA DRIVERS FOR MXL5XX TUNER DEMODULATORS
 L:	linux-media@vger.kernel.org
 S:	Orphan
@@ -14199,6 +14244,15 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 F:	drivers/media/dvb-frontends/mxl5xx*
 
+MEDIA DRIVERS FOR NETUP PCI UNIVERSAL DVB devices
+M:	Abylay Ospan <aospan@amazon.com>
+L:	linux-media@vger.kernel.org
+S:	Supported
+W:	https://linuxtv.org
+W:	http://netup.tv/
+T:	git git://linuxtv.org/media_tree.git
+F:	drivers/media/pci/netup_unidvb/*
+
 MEDIA DRIVERS FOR NVIDIA TEGRA - VDE
 M:	Dmitry Osipenko <digetx@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
2.40.1

