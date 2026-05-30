Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D5D32F770;
	Sat, 30 May 2026 18:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166173; cv=none; b=qQSVQL0LDTm81EoLHvGcWjK7BswsfH6glFHD06YSbFSkKDIrXPnCKENAjp8S90xhCCiANfH9otfvov8P3ig4dCaivtdF40DG9Hl1cxq120JQZ0Mhr1EllxIdin0bF9iInDk49tDG309Uzk4zsx2x7pNCqh1NSyLpHUaHX+KBNhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166173; c=relaxed/simple;
	bh=NpfiIGHkC28c4/TYcuXaLFT+fKMJOyBBeay4SLefoF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpPQjbKog891pABP4G4ngEdvC4QFBwYNwBh2x5sbFBROiTYTUuWOTIkjy4WccDdsSrkMpk1x293t1Miv50pFuh35OcR54ZAO/b1tfb29QoEc/WynHuVivYPw3n735kZb4Fmy0rrwS9K4wk1C+FIj2jW4Swfzz1c9qqTFi+MSMYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoHu/kwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoHu/kwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95901F00893;
	Sat, 30 May 2026 18:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166172;
	bh=MiQui6zzxP5DsUMI56BpW01ZeyicnRqyRN8+gr81jC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoHu/kwPNrAQG+RJPcV485tp7fRvNTy1ke79Kh1ILgxNWn9j5qnyk8mxI2vZSp1bW
	 McRyPJyxiEYhqMXN92bNgvZzixVYo/K+6l9Bp/ha55sUK9Bhv0hccS/yucybmLEgsL
	 mvllzLb/IIb5MeVNfkVr1a2KjkfaJk+B3GHG1RzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gopi Krishna Menon <krishnagopi487@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 296/589] thermal/drivers/spear: Fix error condition for reading st,thermal-flags
Date: Sat, 30 May 2026 18:02:57 +0200
Message-ID: <20260530160232.720127339@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Gopi Krishna Menon <krishnagopi487@gmail.com>

[ Upstream commit da2c4f332a0504d9c284e7626a561d343c8d6f57 ]

of_property_read_u32 returns 0 on success. The current check returns
-EINVAL if the property is read successfully.

Fix the check by removing ! from of_property_read_u32

Fixes: b9c7aff481f1 ("drivers/thermal/spear_thermal.c: add Device Tree probing capability")
Signed-off-by: Gopi Krishna Menon <krishnagopi487@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Suggested-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20260327090526.59330-1-krishnagopi487@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/spear_thermal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index ee33ed692e4f7..42d8736d5ba49 100644
--- a/drivers/thermal/spear_thermal.c
+++ b/drivers/thermal/spear_thermal.c
@@ -94,7 +94,7 @@ static int spear_thermal_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret = 0, val;
 
-	if (!np || !of_property_read_u32(np, "st,thermal-flags", &val)) {
+	if (!np || of_property_read_u32(np, "st,thermal-flags", &val)) {
 		dev_err(&pdev->dev, "Failed: DT Pdata not passed\n");
 		return -EINVAL;
 	}
-- 
2.53.0



