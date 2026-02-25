Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582E51D5ABA;
	Wed, 25 Feb 2026 01:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982945; cv=none; b=oHO4oUrVf39+/zLfdyRRaSo7ptLLvHxm3fRqFNzDBH+UP1WkuegEamFA+ImRHAgPY8K3+ti4+e0RM6nthkec2XM4aJkctDnkD2Pbs5pycqA9myXoBHk3cZdkCf22JmV+VDTjZS7+n71AvaTL0uCm4CFH3rA8kPca+nviaVt79Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982945; c=relaxed/simple;
	bh=hRBsaAOW2gZaAd5/923LkJ62C5y3EdTJTcBt8NpxRQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIC0qRxPOx48Jj3zvUaLmh4lxatXX3hAllyf9FFaPZoUGHxrTf0rxz6H7pm9/xetGrle8qtsuF0DupxALwTvhdTNmfpCsTBZ+BkXs6ants3kyuMM5UfuuXFqWXtOCRM2AoloHwrUQM1vVHLOlk1Qmq93FTkwuli6V3WAQs27/xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKGP3Ayw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKGP3Ayw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16757C116D0;
	Wed, 25 Feb 2026 01:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982945;
	bh=hRBsaAOW2gZaAd5/923LkJ62C5y3EdTJTcBt8NpxRQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKGP3Ayw2IGNvZpM6fuiC/XoKn/ICwCSksTwCKCnfgQI/NtVXTYd4Fvd879YfutxY
	 z32rU8Yyyyvv6MhU/J0yP6ZKuUu2FQFUhbhcm3bdDRfuFbRGw8sYk8o+gRMAntiyl7
	 sASeyZpUMQ3jE55zAwkx2Ewf2tVO/aeEF7Koa4lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 124/781] rtc: amlogic-a4: Remove IRQF_ONESHOT
Date: Tue, 24 Feb 2026 17:13:53 -0800
Message-ID: <20260225012402.710527628@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 18d28446231390e4ea3634fb16200865df2c6506 ]

Passing IRQF_ONESHOT ensures that the interrupt source is masked until
the secondary (threaded) handler is done. If only a primary handler is
used then the flag makes no sense because the interrupt can not fire
(again) while its handler is running.

The flag also prevents force-threading of the primary handler and the
irq-core will warn about this.

Remove IRQF_ONESHOT from irqflags.

Fixes: c89ac9182ee29 ("rtc: support for the Amlogic on-chip RTC")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Link: https://patch.msgid.link/20260128095540.863589-13-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-amlogic-a4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-amlogic-a4.c b/drivers/rtc/rtc-amlogic-a4.c
index 123fb372fc9fe..50938c35af36a 100644
--- a/drivers/rtc/rtc-amlogic-a4.c
+++ b/drivers/rtc/rtc-amlogic-a4.c
@@ -369,7 +369,7 @@ static int aml_rtc_probe(struct platform_device *pdev)
 		return PTR_ERR(rtc->rtc_dev);
 
 	ret = devm_request_irq(dev, rtc->irq, aml_rtc_handler,
-			       IRQF_ONESHOT, "aml-rtc alarm", rtc);
+			       0, "aml-rtc alarm", rtc);
 	if (ret) {
 		dev_err_probe(dev, ret, "IRQ%d request failed, ret = %d\n",
 			      rtc->irq, ret);
-- 
2.51.0



