Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072CD472553;
	Tue, 21 Jul 2026 20:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665410; cv=none; b=OqJE+Qms1+ffQRaIHcJVS6WQ7B1xFnQkRq5ZtIjA1vo5T8zq9aCZtltG686uAUr1N+qkb4dNFUjvLo9PWwmHx0daFQCkbylTgO/LiS02zKv5ylz9yJld+gTBEMnKYX1CteyZfwDYBFywa4E7+uv8NGcMZ1gchRfwV+VqrtWCdjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665410; c=relaxed/simple;
	bh=onkKBBXZxxUJ29RhoqrUjNuvaaDCk4EcIhSqpgicLSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mA5gOMli1a+3yda7F7R2thUklMvkzUP8jBhQ0T8Lr5gZdoOVg9cTgKakMiBO5Yj55mc7zGTbnXDUspSvZmqpy10+BpRhj52oIiAkridwS2q8A/PU0z2qFXIcFTlW1apIIZanVplV/6r6blaI8Z/2nWVuA0p4vtdrA4bPN+pRMes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJmyk7YZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJmyk7YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682581F000E9;
	Tue, 21 Jul 2026 20:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665408;
	bh=hgtwQ1g79h5k1oB1CH9Dp6JEGBXr+0EbFv647oBc4L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJmyk7YZvPZ7Jz1Kb6u3dtCPeGwaoqAsWU+dCLMc3TuIzAFeaSdqRNp6X3OfrKBto
	 7/EvQWewq5swqr7+4Ec/gAONaJvmvLzoUS3FY8wAF1p/ddHGnjo7wzN1nkE8BbKxLi
	 9Z3fuWLA3GYLPJNygGRamfWgM12VtgKCidCgtOjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0293/1266] watchdog: apple: Add "apple,t8103-wdt" compatible
Date: Tue, 21 Jul 2026 17:12:10 +0200
Message-ID: <20260721152448.381280016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -191,6 +191,7 @@ static int apple_wdt_probe(struct platfo
 }
 
 static const struct of_device_id apple_wdt_of_match[] = {
+	{ .compatible = "apple,t8103-wdt" },
 	{ .compatible = "apple,wdt" },
 	{},
 };


