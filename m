Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209350;
	b=hdCwR/uQDSpOnZFRUpyyG+qfWP7kfpF+swlYa0Wdf9L7h5+xzynu0Ru2P7wY/iWJWaZu
	 B/iN3pQWQuZOn/R08/RtaI/9r7w91YQC1nOEP2cSvrgUfvjJq0yjpovPkAvMzmaJubJ/9
	 lNqlrNgHwOmBZIsQ9aeGMp4yLLW3iD4i1cbPYjc+4p33u0KqAawJHUGVdHXa5kTCt8hzU
	 w1unxxw16WOoWti3yYiNO0X3dpKQj1NyIbzjjfaIGUO6wjxKX4Ev3I1PD7HnfV7Ojfmw/
	 CeZaIQRGs0pCOAqVcpU+UKKDQlN4LgJ+c/6TUPC+2SEXZBExeeinUNLq0OhzP7iEUvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Can/vONVSXkLapJIbbBozwROBw9uzaxV3B1UE1iyuM4=;
	b=XB7CAGC99kKDEXnhIKJh6fKUW7oOz/KVVpY/DY2LdWIExg7CX4NgGdazBdcryfp66+Ef
	 Aqbjfp7BQjAcq8PS7RHAZWFqB3EMcNPDagVy348M+BqQXeCMzkyxDf1+418uueWVSnYCg
	 7nQoSrXZHFX8e5YzZIPaeNB/0PaknrRJH32ia574dzZANpSt0UX/49PnIfBXInuUE0Wdu
	 uGH1IkXhkubWyTjCPIBH0ypEzYRRCMTfNsgUKipD/yeOJz9kFyuk+YgNEABdwpCJLRr44
	 Hh26lU3z0FChQA3Z6gRSrUarbDpeM2Ry7AMmNO+Z+os1uWYkSaZWJ6SMvIf5ckz6VNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkEQLls6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5D6606A31C;
	Wed, 28 Oct 2026 17:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkEQLls6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060EE1F01825;
	Wed, 28 Oct 2026 17:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209349;
	bh=Can/vONVSXkLapJIbbBozwROBw9uzaxV3B1UE1iyuM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkEQLls6lQ4bo6PC3ccfVlGZd1oH5EBCcQplYgw+HtVOsqxMPptIvrmpnmjz9I9FZ
	 T5oDKTE8T6N2A1cXhS7gJ9DE93uVQQwglTs0lS2oUzmxCf9RUx1Q1UtPT/SIx2W4Az
	 GeLQOmCAuN/nEh9jAcOnTVbGccDk9tsnGsOY8umk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 440/516] scsi: st: Save the visited block for the partition the drive is in
Date: Wed, 28 Oct 2026 17:59:52 +0100
Message-ID: <20261028170013.907190349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 23bbb062c2aaa..ad1092d0c44ab 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3189,14 +3189,20 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
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



