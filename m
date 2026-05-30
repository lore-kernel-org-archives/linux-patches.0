Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206613AB291;
	Sat, 30 May 2026 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164361; cv=none; b=Tm1zr3y2iZX2cjkm+fquyQS/wk3pyN0pOMl9fA1qRhwspQerDXRXH5j+ysR3UmXoO/mz3AKtjRGCZH7RHg1H1e79ZeqSC6EIA5Nk9lxkd08/g5zAliKFczzMa+xyxp2RqrEumau4lb5sHuBxlI33+fVw+osr1Axb992j+JwlX8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164361; c=relaxed/simple;
	bh=PiQFkEaIFAbxNvat5QrG68Hc9W68wzIic8ZtCmYYt1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P6Ouj1w56bEUTV65tRjc59f53J1NNR7mjmcb0OECKL23kbLWWCE4Hh55C6ZItD28amoTlfRwibudKDklefttsin22t8B1CkFMVb0e1yRaDZ/LNt68hsyN4K6RRbUc7jEp/Z2wbdYcM+/nRzZm48qkqVSB2hLfCQj+jvwtelBchA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrffXA4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrffXA4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563ED1F00893;
	Sat, 30 May 2026 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164360;
	bh=EoM6xXx0xAaVgEJP7ZYKdUGWAOQmnk6bAdd3Epy4mgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PrffXA4JA3wjm/EfXctANeFdHqXX7jlMbjTxm2jgoE/aVQn4f7yn8O/umd0Lx5Zv+
	 Y+/JsauiRVqCPHLhtMAbJ4OeH4fPEHwGKWNC/H/u7atnsLNaySqQy4Ow6ubFP78yED
	 I93vUSqwfZSThAhxD4vH7jbOjG8u858bnVI74AcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 524/776] platform/surface: surfacepro3_button: Drop wakeup source on remove
Date: Sat, 30 May 2026 18:03:58 +0200
Message-ID: <20260530160253.767576952@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 1410a228ab2d36fe2b383415a632ae12048d4f3a ]

The wakeup source added by device_init_wakeup() in surface_button_add()
needs to be dropped during driver removal, so update the driver to do
that.

Fixes: 19351f340765 ("platform/x86: surfacepro3: Support for wakeup from suspend-to-idle")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4368848.1IzOArtZ34@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surfacepro3_button.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/surface/surfacepro3_button.c b/drivers/platform/surface/surfacepro3_button.c
index 242fb690dcaf7..892fb71d5916f 100644
--- a/drivers/platform/surface/surfacepro3_button.c
+++ b/drivers/platform/surface/surfacepro3_button.c
@@ -243,6 +243,7 @@ static int surface_button_remove(struct acpi_device *device)
 {
 	struct surface_button *button = acpi_driver_data(device);
 
+	device_init_wakeup(&device->dev, false);
 	input_unregister_device(button->input);
 	kfree(button);
 	return 0;
-- 
2.53.0



