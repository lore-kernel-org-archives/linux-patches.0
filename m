Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC26B1EB37;
	Mon,  1 Apr 2024 16:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989624; cv=none; b=qVAaOeVwGq9HgTlJbOXR9G2uaxJAkE/ny6VVD9UovTKI0evkjAXJO/Z0W7ZIAM66koa+BIaM98uj01RnrIRZhmyZqkhNgaAT+WEtghXAwXBZ4tbFxRgDFapVys8dOyPNHxqdDwlucGqcfuSLdubPAUUMcsXhVasCMcGFy5IA1XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989624; c=relaxed/simple;
	bh=/vm5C/MUbywBX2Pc0X943rJ/OpDarOW7SkO6nn6y08E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdmFeyEyKtp8aqyrAwjaia0xwxU6lKJfrIP1gUSNUy/eT5nPoSaQ9FpjxzPD2Zc1Bj3qnqTy5WFcoi5uBztoP6GwCg8ClAycthgIojN03qe2Lr2Gvw99Ny5ihsxQiKLwvo7XilUx4dg42udYxCD3xZlsBJecUHyfvCx1f0MKhLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hyoFSJjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hyoFSJjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E08C433F1;
	Mon,  1 Apr 2024 16:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989624;
	bh=/vm5C/MUbywBX2Pc0X943rJ/OpDarOW7SkO6nn6y08E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyoFSJjhjuPXrN2jd/r7+0YiLoUxk9ek4VFPvEXOrxNivWk0NykKA0LIHrTeFXLH1
	 ryaQuCSWBHX8/QPCOXXJKmaLqHAxOnQ5f/+86k7dI8fL0oInFRPk0j/FqP1iGxrQ57
	 KB0fb2uWe5GY+HxqYnPA4ciEYbEod17PyOIkbKmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/396] usb: dwc3-am62: Disable wakeup at remove
Date: Mon,  1 Apr 2024 17:42:16 +0200
Message-ID: <20240401152550.511515072@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 4ead695e6b3cac06543d7bc7241ab75aee4ea6a6 ]

Disable wakeup at remove.
Fixes the below warnings on module unload and reload.

> dwc3-am62 f900000.dwc3-usb: couldn't enable device as a wakeup source: -17
> dwc3-am62 f910000.dwc3-usb: couldn't enable device as a wakeup source: -17

Fixes: 4e3972b589da ("usb: dwc3-am62: Enable as a wakeup source by default")
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20240227-for-v6-9-am62-usb-errata-3-0-v4-2-0ada8ddb0767@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-am62.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/dwc3-am62.c b/drivers/usb/dwc3/dwc3-am62.c
index f85603b7f7c5e..ea6e29091c0c9 100644
--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -274,6 +274,7 @@ static void dwc3_ti_remove(struct platform_device *pdev)
 	u32 reg;
 
 	pm_runtime_get_sync(dev);
+	device_init_wakeup(dev, false);
 	of_platform_depopulate(dev);
 
 	/* Clear mode valid bit */
-- 
2.43.0



