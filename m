Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AA52820D1;
	Mon, 22 Sep 2025 19:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569827; cv=none; b=cHCeclZWM15aTnVfBWmZEaQwZ+gNKXl2MziB+N+OTZRt1+rWRDzDeL1JZdaqOvrJhAkht5DvcYvAq07tzn5Go361a/akk4PfcPiY1gY2PGKi1AGm5grW8hKPGd6aDHTnwb1IaJwvEcwKIJF/uxwuHVh2fJW/s2WqfshNQu+KeYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569827; c=relaxed/simple;
	bh=ltY70nvl5d5SOUp7T6MLfVkEeX6U1jMg0mdH5VWKiyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ttV9tyzo1sexnJ2VGQ9bT6cb1hCxEZO30lwKbAXLkr/5YkxwcRzLAQEW0NITqjyo9q4Sw0nCRbhIo09qzfA5AoUPIedrU3ak9pVycZNtOaw6xeJg9uuS9zNollfEqVJraU26MH+WTJEpGuyShXO3gPSS3vOrSMCYeg70vTrMOHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGh6VHup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGh6VHup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C191CC4CEF0;
	Mon, 22 Sep 2025 19:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569827;
	bh=ltY70nvl5d5SOUp7T6MLfVkEeX6U1jMg0mdH5VWKiyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGh6VHupHJ5PPRKBs2Vsa5ROv/6qy5YquuJv3E3nth9bG30DJYRaYTigitRBPoxI2
	 Df0fgX6+xujvRZZJqtNkYS6ettPQM/RJJR6XjvXQnXt/TCDKDpoqocvDooDsXzLV+q
	 lzgKHmaRLQVTs1F/2y/jkdgiOf8t2ePFPpK6/ZX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/105] pcmcia: omap_cf: Mark driver struct with __refdata to prevent section mismatch
Date: Mon, 22 Sep 2025 21:28:49 +0200
Message-ID: <20250922192409.074124616@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5b639c942f17a..a2f50db2b8bab 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -304,7 +304,13 @@ static void __exit omap_cf_remove(struct platform_device *pdev)
 	kfree(cf);
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



