Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E474D5208AB;
	Wed, 30 Sep 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789705; cv=none; b=dCK8M2dhvqb2ZQG8d4jw4W9hFd22Rb0pxZV/+v/DQw+7D0lawm02RyPXZdrN+cQeVkC1PmjLnzq2isDdCBqgY722EeuIoAJTQggyvSbsjXIxBcqrN05/v4yNwDdoC1reEH9SOfLJtckbCOGOa/K3TP4d/jc7G3j6jNUqiFkl5bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789705; c=relaxed/simple;
	bh=w9feHoe9PZhE+7h+9d0w92d+VtCzrDRxlCdq6jmNTv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/KYanhXigDkVPotMCDDmY+6WL+5TFA4En2EO0k1h7vtM+fsKwHnFWcwRSn2EtH5ykiEmu3LZ0GdOqcMavzTWsDZ0s2dSsKmK7v8/017Rxp07D0U+LNhIH9UMPdydksFKwvatR9989xkpzbB+wSbD8dVJX8QBUliGSs7cGWA0rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgPKCQhW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgPKCQhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647611F008A2;
	Wed, 30 Sep 2026 17:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789703;
	bh=AlahR4lG9Syb5XcVMj2V8kAJldJ6yTYRb56zBAOgR0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lgPKCQhWVGDcitRcmYb7F+t6oYot97cLEAqqHYOJrPS446NF4t25rVcozuqmRLwHL
	 YDU1ZAQeWNYMtHtfA5rBPH2MdITHlXgaIxtg4sijxg//DHyRHp3KmAobMomugD2Rhj
	 y9G3mk8Wa3iGg9yVaj/dL2PpIQPBQPGg+r8abO8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pan Chuang <panchuang@vivo.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 571/877] power: supply: ab8500_fg: Remove redundant dev_err()/dev_err_probe()
Date: Wed, 30 Sep 2026 17:24:42 +0200
Message-ID: <20260930152426.963647956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Pan Chuang <panchuang@vivo.com>

[ Upstream commit aa5f4decedfb4fc5cd0fe49ab256ad4304d192e4 ]

The devm_request_threaded_irq() and devm_request_irq() now automatically
log detailed error messages on failure. This eliminates the need for
driver-specific dev_err() and dev_err_probe() calls that previously
printed generic messages.

Signed-off-by: Pan Chuang <panchuang@vivo.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260709033428.362970-7-panchuang@vivo.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 75b1e88d3425 ("power: supply: ab8500_fg: fix use-after-free on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/ab8500_fg.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3179,8 +3179,6 @@ static int ab8500_fg_probe(struct platfo
 				  ab8500_fg_irq[i].name, di);
 
 		if (ret != 0) {
-			dev_err(dev, "failed to request %s IRQ %d: %d\n",
-				ab8500_fg_irq[i].name, irq, ret);
 			destroy_workqueue(di->fg_wq);
 			return ret;
 		}


