Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208980;
	b=ruS3UEBhI0vSB953Ss7tDEtSBeNWUtNjB3PQHHrSz8porpJSRnZhrv+D8guH4oEeWwbR
	 JXALoyHy/R4gwHKC5cQ2jatGvK0yQeCuwH/bqAeoVN6tVUOCYuZ1JnmsX/S9URt0Ykvpf
	 RVoXE9CTqKXOOjKunpbXxATLDCOLZrYeTjBcqDU8YNQhKhfYqjLMKpHoiIY6+fNuJjzPh
	 bI8a2QGtME8S31rBcQif/KRkmq4Ok5hpXEQdCYnT9aM8IhqzLJo7yjGHN9qkPMbJD16Wg
	 TIbueB6CgX/euyAsFVzSaW9ueachQpgvaZAA/AdKxZ43xguD/tF3FjkrHtlrz90xs9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Groa30+0DX8Ym/N26LOCiE3zBSnbKVI6y5iFEriwi6k=;
	b=y+RR4MI83NCGKK0TO5d0LYiaNrBAMk49a8QLsNl25kI72GgqNd+pBQxu1WERbyIBb6xI
	 Yfj3ny1T1xKEU8Ff/uRWmGbRfhRvRkXJqmO1Gm1fKZCEygAxzJHHMvqb67XpaaPOA2hPN
	 E2dLx6JCLKUbXpOEkhwILXyDlyuhPp0QkDbpq5CxdFvzlvuvX+gFJ3R1a9p1CDVqKPpL+
	 enOVu5qRkc1yBZsqBpQET0t4JLNlgrwdj3u+m5qwuhI8ouc5sP/gCyuPrQMlYk5JCnn72
	 MrAWlYXMTqWu0tIpkW5cB2Fnw+q4SFMw/n2KDIVy8UsvI+L5UYsZSdmZHblOb1n9HYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oe6C+q9b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFF2606A31A;
	Wed, 28 Oct 2026 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oe6C+q9b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EAA1F01825;
	Wed, 28 Oct 2026 17:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208979;
	bh=Groa30+0DX8Ym/N26LOCiE3zBSnbKVI6y5iFEriwi6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oe6C+q9bZrXXaayxzU9g590lF1NsG8dgcGSFvd86AeIZzUU61ZotjhQZMnhedOn2R
	 l8Uxa/Wj40HcMTTdVc3ZFYRjCvuVTVkqmvDRWi1CZ6E3brWzswoPAmsjYwJ+8MU3VQ
	 kW+/lnMKR8siSg3WjGfBVlC3aAugoQUtZhdeU7ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/516] usb: ohci-spear: disable controller wakeup on removal
Date: Wed, 28 Oct 2026 17:57:15 +0100
Message-ID: <20261028170010.195599158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit b1b0f8bdbbc891a4ee7f3b1a878c633e02b7bbeb ]

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
Link: https://patch.msgid.link/20260915012011.61874-4-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ohci-spear.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index ed019c459ea0d..8dd9b77c12fd4 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -105,6 +105,7 @@ static int spear_ohci_hcd_drv_remove(struct platform_device *pdev)
 	struct spear_ohci *sohci_p = to_spear_ohci(hcd);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	clk_disable_unprepare(sohci_p->clk);
 
 	usb_put_hcd(hcd);
-- 
2.53.0



