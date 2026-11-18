Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029353;
	b=SyYxwQjkf0K1a+nklMZLWhRIlQ3cY+FN3PUcepJkJsi/m8h+y6w5joi0CQu7DWf0iYrW
	 IQH2HFLnWJcMiZ4rh4SpPDu7CeZVekm6ufxb66UBtjZ5MkOEmzV8LwCOlxRJN1ZraJHZk
	 XuQ8kVc3g5om5MHObU5H+M1ikGE7QIm6CAsKEBB4iv9sjbEWVhsJP8BOZxZ0DZUOvYuf5
	 3iS7XPFntBtYD+QC4iBaHOklTkdOpw2A3zBbh69kXoTR4+vHwju393pHOxhEfsS/rhWJ7
	 qNrBVAb8I0w3+P/FUJBG1qPAPHF6Ida8uTFnROnu1oL30BB50hIqJ1SLfaL8EBKEOIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fplz71NSzdFwuw2W+xdaaEHJvRB+ytltR1tCKVA2EqY=;
	b=NksBmAhxHZ3yMVEDweBVaWLORdQ8WswtIZ4WJhkb0zJ5ruorIrIlDAyAcWNS7o2nDAXQ
	 ShB5JGbQ5nUOiN/FREQaXG9GdUmUTS7gvoxQon6vXYjtqOoHWwmcw8+b0CIoydTOa7ClP
	 oH0zTpb91E6ECC7zwsueSMyQePEsHEi2GTum3sqXhGWLBl4lF5X8afJo18So33fsYCY/Q
	 /U0g7W1K08/TTSLPKBoiN8K8YQQrklPRUlSNlN9Bm42nP5u2p2HFCrXaovlF8jlPskIRr
	 jxF88k7kw3F4lQIJO/PfqiMwIZJ+pcFfixLr/oQgpYN2kYQBo7B9G8NYWgv3JdzbimA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvplBVBZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B51606A32C;
	Wed, 18 Nov 2026 19:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvplBVBZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C584D1F000C4;
	Wed, 18 Nov 2026 19:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029353;
	bh=fplz71NSzdFwuw2W+xdaaEHJvRB+ytltR1tCKVA2EqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvplBVBZs9cwYWAvG+gcf4e0Qfz2M2Jgz/UfUsXAFgptBhJpZYcUBGAOD4SbNksh7
	 2LE6cfpOqtAxuzycRUfk5XticeffE46FVIStR7Gyu7LC+W4usGCgLSYlZ1nwd8dqyf
	 7JHIxvcAqZxqnwHaDZ0p7jfYsSgqWSHk1a6LUqlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0317/1756] scsi: mpi3mr: Fix NULL pointer dereference on PCI error recovery
Date: Wed, 18 Nov 2026 15:40:44 +0100
Message-ID: <20261118150020.934383142@linuxfoundation.org>
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

[ Upstream commit 2ba1d12b2629827fdb1116eb3c9f8566911f2034 ]

On a frozen PCI channel the driver unmaps the register window and frees the
interrupts, but leaves the firmware event workqueue running. An event
handler that is already in flight can still reach the register window after
it has been unmapped.

Stop event processing and drain the queue first, and start it again when
the channel resumes.

Fixes: 30bafe1774f0 ("scsi: mpi3mr: Support PCI Error Recovery callback handlers")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-18-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 852849d42ea99..3ce4c21e87f2d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2034,9 +2034,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
 	mrioc->current_event = fwevt;
 
-	if (mrioc->stop_drv_processing) {
-		dprint_event_bh(mrioc, "ignoring event(0x%02x) in the bottom half handler\n"
-				"due to stop_drv_processing\n", fwevt->event_id);
+	if (mrioc->stop_drv_processing || mrioc->pci_err_recovery) {
+		dprint_event_bh(mrioc,
+				"ignoring event(0x%02x) in the bottom half handler\n"
+				"due to stop_drv_processing or pci_err_recovery\n",
+				fwevt->event_id);
 		goto out;
 	}
 
-- 
2.53.0



