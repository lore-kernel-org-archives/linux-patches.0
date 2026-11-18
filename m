Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061139;
	b=ay5UP2q8U22KxME5Y1RNQ9LltW0hYNmx18hCRKLa1IKnf95Bl7OrXzN6SvzUJP5+r26u
	 1YvhJ23IYRjB90UOxY/OdYvntvNP4MYJqBWOnq+sEATERYcLFTQFpt5P7Blvuxx15erG5
	 dwxiYCVG6O7KolXw4coT4bOD1Tt3LUQhZDkgqlrKy89v9MErrHoOsvmqjRWe1bqrQBgwp
	 VzISDlfDg1tHZNDaf/+ZQW0l5hY9dJrApmGjwCloUppZrJwjx2Rgq4s3YE+/6u7bZKhdw
	 9YgYTwOQfeH1TJuPi2oc11sgKordHbarMfEnUAtZ7/TGsZyqizw//BcTzSOgy4iAG+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rRlDXDTL6pG/Sm2Ub9tR9xSu5f7OlEob9C0QTUExnuQ=;
	b=miSu845TIGV7CS+ma1yWVkG+3Bb/rM0H2WwiIQAQuPEQUCGHYf+z82VP4bE7ZcvTYW0Z
	 EHYF5qVtNTQToQJpwU8F62JLrU30bOqRYk7ja2hAi3wOXhEc7vIuYGVrelBHCHzTEJw1t
	 2S0w6igekd2bAL/QtJHfUOqlqHwzkajDpaheYkBF376bduVpp9XTsnLjF0Olhz3Cuuq1L
	 PPV0E1W7bz0PakkKD9ugMHI3LX/AsxPKdsk9VB9dCPHMcyBqXEoomgs+A36IkJrtuyDWG
	 8c35Bmdvs5czgluPpbPm7g2avtHcBJzMgl+rDcWMd87FdipJ2gFlocVxykDZjcqym5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJ8XFWV6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93F4606A325;
	Thu, 19 Nov 2026 04:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJ8XFWV6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160811F000C5;
	Thu, 19 Nov 2026 04:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061139;
	bh=rRlDXDTL6pG/Sm2Ub9tR9xSu5f7OlEob9C0QTUExnuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJ8XFWV6THKjhwPj/HhBWABX9YgcYWdxHN/TBtu6dCx3rSZ3tTNfvvU6nuvRYDaDq
	 pqH5MebZDjodFtrx8C4WFzRNoW4BxjWOEZKZcidoAUtGvuMsrOqyBzkMEyB+gukiSm
	 HRWATaQipsCU63yU3pQKHzAqx73SSpT2SwSuPWr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1446/1848] scsi: st: Restore changed drive settings after reset also for MTLOAD and MTRETEN
Date: Wed, 18 Nov 2026 15:58:04 +0100
Message-ID: <20261118150019.981241572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 566dec22b5326..392eb842b5ebe 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3508,6 +3508,23 @@ static int partition_tape(struct scsi_tape *STp, int size)
 
 
 
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
 static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user *p)
 {
@@ -3515,6 +3532,7 @@ static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user
 	int retval = 0;
 	unsigned int blk;
 	bool cmd_mtiocget;
+	int restore_density = -1, restore_blksize = -1;
 	struct scsi_tape *STp = file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
@@ -3654,6 +3672,17 @@ static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user
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
 
@@ -3733,6 +3762,14 @@ static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user
 
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
 
@@ -3751,6 +3788,20 @@ static long st_ioctl_common(struct file *file, unsigned int cmd_in, void __user
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



