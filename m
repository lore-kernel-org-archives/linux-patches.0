Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036414;
	b=wMBmzAOWf8mmENZYErKb6I1Fenmp0P9G2N9MEr63HbfU0AKz9o2EqkODXTI3ad3DgrsC
	 nNp36G1z6MS3km/hknmEUXojsCGk2p9Z5v+GwXHqv851mUNeRIwjYJZj9mq8Fhwyiu3Lf
	 pT1nQy9qVOOoGXhyllE8cq5g7IyREbzvhdwJuWjnIgpwlBmGHbV5pCwPk6NZt1x43wJKY
	 pRoSYa1yOJuNf2PP93pYzu3GQTQHIiqqJkzZD3iZdIM2TJcb0F4b9x2skw1lG2Krbhl3b
	 8IbdMdYIW9bj6J4T+i+Z6wvFGiTWg4DfXEOsF3jMQbp60S/7pXJQGl3rIOn+1fLfMQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bz1+id+D+r5lZE0j8z4hHSap4kI6XYh2y1gWehus8YI=;
	b=2MQv0EC358mLkAKcmN6Ay5vrb+r3oHBDvQnPpunmmeNovt8rq/ZhKRjtFoPRT5YEHx6S
	 rDPBXYjoDn26PVshMedA2nMSrXGp2ecW8K8phcsbylz+DRcsyfW9TYO7xWqV5zLtY8skd
	 fBh8CDBROWNIREQeqKC2qKlNLQgssWGAIDOfrXqNTR0uewc66HFhMGCEWAuHhnKo4v+/L
	 cTur0b/V1Z5mBXdNA9C0gLlm7KTOEdlS5NqhK+46gfcnmbYCV3KHV/q/MOhOaRzrcpIoZ
	 Xt5nS7KFGJ42Go7gjoxvOBgr/RD+GuRm/mRYMy+n4IU9lh2jwAh7yFtM+So2vL1Bjgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1qZo2/R+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA3B606A33F;
	Wed, 18 Nov 2026 21:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qZo2/R+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17F21F000C4;
	Wed, 18 Nov 2026 21:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036414;
	bh=bz1+id+D+r5lZE0j8z4hHSap4kI6XYh2y1gWehus8YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qZo2/R+42FE5wxvPbh/XXAxeVPLNDPCI1pkWmqGH2HZr7lBt5BS35Axpsjx1J1L6
	 UbTII3v0JZUZbgITdiZRkIwn+kIgjd4t2tVLCZ5Zrk5Q8qPNXlUVjLd2zbIN2dK9MG
	 IlDVfwUzIq7CDr8CHy15gZO3ehLFo2CHiKQfiim4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Juergen Gross <jgross@suse.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1050/3318] xen/pcifront: check that an AER callback exists before calling it
Date: Wed, 18 Nov 2026 15:27:52 +0100
Message-ID: <20261118150351.421585857@linuxfoundation.org>
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
index 11636634ae512..451476ce10ae9 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -599,11 +599,16 @@ static pci_ers_result_t pcifront_common_process(int cmd,
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



