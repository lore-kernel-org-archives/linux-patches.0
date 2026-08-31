Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940AA3BE156;
	Mon, 31 Aug 2026 13:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183904; cv=none; b=DWUHPQDM54ZhjKWN9CVXWnTnHG1zV0skYqRVcvjg+NqqMqpehOqPr3zTjgryBJ+HKid/kz98QO4/HEoRyBnZl90jCtTYK342WclDHtSgk4wJg3XUjn4po155uaeeHjAjEQCTkA2j4tTfBWssnS4Q5xykooZJsIGM3DLDIxs5IR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183904; c=relaxed/simple;
	bh=x2j+NgETtm1X41nEpVzlC4QKvy0TLCo29Xu6gsFkB9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bPx8tq5ufLTHVd8RE52jWyvmLIps+6WMysSyJWjcC0jnTTk/ZGjFDzsBNrzKrVKIlF+gcAmCcpn7HJvsb6SsvnPlc3E0GXg6pabCksKlA6VYYO09I9tIphPBqNJQ3d9kfRJlad3JQsPerVPQg4LATtoevelpq57UzZYaUjlGYbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZiVuGBVC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZiVuGBVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4511F00A3D;
	Mon, 31 Aug 2026 13:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183902;
	bh=q/4RCKYbFTZj7nlPh2/VjtjoPb+X2C7cfpcEreRmpJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiVuGBVCAV3zsmT6Wc1eVTt2HJM07usJQ5ffjEpR467j2EluV/hCgim1S537eZE8q
	 /YTJJaYyYyHAWvj4C1PXulBRT+tWAyxQIRMVazkQZvf46mCCPPvq7q1kvNMMKJj5A2
	 pz1Q6UoNlaKxla4QzOUq8ygSsLTVDoFysVA/bSE+55Zl0ZZyrQCokD/LXxz+XKUaQV
	 S7XFNestpEzDaEkUaAUDNMrrl3hvElzzo6P4QZLcatWGbrBLsew6DawE6yui44AJmB
	 dWqKb5/UNzSxoPj2LAN5xIjk/Ip86auRV3X0350rXQTXEfATqmoX4zYd9B9CBvtRiz
	 3A7VtdFK+w/mA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arun T <arun.t@intel.com>,
	Vadillo Miguel <miguel.vadillo@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	israel.a.cepeda.lopez@intel.com,
	hansg@kernel.org,
	linusw@kernel.org,
	brgl@kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] gpio: usbio: Add ACPI device-id for NVL platforms
Date: Mon, 31 Aug 2026 09:26:39 -0400
Message-ID: <20260831133314.4125787-371-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arun T <arun.t@intel.com>

[ Upstream commit 5ccb19ae1cb3620a76254db5c60121d092d9a0f6 ]

Add device IDs of Nova Lake into gpio-usbio support list.

Signed-off-by: Arun T <arun.t@intel.com>
Reviewed-by: Vadillo Miguel <miguel.vadillo@intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/20260410140858.585609-2-arun.t@intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The `gpio-usbio` history search finished successfully. It confirms the
driver was introduced in the `usb-6.18-rc8` merge (`5d324e5159d9e`) —
consistent with the earlier analysis and the **YES** backport verdict.

 drivers/gpio/gpio-usbio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-usbio.c b/drivers/gpio/gpio-usbio.c
index 34d42c743d5bc..489c8ac6299e1 100644
--- a/drivers/gpio/gpio-usbio.c
+++ b/drivers/gpio/gpio-usbio.c
@@ -31,6 +31,7 @@ static const struct acpi_device_id usbio_gpio_acpi_hids[] = {
 	{ "INTC10B5" }, /* LNL */
 	{ "INTC10D1" }, /* MTL-CVF */
 	{ "INTC10E2" }, /* PTL */
+	{ "INTC1116" }, /* NVL */
 	{ }
 };
 
-- 
2.53.0

