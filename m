Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC7C42902A;
	Thu, 16 Jul 2026 14:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212370; cv=none; b=ifA6eR8+8KfOU06xwsQeJGM367Inzv7fdsNsLn35nlnLLqLV3NZUewmVQeaZZ/Cb1mhU5Btnbte7f+1vyzjnmOt0e8OIs+4cO/I3nzut5q2lSIch/muA8i+iluC5/yDz7n+eonDQ1CkeuuqmkUdX2sSV3qXWvyzQNWACSmFqB1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212370; c=relaxed/simple;
	bh=NO2L8A2HRit7tnThc4F4jT9hrjhRBzG9hBNgtdgT/DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m01A0RzXRZ6xz2mhYy6RwLQE+96oNxgbPdpzWj8El/KLduXdRajF0sDGOzoz0FpVtGDnN3eX1GB2SttiRVNyhMv+GbGYnrEtuUtd4MONnS7n+xd0a9puncs20o/ADbUfa0vNenEwQRwLj1/OPQHv5kX1DOtpyUP/izbLkvDwzzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VjyJo7UY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VjyJo7UY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755011F000E9;
	Thu, 16 Jul 2026 14:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212369;
	bh=YJONFqJKtuZU3q4ZD54gJJHx97yHmaG+6ltx5K0gbEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjyJo7UYI6bTtO/GSt0oJR/ceJoxEnLGwDeRBI/HLKXgK95BYAKdzqEyMa65A8avg
	 sMCNEV9H7ad+CDZyhV7ClfA3nCnNKcm0Bid2r0C07gwLtcaPS/lhow0J3s1N9V1xde
	 N3go7kcnVHLBjvXg6k0mt28aZvX70fUS3awLrMCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 301/349] watchdog: apple: Add "apple,t8103-wdt" compatible
Date: Thu, 16 Jul 2026 15:33:55 +0200
Message-ID: <20260716133040.057107746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -215,6 +215,7 @@ static int apple_wdt_suspend(struct devi
 static DEFINE_SIMPLE_DEV_PM_OPS(apple_wdt_pm_ops, apple_wdt_suspend, apple_wdt_resume);
 
 static const struct of_device_id apple_wdt_of_match[] = {
+	{ .compatible = "apple,t8103-wdt" },
 	{ .compatible = "apple,wdt" },
 	{},
 };


