Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773896;
	b=DDoyTpFv0RZxT0Bbw+ceM1KZYvsZAq7qxURVtIZ/2bVWnPsr5sPjcaApOTJtWtRgQsc9
	 g24gDQ0t4MdY4DkgixPgFW3PuHn4+1vyerUpDlZ4eTxTYGnw9yVl0e4koNBwbeDrx2uKB
	 gQfdZxTTBKLx8cLyAPAXtK5d6NkFM9PHYBC7i7blW9uz/Wzo2SjFiRwwHTIkv1zdXiwTf
	 eI4PIksCH12JmG+YRvvuGkJcgvpMprSZJuDgVfv/1RRADzBOdxBjedGgWkEEj5mLgXkXb
	 983Hj3UYHWaC3WMX0swTO/mNWDZ45/WkCz48nG4K53VooRtu0euo0DmYbvJh6xzNIAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bz681o6AseOYWTArBt7n5Tj8IQxOn4xBUK3Vvqpz108=;
	b=VLDs8/GJ4ce0e3AtjTmQTlC0QWzHf3a7b/30nlPL6hRG0loLyRFoNHLJ0ozGuMnj8oAE
	 ZT+rxyVF/HmN+B7hAlfETkwO3BvrWOFh5UqAXo/DaWVpE3g5jYmz7QlUE5cxuT3lWQMCI
	 WI3LtD/ptd79XVCeijXMM4GbOlg/yK8L1ws85rNGeC47MGLwCX0BRRGHo7/58vkC+oGOs
	 18kyt08GEbmK4pWRW0lUzjMFwELDEJm7b6OaLxAF0Wq7uZZDugjM7/s4T1ypO1leyzPGf
	 UVNNCzzwEbqIfKJZhgEIUE2RpPb1E1m05HYg8m6op+k4mtcENaqnas0p1y/rMySfpNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PmJa7hak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F12606A31E;
	Fri, 23 Oct 2026 16:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PmJa7hak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E782B1F01825;
	Fri, 23 Oct 2026 16:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773895;
	bh=bz681o6AseOYWTArBt7n5Tj8IQxOn4xBUK3Vvqpz108=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmJa7hakBEkKSJ0IoKUto0fOq1J6Ff4GQzcqUmpVBj0NYGSQo2iXfXVRP6K6L4IOQ
	 vnAuvFBPu+izkpZuChbNZoQZ86RinlC4aPTxwlRbxhIfExPYJe9j9ahGd6iY0tvZIz
	 +gXNH2jwGTALxF0jKneavbsQhElJZP2XxRtZNu7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/193] scsi: st: Save the visited block for the partition the drive is in
Date: Fri, 23 Oct 2026 18:35:27 +0200
Message-ID: <20261023163715.391042554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurence Oberman <loberman@redhat.com>

[ Upstream commit c9e9f024dd4f61f0f6636c9f2ed0830f87060e11 ]

set_location() saves the current tape location before switching
partitions, so that switch_partition() can return to it later. It reads
the location with READ POSITION but stores it in the st_partstat of
STp->partition, ignoring the partition the drive reports.

The two differ after a device reset. When the reset is recovered with
MTREW, MTSEEK or MTEOM, st_ioctl() sets STp->partition = 0 and calls
switch_partition() to return to STp->new_partition. A drive that was in
partition 1 is still there, so set_location() files the partition 1
position under partition 0. The next switch to partition 0 locates to
that block: if partition 0 holds less data, MTSETPART fails with EIO
(BLANK CHECK), otherwise the tape is silently positioned at the wrong
block.

IBM ULTRIUM-TD5 (LTO-5), LU reset in partition 1 at block 1025:

  st 12:0:0:0: [st0] Visited block 1025 for partition 0 saved.
  ...
  st 12:0:0:0: [st0] Setting block to 1025 and partition to 0.
  st 12:0:0:0: [st0] Error: 402, cmd: 2b 2 0 0 0 4
  st 12:0:0:0: [st0] Sense Key : Blank Check [current]
  st 12:0:0:0: [st0] Add. Sense: End-of-data detected

Store the location in the st_partstat of the partition reported by READ
POSITION. With the fix:

  st 12:0:0:0: [st0] Visited block 1025 for partition 1 saved.

This is a pre-existing issue. It was not caught when testing the recent
st reset series because the partition test was only run on scsi_debug:
on the LTO drive it was skipped, since can-partitions is off in the test
harness's stinit.conf, as is normal for LTO. scsi_debug hides the
problem because its emulated tape returns to the beginning of partition
0 on an LU reset. It was found while validating a backport of that
series to RHEL 9.8, when the partition tests were run on real hardware
with can-partitions enabled. The same failure then reproduced on
unmodified RHEL 9.8 and on upstream, and the fix makes the test pass on
v7.3-rc3 and RHEL 9.8 with an LTO-5.

The harness (https://gitlab.com/loberman/tapetest, test X03) now refuses
to silently skip the partition tests on hardware.

Fixes: 7081dc75df79 ("scsi: st: Restore some drive settings after reset")
Assisted-by: Claude
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Link: https://patch.msgid.link/20261006164250.773840-1-loberman@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 74a6830b7ed8e..b107d50c542c7 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3216,14 +3216,20 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 	    partition >= ST_NBR_PARTITIONS)
 		return (-EINVAL);
 	if (partition != STp->partition) {
-		if (get_location(STp, &blk, &p, 1))
+		/*
+		 * Save the location for the partition the drive reports,
+		 * not for STp->partition: after a reset STp->partition may
+		 * not match the partition the drive is in.
+		 */
+		if (get_location(STp, &blk, &p, 1) ||
+		    p < 0 || p >= ST_NBR_PARTITIONS)
 			STps->last_block_valid = 0;
 		else {
-			STps->last_block_valid = 1;
-			STps->last_block_visited = blk;
+			STp->ps[p].last_block_valid = 1;
+			STp->ps[p].last_block_visited = blk;
 			DEBC_printk(STp, "Visited block %d for "
 				    "partition %d saved.\n",
-				    blk, STp->partition);
+				    blk, p);
 		}
 	}
 
-- 
2.53.0



