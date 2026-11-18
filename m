Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018407;
	b=Wx9nsN35HDcNz0n7QsyoVFKwUw4/i4iWd8H15lIGgXKoeSn2KHgRVNoGoRkioZqaR33E
	 cFqq6BtUCug+1QpeFUHwEP5tX1F4py2f+mSbqXlf6X47cwlqIShDiZ3MZS+nR8U/cuUUy
	 3THwmc3bObDldL3a3vkYOnJjxBXFe9jGSDAjRaypNbT8u9//1GS13S+WHiNHLX6Fwgg2M
	 GmCIeRymW6jgorCZx7UvOHDwmRgQTVTMJlZ3qJ489QXHmgkRgsJfoSsudAX8W99GRO7uG
	 YlnHU4dmuXEX5M0s3p3Y/RgtBL0Dqu1AHgyjBnA/ofMr2UgRm2gGmZRE5cZJgjgPtdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XtApJPHtLuGRDKZm/N86Q9hoaKM/VHSO959ebMqLVAY=;
	b=kFzL6ix6hlG8GZVtyH+HWhmJkRLe0S3aCZkGn3EfnhV+KT0MA9xhA1a6EpQazS22WoWM
	 RPp5l8F6YEne5RR8FHf8W3xkmkdHvjbB8i4iT//gVhdPTVPfI2UeKSWP05zVWzcIhZ1Gu
	 ePnKeRXvmdKZCNKqEaVmFi3WPA4C+/UeCbS8dWpaq1INrM5twqRVi4wrgkFVOWhCjE+zR
	 rNrPXpdq9B1ptm2mUjoRxedgwaTzo9DtRn0oWr1qYu++3h52d2KSXr0M+9nZ7ENuoVVeb
	 zmJg2k5iaddzOeieI3A2nxvjePvDKpbsyICXUITI4aDJZCF6oogbS0z4w2aVnYTYzLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qCyRoU4A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B42606A32C;
	Wed, 18 Nov 2026 16:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qCyRoU4A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FC51F000C7;
	Wed, 18 Nov 2026 16:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018407;
	bh=XtApJPHtLuGRDKZm/N86Q9hoaKM/VHSO959ebMqLVAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qCyRoU4A15sYoT0giNVr2C/jIg2SzMy0NJab2wg93pew7dqsuhkWFPzvB0gHa5K7v
	 O58iHhsS1TieaSviUq+YPDdfHTKzr9Hc02s/HzfQNK7c9/blZLbDr+hA7VieG8nZ9G
	 JGdm4Qmv/2GVztiXKoJjz7A17eUfd75afc0ruDcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1230/2651] scsi: st: Restore changed drive settings after reset also for MTLOAD and MTRETEN
Date: Wed, 18 Nov 2026 15:41:10 +0100
Message-ID: <20261118150332.292412803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurence Oberman <loberman@redhat.com>

[ Upstream commit 8d1cc285194dbcba88c136e1ff7c25cb10e38a5b ]

A device reset returns the drive's density and block size to their
defaults.  Commit 7081dc75df79 ("scsi: st: Restore some drive settings
after reset") re-applies values changed by the user when the position is
recovered with MTREW, MTSEEK or MTEOM.  MTLOAD and MTRETEN are also allowed
to clear the reset condition and also leave the same medium at BOT, but
they restore nothing.

Because check_tape() reads the drive's block size with MODE SENSE on every
open, the driver silently switches to the drive default after the reset.
An application that set fixed-block mode with MTSETBLK and recovers with
MTLOAD or MTRETEN keeps writing, but variable-length blocks, without any
error.

Restore the changed density and block size for MTLOAD and MTRETEN as well.
Both operations may make the drive report a new medium, and the new session
started by check_tape() clears the "changed" flags and applies the mode
defaults.  So save the values before the operation, let check_tape() run
first (do_load_unload() already calls it for MTLOAD; call it after
MTRETEN), and then re-apply them.  Retry the restore once in case a unit
attention is still pending.  Only restore when the drive is ready after the
operation: with an immediate-mode load and O_NONBLOCK, check_tape() does
not wait and the drive may still be loading.  In immediate mode
(MT_ST_NOWAIT) MTRETEN may return before the retension has finished; do not
wait for it there.

MTOFFL is not changed: the medium is unloaded and a different one may be
loaded next, for which the mode defaults apply.

Reproduced with scsi_debug (which reports a new medium after MTRETEN and
MTLOAD) and with IBM LTO drives on FC (which do not).

Fixes: 7081dc75df79 ("scsi: st: Restore some drive settings after reset")
Assisted-by: Claude sashiko
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Kai Mäkisara <kai.makisara@kolumbus.fi>
Link: https://patch.msgid.link/20260929192821.997675-2-loberman@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a757646c8dc63..0cb99ceedfb51 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3592,6 +3592,23 @@ static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef *STm,
 	return retval;
 }
 
