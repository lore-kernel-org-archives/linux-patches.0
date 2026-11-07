Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065302;
	b=2Tyhv9Oh8yyBMnjVSX9lHp3b+dq6LPAQ53KMt8AEosYDuNZePj58uqW5yZIH1ylQ0txX
	 22QjO9o+XtVAtD6I3hpB11r5LgqhgGJTHeVBPjc52V8W+jV8men8YVEv782jWIAMfmroL
	 90TDQh51rPHni2VQzN3IC61GYhL1MUkQfZBlXDuYKcrMBfZP4VTsr/pReESRMLL7UsnML
	 NNyjQGIvOFZsCuqQVk4LZ0Kkyg5URTD91eD2FZQl1LXrY9ZuiHQ1GGgFvZ1+gxFsCDNi+
	 sY0FG/+36cHIVkpGqRTRvRXZey9RyZzSfE/JEHyBI911qcN27zS91CjRgTs8QJcping==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HsHHnFEXbBeg6YHkn359sXZx95MyOjpRuNvFYDFWkKI=;
	b=dZc5Tw7pMIpd9n9+N6JNQN35Fmf3byWzha14F/LYhx9ySQAfXCKh5gdu5bqCERpiGv5g
	 wGoaqImTlf6K2KIEJcV5DpNIkBonK3BzHffEQZ0GH/fZ7Qs6M7TuLtn+Z+heqBENfwvUP
	 jIwJTR25Baw0xTq9mndKK3KeLuZLQ4FB9iqRV0M6eIcNXpqkdSk9SM+Afo5OGQiEXM1lc
	 5gUnSmgeD7OMdfyUJGdS6S+xcew8FdOszl2LMRWuiL7HjYJyVOf+dHWzVYdEPTdSFkhJu
	 OiKO1/gZsi2ZqGVbfX0lqThEZo8bGUELgG9mcnsHAhbOgEv76AH0fWcjeqTCl3do5Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ab6aoTES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309BC606A336;
	Sat,  7 Nov 2026 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ab6aoTES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9811F0089F;
	Sat,  7 Nov 2026 15:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065302;
	bh=HsHHnFEXbBeg6YHkn359sXZx95MyOjpRuNvFYDFWkKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ab6aoTESDZe8qnOc4iWRuafOKqW2loRfRbHr9RKA5LCrLm0X96BznLfwsBH417zUL
	 rks6LcCLrWX0Fi7K5uQoBzUHGmRg4FlFV5pC62sPNWVK/4yqAR6FvYCh1xsCDFHk//
	 5BB4heWFeZiQRJUOjS/CwxDcxS4ZzAaaxDiyYz9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Lianqin Hu <hulianqin@vivo.com>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.garry@linux.dev>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1055/1257] scsi: sd: Mark the disk dead if runtime resume fails in sd_remove()
Date: Sat,  7 Nov 2026 08:55:51 -0500
Message-ID: <20261107135008.427217510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 085bb18a0b91007f04ddca13af30277c78040157 ]

If a SCSI disk is unplugged while runtime suspended, its request queue is
still in the pm-only state when sd_remove() is called. The runtime resume
attempted by scsi_autopm_get_device() fails because the parent device,
e.g. a USB device in the USB_STATE_NOTATTACHED state, cannot be
resumed. Hence, sdev_runtime_resume() is not called and the pm-only state
is not cleared. Next, del_gendisk() calls blk_report_disk_dead(disk,
false), which calls sync_filesystem(). Any bio submitted by the filesystem
waits forever in __bio_queue_enter() because the queue will never leave the
pm-only state and because GD_DEAD has not yet been set:

 __bio_queue_enter+0xb8/0x174
 blk_mq_submit_bio+0x640/0x7e4
 [ ... ]
 exfat_sync_fs+0xa4/0xe0
 sync_filesystem+0xa8/0xdc
 fs_bdev_mark_dead+0x30/0x88
 bdev_mark_dead+0x54/0xc4
 blk_report_disk_dead+0x8c/0xd4
 del_gendisk+0xa0/0x2f8
 sd_remove+0x30/0x60
 [ ... ]
 scsi_remove_host+0x88/0x18c
 usb_stor_disconnect+0x68/0xf4

Fix this hang by calling blk_mark_disk_dead() if runtime resume fails.
This sets GD_DEAD, tells the filesystem that the disk has been removed
without attempting to sync it, and wakes up any bios that are waiting in
__bio_queue_enter(). Syncing the filesystem is not possible anyway if
runtime resume failed, so no data is lost that could otherwise have been
written. If runtime resume succeeds, behavior is not changed.

Please note that this patch converts temporary runtime resume failures into
permanent failures. Before this patch, if runtime resume fails temporarily,
a filesytem sync would be postponed until a later resume succeeds.

Cc: Christoph Hellwig <hch@lst.de>
Tested-by: Lianqin Hu <hulianqin@vivo.com>
Reported-by: Lianqin Hu <hulianqin@vivo.com>
Closes: https://lore.kernel.org/all/TYUPR06MB6217DD31B1B3CD09E431CC12D2922@TYUPR06MB6217.apcprd06.prod.outlook.com/
Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Link: https://patch.msgid.link/2c0c76d70f0fe197932836b9bcf8496095135d1b.1792446921.git.bvanassche@acm.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a1b21ea14e549..208b915f25a2c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4270,7 +4270,15 @@ static void sd_remove(struct scsi_device *sdp)
 	struct device *dev = &sdp->sdev_gendev;
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
-	scsi_autopm_get_device(sdkp->device);
+	/*
+	 * If runtime resume fails, e.g. because the device was unplugged
+	 * while runtime suspended, the request queue stays in the pm-only
+	 * state and any I/O submitted by del_gendisk(), e.g. from
+	 * sync_filesystem(), would wait forever in __bio_queue_enter().
+	 * Prevent this by marking the disk dead.
+	 */
+	if (scsi_autopm_get_device(sdkp->device) < 0)
+		blk_mark_disk_dead(sdkp->disk);
 
 	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
-- 
2.53.0



