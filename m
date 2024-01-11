Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF5F12B81;
	Thu, 11 Jan 2024 09:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxUxpEuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B34C433F1;
	Thu, 11 Jan 2024 09:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704966805;
	bh=1bRXyFtr4YJcJb//yKtGsf/cj7tG/uxLY4fMs2nOuds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxUxpEuBHoZw7wBFkJolZ1bT/n08LrmbPqHCHt0wTm0nbkGltavquTRonHieNSi3j
	 Ozy6J5gK2TZRczTmL1kE6xy1GoNB6NgQTAXm+B39DRYYl0f5FMcPbS7QOfEQHKj381
	 92Y1pSDHTgFrGhJ9KZTxdIc/udqanR6D2tIEYqeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@ucw.cz>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Benjamin Block <bblock@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 5/7] Revert "scsi: core: Introduce scsi_get_sector()"
Date: Thu, 11 Jan 2024 10:52:54 +0100
Message-ID: <20240111094700.479841410@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240111094700.222742213@linuxfoundation.org>
References: <20240111094700.222742213@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f230e6d4249b9ccdcb571077023cecabf91ecbb1 which is
commit f0f214fe8cd32224267ebea93817b8c32074623d upstream.

As reported, a lot of scsi changes were made just to resolve a 2 line
patch, so let's revert them all and then manually fix up the 2 line
fixup so that things are simpler and potential abi changes are not an
issue.

Link: https://lore.kernel.org/r/ZZ042FejzwMM5vDW@duo.ucw.cz
Reported-by: Pavel Machek <pavel@ucw.cz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Benjamin Block <bblock@linux.ibm.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/scsi/scsi_cmnd.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -224,11 +224,6 @@ static inline int scsi_sg_copy_to_buffer
 				 buf, buflen);
 }
 
-static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
-{
-	return blk_rq_pos(scmd->request);
-}
-
 /*
  * The operations below are hints that tell the controller driver how
  * to handle I/Os with DIF or similar types of protection information.


