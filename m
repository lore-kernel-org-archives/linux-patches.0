Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623594;
	b=cxVeV1xueGJWbwrdiPZRXAnfu+1eACHWLj/bZb55czrzEIxXCCEf53ZfNEQxbnCsjR6e
	 qxj7dGINfAD0Ci0FXKQf0ZU3rkfPYCDHrhq5S0Vog/13wu9Q5P3tlBGyvTZg82KYw9Rn3
	 7zK/LG5jvn4mhIqHtEiMBXSZPH3YAQdsfIPLjy0kSMCAwd5xEERAw6/hfSmYGbbD1APP5
	 wrojuuSYaHb0T86UPmAWFcScBWLo31BKHjqCaebul+0487fXLlErl/9dB8Ng24S/V5dF4
	 8mt8bpnHKtzAgz3kHBFODzxW90Fp1EfQLqbM6HPOeo9Y1mMxpE/IIg7cF92/ous1HRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CDcYeY2Kn7TA47nV1rx4HW2VQShET5bTw2A4gA1+Hu4=;
	b=uGW1qILFzzB0EPbiqgJtAfFhwrd40qfnxhI5os1cdS6SjtTwdW4ZgsbOIG2HIAUrIQGm
	 7sFsgn2+xfJm6rkSwMtXbMtAj3N79QxulEo3vfM6zfrNAmG3RtM+d4D4yldUTMg2X1iWy
	 8NUY9GpdDLhVPG0D6Z7lXobfXMgOeHpidueMvgQ/pJQtpKwcfLM1SlJ4OFVGHRfb7QyYm
	 o4gksV7aFZ/xCVVm6lToVoKuypIZy0eZQBGeJQb2PR8eqa/qXnBL5JXk6XrhtS4cWbfMn
	 k6Kx0rtoR/XkmgLwyE79l2exG2LkGeSHJs60Qnjwg9Z4SLU0hC0fZUU4gCtOA7Zys3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rd26VhhC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404C9606A31E;
	Wed, 25 Nov 2026 16:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rd26VhhC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EE11F000CF;
	Wed, 25 Nov 2026 16:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623594;
	bh=CDcYeY2Kn7TA47nV1rx4HW2VQShET5bTw2A4gA1+Hu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rd26VhhCeXnRjCersxoc0DikobOlrsotsH9Zw7pJyID8+E3c4vFiiiFgYGdnRLDGf
	 0V2yZ2kx4chK1VCpQ1zY8o9Xnp7UUG3QoeamJPOTVKD9eF++Q2ZZEACHF7BrWGYkok
	 JtYGdCZs3dsrJ8eb+ZLCF2hki6wkYFHdqaUv+6Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.18 909/990] usb: xhci: disable the correct slot on alloc_dev failure
Date: Wed, 25 Nov 2026 15:37:56 +0100
Message-ID: <20261125143843.299739366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -4299,7 +4299,7 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 	return 1;
 
 disable_slot:
-	xhci_disable_and_free_slot(xhci, udev->slot_id);
+	xhci_disable_and_free_slot(xhci, slot_id);
 
 	return 0;
 }


