Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436EA7EE
	for <patches@lists.linux.dev>; Wed, 27 Jul 2022 01:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=DewYU1MMcgcaZ5TkOP0OAdg0HlHDI4mOJqLv+jp1qp0=; b=eH33iKMrlQnnw6bo+dwzEL86wb
	0kVusBBdPsS66gcjikNBJTG0yaVstYNSfRDnPqkPDkCe0OLddc2SgiJ/UJrv0KPgMzE51LU7eNwLT
	rJF/2IVgFFT15wxJntk1aRv5+epAjwFFl/Gh47M38GDoq5lIp/WPos5Tl6HWaT3hNgCsMfOCMY8k7
	RF7Tpyyz71QUbYTv4HQagQ2x4M/R73byHVOyQtDb9eDBFNtlBgnby6n8Zq+/FsybhdvvNdEafbnG3
	wq9/sz9jNdF46kcTBNPZdAu1GDOu8GlVTtjeKeb3BAySZmio01VSeZ/zme3Q1bf++wHEQI0a2cV5x
	jMr29jKA==;
Received: from [2601:1c0:6280:3f0::a6b3] (helo=casper.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oGVb4-002UbV-Fa; Wed, 27 Jul 2022 01:12:24 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Vadim Fedorenko <vadfed@fb.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] ptp: ocp: select CRC16 to fix build error
Date: Tue, 26 Jul 2022 18:12:13 -0700
Message-Id: <20220727011213.24274-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ptp_ocp.c uses crc16(), so it should select CRC16 to
prevent a build error:

ERROR: modpost: "crc16" [drivers/ptp/ptp_ocp.ko] undefined!

Fixes: 3c3673bde50c ("ptp: ocp: Add firmware header checks")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vadim Fedorenko <vadfed@fb.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 drivers/ptp/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -176,6 +176,7 @@ config PTP_1588_CLOCK_OCP
 	depends on !S390
 	depends on COMMON_CLK
 	select NET_DEVLINK
+	select CRC16
 	help
 	  This driver adds support for an OpenCompute time card.
 
