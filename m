Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB97711CB5;
	Thu, 11 Jan 2024 09:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuNmRQaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDD1C433F1;
	Thu, 11 Jan 2024 09:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704966799;
	bh=DOlcbFzVplYCwBr8yyv+0uP0XOWpwKyp6NWrWVcQJjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuNmRQaUPHRBhHbG+/VvsdxYGslKR6I/0fY8NS0l1solpnnvOhSrD4wwsNvKvrdbB
	 YDYffksd3SsnlGc60JUjH9hVFb2Pa5MN/z/pzaWbM/1cIuAsnurUu5i0IWIihMYN61
	 XBhlZJIqc4FhErFJzZ8dg70+1eoUG4xhtgt9aEs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@ucw.cz>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Benjamin Block <bblock@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 6/7] Revert "scsi: core: Add scsi_prot_ref_tag() helper"
Date: Thu, 11 Jan 2024 10:52:55 +0100
Message-ID: <20240111094700.528887619@linuxfoundation.org>
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

This reverts commit 294d66c35a4e019a9dfe889fe382adce1cc3773e which is
commit 7ba46799d34695534666a3f71a2be10ea85ece6c upstream.

As reported, a lot of scsi changes were made just to resolve a 2 line
patch, so let's revert them all and then manually fix up the 2 line
fixup so that things are simpler and potential abi changes are not an
issue.

Link: https://lore.kernel.org/r/ZZ042FejzwMM5vDW@duo.ucw.cz
Reported-by: Pavel Machek <pavel@ucw.cz>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Benjamin Block <bblock@linux.ibm.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/scsi/scsi_cmnd.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -291,13 +291,6 @@ static inline sector_t scsi_get_lba(stru
 	return blk_rq_pos(scmd->request);
 }
 
-static inline u32 scsi_prot_ref_tag(struct scsi_cmnd *scmd)
-{
-	struct request *rq = blk_mq_rq_from_pdu(scmd);
-
-	return t10_pi_ref_tag(rq);
-}
-
 static inline unsigned int scsi_prot_interval(struct scsi_cmnd *scmd)
 {
 	return scmd->device->sector_size;


