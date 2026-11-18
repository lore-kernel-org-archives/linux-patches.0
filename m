Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045403;
	b=4x4hNXJRkDmcOQwy1eltmuPBj9LLSXSMC4qtZyYtd5wtD4kJXcAGJ4voJy8+IN0B0Jqo
	 tD2Rkn3xmyYaDLpmGhS7SELq97pjhVr+Tr6AZizZqG2lA/t9gHk9xo47bbj5XcO0zM2di
	 +rmQC5dbSSnYLAAVqMUijCS5y2N6FQtG4/RgXdOSQj8drvJ07MeyWyDbqOoXQS1mmj1Bb
	 28vl4g8A/mKYmAWlu1EzKERAhPoa7tWDgW7uzDRxQzpf8E/BCFiqWBvesDIW5uN0HuoqM
	 RlRsI9anWF/sf9tyigWF/nUU3ErQutVgJL1ngUk0h1wOg2XY91LZfnIKiu9oILZWUIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VEwd8ih6wRepOHBADnovviHsY0cCvu9KIuF7PyR1CtA=;
	b=M93N51/aHdkcK6oabPAW7boTiqeyBsLx0P3NfLqC7y8wyMKuvVy40DXTDlGAHA2tZlsg
	 S96l2cp/ck0C4vGLEBf1Bguec5bNHF01siSvP63rszVJyYH+WITiqtgy5YTrrxZUQv7BS
	 8uyPaX8NQr3UgXmzFePDVa5iyPSHFa/oJdfgAcBIJhsdLCS5fGVDckHoU8WhqCJrJeZmd
	 mbKyI3QO0qB+7qNac0HQxhB0VPBXT2p6Z6aJLk/VEp79R/KHJztt6hohozayYkEKQHtyg
	 PvJ2I3UCFmmugW4dTG77wFpTObD70WRLJWVtAhwbyINURo4qmyNcXNMUk29heF8L4Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsLnnMet;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84DA606A320;
	Wed, 18 Nov 2026 23:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IsLnnMet
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3523A1F000C4;
	Wed, 18 Nov 2026 23:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045403;
	bh=VEwd8ih6wRepOHBADnovviHsY0cCvu9KIuF7PyR1CtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsLnnMetZnGxZ6k5tsdeSkQqALA0whGOuVwj2o67UkdOmUd2Fbmi4rgsK+M3ujF4v
	 gKQC7Woy+suftr83dxh41tfso6+NAP6r3NtqyyDblpkcmyYHnwPCcf97xNL+E7UQgr
	 Bv/ldmU/e+NsQ7JkmsKHXHjoGRVVponr4tentTvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0911/2857] xen/pcifront: check that an AER callback exists before calling it
Date: Wed, 18 Nov 2026 15:32:25 +0100
Message-ID: <20261118150234.382340640@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 3b4854b69ee70fffb2fa7acac09e715a7efcbae1 ]

pcifront_common_process() handles an AER request from the backend by
dispatching on aer_op.cmd to the bound driver's PCI error handler.  It
only checks that err_handler and err_handler->error_detected are present,
then for the mmio_enabled, slot_reset and resume commands it calls the
corresponding callback unconditionally.  Those three callbacks are
optional -- the PCI core NULL-checks each of them individually before
use -- and many drivers (for example igb, igc, ice and ixgbevf) install
error_detected without all of them.

aer_op.cmd comes from the shared ring, so a malicious or buggy backend
can send XEN_PCI_OP_aer_mmio (or _slotreset/_resume) for a device whose
driver leaves that callback NULL and make the frontend call through a
NULL pointer, crashing the guest.

Check each callback before calling it.  When mmio_enabled or slot_reset is
absent, return PCI_ERS_RESULT_RECOVERED so recovery proceeds, as the PCI
core does for a missing callback; returning PCI_ERS_RESULT_NONE would
instead make xen-pciback tear the guest domain down.

Fixes: 956a9202cd12 ("xen-pcifront: Xen PCI frontend driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Juergen Gross <jgross@suse.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261006023443.338194-1-yhlee@isslab.korea.ac.kr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/xen-pcifront.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 83c0ab50676df..2c289b89cb8a2 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -600,11 +600,16 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 		case XEN_PCI_OP_aer_detected:
 			return pdrv->err_handler->error_detected(pcidev, state);
 		case XEN_PCI_OP_aer_mmio:
-			return pdrv->err_handler->mmio_enabled(pcidev);
+			if (pdrv->err_handler->mmio_enabled)
+				return pdrv->err_handler->mmio_enabled(pcidev);
+			return PCI_ERS_RESULT_RECOVERED;
 		case XEN_PCI_OP_aer_slotreset:
-			return pdrv->err_handler->slot_reset(pcidev);
+			if (pdrv->err_handler->slot_reset)
+				return pdrv->err_handler->slot_reset(pcidev);
+			return PCI_ERS_RESULT_RECOVERED;
 		case XEN_PCI_OP_aer_resume:
-			pdrv->err_handler->resume(pcidev);
+			if (pdrv->err_handler->resume)
+				pdrv->err_handler->resume(pcidev);
 			return PCI_ERS_RESULT_NONE;
 		default:
 			dev_err(&pdev->xdev->dev,
-- 
2.53.0



