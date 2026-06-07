Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B1230D405;
	Sun,  7 Jun 2026 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826815; cv=none; b=eJoM92q4KPsn+GLGrnRhyJffrml58ornJI349jUSAeWhfmAHKKOZQt3D0lwd5P77VJKagTuPwrif6U0MDhgXOFtQdHbx6/IX5Lk0ILOQcPx4+hR76EaZNi0FE7XA4HAR3fpnh2PT/pn2dBgUwF0P1OixZUQ3tZ68PSioXG7M1Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826815; c=relaxed/simple;
	bh=tW1Gj1Q5xLIfOFc4ZmQ4O5MdDnYuLAFVFNdjnWUnd5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0G/EBitRdKV/V8EM8TyKnmdVwW8tIipVAC4+gTinNciC/8BNK9ADh009WbwnfWBm8H8gp/qoV7sdEnH6TonubURk6Zu3RCovP4qeYPqAiv0XQaFc1zRBG+hsgZYw8kXjW26XGGYEpGZURUCFyD4tcXVQ25PGYWvujJjQq7VyVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leI9jeVr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leI9jeVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668111F00893;
	Sun,  7 Jun 2026 10:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826813;
	bh=SPkRAouXKeI0mG+gxaJlh0I91LVTEm2CdcqSGRVMsQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leI9jeVrxkych1BVoGnq4Qc34JMnT0Iyy1QEVPiij8+QbtSEI817R/e49iPHIZ3Nt
	 lWLmz7KbSW5FzDJIvrrfhJfA8ICNQJ5eT8ARg7GAL7vMioPwaoxx765T0UJz6fws9a
	 LaaSYHkfQmQk3P+Qhu1tppfDtf3Q5EQ+5cygR1qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 030/332] scsi: scsi_debug: Add missing newline in scsi_debug_device_reset()
Date: Sun,  7 Jun 2026 11:56:39 +0200
Message-ID: <20260607095729.196987854@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit e4bb73bf3ac11b4a93634660345b9d764a4a80df ]

A "\n" at the end of the sdev_printk() string appears to have been
inadvertently removed.  Add it back for correct log message formatting.

Fixes: a743b120227a ("scsi: scsi_debug: Stop printing extra function name in debug logs")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260519205356.1040855-1-emilne@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea7e..040c5e1e713a2e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6953,7 +6953,7 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
 	++num_dev_resets;
 
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp, "doing device reset");
+		sdev_printk(KERN_INFO, sdp, "doing device reset\n");
 
 	scsi_debug_stop_all_queued(sdp);
 	if (devip) {
-- 
2.53.0



