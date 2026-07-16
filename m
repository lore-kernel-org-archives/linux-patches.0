Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3CD2FFDEA;
	Thu, 16 Jul 2026 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210128; cv=none; b=rL8vtWsJQWlYR/CS+7Hxnp2wgs1QjzI25cxc4afwDQ767i13SWzDgUlyqrQUcUGX6lDZFCoyF/cfnrVHXkAMvw3BDUa5VuqebiGtXhZA3d2mbyyh++8V7+pgTAAFisQsTzi/PATF0R7jFrKyMoZoxlylG4brdH3l53JO4t8jfiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210128; c=relaxed/simple;
	bh=XnMJoFqlD4bGKg4+2kNsvHV1b6LQ7OoaqSEwu0qajD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiRnowmmMUfLonGgG6yJupiJBQBe5EAOhcb+3nIdpLtdMVeYPQ9Z02zSUPOKdw4ZYcp9BkpcZMb90Po1iZ86G1nf4YLtczS/b0VbyqrLbrucRSKEuYhGxw39+C4gR2LgSPJS8Bx4otw15eFhaaUX5rAXjshNHP5KM5FuO7Kai38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVNb2kqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVNb2kqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE2E1F000E9;
	Thu, 16 Jul 2026 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210127;
	bh=ftSeLRcwn316T+3l7DpFKBk+5gq7xXDFzcWYc5k57PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVNb2kqupaxmsBR0tt4ZJ8zB0eAWE2WF/o4RN2pAEyfa0EB6vWzhMBDKq6cuQCySa
	 I/HyRLXJ8zYuAzS0BG/Kl0FJi9tHj0EG+vPhvz5hcBo4fJtPKY8GO4sd2JvUXPlAjn
	 dOVhy2fB9HVYwBT4ovfFsL7fM9HB00IZ2bjrkJLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.1 405/518] watchdog: apple: Add "apple,t8103-wdt" compatible
Date: Thu, 16 Jul 2026 15:31:13 +0200
Message-ID: <20260716133056.697407992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

commit 14ca4868886f2188401fe06cd7bf01a330b3fb99 upstream.

After discussion with the devicetree maintainers we agreed to not extend
lists with the generic compatible "apple,wdt" anymore [1]. Use
"apple,t8103-wdt" as base compatible as it is the SoC the driver and
bindings were written for.

[1]: https://lore.kernel.org/asahi/12ab93b7-1fc2-4ce0-926e-c8141cfe81bf@kernel.org/

Fixes: 4ed224aeaf66 ("watchdog: Add Apple SoC watchdog driver")
Cc: stable@vger.kernel.org
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Janne Grunau <j@jannau.net>
Link: https://lore.kernel.org/r/20251231-watchdog-apple-t8103-base-compat-v1-1-1702a02e0c45@jannau.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/apple_wdt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/watchdog/apple_wdt.c
+++ b/drivers/watchdog/apple_wdt.c
@@ -218,6 +218,7 @@ static int apple_wdt_suspend(struct devi
 static DEFINE_SIMPLE_DEV_PM_OPS(apple_wdt_pm_ops, apple_wdt_suspend, apple_wdt_resume);
 
 static const struct of_device_id apple_wdt_of_match[] = {
+	{ .compatible = "apple,t8103-wdt" },
 	{ .compatible = "apple,wdt" },
 	{},
 };


