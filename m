Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015922;
	b=cHLuLtr+77SZBvnj+236Mr+OKWVYCvBjY0haD1E2kLTp0ZPDCUBxkFRSa/zzh7mHhqEb
	 kNurUqtjkLNTLKxnU4/fY0R+Vjoogk8ZZdCW2ikG236qCSMYaDxLk9S3gdsFcOmet+w4d
	 exWOhnkwUkZ6XI/Pp2CtliMSr8lMOeJRdE8CGJS1P8WN7KdWISfyEDY9fRpuStNZkfA2z
	 AxO+CP/Uhy7pszzo6rCM4/PRuuRNNXT+N9eRHd6Z24zPYvz/4r5ZrrQHBUSxOeYvNFKZi
	 evE/lvK7e7HUIIdyU2qxyOiq6lDKvVK8E4lxYNU4OvBUUJKkVBupElwaM5z62AgdILA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jHcj/CFVHCOXmMA/xwt6rg93PMPKjIgHgCNiLeND/Ac=;
	b=3YfTHfdX0ZPam2VkNljlwHySs884ime11LFBd2SK/MkARDpeiMe7I4nx+J8jiGx+6VsN
	 uWZ0yzaUJKZcWytgX26/p8TxaVJFtuMhFIzIhXgk7F1eVUSyQD1i9maenvbtQ+Kd8d5zF
	 1RE4OEK4pv8Kz66rcARKoaX9Dhz9hdncoB7yWcXXLSJqHNbrKsVAyMKzwA3dV1EcEnxQH
	 YtFBItzLSYIWmYVVWtnvfCF4rrRwvWEZYmcQSiO20/U0BKE1tGSGFmHphBVx/Kj+DYJGx
	 598q71j2uHBtRDsj/msLWjxE73uW30yNGSjAOUrUDkIGgZKUhK8mcrPOUmcUaJkbM8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d45TpXXz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBF3606A320;
	Wed, 18 Nov 2026 15:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d45TpXXz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4741F000C4;
	Wed, 18 Nov 2026 15:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015921;
	bh=jHcj/CFVHCOXmMA/xwt6rg93PMPKjIgHgCNiLeND/Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d45TpXXznK1nHXJi2FY+cdL5493SnMcV3a9WH9ys3ZPFp2nAs0FbC7fUw3hlemSld
	 PglsVKaeNkEFkaDwHabchhpQwuadnELj2rnogmXgiUHhKwG3DxIfjRvJ2eF2Og5DTC
	 C1W/mNqS0vMdm1nBGYBfjHFWbkAABj3XPXzQ0H94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0346/2651] scsi: mpi3mr: Fix NULL pointer dereference on PCI error recovery
Date: Wed, 18 Nov 2026 15:26:26 +0100
Message-ID: <20261118150300.298589725@linuxfoundation.org>
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
index dbeb8375ff05d..991e29a8d382f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2155,9 +2155,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
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



