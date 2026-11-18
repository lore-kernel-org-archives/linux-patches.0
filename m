Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058404;
	b=N6Wt7ESv5r+R3HyVZY0a1TBBU67WennGKmOdWMsx0jxUnMquSVsfa7/DOlDeRz+frgqa
	 feW2SsmcFMLRvpnzSQzHFPhfmtLBbdEvYh3kzyDFzoA20u4bVHLj4jU6TiYqv1l74uq2T
	 GJuWWhW1FXN0K2f4HWfw2brCkA/Pdd5N89kUhfPxaff8cGpXGSre/zB8EuJTvMkAGr8ih
	 m2mb08f4CXZmsABpXBSeKOpBXnh2NvXn9glK6kZzOM3PRVUcvxH7+jgjjvDSKYVKJ9o+T
	 wRY6XjmdG23wb1O8P/BJ+oetxRrdBeBPIoOc23ISj7sNAC6nUsAmwcHsZPq5Nvr7snQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8/EmPCzPgH+0OcAX8jF09r6jmSphg4fdQwhidkccZB8=;
	b=FbmABR1QTw/D08U6wnxLi09YhO6ZBWmaAc4VDwYzlanQ0c58uN4pMQ3jnD7zsUe21kNF
	 9pE9DC6TrYgdzz9dSLbpZaxTFnIP5Y7xg3i7Aonwhly0tRcp4o42jKts/gq5Q3iBz/ndK
	 wcZPde1pObzlfMkK5b7hEy1OKbuMkEEDulysXsSziV+82VcpRD2J8wnl9Du4VEA992ipu
	 pogRjA64+0HGuL/igE6LV4vrf2WFBcXSMM2Hm0uP5PnlmxtgCphdQU+xerT8uDV2pObgw
	 NZBS0a64ikWQKe6kIJnJ9he788s00erNiumngW3XK5YtPlTvmx+vetdztQq0e5wrfzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bG7/xL5P";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52722606A31C;
	Thu, 19 Nov 2026 03:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bG7/xL5P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2531F000C4;
	Thu, 19 Nov 2026 03:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058403;
	bh=8/EmPCzPgH+0OcAX8jF09r6jmSphg4fdQwhidkccZB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bG7/xL5PMxcTALKOZ9EQiT9jFnEo6z4qqVSXTG4ge1aTFO5FYYrSQ0ZzmVeycsa22
	 ablYo7vmbxRnZZF3zr2oNEJPjdccOo7XKTe6aLhJWZi8HBNUti+UQNGoT8Ov5o7t5G
	 PjyJq6Ru3hdQU7Lm2+8RGx3v06CLkflTOfkclemY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0472/1848] floppy: return the drive state flags from the 32-bit FDGETDRVSTAT
Date: Wed, 18 Nov 2026 15:41:50 +0100
Message-ID: <20261118145934.074700024@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov (Oracle) <efremov@linux.com>

[ Upstream commit bb38473f1bcb287567f2fa7980e483a778092504 ]

compat_getdrvstat() copies every field of the drive state to a 32-bit
caller except ->flags, which stays zero. 32-bit FDGETDRVSTAT and
FDPOLLDRVSTAT therefore never report FD_DISK_WRITABLE, FD_DISK_CHANGED
or FD_VERIFY: i386 fdutils (floppycontrol -P, fdmount), and other
32-bit users see every disk as write-protected and never see a disk
change. The compat code in block/compat_ioctl.c copied the field;
it was lost when that code moved into floppy.c

Also declare the field as compat_ulong_t: the 32-bit struct
floppy_drive_struct starts with an unsigned long, and a signed char at
offset 0 only lines up with its low byte on little-endian machines. The
size and offsets of the compat structure, and so FDGETDRVSTAT32, do not
change.

Cc: stable@vger.kernel.org
Fixes: 229b53c9bf4e ("take floppy compat ioctls to sodding floppy.c")
Link: https://patch.msgid.link/20260924112825.3525931-1-efremov@linux.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 110cf83232c55..8e1a881df16b7 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3693,7 +3693,7 @@ struct compat_floppy_drive_params {
 };
 
 struct compat_floppy_drive_struct {
-	signed char	flags;
+	compat_ulong_t	flags;
 	compat_ulong_t	spinup_date;
 	compat_ulong_t	select_date;
 	compat_ulong_t	first_read_date;
@@ -3877,6 +3877,7 @@ static int compat_getdrvstat(int drive, bool poll,
 			goto Eintr;
 		process_fd_request();
 	}
+	v.flags = drive_state[drive].flags;
 	v.spinup_date = drive_state[drive].spinup_date;
 	v.select_date = drive_state[drive].select_date;
 	v.first_read_date = drive_state[drive].first_read_date;
-- 
2.53.0



