Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212778;
	b=WxQE6pSJN/l1PxjC+cW8jrMbINcVQNd563ryiTRCmHA81oMM674/fP9W1l+MTu+4t9sg
	 UNy+KXUOxPHqFhAUfvocgE7UPMN+B7L02p8R2C0YKAkDHCFS5IDqM5ZqLYNcESjezjjY+
	 RALHCk12rQTMgzLm9QB02xrYlQQ+HXSl3mybT+5xOxZJFL9M19oSmlKbZpEIhch4MwNto
	 o9D0Mh1882R49E7V2tLm41L5/0Sov2rSZ6TR1xdDpxHB7ZWct2ulIks04rDkxfl0UGFjG
	 TbMiYaXi2rKvDrWBNaYHnq4u4f/g8oWnJaEtgQDIK22QqcGefsQf3228x3pB7CZA50Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C5B3ZnImTDJpgPb8Suzv9J46BOG64ZscQYuVU8T9Xlo=;
	b=15z3uhrUUxnUXZyVjVEJouKSlDUkAKMZnQCCPgOrMTYQi8udU77ySe2/GkDKqXcbrwcc
	 0vV5005Q+uEbBVjtZLeAFretJdai9/RVu6HrneqWKg6u6RwUyUve58J449Orrfl89n4xf
	 i0YRKnAvnCwBqfh3Z9Bscql+vZEk1KNe173LegHmkVs98+Led8bAyMFXWG7QvePU3zGqp
	 jbjR4ESmQWMV6iNDbCJ4d0jSgsic6APvdQcXgEJlAAgAqLlFeBPiTIBj1kqkygkbU8LpO
	 a6yLCKtdCbUEQHAc/Dll23xytYtAlUxPJZCx5KJ2OxA/9eSUEhgzWP2nBuGh1zeGyWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaIayzfj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ADB606A31D;
	Wed, 28 Oct 2026 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaIayzfj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7E91F01825;
	Wed, 28 Oct 2026 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212777;
	bh=C5B3ZnImTDJpgPb8Suzv9J46BOG64ZscQYuVU8T9Xlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaIayzfjG3OcKXb5AR5P3PGNYKrLbP0h3EEvQXrWvSGF+5vVkUzSQpt/Sc1FQoCB3
	 tWZeComchwpyV3gKU4nbixYqK2MuPhatif1kfECosGzEmifm7NfzsiA2ZMgzOA1b2R
	 8VF9bWwUaQzERi+E1HwOs2DNJmfPL6GN4hdCM9WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 0273/1887] usb: ohci-s3c2410: disable controller wakeup on removal
Date: Wed, 28 Oct 2026 17:39:29 +0100
Message-ID: <20261028170505.441492704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 8dd8451c527e2a723bca20da5a6d724b8592551f upstream.

Probe enables controller wakeup after the OHCI core marks controllers with
RemoteWakeupConnected as wakeup-capable. Removal does not undo this, so the
wakeup source can remain attached after driver unbind.

Disable controller wakeup after removing the HCD.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: a6eeeb9f45b5 ("USB: Update USB default wakeup settings")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-3-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-s3c2410.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ohci-s3c2410.c
+++ b/drivers/usb/host/ohci-s3c2410.c
@@ -335,6 +335,7 @@ ohci_hcd_s3c2410_remove(struct platform_
 	struct usb_hcd *hcd = platform_get_drvdata(dev);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	s3c2410_stop_hc(dev);
 	usb_put_hcd(hcd);
 	return 0;


