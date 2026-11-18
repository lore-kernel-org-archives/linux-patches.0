Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039524;
	b=Wf5ST0CH8SQT/hRx0a60aG+ESIFlYREF37NnZ5SD0L5/stIYJVf2utWWUlq9tTxpdA8e
	 ZK8ZKNRYACSFokl6cYjzUFgY3HQN2jxUcgH6wlC2m8vOM6SNfy4Azo+eJh9jiFlAkVDd/
	 M7YzTybbfz3HGgC20l3/unrBCI9DNL+ji2rwz92BRD+YxrTYjZpxp2IiXwcfZd7DL5ASP
	 BJSKlm+M6PS+OKTdeMshGifnMpJ2isrkWdzAB0OSnef8TY9tWB+oi9Jw8l3Al47Q7e2SF
	 tpJ/nML/894VfzamsrGZZ3ggtj+61RDyj3NMCVdlt63LJbTYI/ADP1+PCWyuT3+Ic5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GPyAfz7OJRDMM9ju6gFPTHHhMxo5Ba+Bnl4vabZEpyM=;
	b=rojgYTQIgA7zyY1usXcnlsV4VIk0a/bLPCkyv+9bfFvyj1DqgewtNXKc9tJCLpP83aM2
	 aWf8jXFwXbkn6x+7TZN2klkbGBOOG6SYgrZtzE+NONftB6Eej1CnodkzXbEVZypsnMOuG
	 anQKnhvFkKjVRbFQjZ+/TX7jNJ0Rw33NT3bpMMe4H2mDNpcXaMVE/OptkYhebPL1b+9/j
	 OY+oRWL6V8s+ZFClo/2ecLoondl2Rr+MJYV84NdzK8XtaKtOcaFaW987q0nlBjRJesRQe
	 XKHkDb4+cWiY1un+N2kPXLSumupEa6B7CUGVQC42GEYiaYKYr/fK2hHQkXb3VNwNITA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JD4N6lHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929CD606A31C;
	Wed, 18 Nov 2026 22:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JD4N6lHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E221F000C4;
	Wed, 18 Nov 2026 22:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039524;
	bh=GPyAfz7OJRDMM9ju6gFPTHHhMxo5Ba+Bnl4vabZEpyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JD4N6lHIk057IHcNH+sBYUAQcp/FuJYdHnrrtdS2aFq1eGHVwVz3F/ES0Wf5J5aUW
	 eKVR9ojUA1q6eFjU+EeWWncndG7buHvlpqLWjniaXoL4qcAclJtpLcjnysIuYcMNfw
	 jXQTxBmdaO9wJ2ubM1WqtTeXiTcsl1KoAq/tQJO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2130/3318] scsi: mpi3mr: Rename log data save helper to reflect threaded/BH context
Date: Wed, 18 Nov 2026 15:45:52 +0100
Message-ID: <20261118150425.960029297@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 51ad4164a5d5c..ad7947521b24b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1350,7 +1350,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
 int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
-void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size);
 struct mpi3mr_enclosure_node *mpi3mr_enclosure_find_by_handle(
 	struct mpi3mr_ioc *mrioc, u16 handle);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 6ef3a8b1f805b..9f846019211a0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1434,7 +1434,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 }
 
 /**
- * mpi3mr_app_save_logdata - Save Log Data events
+ * mpi3mr_app_save_logdata_th - Save Log Data events
  * @mrioc: Adapter instance reference
  * @event_data: event data associated with log data event
  * @event_data_size: event data size to copy
@@ -1446,7 +1446,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
  *
  * Return:Nothing
  */
-void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
+void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
 	u32 index = mrioc->logdata_buf_idx;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 8c663d237bd91..20bcc3e5bb0ed 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1858,7 +1858,7 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_fwevt *fwevt)
 {
-	mpi3mr_app_save_logdata(mrioc, fwevt->event_data,
+	mpi3mr_app_save_logdata_th(mrioc, fwevt->event_data,
 	    fwevt->event_data_size);
 }
 
@@ -2963,6 +2963,11 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
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



