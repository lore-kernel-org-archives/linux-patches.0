Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053877;
	b=lTzV2HX6+HOm6r3RmyTAjynV0EBeQ5RacXYXJjaFDRRL+sqn8aSmGqJR/lHdIWMDutT3
	 wgJVJcaRe4FGQK9hm8YpHamjWlnkUHAb7NYloCQHTgoEat7YdanFWi2APwCYxA8d3Sy8s
	 DeQ6ai6Eabwt/mPe26XZJaf2Q05ZU6Wvb4TRsRo7nX1EE+xgR5h+PzM2kLSHef7fsgTPG
	 0Bwfssm8YcrLvaQDvPqZ7xaGseY3x3/JWUJvR50TYffaj5Yvgkfs71I6KvBt7fN6A5qGr
	 igfqsUlulollFZHrAtrrQUjUoLbx6DY+4Ri0oHg9tHxUx+Sp/YFNAWXe6eORSXrGsGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=onER9OSCMeOpvk1LMY88KI/RMgwMGTMdq8VpJZBmrg4=;
	b=rmkGN35IOQhKHG5iwjvHOPdLKJ9YMNW1sK4C946N+UzEvLJ19dvs0B/eerXn4PY5K3LN
	 OjUXOtX2dc9a+dVWJqd7aSBWrjplUl2fa+NyJ3qbOwnLztr8Kk8boaNjwbvOUjx79/m4P
	 EFJJmJd2fb8/gIn72wOyMlNxgrJb8lY934PdCe87ZYDsHQTVMx31XW3Azid7ynO5ZF01o
	 2iSBBJ4OMmVLSy+cfZg+ERd/rpWe8HupWIwKzcVkolxK02t7zptrEQb4pobxYIb/mg1zz
	 AcHnTvVeD4VCR3f8KseS6spZ3biX3VoR5uSxfVD2d1Yv0Ic7x2rSsW1k7167S5BuoVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQ6wUVZe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4E0606A325;
	Thu, 19 Nov 2026 02:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQ6wUVZe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA501F000C4;
	Thu, 19 Nov 2026 02:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053877;
	bh=onER9OSCMeOpvk1LMY88KI/RMgwMGTMdq8VpJZBmrg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQ6wUVZeknXj4zVNxbQPHxVzx2rpWlGivV8uKJT3SHBAyro3TJq2k/+YShPb2pzb9
	 30J5EVW3c4zS7m7tIFKVf4vpUnh581ioJUt6ZiW2kwOuRzMcOrK28ecLJyTBi1UrGQ
	 DVTVOKDg3XyO/Bu193CK6VDDxSUJMmZHdIVp8808=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1076/2214] xen/pcifront: check that an AER callback exists before calling it
Date: Wed, 18 Nov 2026 15:45:52 +0100
Message-ID: <20261118150055.302817343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aa3b84823e686..1dac92706f1ec 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -612,11 +612,16 @@ static pci_ers_result_t pcifront_common_process(int cmd,
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



