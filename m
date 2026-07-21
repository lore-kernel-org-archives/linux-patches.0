Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB310347BC6;
	Tue, 21 Jul 2026 22:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674286; cv=none; b=NjlGmDpHG7QVWoR0kmMchKQrJu++MVTAMnGGUlxqPD2VdQqfF+WZM0kCq7hQy2k+XHY5bNbNpzZZ1B5k6rYZLbDiTXa2Ini2akQEXsomlbHDc/h1LwNeDFepp52xxLwy5U401phOXxNaqrK80UcRS86QpJfMbQUJba9M5hNnppg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674286; c=relaxed/simple;
	bh=F4mz25pXgKFdY3rXz2kp7W4VxdQS7spRVXmplOLkgzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4GA4mRJvaT/m1QtLNFPtR/Qkrya0xZAHkKQrhijqRfbYxRDTWqWNlhtqMj1iBSbhXXIplexoJdbQIzw+Ic7b4e5EUeVDQKPl/H6t+C8zbhmP7R64Y2UH9DzCcehmTPB6Y9svI0oowCSn14TrhXT+VxV0A3AFtkwEDKkMBg//Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrLpUFTS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrLpUFTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143F81F000E9;
	Tue, 21 Jul 2026 22:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674284;
	bh=RnpHyscJhjCkuCyG0LVVEQqbnlY9neJ+0xKecV5mOWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BrLpUFTSw6PN4bIFlNzwCif3SqdBZF2ow00OzXPAFQmraAYtkcYF2xXdWYUGSRZQV
	 4rXb9uSsYj3sMsKwM6O71PEH+fyC36waqAc9DLx7L4L3DD2mO6VjOQ2Ju1FDLj0gI/
	 /JMlR2ylFz1BMvXh8btrEgtXJecyAG8ev2P97kCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <martin.wilck@suse.com>,
	Don Brace <don.brace@microchip.com>,
	storagedev@microchip.com,
	Hannes Reinecke <hare@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 482/699] scsi: smartpqi: Use shost_to_hba() in pqi_scan_finished()
Date: Tue, 21 Jul 2026 17:24:01 +0200
Message-ID: <20260721152406.574210569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Martin Wilck <martin.wilck@suse.com>

commit 57db1307afb1f83d45f5ff53b93f8d040100d13e upstream.

shost_to_hba() is used everywhere except to obtain pqi_ctrl_info from
shosti, except in pqi_scan_finished(), where shost_priv() is used.  This
causes one pointer dereference to be missed, as shost->hostdata is a
pointer in smartpqi. Fix it.

Fixes: 6c223761eb54 ("smartpqi: initial commit of Microsemi smartpqi driver")
Signed-off-by: Martin Wilck <martin.wilck@suse.com>
Reviewed-by: Don Brace <don.brace@microchip.com>
Cc: Don Brace <don.brace@microchip.com>
Cc: storagedev@microchip.com
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260513174236.430465-2-mwilck@suse.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2191,7 +2191,7 @@ static int pqi_scan_finished(struct Scsi
 {
 	struct pqi_ctrl_info *ctrl_info;
 
-	ctrl_info = shost_priv(shost);
+	ctrl_info = shost_to_hba(shost);
 
 	return !mutex_is_locked(&ctrl_info->scan_mutex);
 }


