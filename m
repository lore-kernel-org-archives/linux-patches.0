Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023479;
	b=NPDozgoPlelctOGHS+NRC26uHWSXLm8D/7KtLUOxWwrv4Vl9VuWTDREr3RNXo+leW89s
	 HeC4Ep1pPMZPOFGKhsqC0aKyXZxtkY1DxMgys9RUkShPA6W1NOAS6EDYpe78a/wJciQZX
	 9f6fmsTx3cA6YJHUL8V2Oo6ctSxcvW/ejk7uNQ6v8dLuAm3ntIbwwu4ho3EIRpdbRdDE3
	 CebTuk3SmnLDKp8gFzbnf3ZSmWdLVYEBAC9NyEsMgguBd4jUS3WP2zdRPujYQSG8yV4Pl
	 VC/e5evlvSDP9aRG6khUDwNoqJrbXJnJhGHsS8NAQchJQ5q/XIl3r9Pwzum9lhMCrmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UR2/PFzVuw+Nv0LFINo1eP0+9VERWTwHZlLFWbuv808=;
	b=12BBThG4f5J/YBzLyobMjUDWcIpYdL/BITzEvLpVS245JidDPPy7wVDZ6FdAsST8k2hZ
	 +HrbvC19NK0wKpamDptpAhcuDhcloSVCaqNStIFc5gC5sszBiVJnroDPUiiEmkqQlzUnF
	 JHr1a1vHbkdJcjKdsDUP/6XVilX3Ig3X3bwLfhKUfNv3RIQWofjikKZHyJ3PcQBNybaEM
	 ynS0Tfuq3E9B+h1dP60mdh8a3LRSv0SvoKHrjR9QbQBKDZ9E3d8KeD+bCESxZYlmk2nJO
	 zGW1TZCzCACbUveDRaZyo1jWO7XKhvRYZhOUiAIB37CEi8kr5icLEmQ7nbJzWyxlpTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dA5ivK0f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7823B606A33B;
	Wed, 18 Nov 2026 17:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dA5ivK0f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F83A1F000CF;
	Wed, 18 Nov 2026 17:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023479;
	bh=UR2/PFzVuw+Nv0LFINo1eP0+9VERWTwHZlLFWbuv808=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dA5ivK0ffnRZSGYLLOdE8DdKRW7Q7+8E7Gmf8lFjlK1m9gFIL/c0pEON7R6w5T0Mf
	 /RdbKg8mfqq58YGJ8T7qROBCQV6g54jcYs1NCCj1bxGlKsfRX+FF6hLapT6FUMm323
	 dXqZmSxg2vk6NqhvHQnh92/NFJhmOk93DDWBK78Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0343/2151] scsi: mpi3mr: Fix NULL pointer dereference on PCI error recovery
Date: Wed, 18 Nov 2026 15:34:38 +0100
Message-ID: <20261118150134.596037482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index d0f9eb45750df..315664e4ddff3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2042,9 +2042,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
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