+/*
+ * Re-apply a density and block size that were changed by the user before a
+ * device reset (a negative value means "not changed").  A unit attention
+ * still pending after the operation (e.g. new medium after a load) fails the
+ * first MODE SELECT, so retry each once.  As in the other post-reset restore
+ * path, errors are ignored and one setting failing does not prevent
+ * restoring the other.
+ */
+static void st_restore_changed_settings(struct scsi_tape *STp, int density,
+					int blksize)
+{
+	if (density >= 0 && st_int_ioctl(STp, MTSETDENSITY, density))
+		st_int_ioctl(STp, MTSETDENSITY, density);
+	if (blksize >= 0 && st_int_ioctl(STp, MTSETBLK, blksize))
+		st_int_ioctl(STp, MTSETBLK, blksize);
+}
+
 /* The ioctl command */
 static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 {
@@ -3600,6 +3617,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	int retval = 0;
 	unsigned int blk;
 	bool cmd_mtiocget;
+	int restore_density = -1, restore_blksize = -1;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3746,6 +3764,17 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 					st_int_ioctl(STp, MTSETDENSITY, STp->changed_density);
 				if (STp->blksize_changed)
 					st_int_ioctl(STp, MTSETBLK, STp->changed_blksize);
+			} else if (mtc.mt_op == MTLOAD || mtc.mt_op == MTRETEN) {
+				/*
+				 * The same medium ends up at BOT, so the settings
+				 * apply as with MTREW.  The operation may start a
+				 * new session, which clears the "changed" flags:
+				 * save the values and restore them afterwards.
+				 */
+				if (STp->density_changed)
+					restore_density = STp->changed_density;
+				if (STp->blksize_changed)
+					restore_blksize = STp->changed_blksize;
 			}
 		}
 
@@ -3825,6 +3854,14 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 
 		if (mtc.mt_op == MTLOAD) {
 			retval = do_load_unload(STp, file, max(1, mtc.mt_count));
+			/*
+			 * Restore only if the drive is ready: after an
+			 * immediate-mode load with O_NONBLOCK, check_tape()
+			 * does not wait and the drive may still be loading.
+			 */
+			if (!retval && STp->ready == ST_READY)
+				st_restore_changed_settings(STp, restore_density,
+							    restore_blksize);
 			goto out;
 		}
 
@@ -3843,6 +3880,20 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 			retval = st_compression(STp, (mtc.mt_count & 1));
 		else
 			retval = st_int_ioctl(STp, mtc.mt_op, mtc.mt_count);
+		if (!retval && mtc.mt_op == MTRETEN && !STp->immediate &&
+		    (restore_density >= 0 || restore_blksize >= 0)) {
+			/*
+			 * Retension reloads the medium and the drive may
+			 * report a new medium.  Let check_tape() start the new
+			 * session (applying the mode defaults) now, as for
+			 * MTLOAD; otherwise it happens at the next open and
+			 * overrides the restored settings.
+			 */
+			if (check_tape(STp, file) >= 0 &&
+			    STp->ready == ST_READY)
+				st_restore_changed_settings(STp, restore_density,
+							    restore_blksize);
+		}
 		goto out;
 	}
 	if (!STm->defined) {
-- 
2.53.0



