Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1319047DD73;
	Thu, 20 Aug 2026 16:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244344; cv=none; b=XAkLUuYiS9VYmFkhd6PDNLLs6nfdbO2kOs5egckw3ihgXpGR/lU91DHSxIqSzg5X2ieB0umejj+ArobbrRYTY57Z5YJvyjoW79wG70M67+4ymGBuVjCxvewU00S/QJfmgpQ3s1F1WeX+4VstQhctSLj7XH0EmlCgyvDSkNDT6zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244344; c=relaxed/simple;
	bh=sG6RuTxr51DYZUnzaoiRxAptWdfyM5lNpYfofb772eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mifpiIhI5j+UsgrUTSGkMP9euSsCXkAxYqK0BzIAWCsjlEIs81bvSPt3eD9/rYc5NKmJ4gYiQp/EIBe8+8Yt1zg1pctrOVK5AsJbEixwUxEbZ4+JOWPXM7jKVCm/eabO61/mBvSLbAg4YsTRzj+c0wC2yqR4ht8pwYtF1KOuzho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODPbDsf8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODPbDsf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEA71F00A3A;
	Thu, 20 Aug 2026 16:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244343;
	bh=4rGA2hvn2odFR60rf26gA6cxFzeNc7JJYmGHvGE8ZNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODPbDsf8yf4ZBeqZ0fYRD5P5SzqiyUyy0lF1BBC+zpRNkNtjfaJ3QoNRd4/a6f6Wx
	 pzd/o184luPszyIpZSu9/GB8wdnZoXkwAHhl90VLByMCtuSm5vbwGygBrBf73fZwnI
	 vMKVoG7/3n+QHirjxnnU5Mo+cq/A8w77i1UOm+ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Felipe Balbi <balbi@kernel.org>,
	Chunfeng Yun <chunfeng.yun@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/235] usb: gadget: bdc: fix checkpatch.pl spacing error
Date: Thu, 20 Aug 2026 16:56:10 +0200
Message-ID: <20260820145220.507382676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 14a46f82d74e9bd8ce03cdbfcdb9f8408c1fc205 ]

fix checkpatch.pl error:
ERROR:SPACING: space prohibited before that ','

Cc: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1610505748-30616-10-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 0583f2fbf8f8 ("usb: gadget: udc: bdc: free IRQ and drain func_wake_notify before teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/bdc/bdc_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/bdc/bdc_udc.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_udc.c
@@ -531,7 +531,7 @@ int bdc_udc_init(struct bdc *bdc)
 
 	bdc->gadget.name = BRCM_BDC_NAME;
 	ret = devm_request_irq(bdc->dev, bdc->irq, bdc_udc_interrupt,
-				IRQF_SHARED , BRCM_BDC_NAME, bdc);
+				IRQF_SHARED, BRCM_BDC_NAME, bdc);
 	if (ret) {
 		dev_err(bdc->dev,
 			"failed to request irq #%d %d\n",


