Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029313;
	b=t4SJU1aKX1cU9dsMaXHHSXNjEDSJpqLxsmPmc/N8LQmajp0n55KKZifwSkK51JjO4P0h
	 AexO9qxlli17smVAlULrGqVFRXa6NKSAnG0zGSMYNfrXyeaqx25ZHwqfakZ5XIGa5tfLg
	 Ts+V0nDxRZJw3Bb3ly2fyoXulB6livwXCpfSpxl0s0pBqQ23+A6S4Ta5W5j/CDzcgRyEX
	 i4H8PkMn3xgaw1wX3AUtaMdskuLlZJ9nULgcbK9Ffu7p77rCMVisL/S1OS9F5sM3tQmyh
	 fGZkLpR6gCMtbP5Hf+SlqRvc3KG3XnEMwlxby1aMz5YV/vcRycZmlTesi1P4Jm1i6bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cX2xJ/SDZ9G7ctUysIoZOG1iiotwUX9ls4TVDidT4lg=;
	b=iYssjCxI6JHJkIgsvLtwRyqWr845TXIY5VKJPU38XwvhpfH2TehgPYPRjD12g5r57ocf
	 lKCW1dN7TGkDlEWn7xASn1pyYEysazdygAqnILNnUi+fvYp9KlXVY8R+gbfk0fvQYRhIn
	 6POo33YAwS2vyHJTB0jizQ0DpJpfBth5md4Kp9PLbQGeJcbAm40xctJfl48mQYSSWF7OM
	 eaiPEZeRN2MO0X2qqUF2tNDHIN52wHaR5V0bqnQHDP0nbvKJRK5/UbyTWj/5zCaFqHFIJ
	 CIg/sVtaftEMh5IhPKystLZoEHxnAFT/hW9khfxjU6mMOYzPdw3KiE8XkRsABX8iX8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w/uUQjhg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA0E606A325;
	Wed, 18 Nov 2026 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w/uUQjhg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ACA1F000C4;
	Wed, 18 Nov 2026 19:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029313;
	bh=cX2xJ/SDZ9G7ctUysIoZOG1iiotwUX9ls4TVDidT4lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/uUQjhgMw55DceY9nmsrm00bOF/t+4FtV0qMeJEaZZinmdkUXmh+GlNB2TqL7HIt
	 CsLM3xA6Zz85lOeJT7HsOkHY5Z7ftkE+Ei3HcB39cxuXJbDCsFGZeZauFHTGatQX8h
	 q7GM2CxeajrQeFBLf6JoFzOlMM/xmOXx1pbL/r+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0305/1756] scsi: mpi3mr: Fix out-of-bounds bitmap access during device removal
Date: Wed, 18 Nov 2026 15:40:32 +0100
Message-ID: <20261118150020.488543858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 5dade59551d344d0308256edfef6bc3fb4202eb3 ]

Device handles reported by the controller are used to index the remove
pending bitmap and to build a task management request without being
compared against the maximum handle the controller reported.

Check the handle before using it.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-9-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 894d358ade75b..eb9477d70e681 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2285,7 +2285,8 @@ static void mpi3mr_dev_rmhs_complete_iou(struct mpi3mr_ioc *mrioc,
 		ioc_info(mrioc,
 		    "%s :dev removal handshake completed successfully: handle(0x%04x)\n",
 		    __func__, drv_cmd->dev_handle);
-		clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
+		if (drv_cmd->dev_handle < mrioc->facts.max_devhandle)
+			clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
 	}
 
 	if (!list_empty(&mrioc->delayed_rmhs_list)) {
@@ -2399,6 +2400,20 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	unsigned long flags;
 
+	if (handle >= mrioc->facts.max_devhandle) {
+		ioc_err(mrioc, "dev_remove_hs: handle(0x%04x) >= max_devhandle(0x%04x)\n",
+			handle, mrioc->facts.max_devhandle);
+		if (drv_cmd) {
+			cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
+			drv_cmd->state = MPI3MR_CMD_NOTUSED;
+			drv_cmd->callback = NULL;
+			drv_cmd->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+			drv_cmd->retry_count = 0;
+			clear_bit(cmd_idx, mrioc->devrem_bitmap);
+		}
+		return;
+	}
+
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	tgtdev = __mpi3mr_get_tgtdev_by_handle(mrioc, handle);
 	if (tgtdev && (iou_rc == MPI3_CTRL_OP_REMOVE_DEVICE))
-- 
2.53.0



