Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049003;
	b=X9OrRfEoC8Q66Yzg0YysdFyuJC52OC5ZuLfUHzDLFcXrinyn952zBQnvLHnBITdhOoYm
	 92gEgrbK7EHfcxKjguPqRVvwWqHuTFQ/y6hJjCqXjj4Y/tjMl1hwBhkeg2lngsEuolyWN
	 sKeaVpTOSsb9LvqYBsVt6fIRW3eXmP5sHvDvExr0O3eF1j2qWa0SIaMcHJDdac/MyZu6p
	 knpbC/bQchCUftOcoG5XoCAgKQk6d4YoVtg5YAQ/wD33DWQoPSdTY/lHzHRizW2hZ1Gkw
	 QxIo82R4+4Q6eCXFN+yjvCZAbG2pfZaaGlqls4p/G+D5nFi3RcnAg/iy1usehGk00Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=up0Ux3tPdpkUyK1J2yMbbLmSeqoRwvKdAzzTz5HOyMU=;
	b=RXkW7UFyNG7z5pJvAd9cRfy19ZzFfQ7d4W14xzc7YrdabUJjccb7dNBqASx2l+qw6FNy
	 JmpUX/zIvlNy3iGEC3+HQhBvrE+t/90S/tqhaGwOmerWfdlG3biDRFsxFpfanEecWSMcH
	 b4fordVfT8BpJAkAoD2KzybHEn3zD0EdsN5PjEtQPNSMwh1WpyXs9K6JZaIxJp4QaN/23
	 SoiXZtTzPZ+SO3yXXQztKr4zR9ZRyhsJAB4xeDtNg53Qw0RxiwQkwQ4jWlxHk+qJ91p0c
	 7Hg/vMdr2KOZX+ibYGMawsGqzdiYnVtCbwc5PSXft9gKqsqx0u8iLOvXPqYKKwvznMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mnWyXN9O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0770606A325;
	Thu, 19 Nov 2026 00:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mnWyXN9O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AD71F000C6;
	Thu, 19 Nov 2026 00:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049002;
	bh=up0Ux3tPdpkUyK1J2yMbbLmSeqoRwvKdAzzTz5HOyMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnWyXN9OjkWr3heeRBelr/PwUphbbSMcfpxhT1LKuzOCJ7KYSchnht0MUW+7EL2d5
	 Z6qe1mbg7IH0Wl92WSNcVGapZBd+k4VGa3+3mieQVdmxtbHD1Col0sbNODFovngU2e
	 9QHUTcI62eZiLepCH4KV5J22W+/cAseHFT7Os9wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2197/2857] scsi: st: Restore changed drive settings after reset also for MTLOAD and MTRETEN
Date: Wed, 18 Nov 2026 15:53:51 +0100
Message-ID: <20261118150320.528390779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2ad1703240e43..64c3b5fbb9f55 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3506,6 +3506,23 @@ static int partition_tape(struct scsi_tape *STp, int size)
 
 
 
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
@@ -3514,6 +3531,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	int retval = 0;
 	unsigned int blk;
 	bool cmd_mtiocget;
+	int restore_density = -1, restore_blksize = -1;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3653,6 +3671,17 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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
 
@@ -3732,6 +3761,14 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 
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
 
@@ -3750,6 +3787,20 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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



