Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73246217F55;
	Tue, 30 Sep 2025 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245094; cv=none; b=YvaiuTnur3b3DlKs8M8KCeVuHctAM1+XX//018fV47SERiq29l1Kj3i80nqS2YlosMqc0YXDKtJcD4+RI4CuW7HlX2CBBNn/HNsHsB16za0UmXdOm4dJk2GQL4o+Q49TV/ltM+d8nGQcSVZwcpfKzmwkN6YrGQvEoPUSHH0SFw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245094; c=relaxed/simple;
	bh=SARIV/MC2B1AQcA0KpijJ6Iba4zFJE6aBubEbk1n48Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BqurhxdSfDOw7w486E0Q31a9KLtIqH6CuJPdX9ShXlUqs/QddgrIs7BpMaNwkeiORwOeD2i/ddHh/nlGZOK3LsUDxVMW3tEi+39cyPBu2thAIz5abu9Cd7RC3WaUXA6tpZ+ynKXZzuc6+PNXIVWhgB4XB/ffu51m6zSnwjxfMjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcWOO8dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcWOO8dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC20C4CEF0;
	Tue, 30 Sep 2025 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245094;
	bh=SARIV/MC2B1AQcA0KpijJ6Iba4zFJE6aBubEbk1n48Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcWOO8dvhdLcBtIej5GDpO7HwqDkkb7S62lhn3qKHK8UXZOuR0m+XKy4gHuy+HDBf
	 OgetYYvgpxUV+uvmRCs4Yx3QjiP7eu+lxaBIuK0tKRGQv9Ukw9uzf/cu3TZJyUk6n0
	 3RgoI+kpCn+CcrIc/XTbPOjlWAXZSpREps4Yo5e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/151] pcmcia: omap_cf: Mark driver struct with __refdata to prevent section mismatch
Date: Tue, 30 Sep 2025 16:46:37 +0200
Message-ID: <20250930143830.267134608@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d1dfcdd30140c031ae091868fb5bed084132bca1 ]

As described in the added code comment, a reference to .exit.text is ok
for drivers registered via platform_driver_probe().  Make this explicit
to prevent the following section mismatch warning

    WARNING: modpost: drivers/pcmcia/omap_cf: section mismatch in reference: omap_cf_driver+0x4 (section: .data) -> omap_cf_remove (section: .exit.text)

that triggers on an omap1_defconfig + CONFIG_OMAP_CF=m build.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pcmcia/omap_cf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pcmcia/omap_cf.c b/drivers/pcmcia/omap_cf.c
index f0b2c2d034695..ca88c75f04277 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -331,7 +331,13 @@ static int __exit omap_cf_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver omap_cf_driver = {
+/*
+ * omap_cf_remove() lives in .exit.text. For drivers registered via
+ * platform_driver_probe() this is ok because they cannot get unbound at
+ * runtime. So mark the driver struct with __refdata to prevent modpost
+ * triggering a section mismatch warning.
+ */
+static struct platform_driver omap_cf_driver __refdata = {
 	.driver = {
 		.name	= driver_name,
 	},
-- 
2.51.0



