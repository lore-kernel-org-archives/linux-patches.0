Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7D4391E51;
	Sat, 17 Oct 2026 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257049; cv=none; b=oVTOU+xNYyEE2gPwRQ5T5HYeYS3QdeP2j6L8xEXydIRTMvfvmZ+vhIEsFIK8TFwj0TNbx6b+UfxGTZN5kZjBuQP0AO3RTmYCzaOJoT5V15tdoLi5EUWYexY1Tly1ElpulWtZR6tIlRJZuc9bspDgfeEjDFEt6JPq/YgwFlsBptA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257049; c=relaxed/simple;
	bh=cxQct12mdE1Ih8JCjMLfAmcAolCLacQe6WgnIw+mmxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ic7kBlFeYEh0JWhPG4xP0TgIOE34j1SIxdOJLq4DymPrQBh6SZkteuk24E+1UVcSVVUc6qJycPZRZEdLinZga1UuCHxKicCaU9P5DB5PTmycsDzm8WuJ0fo/ckO3BLP7dfQKBzvcJ6oUam9+9UXlKMm+UFOMI2Gm1hrh/zBViWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0wpOAHf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0wpOAHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2DF1F000C5;
	Sat, 17 Oct 2026 17:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257048;
	bh=zJzulLSwOimibxsusQu27AChuweWlmxj9uL9NX7VKYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0wpOAHf+gBoic9gIJe/eIZorCfJyoAOmWXsrFx8edlaMNEhQNWdHO2u0E14s8sKF
	 PwongtlBeKnnfXr8kse1edpTrklJF872IW+IMncVLsf8cfHkMTGpg2135aZ95yB3Mb
	 +JsRIuM82EqLv0NxYi64zEV3012gHb+OHNzFMhUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0392/1674] usb: ohci-spear: disable controller wakeup on removal
Date: Sat, 17 Oct 2026 17:44:24 +0200
Message-ID: <20261017160441.169500084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



