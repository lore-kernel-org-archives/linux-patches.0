Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C006D356744;
	Sat, 12 Sep 2026 09:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206891; cv=none; b=gBA3vhQqA8CLMVo8XkSLfjy5rjtr2B9RIr406WnNU+K4Q3MPb1Xc/U+Z2w9vYLv25tE0jN5oyBczW4LKW9if7ruoIc3FO8gSfeudMdmj2Qa3cyBrUUnmwtVehpR1hHvRqm877o4qLdgaLEhJjDdWsNIQCYFxvm6q5GLZjXqux9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206891; c=relaxed/simple;
	bh=1I3qfUtigDvTJQD+2RIXWWPmnkJy/ZnleXQK/Sz1gQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=knR7a75RNoARFuE6NELFZIhEdR9bZ7OkqOIll30AwW6DnK0KwNXFAen1nV9XUXmQnouy4QUvu6qCzAroc1FONJOadjOonCto8DOgpYa9P00/de0eoSWtntP944FdKMmcXbie3uCKgW7PLUe4y2LYaBYD7gRS3zv3NzJGnNeKlh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ui+iqjg0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ui+iqjg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CB11F000FF;
	Sat, 12 Sep 2026 09:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206890;
	bh=WYJNFQ4zTOfZAP4S0OW2rYq1J3XoJikaa0KbP4Nv8IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ui+iqjg06xFaNhKT+AejPuiVrO3RHhvNb3Pu7i7zo+uOv3PyGIr9bYBSLAEb/4wRq
	 IWjf2F5xNhn0uuJSQfCbaMtaSNy2s1Ri0l1div9t2SYrjBM2QJ1CQAzsDcvuxu6a1h
	 HZCUhNFvfFYOee+0JW6zWospB6vmtsiPQilFeTUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0300/1518] platform/x86: lg-laptop: Drop debug-only ACPI notify handler
Date: Sat, 12 Sep 2026 08:41:09 +0200
Message-ID: <20260912065630.265487413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit c12fe0b2c12195e0d1c56e0f670a6bd792b0567e ]

To facilitate subsequent conversion of the driver to using struct
platform_driver instead of struct acpi_driver, drop the debug-only
notify handler method from the driver.

No intentional functional impact beyond debug.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3346280.5fSG56mABF@rafael.j.wysocki
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 3e91964aa74a ("platform/x86: lg-laptop: Fix LED resource handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 6af6cf477c5b5..6a45e6270941a 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -269,11 +269,6 @@ static void wmi_input_setup(void)
 	}
 }
 
-static void acpi_notify(struct acpi_device *device, u32 event)
-{
-	acpi_handle_debug(device->handle, "notify: %d\n", event);
-}
-
 static ssize_t fan_mode_store(struct device *dev,
 			      struct device_attribute *attr,
 			      const char *buffer, size_t count)
@@ -886,7 +881,6 @@ static struct acpi_driver acpi_driver = {
 	.ops = {
 		.add = acpi_add,
 		.remove = acpi_remove,
-		.notify = acpi_notify,
 		},
 };
 
-- 
2.53.0



