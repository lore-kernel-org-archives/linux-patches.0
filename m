Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018410;
	b=GmXugu6jptrJuAwaqxhQGUcXHEXDp4mHn55Ea4EfNNw+Sp0NZvtloSMSVBLv6yqGysoD
	 9lCjmswotrCl2ZJ86sUIZ/xpcbeZ1e24iza1txfk1jy7p3Y5hnb/uiZpVDPP09LbrbRiI
	 v+grGfRpbe80EHR3V9hMsPueCO/uqN8oQOFRdwE+Tteeatx5Pt9Y1GlLhfX7ch6nTp2ky
	 AoWspMcYNnv9jJiu7MDZ/1llJrYU3cPi7VkeSah/Ry2toRj+AfOAQHsoCZkDofqMXIEKI
	 KYt/PrYKMQYNlLu4o2X26yMbug2JAoTcke9mECrddR7Z7PmH9ZfhHXEDEWygi06dEMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fqyIPY790PkDfd4BW2uiXKdiCqavwa12EXjx3K3YXcM=;
	b=b8BKXhd+AHuj17/eXmWZlohvxdO1Ja9QMJc3Z7aJRiKdIPQ0/LOifVx0vrS3/sGNerlq
	 QA/tLm6lLfumtV199dk5Hb+aYSEi+wmV1hvoMX+c+ztytjgjj/IlEMmVRXqEolbgyM+Qh
	 R7ED/1m2yRfY/DWFlZwjGPqxSuCbUSHHzr0ROfG6LMngJyU+A6ZjlIRiE6EDrvOvviY7p
	 j8fhfyIoLVyrdvanECENu1G43aNTLH6lqt1EjH3HGv3tm3LiJWl17ruXUkcId0K1K4VVg
	 ihNwqVuegOESUGWgjKYBhAmQEoPYpNTr0/OTQJOzjXtGBLmkuf+qOQt5hyqSjzpNnHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gck950OZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9A7606A31C;
	Wed, 18 Nov 2026 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gck950OZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBD41F000C6;
	Wed, 18 Nov 2026 16:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018410;
	bh=fqyIPY790PkDfd4BW2uiXKdiCqavwa12EXjx3K3YXcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gck950OZqh7VlFKE4EsKhDjWzB+rZqzC6mFQK/tws8w0p3NMWXFWP/Oa8MRuFGM5p
	 UHxW2DKP7wqgKk96+M3ZuQNLmoPW9dAmOXgDGTubvjKm138T/0sZlSPGdflFQnWnAo
	 d1K8Y13bx86Y3xVZqH1B4Un5+QtLMvAoaybYio5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Laurence Oberman <loberman@redhat.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1231/2651] scsi: st: Record the tape position after a successful MTLOAD
Date: Wed, 18 Nov 2026 15:41:11 +0100
Message-ID: <20261118150332.327217347@linuxfoundation.org>
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

[ Upstream commit 54ee0ee9bdeb7e9d3b70cc5c2bdf7e58c4423e8d ]

Commit 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed
after device reset") allows MTLOAD to clear the reset condition because the
tape location is known after MTLOAD.  But the driver does not record it:
reset_state() sets the file and block numbers to -1, and do_load_unload()
leaves them there.  check_tape() sets them to 0 only for a new session,
which requires a new-medium unit attention.  Drives that do not report one
when the medium was already loaded (seen with IBM LTO drives) keep
reporting file/block -1 in MTIOCGET and no BOT, although the tape is at the
beginning.

After a successful load, reset the partition and the state of all
partitions, as the new-session path in check_tape() does: partition 0,
position at BOT, EOF state cleared and no pending write.  Otherwise the
driver may still record the previous partition, so that a later MTSETPART
to that partition is not performed; a read after loading at EOD fails with
EIO; and a partition left in the ST_WRITING state by a partition switch in
read() or write() makes st_flush() write a filemark at the beginning of
partition 0 when the device is closed.

Fixes: 0b120edb37dc ("scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset")
Suggested-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Assisted-by: Claude sashiko
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Kai Mäkisara <kai.makisara@kolumbus.fi>
Link: https://patch.msgid.link/20260929192821.997675-3-loberman@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 0cb99ceedfb51..f7d9c67aaf87a 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2686,6 +2686,30 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		else {
 			STp->rew_at_close = STp->autorew_dev;
 			retval = check_tape(STp, filp);
+			/*
+			 * LOAD leaves the medium at the beginning of partition
+			 * 0.  check_tape() records that only for a new session;
+			 * without a new-medium unit attention (the medium was
+			 * already loaded) the partition and the partition state
+			 * would be left as before the load.  Reset them as a
+			 * new session does, for all partitions: a stale
+			 * ST_WRITING state would make st_flush() write a
+			 * filemark at the beginning of partition 0.
+			 */
+			if (retval == CHKRES_READY) {
+				int i;
+
+				STp->partition = STp->new_partition = 0;
+				for (i = 0; i < ST_NBR_PARTITIONS; i++) {
+					STps = &(STp->ps[i]);
+					STps->rw = ST_IDLE;
+					STps->eof = ST_NOEOF;
+					STps->at_sm = 0;
+					STps->last_block_valid = 0;
+					STps->drv_block = 0;
+					STps->drv_file = 0;
+				}
+			}
 			if (retval > 0)
 				retval = 0;
 		}
-- 
2.53.0



