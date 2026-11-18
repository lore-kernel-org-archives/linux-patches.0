Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025391;
	b=BLb7WdqcP5r1UrIxTLQeK6iQ0ssJbJyBvs/JMp3VhoVr4K6sdjnL2FhFg4bHLdXpZ1Ov
	 ymM3ih8EjyQLrbEdBv6VMr8X2xhr8Tu3FyavoNxlegZ0dK6HSv1Y1Shuj1oFSWqeV9kov
	 qwvqc2fWugQALdHMEtKVvDr7m51BUPAUUrilcHBj2OZLczs7MhZw81Vss4rlsdjjsKx89
	 WGisvO0oVzmxL9GF5Nd4iGFxtRu2H3iyJCg4tZt7SxySfM3loy0X0fJbxPtUvjEkNgY5Z
	 CYgLJ45thq6xtRIXJRFmiQ/og6uZqKjvkDy677SGC/x7OQzQg0jjelxPcVSsil3znSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6Ab+Y6IaT8r7QL5QqjXrmKja8NFGh8ODDWeJefbuMqc=;
	b=MfQj/iOzsT84PqjtOm/ehdTpPuHKrWj9wrWMtZ7EnmFYaSHbchgSzhqHqUCqlw/bq4p2
	 ZvweggsQkWQe0ZQddPMfI2xGkWQ5ySy8qeFcJQFHEaJwcbJjOaBOo3z16YPNw1IhFTpc0
	 GkoqgCOKacox1QrJRE4BPKAXK6w+1RxxGhjL7W+jeM2MA+bnnjdax/kLAFYbpkTdG4VhS
	 NRa9m530qor/L44J1P7rxLnDmNjBNQy3jRbFxCmsFUQQGsky+H5YIL7OX5wBSnNPCgOst
	 dnchbh48VFOkNziEGeEYVyZ11woLA4miawQ6QSpl5Swf76qnobODUncuh1UFZOsj3+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M9smAqHL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64719606A31C;
	Wed, 18 Nov 2026 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M9smAqHL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B530E1F000C4;
	Wed, 18 Nov 2026 18:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025391;
	bh=6Ab+Y6IaT8r7QL5QqjXrmKja8NFGh8ODDWeJefbuMqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M9smAqHL2IBGMstQjDVS71M+bg2vOCzvDY6/TS2lmuuGT3gPmxRhFxYjcfMzcOb4D
	 860L7JcnHNnbKRk/9sc3cNoY3QSBLf7FtlCPCAJi0wWNuWHbIII2agcMV65WUycPv1
	 b8ducbZeSsrMcABbk2DT7VzrWhJDsNYZxzcy+ch4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1022/2151] scsi: st: Restore changed drive settings after reset also for MTLOAD and MTRETEN
Date: Wed, 18 Nov 2026 15:45:57 +0100
Message-ID: <20261118150159.630504437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 476a45fdf7871..f90e5b055fa97 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3535,6 +3535,23 @@ static int partition_tape(struct scsi_tape *STp, int size)
 
 
 
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
@@ -3543,6 +3560,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	int retval = 0;
 	unsigned int blk;
 	bool cmd_mtiocget;
+	int restore_density = -1, restore_blksize = -1;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3680,6 +3698,17 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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
 
@@ -3759,6 +3788,14 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 
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
 
@@ -3777,6 +3814,20 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
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



