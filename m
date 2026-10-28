Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211243;
	b=GYjwLEA1YuDC55tlaPS4IpFioBaiQsMLD1pz/vz0usg8l9DJcY9k6zqfBmpxnHB1DLo3
	 dWuIZnlwarEF2AfvRxGYcQmjqnq/5XVxqecZSyTnULNkgGXAhL6iev1+h8jS06NwCiIaN
	 zEx9eX4ekagDy1Au6jH+8x66+swv8VgMKqdZZkVeEwEMMx2JJZS47uNBEuGRMXYR6eGbb
	 +rmqh0qMBJ3OmKvEIudAOKFinRTTCxAzVj0BLjg2Or8A25n07f+FEwZNSJo6UcW4EAjKJ
	 jyuWp/0ww441BbiRI0q/u2oN/3qf8tse/iVeAQJPVHWq6uGkNfq/bQ19ZLVjNTR03/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x8WFMsbB48vi9r6s3rBq42GwY7d8wGjsiDZqrFPIQ1w=;
	b=th6rcG+njdSOUnWlqCHLR9EnQLlCwBCY+UcL1EkHFl5Ed5ArK3vjnKxM2ZC0Gz1jsktO
	 T+rO8YbHOZe5/zfilMP6cuL7OVPKKtYcRrJietkK8hUiswBI8ENziEo223bJyN5bD5Tn/
	 uuz08Ew72rsx5a3tkLxkcPdWFt3skiaNxqp1IDKHNOwbuK+Bv2/6MCryMny+Vm0coWlLZ
	 kEx+AVXUO4wOBYpSDHOgJn5K958l2Kff92k3waENZmGtJsVR7rM8lXk443tkzBkYdDPDI
	 W5VeGuLOzLRQyjWHFzmW0fLvDNxvzq6JVYOgog+GYCeCqicsYOYHyudqfwFh5r4njwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KM4KnAUu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3323360A261D;
	Wed, 28 Oct 2026 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KM4KnAUu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C891F01829;
	Wed, 28 Oct 2026 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211242;
	bh=x8WFMsbB48vi9r6s3rBq42GwY7d8wGjsiDZqrFPIQ1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KM4KnAUuM5zDb19NpvibccrEx5jiwu1ZfNltzduSliXnkxDRMLyXkuEq4aHgOIhc+
	 PIwFkC7XDuYYjIqEjZ4cNMhmhYu43AlUAi+LZ1P1j62dumbvnvRwBlz46NSMSlYtn4
	 8zJNsZ6q2pPYl6PGuNMJhxCSsxaANkEhBk18ToYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/571] usb: ohci-spear: disable controller wakeup on removal
Date: Wed, 28 Oct 2026 17:57:35 +0100
Message-ID: <20261028170015.307278142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index 986406f7aeb15..7d798b3e75171 100644
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



