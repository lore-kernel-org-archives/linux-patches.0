Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040658;
	b=omnXonSLwfwqPtcObM4ysL8fPyHZ6p2unlWsPiFkwe04ZeITN+szq6+64sPzeXmvY8vC
	 B7APAHcspjUb6S5gxhgCeeraKV0ysOlQiMa1RryuPH2/AWHDuQS3L1BeWP+5se04KlNcc
	 0uDDCEeF3PnaKAD8ECQ4s6FlkDU+7aedmcKZekVN0kom2NolaasEl/QeFB2zs6tfJc09+
	 f5P86LTIj+FCNvK2Hw8FrqtOanSfuJNHaLFuOqt4XGszj3LUjGUdz2W3pESkes5EQfaQF
	 MMZPWiI9/YWcm7q8H1fjvjAgYeHE6NaTH8RQX+oB2tlwu9AQt9hXsY4wAnVVTk5A0Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+iO7PGyGluny+cpgXCH62kKwyP3VR3YdX8w6tGITSVM=;
	b=cngmAc5Utllj7DQyS5C2nZFfTD/Rd/DMp7BlIAG5R1QAK6XI6UiZxd71Q24Yq+VigCLd
	 LD1RB19xRXVtJgZIs72y9wN41krvRCxyxz5yAQoojic6MvnZItYmXvyMJoU33d0uSRj4/
	 UOiBZTqhR2geFOYAkAvBMR/II72gKgZR+5eX5xGIymV6GY9Zf1GpE/bsLm3eZCW913u2f
	 QBcSWKl55/kNUfWNhPVSQTI9zhpDIC3OTAg5vAO7ZkgGDAMl7UekYFiMWU2SPXfye9uID
	 Opn0EQjAsApLYZHNKVN3b9iIuFjn19pGwegTS1Kp0pDgpMbWhIjBN5gbnzUwWR2djyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=by8W8RO3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B19606A31C;
	Wed, 18 Nov 2026 22:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=by8W8RO3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6F61F000C4;
	Wed, 18 Nov 2026 22:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040657;
	bh=+iO7PGyGluny+cpgXCH62kKwyP3VR3YdX8w6tGITSVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=by8W8RO3D46gbx7QCTkJx5zAyJMSRQqI7fOfluBlLYHyEqWjhgHaEBvvyN66S0Vqw
	 wWROfgLTiS0umGGvLV1akiYDXQ6wfLin9giDREZ7jgj5FoW9h/2W3DPQ7TvYZL0XkP
	 xqZI/PQOusddxYJwIZrzzU9scxOuEyiRjv8Qfdkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	Laurence Oberman <loberman@redhat.com>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2534/3318] scsi: st: Record the tape position after a successful MTLOAD
Date: Wed, 18 Nov 2026 15:52:36 +0100
Message-ID: <20261118150437.347528683@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c8d9ac6d836b3..0009c81a69264 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2664,6 +2664,30 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
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



