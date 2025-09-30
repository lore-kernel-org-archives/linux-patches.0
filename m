Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C87201017;
	Tue, 30 Sep 2025 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244309; cv=none; b=CDSrt3W8H4ufh49MjCefsJeCeql3MQhMEQe6PFggWgCyyF7UH794ObDlcznCSOnytlNGYy+HUuQc3FugSMsGLa81KdET8x4gBLqnBM/0ofsme7LCdl6DSovYN8m18jrYntoz3NqkLwYB+qyS+skxA2iZ8OAjKvEdMH7aS5QNp2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244309; c=relaxed/simple;
	bh=jvJUXhOjj7aOzHC9zUQwsdP80c/+xTKxRZ66GHUd/Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptdfeb52NjGw61+HfgfvuUDZjvJx1cBCjcC7+wM/BZvycgpYGMXQ3sCOxpJarpEZ+RXM10vMMelUwbIVmczZp+kJVcdomV0WiQLdEh/4ZAltc+SxoTprASvO6firNZJP+Fl2aK2SFzY8wut8Apl+tnp2Aoi3hFyXj6jsOE2tHQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qucQ/XPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qucQ/XPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784A1C4CEF0;
	Tue, 30 Sep 2025 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244309;
	bh=jvJUXhOjj7aOzHC9zUQwsdP80c/+xTKxRZ66GHUd/Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qucQ/XPSt5XlNV33QfMa4AACF+ImBasV9MlzUwtANZJw0YLgkcmm6K8m+7m3EiNtO
	 GCDLTbmpPmMU34H4248sCxDjGEhmeaqDyt8hsznBBzA0kBbg2HwvYdRqcF62PNKsiH
	 7+knuVevYfFGI9olYFuMN15Yt1u5fQGapZFmHopE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/122] pcmcia: omap_cf: Mark driver struct with __refdata to prevent section mismatch
Date: Tue, 30 Sep 2025 16:46:19 +0200
Message-ID: <20250930143824.971994079@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d3ef5534991e6..a98841db02d5d 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -327,7 +327,13 @@ static int __exit omap_cf_remove(struct platform_device *pdev)
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



