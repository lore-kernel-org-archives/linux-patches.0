Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064669;
	b=EphnkGSgcb6bT3Z58n3GfrN7kLzNskr1gJw/54Il+zLiSoFzm03zbDytxJd2q+3aIx6e
	 cCG1z3F/E45b900EJi/YIlh2LUUJEqE8GJVmgMFLCDMn2ya8THg1lbpgKqKC50Lg/3kwq
	 TecAQ/sdlcdZGK8EGJoOZWg9qnKPyk2baWha+A91eTRTtxQNPZHKU33up8HCFXCHRzbS8
	 hysgzYt48Z07eKXUhBxbMLqnlPlAHfE8Sk4SAKRGV/pe9JyiNgE0Hwnk4uP1kRLYaoR7F
	 0lI0TD9gjceNhie2/BdB/uDbhn0zoxB+YCfgtN3GPxNVh6ECJuL2WWV9NBES3Z6+jjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FKPP1j1mg6pmAjCCZEQ4biFgsV5HseZgjUEhu408H9Y=;
	b=LokDgYaNVy1CAsg6Zh1mDu+x9g0co5/EhL/58vDoOai312cN/dc4Rq0Zv3JyWrIQ9pB9
	 dsjZQGvnnvcJmcy5Qdc36Yqxm8zUa26u3kLUioN+nHDxsLykn0aUmRW6hxv0oX7XA9k6u
	 vIZ/yJhcCNfHyH5LYwChEM4LFfvsfXLW+O55nBbQxhu1OKNJf7OmJrhakyu/AAwvJ3n8f
	 SyOj5j0QRNBfu6Y4Feo67oIjxbtARICoKHIUx6jXilm6vuxmIkve8FE8ZyESY58isUxWy
	 EGSIGHTNPghBhW1xuUmUD76ze79ewL37OiUu6c639YgIr3m+GACnsqz4gBPRJKY19FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0MdhbWzd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5034606A9CF;
	Sat,  7 Nov 2026 15:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0MdhbWzd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428661F0089F;
	Sat,  7 Nov 2026 15:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064668;
	bh=FKPP1j1mg6pmAjCCZEQ4biFgsV5HseZgjUEhu408H9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0MdhbWzdCH6e8XuyG/2AfT74eApULmNhxnXO2ERN1mwH/txy5LVlvAKL7gKJPCgZL
	 ZqdJ5qygXMS1LBDz1OFlFqoS/TFJ6++odWrWMtOTjYOmA3gnMyCzYUskmqXuKqrgvi
	 xb/ksV09jbZnpqAg8QpnQK1sqNo7yYvJPzn8T57o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lianqin Hu <hulianqin@vivo.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0629/1257] xhci: Prevent invalid vdev dereference during sideband unregister
Date: Sat,  7 Nov 2026 08:48:45 -0500
Message-ID: <20261107134956.665583852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit fd616dc74e8f58f351f2b295620027116cd6e92e ]

Offloaded USB audio devices using the xhci-sideband API store a pointer to
the xhci virtual device (vdev) in the sideband structure when registering.

This pointer typically remains valid throughout the lifetime of the USB
device. If a configured offloaded device requires a reset, the USB core
usually unbinds or notifies the audio driver beforehand, ensuring that the
sideband is unregistered before the vdev is freed.

An exception occurs when the USB core resets a device to recover from a
failed resume, but a subsequent 'address device' request also fails. To
recover in this specific scenario, the xHCI driver disables and re-enables
the slot, which frees and re-allocates the vdev.

xhci_sideband_unregister() later dereferences the stale, previously freed
vdev pointer during disconnect, triggering a kernel oops:

 Unable to handle kernel paging request at virtual address dead000000000122
 Call trace:
  xhci_get_ep_ctx+0x0/0x38
  xhci_sideband_unregister+0x68/0xf0
  uaudio_disconnect+0x70/0x144
  usb_audio_disconnect+0x7c/0x268
  usb_unbind_interface+0x13c/0x340
  device_release_driver_internal+0x1c4/0x2bc
  usb_disable_device+0x84/0x190
  usb_disconnect+0xe8/0x338
  hub_event+0xbd8/0x19ac

Fix this by preventing the reallocation of the vdev in this specific error
path if the device is registered for sideband use.

Just propagate the error directly to the USB core. It should either retry
enumeration or detect the disconnected device, and handle it accordingly.

Debugging this issue to the dangling vdev pointer, reporting it, testing,
and initial patch with different solution by Lianqin Hu

Reported-by: Lianqin Hu <hulianqin@vivo.com>
Closes: https://lore.kernel.org/linux-usb/TYUPR06MB6217000B59003EDF233D7246D2B22@TYUPR06MB6217.apcprd06.prod.outlook.com/
Tested-by: Lianqin Hu <hulianqin@vivo.com>
Fixes: de66754e9f80 ("xhci: sideband: add initial api to register a secondary interrupter entity")
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261009151624.618967-12-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a9e47e178c280..28bfe5fd0b6f4 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4435,10 +4435,13 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 		dev_warn(&udev->dev, "Device not responding to setup %s.\n", act);
 
 		mutex_unlock(&xhci->mutex);
-		ret = xhci_disable_and_free_slot(xhci, udev->slot_id);
-		if (!ret) {
-			if (xhci_alloc_dev(hcd, udev) == 1)
-				xhci_setup_addressable_virt_dev(xhci, udev);
+
+		if (!virt_dev->sideband) {
+			ret = xhci_disable_and_free_slot(xhci, udev->slot_id);
+			if (!ret) {
+				if (xhci_alloc_dev(hcd, udev) == 1)
+					xhci_setup_addressable_virt_dev(xhci, udev);
+			}
 		}
 		kfree(command->completion);
 		kfree(command);
-- 
2.53.0



