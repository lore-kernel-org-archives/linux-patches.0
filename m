Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213104;
	b=aIuKgBFA8ht1XqKSVbpYlxZUyWFmaJEWTeQ05Nb3xHVulo8j3EIH98JP3f+rZFeisLoR
	 PX0zBkRqnrXn1wCWTLMTnUWm3QRFUtmmV0EMwcrlfpJA5Xc0/huGJpxIPvnDToZzfkKOi
	 4BQyQISZ5BaTL91onnHdO9yoUxYqNiK0FpqHVtGIM9UHNOk5Yh0IDlVFBk2ZuDZoQ8Htp
	 MBMoFtX3DLb3qg3wqSdUOjzrZYGVnFt2D6p+AkyotruDNIYJeYY7MwBZ6AYeOgFUoygee
	 pOZZVHgkTD8jZiZdTDQ43BRnePXoa9cbxjVeoj46l1HjhqpvjyKE3KR6qaEOuX8StLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=028HnY0vSIrY4Kp3cwuMePz6BcaKD+ovVxOT2/iVamc=;
	b=csuiEmaHp0KiSeAN8oH/59FJuKpGJO2VwG+QXzVN0q75ZbUe4xwYd5l0KRhIEXGjyD7d
	 AlS+Mjxq1oWYCn+jsVRiunmwAtAxCHvuBaKxv6f125M2YIr10gcrqO8ig2FfBtZvs7369
	 6Q5efjRHYC/7cHxDf7JWspWi3Gv0PX4JNZdy/60vFth8ORrMUCwUuB7F2WBUxw7unVmow
	 iXseM0HNnkkqXgeuyXoxGSvBPPyY88DmE4SuhwebqhXApR1dDIhlg9CZzzJnB0GorTLem
	 CJuw2O356kH2Cu1wx+LhU63newmHED9CkmcJ5676+SrjDjMYD5dDEWZ4D7ho/Ngxuzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+HqXMsk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E81606A321;
	Wed, 28 Oct 2026 18:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+HqXMsk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7711F01825;
	Wed, 28 Oct 2026 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213104;
	bh=028HnY0vSIrY4Kp3cwuMePz6BcaKD+ovVxOT2/iVamc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+HqXMskvC8RlwRiN94RNRoWVQ4hxkEcWeG1DXf9NRChNqQwDiNZLww1NVjAJkFtG
	 I92rWCHCmlB+gZI5NnDurt9MMP5TGlcdL+sV+A9T+ZTZdrMw33o+wjP/0Kdt6smiPC
	 G7rinRl1nmNeZWleWsmi/ywctKAkagYAXRlfun5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0386/1887] usb: ohci-spear: disable controller wakeup on removal
Date: Wed, 28 Oct 2026 17:41:22 +0100
Message-ID: <20261028170508.019105197@linuxfoundation.org>
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
index 0f646c35ca737..47f590bdc1aa0 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -104,6 +104,7 @@ static int spear_ohci_hcd_drv_remove(struct platform_device *pdev)
 	struct spear_ohci *sohci_p = to_spear_ohci(hcd);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	clk_disable_unprepare(sohci_p->clk);
 
 	usb_put_hcd(hcd);
-- 
2.53.0



