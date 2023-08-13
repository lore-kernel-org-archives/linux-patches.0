Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4623C9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1862C433C8;
	Sun, 13 Aug 2023 21:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961720;
	bh=R15l1BKXod8hZEPiErcBzYQA82uGFFFFFen6jImXGo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hyt0I84SFM2vF4npw8fqx+K3zHDCShwKm5KXY1n2bzWleUrVTYMaZDh2SPl/dcJ1o
	 oq3QOE+vOJa6WI7QTqS6JYGn4QIF37IU6fj9szfC+bFqFIjsU4/75/Q54R1fatuNHQ
	 3zlRd5euZaV7+kU44l+u7UvRU/y79VYPIOBGgQjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Telezhnikov <vtelezhnikov@astralinux.ru>,
	Alexandra Diupina <adiupina@astralinux.ru>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 23/26] scsi: 53c700: Check that command slot is not NULL
Date: Sun, 13 Aug 2023 23:19:16 +0200
Message-ID: <20230813211703.848550401@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211702.980427106@linuxfoundation.org>
References: <20230813211702.980427106@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandra Diupina <adiupina@astralinux.ru>

commit 8366d1f1249a0d0bba41d0bd1298d63e5d34c7f7 upstream.

Add a check for the command slot value to avoid dereferencing a NULL
pointer.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-developed-by: Vladimir Telezhnikov <vtelezhnikov@astralinux.ru>
Signed-off-by: Vladimir Telezhnikov <vtelezhnikov@astralinux.ru>
Signed-off-by: Alexandra Diupina <adiupina@astralinux.ru>
Link: https://lore.kernel.org/r/20230728123521.18293-1-adiupina@astralinux.ru
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/53c700.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1594,7 +1594,7 @@ NCR_700_intr(int irq, void *dev_id)
 				printk("scsi%d (%d:%d) PHASE MISMATCH IN SEND MESSAGE %d remain, return %p[%04x], phase %s\n", host->host_no, pun, lun, count, (void *)temp, temp - hostdata->pScript, sbcl_to_string(NCR_700_readb(host, SBCL_REG)));
 #endif
 				resume_offset = hostdata->pScript + Ent_SendMessagePhaseMismatch;
-			} else if(dsp >= to32bit(&slot->pSG[0].ins) &&
+			} else if (slot && dsp >= to32bit(&slot->pSG[0].ins) &&
 				  dsp <= to32bit(&slot->pSG[NCR_700_SG_SEGMENTS].ins)) {
 				int data_transfer = NCR_700_readl(host, DBC_REG) & 0xffffff;
 				int SGcount = (dsp - to32bit(&slot->pSG[0].ins))/sizeof(struct NCR_700_SG_List);


