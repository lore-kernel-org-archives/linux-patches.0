Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809DE404BF6;
	Tue, 21 Jul 2026 21:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670204; cv=none; b=Z3tDF0Nr1vkAoF0ZJ3/yQ0hVxLOrr1Uvj3U3B9qf2R2WZf+QKOjbEcoar4YFjK00kbMFHSAhgU43z6LkFFHlQUMomXE7yvjUNHH7yRuztpgkCOmNyc5ONLB8umrv+K4ZjAVRRFn3Bny5tOaMYT5SHiR1Gy/ydK23Z/Nm74ETQaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670204; c=relaxed/simple;
	bh=zI0y4yV6HpEC8Ec/SZjBM9e5aVe1wR7kEkvIizv0Cc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZ8d1ADDA5nGbFuksUgbKVxXjYiDAjvJ0BmAd2YjERelIAAfBTSOaSItvKVrf3oUOAf5SXE7lGUtvDRUTttmmu+x5cBmfhf5RQZhko+y8qgAYNomRgnNWUdQoWCl0oghPbcLPnCQDbY+dVKHBxyeEmM+H/HuqY+/UYRTrY/NGH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAQcjqHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAQcjqHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE87A1F000E9;
	Tue, 21 Jul 2026 21:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670203;
	bh=/vrzGl0UrsPF0pQVXbOTmqbpYa7WVmJujg2AHJKahqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAQcjqHYg4R3JnRD7hywHWK3WMvyuUldsa4loawURnET7aOYZULM3ez8mVeVAYUw6
	 y2tqrEOVq7whHAyI65XBMd+0VWgnWlZeE/ZaXAVirRNAi9fMwyC3GvE2l3BETduzAW
	 GlrvaC74sMHQlYX2cWvNHoCPQrQE+4TXpKvJuYo4=
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
Subject: [PATCH 6.1 0801/1067] scsi: smartpqi: Use shost_to_hba() in pqi_scan_finished()
Date: Tue, 21 Jul 2026 17:23:22 +0200
Message-ID: <20260721152442.481779175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2632,7 +2632,7 @@ static int pqi_scan_finished(struct Scsi
 {
 	struct pqi_ctrl_info *ctrl_info;
 
-	ctrl_info = shost_priv(shost);
+	ctrl_info = shost_to_hba(shost);
 
 	return !mutex_is_locked(&ctrl_info->scan_mutex);
 }


