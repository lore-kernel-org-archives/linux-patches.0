Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055285;
	b=GVf8vJq4XN+gcSbjHUM5T6cK2m3rNXdmXOK5Y9/QdohvkLFRi9cw3rRzcqP98I4YhZ5W
	 niZpibhccgyrVX7LgKLSnVfEYa0YGcJ89tmB+SERm3W33t0OUE3BOHyGn56SDp4VuPWeD
	 jIyMdw2kWmZIFVLyw5W6kNmvUNUU6yr7W5hbkS05vRhqG2Qsghpdm6SdeH+NWu5/f39MF
	 4k3BIkpFCQq9ISNdHyysoHT94EU211zV0Qu3Fl6zHjOhI+yPUselKF6xe5HUp8oOxp6T7
	 cWyRwhhNOmKW4d+i8uWf8yZGVL1qGa0zVWC0lUg/VqQQ2en38JiZ6KQhWSWQ+6/CLYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RbwjVu9geP2008biVxFSMUFeG3dkSGYVsKGobpDWfPQ=;
	b=r6efjVjWsLQABV+iKQRRvYF05b8BtFuylvqjnzaNQWmkj8RzWN8o2GpT31UZ7k6DOJ5c
	 7WL/uzX6wwp2IXY9y7G0FuJbFyNXbpA3da9G2E2+Q39EzpIEP+ch2fFCUtANscunXjlBw
	 DUILl6mhv16hdwhxHez7LQCugkXGmQNPQDgCCFDvPcQ70HkGIjZXFrvCqMktgIccmzJC5
	 Sow6YX2DkH+YqM6M+bMJT0pVCT20w87ckpPvTRi8mr21sh30Mczp+BhNw5MT2Lf42hCRQ
	 GQUfkiBwJakPH4/K4UI22cX38ZM+k2eWA6ZzPReUElxqNCZKR2qj8IUi9nEcNan6m6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYdDuJ+f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7C8606A330;
	Thu, 19 Nov 2026 02:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYdDuJ+f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A091F000C4;
	Thu, 19 Nov 2026 02:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055284;
	bh=RbwjVu9geP2008biVxFSMUFeG3dkSGYVsKGobpDWfPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYdDuJ+fvNwUxc9x3DFGW/DSkmqBR8Iv/odSgLXq99WXb5GvvjnZ1EU7/Tfpl0IBo
	 7Gb+gfKTlUC9YPNb+CaZ3tErmVfCT5bpOqtQowL+B4AtOUWp7kBLcZM+eROg2fBDcL
	 LueJacWqtGp8e7QAoByYfOZGh/SzDH74w1YNYLC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1576/2214] swim: Check error register during sector read
Date: Wed, 18 Nov 2026 15:54:12 +0100
Message-ID: <20261118150115.085414930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit d66bdef0a3083fed1a0fc4f0ee1c85b26476b21c ]

Clear the error register only once before a sector read operation. Don't
clear it afterwards -- the caller needs it. Check the error register in
swim_read_sector() and return the appropriate error when necessary. Fully
validate the sector header. Don't terminate the search loop early just
because an erroneous sector header showed up.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/efabd807f4ecf5cbc05b60e91ed69aa4c10691a8.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c     | 13 +++++++------
 drivers/block/swim_asm.S |  8 --------
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 066cceafd9d70..f4fbe195cbc09 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -482,20 +482,21 @@ static inline int swim_read_sector(struct floppy_state *fs,
 
 	local_irq_save(flags);
 	for (i = 0; i < 36; i++) {
-		ret = swim_read_sector_header(base, &header);
-		if (!ret && (header.sector == sector)) {
+		if (swim_read_sector_header(base, &header) ||
+		    swim_read(base, error) || header.track != track ||
+		    header.side != side || header.size != 2)
+			continue;
+		if (header.sector == sector) {
 			/* found */
 
 			ret = swim_read_sector_data(base, buffer);
+			if (swim_read(base, error))
+				ret = -EIO;
 			break;
 		}
 	}
 	local_irq_restore(flags);
 
-	if ((header.side != side)  || (header.track != track) ||
-	     (header.sector != sector))
-		return 0;
-
 	return ret;
 }
 
diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 81c824923336c..fcf574ced85ec 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -67,7 +67,6 @@ mfm_read_addrmark:
 	movew	#seek_time, %d2
 
 wait_header_init:
-	tstb	%a3@(read_error - read_mark)
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	moveb	#0x01, %a3@(write_mode1 - read_mark)
 	moveb	#0x01, %a3@(write_mode0 - read_mark)
@@ -140,8 +139,6 @@ crc1:	tstb	%a2@
 	andb	#.Lhr_crc_error, %d5
 	bne	signal_nonyb
 
-	tstb	%a3@(read_error - read_mark)
-
 	moveq	#0, %d0
 signal_nonyb:
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
@@ -166,7 +163,6 @@ mfm_read_data:
 	movew	#seek_time, %d2
 
 wait_data_init:
-	tstb	%a3@(read_error - read_mark)
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	moveb	#0x01, %a3@(write_mode1 - read_mark)
 	moveb	#0x01, %a3@(write_mode0 - read_mark)
@@ -191,8 +187,6 @@ wait_data_mark_byte:
 
 	/* read data */
 
-	tstb	%a3@(read_error - read_mark)
-
 	movel	#sector_size-1, %d4		/* sector size */
 read_new_data:
 	movew	#max_retry, %d2
@@ -234,8 +228,6 @@ data_crc1:
 	andb	#.Lhr_crc_error, %d5
 	bne	data_exit
 
-	tstb	%a3@(read_error - read_mark)
-
 	/* return number of bytes read */
 
 	movel	#sector_size, %d0
-- 
2.53.0



