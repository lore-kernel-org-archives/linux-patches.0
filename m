Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA6F47AF75;
	Thu, 20 Aug 2026 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243791; cv=none; b=H1Xfeex3XC9vUyT7XYDWha2yirrdWls4aqjM20kpNZiiUvZIN9xQkrQ04mbXwtEiA9pYgWmj9lwDNxo+yhw0aiI4Jo7z/Xz7++yVLFmKmfUIIGWG46pYmjftoMfm3N09iwj4Aqi625f4zgOgHyzTVOY7bcPX5GUQ4Bor2G+dMzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243791; c=relaxed/simple;
	bh=XOo56aPtOuhfcHxrj9dBhPgWjNxF5FvvArzDeAr9DP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRDMh4NkK/KVZPhUij9AqF8uORVE6elKVxaaegGbKGelle+6UCWRx5vxLeLNV12MsxVzTA1jbqUoAXzvFEAY2C0urFHZU7mQM9+Tx6G6Rk7x2KIhYXK6yQy7W2RrKYMATzXI/0If99aqjPUiv2Hs7RXI637KDXrou1D4I+xuyCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgvItjLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgvItjLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78FA1F000E9;
	Thu, 20 Aug 2026 16:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243789;
	bh=BDhMYpnccQSxvjDFKCQdZQ+Sk+l+mPZn+lSJvHWOgYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgvItjLiDS/QSHXHvu93zXjppF3BaJqs219F6BhuPv2Rg051sKkvMP+HnDwn60AwB
	 waT3V5lX96TozqARuDwFiE3SreeTbpzJghkVen4HyjB0veXzzBcACAkJ1UW1hiOTkf
	 B6Ce9XUnvbtO/zVGZJSGxcH8sS9GwT4F66YBRHxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Lech Perczak <lech.perczak@camlingroup.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 199/272] serial: sc16is7xx: remove obsolete out_thread label
Date: Thu, 20 Aug 2026 16:56:23 +0200
Message-ID: <20260820145237.443258160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit dabc54a45711fe77674a6c0348231e00e66bd567 ]

Commit c8f71b49ee4d ("serial: sc16is7xx: setup GPIO controller later
in probe") moved GPIO setup code later in probe function. Doing so
also required to move ports cleanup code (out_ports label) after the
GPIO cleanup code.

After these moves, the out_thread label becomes misplaced and makes
part of the cleanup code illogical.

This patch remove the now obsolete out_thread label and make GPIO
setup code jump to out_ports label if it fails.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Reviewed-by: Lech Perczak <lech.perczak@camlingroup.com>
Tested-by: Lech Perczak <lech.perczak@camlingroup.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20230807214556.540627-3-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: af071d9e07e5 ("serial: sc16is7xx: implement gpio get_direction() callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1399,7 +1399,7 @@ static int sc16is7xx_probe(struct device
 		s->gpio.can_sleep	 = 1;
 		ret = gpiochip_add_data(&s->gpio, s);
 		if (ret)
-			goto out_thread;
+			goto out_ports;
 	}
 #endif
 
@@ -1425,8 +1425,6 @@ static int sc16is7xx_probe(struct device
 #ifdef CONFIG_GPIOLIB
 	if (devtype->nr_gpio)
 		gpiochip_remove(&s->gpio);
-
-out_thread:
 #endif
 
 out_ports:


