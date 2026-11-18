Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016011;
	b=xqHkuKvEexzNo8O6DB+W85DGHb/Suu7JjWRA7iPo4gJgw8j8ziiG3VMe1As28AgI5+UY
	 B3ELBOThQvUECjngQhJKJXAVZt2eLspoSPEuFDRnJAb6RcCydOW3IOKJr06CdmUq5r1bm
	 8A+5bMaB5kcRxod9hVY8U4xsuGFmq6ydC8CEQH9/pUlY/mW5J2E1r5xSv4W4eHxe7H6++
	 nJZpWACjm6jcdr2ojbkrsrrGjhD4z4OkXo7O9SCuxg8L5hKSnjXoDZEKHvSdeVQ9TqIWI
	 5YcaUNLjiuD9Oe5DCf7fKkEXAt0aHd2zcxsYPuaeJvSGgHBV1bUbFNAlD0tu4ALvs2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3m0QYUdsF7seN6BN2qqkc3HFdomcWt4w0gEdh37ZED4=;
	b=omnoLsk5bg9da1j6761Ho9nuLpuR3aqMhHuzz443zxOHrVW3P8v5WkETqop7wLv0UPJF
	 GuRsOjKFhcOFcypV3/BqHMe/udv2Izq5HfdfR/o0uQyD2j0A5R/91x/rME9hGs4PshpgF
	 AfFBxc7rJu307FHTUzZ2eASGImBdyVzp6yYIDfD5w+4ZU7g78pMki9gtLUZYmu+JUNcm9
	 9dtSsbkxIOi5KEnzZZZcFRisD4C9f7O9r6RD9tsIzs+9ng7N7gqoJteigvLdXBWs6ezSc
	 Mk79MwoYeXk8336NIA70CvRc6adTlOtfxcTOFPg26jil2VsmVQHTu4GUj/M6U/BOgMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTOEOpYQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D33606A320;
	Wed, 18 Nov 2026 15:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTOEOpYQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D88B1F000C5;
	Wed, 18 Nov 2026 15:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016011;
	bh=3m0QYUdsF7seN6BN2qqkc3HFdomcWt4w0gEdh37ZED4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTOEOpYQypfTJ75c3ldjWoaeRwuPgOA9A7bDxSDvIGo9AgRm9ynSZgEY3/IWrbvGf
	 n6eBGAjPExDKwuOXlSDAm9ziy0vTpk4mpuFjS517JRAGLYMBiF5o/mtKDmDa7j1L3H
	 JmFHJlepP+qsHMyWH2ITTkJ7aXVCI3Rj+jPaLX8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0340/2651] scsi: mpi3mr: Fix out-of-bounds read of event data
Date: Wed, 18 Nov 2026 15:26:20 +0100
Message-ID: <20261118150300.088138277@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 77554f01187d91c20f04d2a8e28270943ed64cca ]

The event data length from the reply is used as is, both when caching log
data and when sizing the buffer handed to the bottom half. A length larger
than the frame makes both of them read past the end of it.

Clamp the length to what the frame can hold.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Fixes: d0d19250ed81 ("scsi: mpi3mr: Rename log data save helper to reflect threaded/BH context")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-12-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6677f39b8c8f0..83ffd44ce938c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3143,7 +3143,7 @@ void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc)
 void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_notification_reply *event_reply)
 {
-	u16 evt_type, sz;
+	u16 evt_type, sz, avail_reply_room;
 	struct mpi3mr_fwevt *fwevt = NULL;
 	bool ack_req = 0, process_evt_bh = 0;
 
@@ -3204,7 +3204,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	case MPI3_EVENT_LOG_DATA:
 
-		sz = event_reply->event_data_length * 4;
+		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, event_data))
+			avail_reply_room = mrioc->reply_sz -
+			    offsetof(struct mpi3_event_notification_reply, event_data);
+		else
+			avail_reply_room = 0;
+		sz = min_t(u16, event_reply->event_data_length * 4, avail_reply_room);
 		mpi3mr_app_save_logdata_th(mrioc,
 			(char *)event_reply->event_data, sz);
 		break;
@@ -3238,7 +3243,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 		dprint_event_th(mrioc,
 		    "scheduling bottom half handler for event(0x%02x) - (0x%08x), ack_required=%d\n",
 		    evt_type, le32_to_cpu(event_reply->event_context), ack_req);
-		sz = event_reply->event_data_length * 4;
+		if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, event_data))
+			avail_reply_room = mrioc->reply_sz -
+			    offsetof(struct mpi3_event_notification_reply, event_data);
+		else
+			avail_reply_room = 0;
+		sz = min_t(u16, event_reply->event_data_length * 4, avail_reply_room);
 		fwevt = mpi3mr_alloc_fwevt(sz);
 		if (!fwevt) {
 			dprint_event_th(mrioc,
-- 
2.53.0



