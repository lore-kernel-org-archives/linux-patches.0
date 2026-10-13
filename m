Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E594FDE41;
	Tue, 13 Oct 2026 12:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895502; cv=none; b=aurDQMooth3i30ojmymZiv7a7c2XqU0rCN3uR2KAHT3w5qQ3uDTayHJN9RFntp5DmoO0Br7flyMuNHlr0fdmUJyYro0Me9d0jdeQu1Hce4tDiRqV4A42/SsG/yAcZV+V1cbrwM/e5qpr0XnKo2IorPJTPcvObJvSGCEBkLqo0Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895502; c=relaxed/simple;
	bh=PP42B4bsAzm1Qr1yCLiaHB1kXk0+doEJo6TZKI/Spy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Or6y5BUWRdgU9kfAqBycEZ5gp00C17K7vvyzi7elL5m29u8wuDtqabMFJ1GUW41Saf9tk6QxImQJtahGnTCJ8zp+caLEn28qVbOh7z4hJlrInHCCY9dPzUtvh0RYXjQrL58MlB/lZOjJaLa2q9eULsLseylccXLR3EF7CEPbaU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfNkY7cH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfNkY7cH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7C31F000FF;
	Tue, 13 Oct 2026 12:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895501;
	bh=HMVQbhaIMZ3SziZdqPUvKoeKtfeoeoLfGqE8pXc1m+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfNkY7cHN8Cx+v92KC1UvEY+5ODxi0J+ax+9IsFf3YpuOQULawFL88W60LYVtsGzu
	 8fCR/RTqARopNI7MsV2G45jA/cSuZX51lfmS+lEsr4eH3A1QRG6wGdFHYFYvAlpfKU
	 6W0nvnsbPk+p02m43eXfbmFhOSsHOn2JyIZA5ApI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/497] usb: ohci-spear: disable controller wakeup on removal
Date: Tue, 13 Oct 2026 13:37:43 +0200
Message-ID: <20261013112914.922626162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3192d7ce04fec..f9414b2de65b8 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -103,6 +103,7 @@ static void spear_ohci_hcd_drv_remove(struct platform_device *pdev)
 	struct spear_ohci *sohci_p = to_spear_ohci(hcd);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	clk_disable_unprepare(sohci_p->clk);
 
 	usb_put_hcd(hcd);
-- 
2.53.0



