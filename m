Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7710035C6A1;
	Tue, 21 Jul 2026 21:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668566; cv=none; b=pQ0ZmscGcTXvj247HRiWNElGUkWO7/Ay33n4JuMKnYzE8XRxwJaq9OokkVYyf0NvUmKbS+1qDXCRSI9ckM3iJTeJ61lFQ4mD4Ad/e2qtgUFuKoGN/CrVysZ4d6286Wp4iptM3EA4xiCikvQ4CIKCj6d8JdmjVKUaLg5aWNh6uD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668566; c=relaxed/simple;
	bh=rs54hIJhGs2j37fa1+kJH8McBC8eG6XIFCmTFKaSRZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aiq62htLHlL81xBuQsO9dp9MDQODNm8vFYkOCKNOJcUTK8MIZW88WtZeY+NqSi9Lujgc7hMljbjamIwnkWzlOw3oYMko7jpvwRPxd8pDbLxnpYC/R9t44Cbqv7bwzX0WrRJkndTjQF9uYaEQG6JseuOryhgaS3lake3SO9XZWhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0001I8Yh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0001I8Yh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2BA1F000E9;
	Tue, 21 Jul 2026 21:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668565;
	bh=WL3gZZ7j2Ebh8GKG60cJLjwCe2CZHrAPTqf85AmRNsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0001I8Yh7I+aqDWp0BzwVYa0W3cuSDk3gFHDhyU2ncWY36D3mtEB9BZ8UolLSxVEU
	 dAPBfCxFQeOYs/pEveKXiEnxlCmDHcQ3l5Dw4FqL9xvraltYMye4+e8MEe2b8vVg40
	 Z8mklwjKx5nYZVRHrjYBNsfcqo5n5BwjTPBo3XnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 0223/1067] watchdog: apple: Add "apple,t8103-wdt" compatible
Date: Tue, 21 Jul 2026 17:13:44 +0200
Message-ID: <20260721152429.588234307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -207,6 +207,7 @@ static int apple_wdt_probe(struct platfo
 }
 
 static const struct of_device_id apple_wdt_of_match[] = {
+	{ .compatible = "apple,t8103-wdt" },
 	{ .compatible = "apple,wdt" },
 	{},
 };


