Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02D8882C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DB8C4339E;
	Fri, 10 Mar 2023 15:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461448;
	bh=rnWDVu1bfyQaIXiu6IIUeP98/MFYCQ/ijt/d+dlaa5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ne3ujYgETo/gi93YFBVJ6NTk994k4mR46WAppaAQLPus1Hnli8NQYE+4xM2Cv87sj
	 ez1Q1HL8qroywfRTyCNjJukaCy9MAn3ciUPWTsUUlrAfffKRXXN2qLOnDfFMYrHu8r
	 UwnzaHS8Ur6MDsEK/G7pV15XR9b/NPfGlq5IkfTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.15 131/136] Revert "scsi: mpt3sas: Fix return value check of dma_get_required_mask()"
Date: Fri, 10 Mar 2023 14:44:13 +0100
Message-Id: <20230310133711.192781682@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Salvatore Bonaccorso <carnil@debian.org>

This reverts commit e0e0747de0ea3dd87cdbb0393311e17471a9baf1.

As noted in 1a2dcbdde82e ("scsi: mpt3sas: re-do lost mpt3sas DMA mask
fix") in mainline there was a mis-merge in commit 62e6e5940c0c ("Merge
tag 'scsi-misc' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi"). causing that
the fix needed to be redone later on again. To make series of patches
apply cleanly to the stable series where e0e0747de0ea ("scsi: mpt3sas:
Fix return value check of dma_get_required_mask()") was backported,
revert the aforementioned commit.

No upstream commit exists for this commit.

Link: https://lore.kernel.org/regressions/yq1sfehmjnb.fsf@ca-mkp.ca.oracle.com/
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2993,7 +2993,7 @@ _base_config_dma_addressing(struct MPT3S
 
 	if (ioc->is_mcpu_endpoint ||
 	    sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
-	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32))
+	    dma_get_required_mask(&pdev->dev) <= 32)
 		ioc->dma_mask = 32;
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
 	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)


