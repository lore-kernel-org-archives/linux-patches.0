Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429C321ADC7;
	Sat, 30 May 2026 18:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165598; cv=none; b=lBGOImqmmLzcqEOwVq34r+GylRCT2M4xSY16qjRGSNhhTdEbuRJ13DeZByUGyJItHZRETaU31zIczBiiGsapBVLNlJtrY54W4vRAalnj1nDwAPNvBWOnLfh10aHy+MP3vaaNmShl8yHIYSyQ7WIvXFAa0boIgaMuT7lk0RD2BxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165598; c=relaxed/simple;
	bh=y62y/oQ0bmQWGIysRmU3zSzMtUsLgGq0HqoGhAFsTUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gATSYwUlJshgb3TeI4FFdNLjGek3TWzewzFd5jmBQ2n06mCVJh9dBpeuILhGjESFb1CdWvuEdbUDu3v+MQ5PBnJDnHjUre6Sq7RxAul4zvlxkTYgPVv5yB7af1QRbl/wCcRdZIDt1sVpLcwQAVzK1fE2RJsVOdegAygpZfZdFMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l75X77Z+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l75X77Z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A481F00893;
	Sat, 30 May 2026 18:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165596;
	bh=gCBcwvf7iG8GopF+PtDNfsMt9mqHbHCHkf1ehNX3OVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l75X77Z+MHN0c2GQA+3rw9Sr+RC//kg+VwPuyzxCw1sVThN6cZzdFkm5rrR6N8aX5
	 zdma2Oq3v6emk5/83XzrGE4QC5zKq6iBPGOOSV0YY2bA4pOjprcR3QVwKNhoBKM+6Y
	 CT7jIJmK6vOYZbSJ2sOjFBWsPAmFcYPdgBdP/DJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/589] Revert "scsi: ufs: core: Improve SCSI abort handling"
Date: Sat, 30 May 2026 18:00:05 +0200
Message-ID: <20260530160228.026730223@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
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

This reverts commit 133811fbc1cc171477281c829eb5fd567f013ba7.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1b8072f47e7e8..c7bf0e6bc303d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6788,7 +6788,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		__ufshcd_transfer_req_compl(hba, (1UL << tag));
 		spin_unlock_irqrestore(host->host_lock, flags);
 out:
-		lrbp->cmd = NULL;
 		err = SUCCESS;
 	} else {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
-- 
2.53.0



