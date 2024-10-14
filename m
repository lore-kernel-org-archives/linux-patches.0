Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967611AB507;
	Mon, 14 Oct 2024 14:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916663; cv=none; b=Rd5hWVlGL+75R4ch4R2z4usJiTdTYr9K6h8+tWv/WFGENL69SX98SFNIrceTd0fP9w15tr+xkTewshcOfpL6FCIGjPyuhaBl4WeQmNEBenYgn6ljsmwxV0PHc6Bi5H3mNchKN0YNs9xBZyFbFtfVjsvFpBlzQEdBUHEAPndFOLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916663; c=relaxed/simple;
	bh=rJgLx1404ahk5IukRUtxi5sQzFsVkQBTycEvzOy+YqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6jGltrSWp5is8QzZSPG/l0Gg3mtJbpz9dQd8SVsIi8GigLrGTzx5hrwwLQ16HPrZsbTPTDvx1ubDUGZPX7uFmMOosZOTx/ojtpgsNuZqASX08RkRGtxbPs7g2XWiGnBF0iT/Ktd4grKuKwMliOGYcGoy/EQSO5aSqFrOat8woQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0JIKqLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0JIKqLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48A8C4CEC3;
	Mon, 14 Oct 2024 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916663;
	bh=rJgLx1404ahk5IukRUtxi5sQzFsVkQBTycEvzOy+YqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0JIKqLNZBxqTHB33RmrUMl/v0T4f0V9hAhElQgV1Z0oJVHnZZFrW7WepjSEhEBJZ
	 qMJhY3RAwUzLhAYvW1FUGmq4Rjp/3ScOumQ+HafZDOY+l+EiwRCNnYlZ8boa2+LSF+
	 zpOjkbLtVhzAwyxKRVhbFuRbI6LkzhnpP6fSeg4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/213] scsi: Remove scsi device no_start_on_resume flag
Date: Mon, 14 Oct 2024 16:18:56 +0200
Message-ID: <20241014141044.162199888@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit c4367ac83805a2322268c9736cd8ef9124063424 ]

The scsi device flag no_start_on_resume is not set by any scsi low
level driver. Remove it. This reverts the changes introduced by commit
0a8589055936 ("ata,scsi: do not issue START STOP UNIT on resume").

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 7a6bbc2829d4 ("scsi: sd: Do not repeat the starting disk message")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c          | 9 +++------
 include/scsi/scsi_device.h | 1 -
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b0a574c534c4c..2c627deedc1fa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3968,7 +3968,7 @@ static int sd_resume(struct device *dev)
 static int sd_resume_common(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	int ret = 0;
+	int ret;
 
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
@@ -3978,11 +3978,8 @@ static int sd_resume_common(struct device *dev, bool runtime)
 		return 0;
 	}
 
-	if (!sdkp->device->no_start_on_resume) {
-		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-		ret = sd_start_stop_device(sdkp, 1);
-	}
-
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
 		sd_resume(dev);
 		sdkp->suspended = false;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c8b6f611330c..c38f4fe5e64cf 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -216,7 +216,6 @@ struct scsi_device {
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
-	unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on resume */
 	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
-- 
2.43.0



