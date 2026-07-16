Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CBE425896;
	Thu, 16 Jul 2026 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211329; cv=none; b=NYn7BeeuPz/dGqedzFl3+j5VIyUIYC8EWQiYPtcu5pIi8mpbICKpDJoh7gtWqDb/1Aeir3pA4zXbd9XrUxtaxy1Btk1QOUCIZxsbHXK7H9rqmn93SXt/2+PpPT6EsjmP+oS0XIhY46s16KxHuFYMk5T092VaWlkFd/EaZuXM9L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211329; c=relaxed/simple;
	bh=AyZcDjlt9548e6yhMhIJlUcRIIjYGO9nsqYm0jHIpNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzau7qEjluOsvWJgsk+c7mYPuQ1jDMb+hrntKCmVjDsrR4hT3W7siC3kujRnMNzNn2sAWLuRKYPWmmeocC6Xva4ER50Mi8j8VQ3JGO2kDKGq0zGNYS0SsY3lTMRkmKFrTOxIaUv+4YSGD5C572V+RWinUJ/KE5H07WefLNgpab4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLLk3xT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLLk3xT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6C51F000E9;
	Thu, 16 Jul 2026 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211328;
	bh=qR8+14emOJ3wdbXVJSnhny69P8h9f8qBe8R7DBdkiLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vLLk3xT90VamWwa/DXtgPU2XXQafzQ3YIsoT3OgwKB0loEbPHhRBAYTYx1He41HDs
	 a7vCbHAorEcQ5Aw3hfEHRhLpvCSO5qvzYSnOJVt0xh2qSj4AzGrVcAjeJm6G99nlwu
	 LKl0aeovrKz+TxLGSMMWmHXbPy3fhGDDRv4ePAiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 387/480] watchdog: apple: Add "apple,t8103-wdt" compatible
Date: Thu, 16 Jul 2026 15:32:14 +0200
Message-ID: <20260716133053.172701502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


