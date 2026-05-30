Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B5721B191;
	Sat, 30 May 2026 18:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166503; cv=none; b=YEZrlS02HEXav1fXcTT0RKOCnxklEbzGia6Adw++xZgt+hoc7Wj7rXIBLkm1b5FOrmpvkR/diUXNZhBeBhl1j5XfZ8C0Um0PUlTCDzk7MZOYJTuWWGtjQLfNwa2a9NpZuC6AhbHfa7sr06nD5xvhh7tcwBO32IF5IPPiOsIMAt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166503; c=relaxed/simple;
	bh=rmzAyI2VGjrIwrZQzMXUZ7M88m5VhiLJ7B8HQgcoeOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TjvlYhctmq9SLvsKzgkHtLMbLA8PYEUFwiBEW8yJ2qw/dRls2mPJLtCOVV5GjWXl7lviCpOd05pbt5gzQqflSL5Sb1a/40RRTSIefHgGNQBIuO/911KHNYjSV8kMakDi4N8br2h0WNyy+KCuoeHRqH26gGYY95xszQUe42Jp9D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9rTCNpT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9rTCNpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1171F00893;
	Sat, 30 May 2026 18:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166499;
	bh=kZ1iqC3ci2Z+VAOqJztskUdvmydjdVFR/Csn9Kq51Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9rTCNpTr01CrIySoJtiXZZ2DZCnuLb2mZdrTx68bZ8C5DEAD2yzhukjKmroNqvAO
	 SDVNWrN4bxexQmyRgd1s4XWLb5Yp5N83KqhSDvGHZy3IXtSinO52hkiwClFwUb+zY3
	 b3sYii8jajjHPraakUXaDlPBLbnau8wv8MqhgK0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 390/589] platform/surface: surfacepro3_button: Drop wakeup source on remove
Date: Sat, 30 May 2026 18:04:31 +0200
Message-ID: <20260530160235.050735582@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
 drivers/platform/x86/surfacepro3_button.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/surfacepro3_button.c b/drivers/platform/x86/surfacepro3_button.c
index d8afed5db94c5..17d3fc81aa6e7 100644
--- a/drivers/platform/x86/surfacepro3_button.c
+++ b/drivers/platform/x86/surfacepro3_button.c
@@ -245,6 +245,7 @@ static int surface_button_remove(struct acpi_device *device)
 {
 	struct surface_button *button = acpi_driver_data(device);
 
+	device_init_wakeup(&device->dev, false);
 	input_unregister_device(button->input);
 	kfree(button);
 	return 0;
-- 
2.53.0



