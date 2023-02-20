Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEC763BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81D4C4339B;
	Mon, 20 Feb 2023 14:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901642;
	bh=bMFfOd/8kmoVEJG3kl4sxmv4d5YwfpyXqjkKVhpLECc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GH2Pgn2NcV3YEs/M4NJ6B08SOEM6QxuPzWmaGBl4yq1nXiwY6u7bNYNzpErwSCMK1
	 XY/kutxSnzoFO5+alkKJEUfelW91+PgRs/8DrlzR0b6jycsTxaUKtyPf84WSic15Wv
	 R6nTh423XvsmtoxfL4bpREqdO5fAmXHNN0iiupYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick McLean <chutzpah@gentoo.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 6.1 065/118] ata: libata-core: Disable READ LOG DMA EXT for Samsung MZ7LH
Date: Mon, 20 Feb 2023 14:36:21 +0100
Message-Id: <20230220133603.029430013@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Patrick McLean <chutzpah@gentoo.org>

commit ead089577e0f55b238f980d9f62eaa90b7b64672 upstream.

Samsung MZ7LH drives are spewing messages like this in to dmesg with AMD
SATA controllers:

ata1.00: exception Emask 0x0 SAct 0x7e0000 SErr 0x0 action 0x6 frozen
ata1.00: failed command: SEND FPDMA QUEUED
ata1.00: cmd 64/01:88:00:00:00/00:00:00:00:00/a0 tag 17 ncq dma 512 out
         res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask
         0x4 (timeout)

Since this was seen previously with SSD 840 EVO drives in
https://bugzilla.kernel.org/show_bug.cgi?id=203475 let's add the same
fix for these drives as the EVOs have, since they likely have very
similar firmwares.

Signed-off-by: Patrick McLean <chutzpah@gentoo.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4044,6 +4044,9 @@ static const struct ata_blacklist_entry
 	{ "Samsung SSD 870*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM |
 						ATA_HORKAGE_NO_NCQ_ON_ATI },
+	{ "SAMSUNG*MZ7LH*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_ZERO_AFTER_TRIM |
+						ATA_HORKAGE_NO_NCQ_ON_ATI, },
 	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM },
 


