Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015955;
	b=FgbHSEqezzJxoLcrqpTXHIS44mzMEfG/uaj9EsFeFXp746UpdQRwUdLZL93FtGF5uI7k
	 uksqDNFxHqJDgIFhMP0kpgk/Zm40VHri1X86aw9OiBZ+wqXe0jmMOqBEtLb9PY7vq9wca
	 SDRQte5fG60bpo6SGjVX0WfeqmZ1iGRTRCHERLJadisiSQcMPNtVzSsuI7SGKTyJhBOn1
	 LIJPW7s1FurtrzI+ndRrcIGOlfa4HpHAfe/u6zGfZHW/vsYjgQnyWh5jBdsvYnENkgdyT
	 cLnx+n6r1cOoV874zjWMp7qMpngL5yF+lqhK27wqWt+UlzNUGBdbm8jnNIFvQPLLELw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XOjJDUpwUc7JmG/hzmXGuGhrjLou0bN1Z3OtVcZEc0Y=;
	b=HzSvgsrCTRm4cLPJZkN9D+i4nsIN1v5o5N423R8GWFgFIoNZsHe281YCfW9SttuPY7Jb
	 07sFfZjTISomMsa+rbLf4y7GTKmTbVkiUMR+0w2h/LieonLUmDlAHd55Fqbg/Ml0nGD6A
	 V7YWcw1YYEI4O4v4ZKZw8IVZJyKGeQghwfXKLtTkJgY0t50rvwbOVMEkuDxqlU2y+21oq
	 j0jrscmrMeRPS8mqB5JUpQBr+EP6Ds8Bow4K33Hu8dyJKi9kcDDoYu95ecLlHOOH8ElQG
	 /YjlwIKZNFuF3lA1b1qcDup1afwIzVWF1sHi3EIrUfMM5wrOLKWw6339/bPNsQ2Dwjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hYIIxnz1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FFB606A32C;
	Wed, 18 Nov 2026 15:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hYIIxnz1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E721F000C5;
	Wed, 18 Nov 2026 15:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015955;
	bh=XOjJDUpwUc7JmG/hzmXGuGhrjLou0bN1Z3OtVcZEc0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYIIxnz1Glj+/ER40LBi04TcvbwgXsT4fyFKyNP6sugglrqTTt37lQdp6DVe/k39t
	 cIni8EppQQzJpEJN6tr0XlbrG8AWO9tI8jn1q3Qsh1F/mnKjbzZ9jTLidfr0B46QAr
	 hiIbK0APzs3J1iUtEK44ivjzZTusBoAPH94wxDu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0357/2651] USB: pci-quirks: Release EHCI device reference
Date: Wed, 18 Nov 2026 15:26:37 +0100
Message-ID: <20261118150300.690961817@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit e93731c29f749d5b2495a67109d1f0804ab3b89d ]

for_each_pci_dev() holds a reference to the current device.  The Intel
EHCI lookup breaks as soon as it finds a match, so the iterator does not
get a chance to drop that reference on its next iteration.

Release the reference before leaving the loop.

Fixes: 26b76798e050 ("Intel xhci: refactor EHCI/xHCI port switching")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260807024304.928708-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/pci-quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 0404489c2f6a9..ba158d63bb8bd 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -1073,6 +1073,7 @@ void usb_enable_intel_xhci_ports(struct pci_dev *xhci_pdev)
 		if (companion->class == PCI_CLASS_SERIAL_USB_EHCI &&
 		    companion->vendor == PCI_VENDOR_ID_INTEL) {
 			ehci_found = true;
+			pci_dev_put(companion);
 			break;
 		}
 	}
-- 
2.53.0



