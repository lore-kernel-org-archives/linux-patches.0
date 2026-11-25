Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620466;
	b=NS+HblE1jp5ne6oMmJnujsOSy0bLBgh50vsXp+0l+ziTffgEcEvKbYb5ERyJrilJmgDM
	 s9nYjwEkaZWVYtzemmSZbsS3ADkZqDdW61DkYoEvR205d4/nIOhrFoZjuUsyQOWEQo1py
	 iYX1Z7CO8TSBn9XQ5crn81CVLTl/Wq5J6SbzSmUilWcEF3nBRlkaD7Q0tD4hKLRaEvnAD
	 gcClWPTN+x4tFmFRzl1ZLXUJWAF+oglZnPWyyWBcguSpFrdlo+qCB996npSyK48EPWd5Z
	 PpRBDun+E8GNOVRX9E7FLelbhTe8l+Fe8+a75YHw/qK7KlWUs+vnf5Q3s2mfgfAO7hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H4N6b1g2O68MRx/vx3d0PsWrpTD6dLToqArqWPt/+JE=;
	b=zz682S/GdTFPZO9xABYVgUKWYFxFRmUtHYh0kpqsLhTEXtPoSe2//zaRMj7uKk0qYcnJ
	 t1W2afzBdsuX3NeU3GBDkR1t04OtMm3+cS9oKNTjosBHvzRMhUvdYoFFmSpC286+jwOv9
	 szDaPBufLMF4h38WLkkeCkuCI5nT6/rO8P6mXP+aUjARlvj1brkNJoGElqvm2CFVTLgOl
	 ple1mfDL0GcTV+a9vQA9AI+8vM2PTgXc+PZ7Ak9VU5ZQGsUcJh38jhUH7FA318pNjV5Hr
	 XAs/Hu5Dp3TVEPs7IXkOMnkN1SgjvKzPrYTwKu8H3xE1knxdblZLs2iiggnqIj4AprA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGl0DIHu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08EA606A321;
	Wed, 25 Nov 2026 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XGl0DIHu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8431F000C4;
	Wed, 25 Nov 2026 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620465;
	bh=H4N6b1g2O68MRx/vx3d0PsWrpTD6dLToqArqWPt/+JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XGl0DIHuUXpf+lDbGnAr989YOVPmIKBisStl2a1oWXaZztvFcbrbqYMnI45uxQ2yT
	 02Qh8n3MU0b9GKu8rDGcRlP5bJOnSjA8FpYDIMcGSlVxZdcATePwCRSkgcbx+HRXkE
	 wCrPfjSflJRwQRohQLcJKX8IArbrYBHCm/1E4Bmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 7.3 0925/1005] usb: xhci: disable the correct slot on alloc_dev failure
Date: Wed, 25 Nov 2026 15:37:43 +0100
Message-ID: <20261125143843.356338723@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit 2f2fe3201029ffc215b46ac40a0a9587715bc43a upstream.

xhci_alloc_dev() stores the Slot ID returned by the Enable Slot command
in the local slot_id variable.  udev->slot_id is updated only after
xhci_alloc_virt_device() succeeds.

If endpoint resource reservation or virtual device allocation fails
before that update, the error path passes udev->slot_id to
xhci_disable_and_free_slot().  During initial enumeration this is slot 0.
When reallocating a device whose virtual device is missing or belongs to
another usb_device, udev->slot_id may contain a stale Slot ID.
The newly enabled slot can therefore remain active, or the wrong slot can
be disabled.

Pass slot_id, which identifies the slot enabled by this invocation.
xhci_disable_and_free_slot() already handles a missing xhci->devs entry.

Fixes: 3ffbba9511b4 ("USB: xhci: Allocate and address USB devices")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261105175106.241182-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4300,7 +4300,7 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 	return 1;
 
 disable_slot:
-	xhci_disable_and_free_slot(xhci, udev->slot_id);
+	xhci_disable_and_free_slot(xhci, slot_id);
 
 	return 0;
 }


