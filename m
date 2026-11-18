Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048132;
	b=NCcd78kNDGtqn1gLuqHiEjLNw69Cu6DGhxogxWXJoPWJ4UdIVU9C+YdgsGLa4SjKnl3l
	 eMEbQjVQUESPVCMuB0uGPI1b9sd8DSfHaa/haMnMSeWxSF3o+ylxbu95BOfpRHvTWl1T0
	 xob27VC1LKyZQTr30jbQZXDK1QCz8X/F8il5YblRBzwx2HlL0vRVZC0hvKIyXg3X4pOZF
	 oQx1MpChDekRCa5gn/+CeNj2HLH9NklGl8ngFvY0XPJywqoBsp3qPfWwt/Wa50WnTqR9K
	 7vr499JugYiD3HpxmYMgmOqxk/6C78cnRSb2aG/fYNmbOPBqChFzFOtdv1ADNQHbv5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JQi0H7xndWOIeRQSjBzupeAms7/c7TqLU7d+45847rs=;
	b=msPl+j9RftoOaMjInwbYOj73gVRnfzzPWnRWY2FYI/O2IpZY0DLbNXZkNFX7E8F4doFk
	 3LUyXolDjB0oYyyKSUaZWZeQYyMFbTX5lAuhsNb7pyG6w+5u9AFw0KAUUzVrwBNOHkoH7
	 8D33+Egpmqz3zdzyM60afS+yEYYZSK5Idqx6BWXWU9nbIkEvQJSFdrVW+aJn1JCGL9osy
	 Cxot21Fx9kMunqshbRzjyGcCVZUM8piqwDJrDSZM0KU2DiDVWz1sphpvrsvHTWI9kBdyI
	 sYjlGSMEI4+TZ0t57KufU1KWaGAR6DsOrQ9tb8uBQ+2u4jSFVBus5J0S5FJCvk88pYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EobozPSw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFB8606A31C;
	Thu, 19 Nov 2026 00:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EobozPSw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BF91F000C4;
	Thu, 19 Nov 2026 00:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048132;
	bh=JQi0H7xndWOIeRQSjBzupeAms7/c7TqLU7d+45847rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EobozPSwggqpvQPzNVjOZMYzwp+J61B2uQpmRSCuoDyd5wsxLsP86obFfVrbj4MCY
	 mbuL98xnNFyNhEJ5j6cr1WPo2KCl9x5HUpjSWSvrjV6ugXntZOyVyi4JncCyat2BM9
	 mW4bvKq7Rn3bLHJopjgajtIWBlBXZ4YENqhB5vjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1859/2857] scsi: mpi3mr: Rename log data save helper to reflect threaded/BH context
Date: Wed, 18 Nov 2026 15:48:13 +0100
Message-ID: <20261118150308.174696874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit d0d19250ed81907eac707be8221eb31e5b96b647 ]

Log data events can be processed from BH and threaded contexts.  Rename
the save helper to document its intended usage and improve readability
of the event handling flow.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://patch.msgid.link/20260116060719.32937-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 77554f01187d ("scsi: mpi3mr: Fix out-of-bounds read of event data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h     | 2 +-
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c  | 7 ++++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index bd7dbb1490b8e..d7e44b66331fb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1331,7 +1331,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
 int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
-void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size);
 struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
 	struct mpi3mr_ioc *mrioc, u16 handle);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 91cf32ba55256..4d856e1a58028 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1433,7 +1433,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 }
 
 /**
- * mpi3mr_app_save_logdata - Save Log Data events
+ * mpi3mr_app_save_logdata_th - Save Log Data events
  * @mrioc: Adapter instance reference
  * @event_data: event data associated with log data event
  * @event_data_size: event data size to copy
@@ -1445,7 +1445,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
  *
  * Return:Nothing
  */
-void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
 	u32 index = mrioc->logdata_buf_idx;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ef913e4432270..c1fd101fa7e59 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1819,7 +1819,7 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_fwevt *fwevt)
 {
-	mpi3mr_app_save_logdata(mrioc, fwevt->event_data,
+	mpi3mr_app_save_logdata_th(mrioc, fwevt->event_data,
 	    fwevt->event_data_size);
 }
 
@@ -2924,6 +2924,11 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 	}
 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
 	case MPI3_EVENT_LOG_DATA:
+
+		sz = event_reply->event_data_length * 4;
+		mpi3mr_app_save_logdata_th(mrioc,
+			(char *)event_reply->event_data, sz);
+		break;
 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
 	case MPI3_EVENT_ENCL_DEVICE_ADDED:
 	{
-- 
2.53.0



