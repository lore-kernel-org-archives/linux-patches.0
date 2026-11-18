Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029330;
	b=qczGsNMm6WPPnGrgVXaR9FxBnUYfiNUk3BgcpWgYZmDdEI4VBXB2inW+nb5knLVPBgBL
	 eHjk8V8pKZ/8mscB0ypAX1d0HSVlr6E8sIMXbYvEW0YeYs5lI4IbE7qamoFIWdugRAuZD
	 3iJGxAx9/nYj7wc+WB/J0vW1NwtsRomCZcQuybUpZ5+30+KWZhAEtp54mI5KqOgIsNc9+
	 boRtBI/sgAvgiPdYF2u9Do5imTJ/0t89aHyEHFp8+TE0mFdFLA/t8l78HfBq7idNdwI96
	 kZdp26sRBifsDSxDkLMy5H6gU4+SjU+7CLTdxa6ZuaEnkto0IVlDYlRkZH+awiD06NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nFTtapwaStabpfXytGKHJ+B42Ev473FWWVhOiDa2fUQ=;
	b=iX6xXsln6yBj2Ijmu+nxzjqkvAxLM1m0WxpRXrBP0GxUF5p6tTVqTjKvlq8hdQIZ6Ti0
	 jd3Q9wohq5bfbF2Ot9vLYJXXwcGj6ceM2aRyo6S/7V5YFA4QeH+gbcJC8ql5QEvL9SWQ8
	 L70Sk3bfyRiVEfJElmtDpOG0xkIsnaR+MX0DnGfpu5PXcCdRRhEwn/Gd6L+s6KQEpPU9s
	 NhPCW4gSdo5SkPrGlrZ209KZ2GTc9DLytwClU8MFK7IX5Vo7TKOwfbMfj0eSH5+p1VviP
	 9XLS+1DHH3BiRNZSC4GQHkMUh6IUMyRS39E6kKZl726gJe0i5UxY/YDR+hxyzH4hNYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeLpalLU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3597606A331;
	Wed, 18 Nov 2026 19:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeLpalLU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2253D1F000C5;
	Wed, 18 Nov 2026 19:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029330;
	bh=nFTtapwaStabpfXytGKHJ+B42Ev473FWWVhOiDa2fUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xeLpalLUVgJiR937wAs4Hr3PMv7tXU4vmstEjIEhUvBdgA052AMzOo/oLDWSVa0DZ
	 U/reyVFJjOwl3ggbUVLoyyOL8NwA4gXiDRTaDHDat5yDRz9gpJbBvsFqJEG56tqPkB
	 TyR6vhQtZnM+WkxkVZicvCtGsGMLZdv8YYSjlV/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0310/1756] scsi: mpi3mr: Rename log data save helper to reflect threaded/BH context
Date: Wed, 18 Nov 2026 15:40:37 +0100
Message-ID: <20261118150020.671964571@linuxfoundation.org>
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
index 840195373084e..07e8ffb4d0565 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1488,7 +1488,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
 int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
-void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size);
 struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
 	struct mpi3mr_ioc *mrioc, u16 handle);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 3c409b3fdd925..337b6ebda49c0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2847,7 +2847,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 }
 
 /**
- * mpi3mr_app_save_logdata - Save Log Data events
+ * mpi3mr_app_save_logdata_th - Save Log Data events
  * @mrioc: Adapter instance reference
  * @event_data: event data associated with log data event
  * @event_data_size: event data size to copy
@@ -2859,7 +2859,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
  *
  * Return:Nothing
  */
-void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
 	u32 index = mrioc->logdata_buf_idx;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 53408fb9fc407..18d3ebdb62e3c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1954,7 +1954,7 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_fwevt *fwevt)
 {
-	mpi3mr_app_save_logdata(mrioc, fwevt->event_data,
+	mpi3mr_app_save_logdata_th(mrioc, fwevt->event_data,
 	    fwevt->event_data_size);
 }
 
@@ -3084,6 +3084,11 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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



